# MedCare — Antigravity Project Guide (A to Z Walkthrough)

Welcome to the ultimate technical guide for **MedCare**, your Final Year Project (FYP). This guide is designed to help you understand every aspect of the project so you can confidently answer any question your teacher asks during your demo, including how to live-code changes to the UI, styling, validation, and database logic.

---

## Table of Contents
1. [Project Overview & Key Features](#1-project-overview--key-features)
2. [Tech Stack & What Each Library Does](#2-tech-stack--what-each-library-does)
3. [Architecture (MVVM + Clean Separation)](#3-architecture-mvvm--clean-separation)
4. [Folder Structure (Every File Explained)](#4-folder-structure-every-file-explained)
5. [Data Models Deep Dive](#5-data-models-deep-dive)
6. [Services Layer (The Integration Engine)](#6-services-layer-the-integration-engine)
7. [Controllers / ViewModels (The Logic & State)](#7-controllers--viewmodels-the-logic--state)
8. [Views & UI Screens (The Frontend Layout)](#8-views--ui-screens-the-frontend-layout)
9. [Complete Step-by-Step Data Flows](#9-complete-step-by-step-data-flows)
10. [Advanced & Tricky Logic Explained](#10-advanced--tricky-logic-explained)
11. [Live-Coding Cheat Sheet (How to Make Quick Changes)](#11-live-coding-cheat-sheet-how-to-make-quick-changes)
12. [Common Demo Questions & How to Answer Them](#12-common-demo-questions--how-to-answer-them)
13. [Code-Level Walkthrough (EVERY Screen & Logic Explained)](#13-code-level-walkthrough-every-screen--logic-explained)
14. [App Initialization (`main.dart`)](#14-app-initialization-maindart)
15. [Global Reusable Widgets (UI Components)](#15-global-reusable-widgets-ui-components)

---

## 1. Project Overview & Key Features

**MedCare** is an offline-first, cloud-synchronized mobile application built with Flutter. It functions as a smart medicine reminder, health records repository, wellness tracker, and AI-enabled health assistant.

### Key Features Implemented:
*   **Multi-Mode Authentication**: Email/Password registry + secure Google Sign-In authentication.
*   **Offline-First Operation**: Runs 100% offline using Hive local database. Syncs back to Firebase Realtime Database once the connection returns.
*   **Complex Medicine Scheduling**: Supports Daily schedules, Specific Days of the week (e.g. Mon/Wed/Fri), Interval-based schedules (every X days), and Cyclic schedules (X days on, Y days off like birth control pills).
*   **Multiple Reminders per Dose**: Set different alert times for a single medicine.
*   **Notification Action Buttons**: "Take", "Skip", and "Snooze" options directly on local push notifications.
*   **Inventory Control**: Auto-marks low-stock warnings (stock $\le 5$), displays them at the top of the inventory list, and hides future doses in the calendar if stock runs out.
*   **Auto-Miss Feature**: When the app starts or resumes, it checks for past unrecorded doses and auto-marks them as "Skipped" so reports remain accurate.
*   **AI Chat Assistant**: Integration with the Google Gemini API using environment variables (`.env`) for health queries, with a static offline fallback.
*   **Health Hub & Analytics**: Tracks user streak logs, calculates compliance percentage, displays fl_chart graphs, manages journal entries, and views doctor appointments.

---

## 2. Tech Stack & What Each Library Does

These dependencies are declared in `pubspec.yaml`:

*   **GetX (`get`)**: Handles state management (updating UI via `.obs` and `Obx`), dependency injection (`Get.put()`, `Get.lazyPut()`), and screen navigation (`Get.toNamed()`) without context.
*   **Hive & Hive Flutter (`hive_flutter`)**: NoSQL database for local storage. Highly performant and perfect for offline-first architecture.
*   **Firebase Core & Auth (`firebase_core`, `firebase_auth`)**: Provides cloud services authentication, credentials storage, and password reset workflows.
*   **Firebase Realtime Database (`firebase_database`)**: Fast NoSQL cloud database to back up profile data and sync sessions.
*   **Google Sign-In (`google_sign_in`)**: Integrates Google Authentication services.
*   **flutter_local_notifications**: Leverages native Android and iOS alert triggers to ring reminder alarms, manage background actions, and display low stock warnings.
*   **google_generative_ai**: Integrates Google's Gemini API for the AI chat health advisor.
*   **flutter_dotenv**: Loads secret keys (like the Gemini API Key) from a local `.env` file instead of hardcoding them.
*   **table_calendar**: Creates the Calendar view page allowing users to view medication schedules for a 30-day window ($\pm 15$ days relative to today).
*   **fl_chart**: Generates interactive charts representing weekly/monthly compliance and dosage histories.
*   **uuid**: Creates unique strings to use as IDs for models (medicines, logs, reports).
*   **audio_players**: Plays customized notification sound previews in the settings menu.

---

## 3. Architecture (MVVM + Clean Separation)

MedCare follows a strict **Model-View-ViewModel (MVVM)** architecture to cleanly separate concerns.

```
+-------------------------------------------------------------+
|                        UI LAYER                             |
|          Views (Scaffolds, Widgets, Obx Builders)           |
|                Location: `lib/views/`                       |
+------------------------------+------------------------------+
                               | Read state / User interactions
+------------------------------v------------------------------+
|                     LOGIC & STATE LAYER                     |
|           Controllers (GetxControllers, state variables)    |
|             Location: `lib/view_models/`                    |
+------------------------------+------------------------------+
                               | CRUD actions / API calls
+------------------------------v------------------------------+
|                        DATA LAYER                           |
|       Services (Hive, Firebase, Notifications, Gemini)      |
|                Location: `lib/data/services/`               |
|                                                             |
|       Models (Dart schemas representing database items)     |
|                Location: `lib/data/models/`                 |
+-------------------------------------------------------------+
```

---

## 13. Code-Level Walkthrough (EVERY Screen & Logic Explained)

This section maps **every single file** in your views and view_models folders. If the teacher points at *any* screen, search for it here.

### Group 1: Core Navigation & Dashboard
*   **File: `lib/views/home_view.dart`**
    *   **What it does**: The main shell with the bottom Navigation Bar.
    *   **Logic**: Uses a GetX `RxInt selectedIndex` to swap out `pages[current]` inside an `AnimatedSwitcher`.
*   **File: `lib/views/tabs/dashboard_view.dart`**
    *   **What it does**: The "Today" screen. Shows progress ring, calendar slider, and today's meds.
    *   **Logic**: Calls `MedicineController.getDailyProgress()` to animate the ring. Maps over medicines and calls `_filterByTime()` to place them into Morning, Afternoon, or Evening buckets.
*   **File: `lib/views/splash_view.dart`**
    *   **What it does**: The startup screen with the logo.
    *   **Logic**: Runs a timer, then asks `HiveService.getUserId()`. If null, `Get.offAll(() => LoginView())`. If exists, `Get.offAll(() => HomeView())`.

### Group 2: Medicine Management
*   **File: `lib/views/medicine_list_view.dart`**
    *   **What it does**: Lists all medicines, both active and inactive. Shows inventory stock.
    *   **Logic**: Reads `medController.medicines`. Swiping a medicine calls `deleteMedicine()`.
*   **File: `lib/views/add_medicine_view.dart`**
    *   **What it does**: Form to add/edit medicines.
    *   **Logic**: Binds text controllers to `MedicineController`. Builds dynamic frequency selectors (Daily, Interval, Cyclic) using `Obx`. On save, writes to Hive and calls `NotificationService.scheduleMedicine()`.
*   **File: `lib/views/medicine_action_dialog.dart`**
    *   **What it does**: The popup when a notification is tapped.
    *   **Logic**: Buttons call `controller.handleNotificationAction('take'/'skip'/'snooze')`. This logs the status, decrements stock, and triggers low-stock warnings if needed.
*   **File: `lib/view_models/medicine_controller.dart`**
    *   **What it does**: The brain of the app.
    *   **Logic**: Uses `didChangeAppLifecycleState` to detect when the app opens to refresh logs. Calculates specific dates using modulo arithmetic.

### Group 3: Authentication & Profiles
*   **File: `lib/views/login_view.dart` & `signup_view.dart`**
    *   **What it does**: Glassmorphism forms for logging in and registering.
    *   **Logic**: Both connect to `AuthController`. `signUp()` runs rules from `SafetyRulesService`.
*   **File: `lib/views/forgot_password_view.dart` & `change_password_view.dart`**
    *   **What it does**: Handles password resets.
    *   **Logic**: Sends Firebase Auth password reset emails and updates passwords via `AuthController`.
*   **File: `lib/view_models/auth_controller.dart`**
    *   **What it does**: Talks to Firebase.
    *   **Logic**: Creates user documents in Firebase Realtime Database. Caches the user ID in Hive for offline persistence.
*   **File: `lib/views/profile_view.dart` & `edit_profile_view.dart`**
    *   **What it does**: Displays and edits height, weight, blood group.
    *   **Logic**: Uses `ProfileController.calculateBMI(weight, height)`. Uploads profile pictures to Firebase Storage.

### Group 4: The Health Hub & Analytics
*   **File: `lib/views/tabs/health_hub_view.dart`**
    *   **What it does**: A grid menu with animated cards linking to Analytics, AI, Appointments, etc.
*   **File: `lib/views/analytics_view.dart` & `lib/view_models/analytics_controller.dart`**
    *   **What it does**: Shows pie charts and bar charts for compliance.
    *   **Logic**: Controller pulls all `MedicineLogModel` records. Uses `getStatusDistribution()` for pie charts and `getMonthlyWeeklyCounts()` for bar charts. Also calculates `getIrregularMedicines()` if missed rate > 30%.
*   **File: `lib/views/medication_history_view.dart`**
    *   **What it does**: A simple list view of past medication logs.

### Group 5: The AI Assistant
*   **File: `lib/views/chat_view.dart` & `lib/view_models/chat_controller.dart`**
    *   **What it does**: Chatbot interface.
    *   **Logic**: Uses `google_generative_ai`. Reads API key from `.env`. Intercepts messages using `SafetyRulesService.isBlocked(text)` before sending. Saves history to `HiveService`.

### Group 6: Wellness, Journaling, and Records
*   **File: `lib/views/wellness_view.dart` & `lib/view_models/wellness_controller.dart`**
    *   **What it does**: Allows users to log their mood and calculate their compliance streaks.
    *   **Logic**: The controller reads `JournalModel` entries from Hive. The Streak calculator loops through past dates and adds +1 for every day where 100% of doses were "Taken".
*   **File: `lib/views/reports_view.dart`, `report_pdf_view.dart`, `report_image_view.dart`**
    *   **What it does**: Stores medical documents (prescriptions, test results).
    *   **Logic**: Connects to `ReportController`. Uses native file pickers to grab images/PDFs and saves their local file paths into `ReportModel` in Hive.
*   **File: `lib/views/health_records_view.dart`**
    *   **What it does**: Shows vitals metrics (Blood Pressure, Sugar). (Static UI placeholder for expansion).

### Group 7: Appointments
*   **File: `lib/views/appointments_view.dart` & `add_appointment_view.dart`**
    *   **What it does**: Lists upcoming doctor visits and adds new ones.
    *   **Logic**: `AppointmentController` saves `AppointmentModel` objects to Hive. It also uses `NotificationService.scheduleAppointmentReminder()` to set a native alarm based on the chosen time.

### Group 8: Settings & Configurations
*   **File: `lib/views/settings_view.dart` & `lib/view_models/settings_controller.dart`**
    *   **What it does**: Theme toggle (Dark/Light mode).
    *   **Logic**: Toggles GetX `ThemeMode` and saves the preference to `HiveService.settingsBox`.
*   **File: `lib/views/notification_settings_view.dart` & `notification_sound_settings_view.dart`**
    *   **What it does**: Allows users to pick different ringtones for medicines vs appointments.
    *   **Logic**: Connects to `NotificationSettingsController`. Uses the `audio_players` package to preview sounds (e.g., `bell.mp3`, `chime.mp3`) before saving the `NotificationSettingsModel` to Hive.
*   **File: `lib/views/help_support_view.dart`**
    *   **What it does**: Basic FAQs and contact forms.

---

## 14. App Initialization (`main.dart`)
This is the root of your application and runs before the UI ever paints. If your teacher asks, *"Where do environment variables load?"* or *"How do you inject GetX controllers?"*, point them here.
*   **Environment Loading**: `dotenv.load(fileName: '.env')` loads the Gemini API key. It is wrapped in a `try/catch` so the app doesn't crash if the file is missing (it gracefully degrades offline).
*   **Database & Services Init**: Calls `HiveService.init()` and `NotificationService.init()`.
*   **Theme Preload**: Opens `settingsBox` directly to read `isDarkMode`. This ensures the Splash Screen loads in the correct theme instantly, avoiding a blinding flash of white light for dark-mode users.
*   **Dependency Injection (`initialBinding`)**: Uses `Get.lazyPut()` to inject controllers into memory only when they are needed.

## 15. Global Reusable Widgets (UI Components)
The files inside `lib/views/widgets/` are small, reusable building blocks used across many screens.
*   **`orb_painter.dart`**: This is the CustomPainter that draws the floating, animated, blurry background circles (orbs) you see on the Login and Hub screens. It uses `math.sin` and radial gradients.
*   **`custom_text_field.dart`**: The standard glassmorphism text input box used in all your forms (Login, Signup, Profile). It standardizes the transparent borders.
*   **`premium_card.dart`**: A container widget that automatically applies a frosted glass effect and border, used for the main information cards.
*   **`schedule_item_card.dart`**: The UI template for the rows that display medicines and appointments in the dashboard timeline.
*   **`animated_list_item.dart`**: A wrapper that makes items slide up gracefully when a `ListView` is built.
*   **`animated_empty_state.dart`**: The "No Medicines Found" graphic that appears when a list is empty.

---
*This guide covers EVERY SINGLE FILE in the project.*
