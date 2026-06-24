# MedCare Codebase Guide

This file is meant to help you understand the project code quickly before a demo.

The app is a Flutter medicine reminder and health-tracking system called MedCare. It uses:

- Firebase for authentication and cloud profile sync.
- Hive for offline/local storage.
- GetX for state management and navigation.
- Local notifications for medicine and appointment reminders.
- Gemini AI for chat/wellness features.

## 1. How The App Starts

Main startup file: [lib/main.dart](lib/main.dart)

### What happens in `main()`

`main()` is the first function that runs when the app opens. It does the setup work before the UI appears:

1. Loads environment variables from `.env` for AI keys.
2. Initializes Firebase.
3. Initializes Hive local storage.
4. Reads saved theme mode from Hive.
5. Initializes notification service.
6. Sets the status bar style.
7. Opens the app on the splash screen.

### What `MyApp` does

`MyApp` creates the whole app shell using `GetMaterialApp`.

It defines:

- App title and theme.
- Light and dark themes.
- Initial route: `/splash`.
- Dependency injection using `initialBinding`.
- All named routes using `getPages`.

### Controllers registered at startup

These controllers are created before screens load:

- `SettingsController` for theme and notification sound settings.
- `AuthController` for login, signup, and logout.
- `ProfileController` for profile and health records.
- `MedicineController` for medicine management.
- `AppointmentController` for appointments.
- `ScheduleController` for schedule/calendar logic.

## 2. Project Architecture

The code is organized into four main layers:

- `views/` = screens the user sees.
- `view_models/` = GetX controllers that hold logic and state.
- `data/models/` = data classes stored in Hive or synced to Firebase.
- `data/services/` = services for storage, auth, notifications, and AI.

There are also:

- `views/widgets/` = reusable UI pieces.
- `utils/` = shared helpers for theme/platform behavior.

## 3. Folder By Folder Explanation

## `lib/data/models/`

These are the app’s data structures. They describe what gets saved locally and/or remotely.

### [medicine_model.dart](lib/data/models/medicine_model.dart)

Stores one medicine record.

Important fields:

- Medicine name, dosage, type, and stock.
- Multiple reminder times.
- Active/inactive status.
- Schedule type such as daily, specific days, interval, or cyclic.
- Optional cyclic schedule fields like on/off days and start date.

This model is central to the medicine reminder feature.

### [medicine_log_model.dart](lib/data/models/medicine_log_model.dart)

Stores a log entry for a medicine dose.

This is used to track whether a medicine was taken, missed, or snoozed.

### [appointment_model.dart](lib/data/models/appointment_model.dart)

Stores appointment data.

Important fields:

- Doctor name.
- Category.
- Date and time.
- Reminder minutes.
- Visit notes.
- Completion flag.
- Recurring reminder settings.

### [user_model.dart](lib/data/models/user_model.dart)

Stores user profile information.

Important fields:

- UID, email, and full name.
- Photo URL.
- Gender, date of birth, blood group.
- Height, weight, and BMI.
- Local health records such as allergies, illnesses, and restraints.

This model has helpers for:

- `toMap()` for Firebase.
- `toHiveMap()` for Hive.
- `fromMap()` to read either storage format back into a user object.

### [journal_model.dart](lib/data/models/journal_model.dart)

Stores journal or wellness diary entries.

Used by the wellness/health record part of the app.

### [report_model.dart](lib/data/models/report_model.dart)

Stores reports or health summaries.

Used by the reports/analytics area.

### [streak_model.dart](lib/data/models/streak_model.dart)

Stores streak data.

This likely supports daily adherence or activity streak tracking.

### [chat_message_model.dart](lib/data/models/chat_message_model.dart)

Stores chat messages for the AI/chat screen.

### [notification_settings_model.dart](lib/data/models/notification_settings_model.dart)

Stores notification sound preferences.

This is used when the user changes short/long alert sounds.

### Generated files in this folder

Files ending in `.g.dart` are generated automatically by Hive.

You do not normally edit them by hand.

They exist so Hive can serialize and deserialize the models above.

## `lib/data/services/`

These files talk to Firebase, Hive, notifications, and Gemini.

### [hive_service.dart](lib/data/services/hive_service.dart)

This is the local storage layer.

It defines box names and provides methods to:

- Initialize Hive boxes.
- Save and read the current user.
- Save and read medicines.
- Save and read medicine logs.
- Save and read appointments.
- Save and read journals, reports, streaks, and chat history.
- Save notification settings.
- Clear session data on logout.

This file is the main reason the app can work offline.

### [firebase_auth_service.dart](lib/data/services/firebase_auth_service.dart)

This file talks directly to Firebase Authentication.

Main responsibilities:

- Sign up with email and password.
- Log in with email and password.
- Handle Google sign-in.
- Send verification emails.
- Reset or change password flows.
- Convert Firebase errors into readable messages.

### [realtime_database_service.dart](lib/data/services/realtime_database_service.dart)

This service syncs user profile data with Firebase Realtime Database.

It is mainly used by the profile controller to keep local and cloud data aligned.

### [notification_service.dart](lib/data/services/notification_service.dart)

This is the reminder engine for local notifications.

It handles:

- Notification initialization.
- Permission setup.
- Notification channel setup.
- Scheduling medicine reminders.
- Scheduling appointment reminders.
- Canceling reminders.
- Canceling all reminders.
- Handling background action buttons like take, miss, or snooze.

This file is critical to the app’s core reminder functionality.

### [gemini_service.dart](lib/data/services/gemini_service.dart)

This wraps Gemini AI setup.

It:

- Reads `GEMINI_API_KEY` from `.env`.
- Throws a clear error if the key is missing.
- Builds a configured `GenerativeModel` for chat use.

This is the base service for AI/chat/wellness features.

### [safety_rules_service.dart](lib/data/services/safety_rules_service.dart)

This file likely contains prompt or content rules for safer AI responses.

It helps keep health-related AI responses more controlled.

## `lib/view_models/`

These are the GetX controllers. They keep logic out of the UI.

### [auth_controller.dart](lib/view_models/auth_controller.dart)

Handles sign up, login, and logout logic.

Important methods:

- `validatePassword()` checks password strength.
- `signUp()` creates a user account and sends verification email.
- `login()` signs the user in.
- `logout()` signs the user out and clears session data.

It uses `FirebaseAuthService` and `RealtimeDatabaseService`.

### [medicine_controller.dart](lib/view_models/medicine_controller.dart)

This is one of the most important controllers in the app.

It manages:

- Medicine list loading and saving.
- Add/edit/delete medicine forms.
- Reminder times and schedule types.
- Stock tracking.
- Medication log history.
- Notification scheduling for medicine doses.
- Taken/missed dose handling.

If you want to explain the core purpose of the app in a demo, this controller is a good place to point to.

### [appointment_controller.dart](lib/view_models/appointment_controller.dart)

Manages appointment data.

Important methods:

- `loadAppointments()` reads appointments from Hive.
- `saveAppointment()` creates or updates an appointment.
- `deleteAppointment()` removes an appointment and cancels its reminder.
- `markCompleted()` moves an appointment to history.
- `_scheduleAlert()` schedules the appointment reminder notification.
- `rescheduleAllNotifications()` updates all reminders after sound changes.
- `prepareEdit()` fills form fields for editing.

### [profile_controller.dart](lib/view_models/profile_controller.dart)

Manages user profile and health records.

Important methods:

- `loadProfile()` loads profile from Hive first, then syncs from Firebase.
- `prepareEditData()` fills the edit form.
- `updateProfile()` saves changes to cloud and local storage.
- `pickImage()` lets the user choose a profile photo.
- `logout()` signs out and clears session data.
- `addAllergy()` / `removeAllergy()` manage health records.
- `addIllness()` / `removeIllness()` manage chronic illnesses.
- `addRestraint()` / `removeRestraint()` manage restrictions.

It also calculates BMI live from height and weight inputs.

### [schedule_controller.dart](lib/view_models/schedule_controller.dart)

Builds the daily schedule view.

Important responsibilities:

- Combines medicines and appointments into one timeline.
- Restricts the calendar to a ±15 day range.
- Marks dates with events.
- Calculates item status such as taken, missed, pending, or upcoming.
- Finds medicine or appointment items by ID.

Useful methods:

- `onDaySelected()` updates the selected date.
- `scheduleForDate()` builds all timeline items for one date.
- `markedDates` returns dates that should be highlighted in the calendar.
- `markMedicineTaken()` marks a dose as completed.

### [settings_controller.dart](lib/view_models/settings_controller.dart)

Manages app preferences.

Important responsibilities:

- Reads and stores theme mode.
- Reads the current time zone.
- Stores notification sound preferences.
- Lets the user preview sounds.
- Reschedules notifications after sound changes.

Important methods:

- `_loadSettings()` loads dark/light mode from Hive.
- `toggleTheme()` changes and saves the theme.
- `_loadNotificationSettings()` loads saved notification sound settings.
- `updateShortSound()` / `updateLongSound()` change sounds.
- `toggleMedicineSound()` / `toggleAppointmentSound()` decide which sound style to use.
- `_saveNotificationSettings()` saves settings and reschedules alerts.
- `previewSound()` plays an audio preview.

### [chat_controller.dart](lib/view_models/chat_controller.dart)

Manages the AI chat conversation.

It likely stores messages, sends prompts to Gemini, and saves chat history locally.

### [analytics_controller.dart](lib/view_models/analytics_controller.dart)

Handles reporting and chart data.

This controller likely summarizes medicine adherence, appointment activity, and other metrics.

### [report_controller.dart](lib/view_models/report_controller.dart)

Manages report generation and saved report records.

### [wellness_controller.dart](lib/view_models/wellness_controller.dart)

Manages wellness-related content and state.

This is likely used by the health/wellness section of the app.

### [notification_settings_controller.dart](lib/view_models/notification_settings_controller.dart)

Handles the notification settings screen logic.

### [login_view_controller.dart](lib/view_models/login_view_controller.dart)

Controls login screen UI state.

Typically this means password visibility and similar small UI behavior.

### [signup_view_controller.dart](lib/view_models/signup_view_controller.dart)

Controls sign-up screen UI state.

It is usually used for password visibility or form-related UI toggles.

## `lib/views/`

These are the screens shown to the user.

### Authentication flow

- [splash_view.dart](lib/views/splash_view.dart) decides whether to send the user to login or home.
- [login_view.dart](lib/views/login_view.dart) shows the sign-in screen.
- [signup_view.dart](lib/views/signup_view.dart) shows account creation.
- [forgot_password_view.dart](lib/views/forgot_password_view.dart) handles password reset.
- [change_password_view.dart](lib/views/change_password_view.dart) allows password update.

### Main app shell

- [home_view.dart](lib/views/home_view.dart) is the main navigation shell after login.
- It hosts the bottom navigation bar.
- It switches between dashboard, health hub, medicines, and profile.

### Dashboard and home tabs

- [tabs/dashboard_view.dart](lib/views/tabs/dashboard_view.dart) is the main landing dashboard.
- [tabs/health_hub_view.dart](lib/views/tabs/health_hub_view.dart) is the health or wellness hub.

### Medicine flow

- [medicine_list_view.dart](lib/views/medicine_list_view.dart) lists all medicines.
- [add_medicine_view.dart](lib/views/add_medicine_view.dart) adds a new medicine.
- [medicine_action_dialog.dart](lib/views/medicine_action_dialog.dart) is the popup used for medicine actions.
- [medication_history_view.dart](lib/views/medication_history_view.dart) shows dose history.

### Appointment flow

- [appointments_view.dart](lib/views/appointments_view.dart) lists appointments.
- [add_appointment_view.dart](lib/views/add_appointment_view.dart) adds a new appointment.
- [schedule_view.dart](lib/views/schedule_view.dart) shows the combined medicine and appointment calendar.

### Reports and analytics

- [analytics_view.dart](lib/views/analytics_view.dart) shows charts and stats.
- [reports_view.dart](lib/views/reports_view.dart) shows generated reports.

### Profile and health records

- [profile_view.dart](lib/views/profile_view.dart) shows user profile details.
- [edit_profile_view.dart](lib/views/edit_profile_view.dart) edits profile data.
- [health_records_view.dart](lib/views/health_records_view.dart) manages personal health records.

### Wellness and support

- [wellness_view.dart](lib/views/wellness_view.dart) is the wellness feature screen.
- [chat_view.dart](lib/views/chat_view.dart) is the AI/chat interface.
- [help_support_view.dart](lib/views/help_support_view.dart) provides help/support content.

### Settings

- [settings_view.dart](lib/views/settings_view.dart) is the general settings screen.
- [notification_settings_view.dart](lib/views/notification_settings_view.dart) is the notification preference screen.
- [notification_sound_settings_view.dart](lib/views/notification_sound_settings_view.dart) manages notification sounds.

## `lib/views/widgets/`

These are reusable UI pieces used across multiple screens.

- [animated_list_item.dart](lib/views/widgets/animated_list_item.dart) animates list entries.
- [animated_empty_state.dart](lib/views/widgets/animated_empty_state.dart) shows empty states.
- [custom_text_field.dart](lib/views/widgets/custom_text_field.dart) is a reusable input field.
- [premium_card.dart](lib/views/widgets/premium_card.dart) is a styled card component.
- [schedule_item_card.dart](lib/views/widgets/schedule_item_card.dart) renders schedule items.
- [orb_painter.dart](lib/views/widgets/orb_painter.dart) draws the floating background orbs.

## `lib/utils/`

These files provide shared helpers.

### [app_theme_colors.dart](lib/utils/app_theme_colors.dart)

Contains shared colors, gradients, and theme helpers.

This keeps the app’s visual style consistent.

### [platform_utils.dart](lib/utils/platform_utils.dart)

Contains platform-specific checks or helpers.

This is useful when behavior differs between Android, iOS, or desktop.

## 4. Main User Flow

Here is the simplest way to explain the app in a demo:

1. The app starts in [main.dart](lib/main.dart).
2. The splash screen checks whether the user is already logged in.
3. If not logged in, the user goes to login or sign-up.
4. After login, the user enters [home_view.dart](lib/views/home_view.dart).
5. The dashboard shows daily reminders and appointments.
6. Medicines are managed in the medicine list and add-medicine screens.
7. Appointments are managed in the appointment screens.
8. Schedule, reports, chat, wellness, and profile screens extend the health tracking features.

## 5. Data Flow In The App

The app uses a simple pattern:

- UI screens are in `views/`.
- Screens talk to controllers in `view_models/`.
- Controllers call services in `data/services/`.
- Services read/write models in `data/models/`.
- Hive keeps data available offline.
- Firebase keeps account and profile data synced online.

That means most user actions follow this path:

screen → controller → service → storage/cloud → controller → screen refresh

## 6. What To Say In A Demo

If someone asks what the project does, you can say:

“MedCare is a Flutter app that helps users manage medicines, reminders, appointments, and health records. It uses Firebase for login and cloud sync, Hive for offline data, local notifications for reminders, and GetX for state management.”

If they ask where a feature lives:

- Login and authentication: `auth_controller.dart`, `firebase_auth_service.dart`, `login_view.dart`, `signup_view.dart`
- Medicine reminders: `medicine_controller.dart`, `medicine_model.dart`, `notification_service.dart`, `medicine_list_view.dart`
- Appointments: `appointment_controller.dart`, `appointment_model.dart`, `appointments_view.dart`
- Profile: `profile_controller.dart`, `user_model.dart`, `profile_view.dart`
- Settings and sounds: `settings_controller.dart`, `notification_settings_model.dart`, `settings_view.dart`
- Schedule/calendar: `schedule_controller.dart`, `schedule_view.dart`
- AI/chat: `gemini_service.dart`, `chat_controller.dart`, `chat_view.dart`

## 7. Files You Should Recognize First

If you are short on time, focus on these files first:

- [lib/main.dart](lib/main.dart)
- [lib/view_models/auth_controller.dart](lib/view_models/auth_controller.dart)
- [lib/view_models/medicine_controller.dart](lib/view_models/medicine_controller.dart)
- [lib/view_models/appointment_controller.dart](lib/view_models/appointment_controller.dart)
- [lib/view_models/profile_controller.dart](lib/view_models/profile_controller.dart)
- [lib/view_models/settings_controller.dart](lib/view_models/settings_controller.dart)
- [lib/data/services/hive_service.dart](lib/data/services/hive_service.dart)
- [lib/data/services/notification_service.dart](lib/data/services/notification_service.dart)
- [lib/data/services/firebase_auth_service.dart](lib/data/services/firebase_auth_service.dart)
- [lib/views/home_view.dart](lib/views/home_view.dart)
- [lib/views/tabs/dashboard_view.dart](lib/views/tabs/dashboard_view.dart)
- [lib/views/medicine_list_view.dart](lib/views/medicine_list_view.dart)
- [lib/views/appointments_view.dart](lib/views/appointments_view.dart)
- [lib/views/profile_view.dart](lib/views/profile_view.dart)

## 8. Short Version

This project is structured in a clean way:

- `main.dart` boots everything.
- `services` connect the app to Firebase, Hive, notifications, and Gemini.
- `controllers` contain the behavior.
- `views` contain the screens.
- `models` define the saved data.

If you understand those five folders, the whole app becomes much easier to explain.

## 9. Detailed File Walkthrough

This section is the one to use when you want to trace the code file by file. I grouped the files so you can read them in the same order the app uses them.

### App bootstrap and platform setup

- [lib/main.dart](lib/main.dart#L1) sets up Firebase, Hive, notifications, theme loading, and GetX routing. The startup logic is mostly in the first half of the file, where `main()` initializes services and `MyApp` defines routes and theme setup.
- [lib/firebase_options.dart](lib/firebase_options.dart#L1) is generated by FlutterFire. It contains platform-specific Firebase configuration and is only used by `Firebase.initializeApp(...)`.
- [lib/utils/platform_utils.dart](lib/utils/platform_utils.dart#L1) contains small platform checks such as whether the app is running on web or mobile, and whether custom notification sounds are supported.
- [lib/utils/app_theme_colors.dart](lib/utils/app_theme_colors.dart#L1) centralizes color and gradient helpers so the same visual language is reused across all screens.

### Local storage and backend services

- [lib/data/services/hive_service.dart](lib/data/services/hive_service.dart#L1) is the offline database layer. Its initialization section registers Hive adapters and opens the app boxes, while the rest of the file stores and retrieves medicines, logs, appointments, journals, reports, chat history, settings, and user data.
- [lib/data/services/notification_service.dart](lib/data/services/notification_service.dart#L1) is the reminder engine. The top part handles the background notification action callback, and the rest of the file schedules, cancels, and reschedules reminders for medicines and appointments.
- [lib/data/services/firebase_auth_service.dart](lib/data/services/firebase_auth_service.dart#L1) wraps Firebase Authentication. The early methods handle exception translation, sign-up, login, Google sign-in, password reset, and logout flows.
- [lib/data/services/realtime_database_service.dart](lib/data/services/realtime_database_service.dart#L1) syncs profile data to Firebase Realtime Database. `saveUser` writes the user object to `users/<uid>`, and `getUser` reads and rebuilds a `UserModel`.
- [lib/data/services/gemini_service.dart](lib/data/services/gemini_service.dart#L1) creates the Gemini model using the `.env` API key. The key method is `buildChatModel`, which configures model name, safety settings, token limits, and system instruction.
- [lib/data/services/safety_rules_service.dart](lib/data/services/safety_rules_service.dart#L1) manages client-side AI safety rules. It keeps the blocked keyword list synced with Firebase and provides fallback defaults if the network is unavailable.

### Core data models

- [lib/data/models/user_model.dart](lib/data/models/user_model.dart#L1) defines the user profile object, BMI calculation, Firebase mapping, Hive mapping, and map-to-object conversion.
- [lib/data/models/medicine_model.dart](lib/data/models/medicine_model.dart#L1) defines one medicine and its schedule rules. The first part of the file stores the core medicine metadata, and the later fields store frequency and cyclic scheduling data.
- [lib/data/models/medicine_log_model.dart](lib/data/models/medicine_log_model.dart#L1) stores dose history entries, including the scheduled time, actual time, and status such as taken or skipped.
- [lib/data/models/appointment_model.dart](lib/data/models/appointment_model.dart#L1) stores an appointment, its reminder lead time, recurring reminder settings, and completion state.
- [lib/data/models/journal_model.dart](lib/data/models/journal_model.dart#L1) stores wellness journal entries with date, mood, and optional notes.
- [lib/data/models/report_model.dart](lib/data/models/report_model.dart#L1) stores uploaded document metadata such as title, category, upload date, and file path.
- [lib/data/models/streak_model.dart](lib/data/models/streak_model.dart#L1) stores streak progress for adherence or wellness tracking.
- [lib/data/models/chat_message_model.dart](lib/data/models/chat_message_model.dart#L1) stores each chat bubble, whether it came from the user, timestamp, and whether it was blocked by safety rules.
- [lib/data/models/notification_settings_model.dart](lib/data/models/notification_settings_model.dart#L1) stores the selected short and long notification sounds and whether those sounds apply to medicines or appointments.

### Auth and onboarding controllers

- [lib/view_models/auth_controller.dart](lib/view_models/auth_controller.dart#L1) is the main authentication controller. The first methods validate passwords and handle sign-up; later methods manage login, logout, session storage, and routing.
- [lib/view_models/login_view_controller.dart](lib/view_models/login_view_controller.dart#L1) only manages login screen UI state, mainly password visibility.
- [lib/view_models/signup_view_controller.dart](lib/view_models/signup_view_controller.dart#L1) does the same for the sign-up screen, but with both password and confirm-password visibility plus password strength hints.

### Medicine flow

- [lib/view_models/medicine_controller.dart](lib/view_models/medicine_controller.dart#L1) is the main medicine logic file. The top section defines form state and reactive values, while the middle and lower parts handle loading medicines, saving them, tracking logs, schedule evaluation, and notification handling.
- [lib/views/medicine_list_view.dart](lib/views/medicine_list_view.dart#L1) shows the medicine list, low-stock alerts, and the add button that opens the add-medicine screen.
- [lib/views/add_medicine_view.dart](lib/views/add_medicine_view.dart#L1) is the form used to create or edit a medicine. The first part wires the controller and pre-fills data when editing.
- [lib/views/medicine_action_dialog.dart](lib/views/medicine_action_dialog.dart#L1) is the modal shown when the user taps a reminder notification and needs to mark a medicine as taken, missed, or snoozed.
- [lib/views/medication_history_view.dart](lib/views/medication_history_view.dart#L1) displays historical medicine logs in a tabbed view.
- [lib/views/widgets/schedule_item_card.dart](lib/views/widgets/schedule_item_card.dart#L1) renders one schedule row and supports dismissal or action gestures.

### Appointment flow

- [lib/view_models/appointment_controller.dart](lib/view_models/appointment_controller.dart#L1) owns appointment CRUD, sorting, recurring reminders, and alert scheduling. The `saveAppointment` and `_scheduleAlert` methods are the main functions to understand.
- [lib/views/appointments_view.dart](lib/views/appointments_view.dart#L1) lists appointments, separates upcoming and history items, and uses tabs to organize the content.
- [lib/views/add_appointment_view.dart](lib/views/add_appointment_view.dart#L1) is the appointment creation/edit form and uses the controller’s prefill logic when editing existing items.

### Schedule and calendar

- [lib/view_models/schedule_controller.dart](lib/view_models/schedule_controller.dart#L1) combines medicines and appointments into one calendar-driven timeline. Its `scheduleForDate` method builds the schedule items, and `markedDates` decides which dates get event indicators.
- [lib/views/schedule_view.dart](lib/views/schedule_view.dart#L1) is the screen that shows the calendar and the day’s schedule list.
- [lib/views/widgets/schedule_item_card.dart](lib/views/widgets/schedule_item_card.dart#L1) is the reusable card that renders each medicine or appointment item in the schedule.
- [lib/views/widgets/animated_empty_state.dart](lib/views/widgets/animated_empty_state.dart#L1) shows the animated empty state when nothing is scheduled for the selected day.

### Dashboard and home navigation

- [lib/views/home_view.dart](lib/views/home_view.dart#L1) is the main shell after login. The first part defines the tab pages, and the lower part renders the custom glass bottom navigation bar.
- [lib/views/tabs/dashboard_view.dart](lib/views/tabs/dashboard_view.dart#L1) is the daily landing page. The top section builds the background and calendar, and the rest of the file groups the medicine and appointment cards.
- [lib/views/tabs/health_hub_view.dart](lib/views/tabs/health_hub_view.dart#L1) is the hub screen that links to appointments, analytics, wellness, reports, chat, and health records.
- [lib/views/widgets/animated_list_item.dart](lib/views/widgets/animated_list_item.dart#L1) provides reusable entry animation wrappers used by multiple list-style screens.

### Profile and health records

- [lib/view_models/profile_controller.dart](lib/view_models/profile_controller.dart#L1) loads the profile from Hive first, then syncs with Firebase, and exposes helpers for editing, BMI, image selection, logout, and health record lists.
- [lib/views/profile_view.dart](lib/views/profile_view.dart#L1) shows the current user profile and shortcuts into edit/settings pages.
- [lib/views/edit_profile_view.dart](lib/views/edit_profile_view.dart#L1) is the editing form for name, date of birth, gender, blood group, height, and weight.
- [lib/views/health_records_view.dart](lib/views/health_records_view.dart#L1) combines health details, allergies, chronic illness data, current medicine references, and past medicine history.

### Reports and analytics

- [lib/view_models/analytics_controller.dart](lib/view_models/analytics_controller.dart#L1) loads logs and medicines and transforms them into chart-ready analytics such as taken vs missed distribution and 7-day/28-day trends.
- [lib/view_models/report_controller.dart](lib/view_models/report_controller.dart#L1) manages uploaded reports, including file picking, filtering, and persistence.
- [lib/views/analytics_view.dart](lib/views/analytics_view.dart#L1) draws the charts and summary cards using `fl_chart`.
- [lib/views/reports_view.dart](lib/views/reports_view.dart#L1) displays stored reports and report actions.

### Wellness, chat, and support

- [lib/view_models/wellness_controller.dart](lib/view_models/wellness_controller.dart#L1) manages mood entries, journaling, streaks, and challenge generation for the wellness area.
- [lib/view_models/chat_controller.dart](lib/view_models/chat_controller.dart#L1) is the AI chat state controller. It loads history, initializes Gemini, blocks unsafe prompts, stores the conversation, and resets chat sessions after errors.
- [lib/views/wellness_view.dart](lib/views/wellness_view.dart#L1) shows the wellness module UI.
- [lib/views/chat_view.dart](lib/views/chat_view.dart#L1) is the chat interface that binds to the chat controller and auto-scrolls to the latest message.
- [lib/views/help_support_view.dart](lib/views/help_support_view.dart#L1) contains support/contact actions like opening email.

### Settings and notification sounds

- [lib/view_models/settings_controller.dart](lib/view_models/settings_controller.dart#L1) manages theme, timezone, notification sound settings, and rescheduling reminders after sound changes.
- [lib/view_models/notification_settings_controller.dart](lib/view_models/notification_settings_controller.dart#L1) is a smaller controller specifically for the notification sound settings screen and preview playback.
- [lib/views/settings_view.dart](lib/views/settings_view.dart#L1) is the main app settings page.
- [lib/views/notification_settings_view.dart](lib/views/notification_settings_view.dart#L1) exposes notification behavior settings.
- [lib/views/notification_sound_settings_view.dart](lib/views/notification_sound_settings_view.dart#L1) is the screen for choosing and previewing sound assets.

### Reusable UI building blocks

- [lib/views/widgets/orb_painter.dart](lib/views/widgets/orb_painter.dart#L1) draws the animated orb background shared across many screens.
- [lib/views/widgets/premium_card.dart](lib/views/widgets/premium_card.dart#L1) is a generic glass-style card widget.
- [lib/views/widgets/custom_text_field.dart](lib/views/widgets/custom_text_field.dart#L1) is a reusable form field widget used in simpler forms.
- [lib/views/widgets/animated_empty_state.dart](lib/views/widgets/animated_empty_state.dart#L1) provides the empty state animation used by the schedule screen.

## 10. Reading Order for a New Developer

If you want to understand the project fast, read the files in this order:

1. [lib/main.dart](lib/main.dart#L1)
2. [lib/data/services/hive_service.dart](lib/data/services/hive_service.dart#L1)
3. [lib/data/services/notification_service.dart](lib/data/services/notification_service.dart#L1)
4. [lib/view_models/auth_controller.dart](lib/view_models/auth_controller.dart#L1)
5. [lib/view_models/medicine_controller.dart](lib/view_models/medicine_controller.dart#L1)
6. [lib/view_models/appointment_controller.dart](lib/view_models/appointment_controller.dart#L1)
7. [lib/view_models/profile_controller.dart](lib/view_models/profile_controller.dart#L1)
8. [lib/view_models/schedule_controller.dart](lib/view_models/schedule_controller.dart#L1)
9. [lib/views/home_view.dart](lib/views/home_view.dart#L1)
10. [lib/views/tabs/dashboard_view.dart](lib/views/tabs/dashboard_view.dart#L1)

## 11. Notes On Generated Files

Any file that ends with `.g.dart` is generated automatically for Hive. These files are not where the business logic lives, so for demo prep you should focus on the parent `.dart` file instead.

## 12. What Each Major Controller Is Responsible For

- `AuthController`: account creation, login, logout, password validation.
- `MedicineController`: add/edit/remove medicines, reminder times, logs, stock, schedule checks.
- `AppointmentController`: appointment CRUD, completion, recurring appointment reminders.
- `ProfileController`: cloud/local profile sync, BMI, personal health records, avatar selection.
- `ScheduleController`: combines medicines and appointments into a single calendar schedule.
- `SettingsController`: theme, timezone, notification sound preferences, rescheduling.
- `ChatController`: Gemini AI conversation, safety filtering, local chat history.
- `AnalyticsController`: chart data and adherence trends.
- `ReportController`: file upload and report storage.
- `WellnessController`: journal entries, streaks, and wellness prompts.

## 13. Demo-Friendly One-Line Summaries

- `main.dart`: starts the app and wires all services together.
- `home_view.dart`: hosts the main tab navigation after login.
- `dashboard_view.dart`: shows today’s medicines and appointments.
- `medicine_controller.dart`: drives medicine CRUD and reminder logic.
- `appointment_controller.dart`: drives appointment CRUD and reminder logic.
- `profile_controller.dart`: manages profile and health records.
- `schedule_controller.dart`: merges medicine and appointment data into one schedule.
- `chat_controller.dart`: powers the AI health assistant.
- `settings_controller.dart`: manages theme and reminder sounds.

## 14. If A Teacher Asks You A Question

Use these short answers as a starting point, then point to the file named below.

- If they ask what starts the app, say it is [lib/main.dart](lib/main.dart#L1) because it initializes Firebase, Hive, notifications, controllers, and navigation.
- If they ask where login works, point to [lib/view_models/auth_controller.dart](lib/view_models/auth_controller.dart#L1) and [lib/data/services/firebase_auth_service.dart](lib/data/services/firebase_auth_service.dart#L1).
- If they ask where medicines are saved or scheduled, point to [lib/view_models/medicine_controller.dart](lib/view_models/medicine_controller.dart#L1), [lib/data/models/medicine_model.dart](lib/data/models/medicine_model.dart#L1), and [lib/data/services/notification_service.dart](lib/data/services/notification_service.dart#L1).
- If they ask where appointments are handled, point to [lib/view_models/appointment_controller.dart](lib/view_models/appointment_controller.dart#L1) and [lib/data/models/appointment_model.dart](lib/data/models/appointment_model.dart#L1).
- If they ask where profile data is managed, point to [lib/view_models/profile_controller.dart](lib/view_models/profile_controller.dart#L1) and [lib/data/models/user_model.dart](lib/data/models/user_model.dart#L1).
- If they ask where the dashboard or home page is, point to [lib/views/home_view.dart](lib/views/home_view.dart#L1) and [lib/views/tabs/dashboard_view.dart](lib/views/tabs/dashboard_view.dart#L1).
- If they ask where analytics or reports are, point to [lib/view_models/analytics_controller.dart](lib/view_models/analytics_controller.dart#L1), [lib/views/analytics_view.dart](lib/views/analytics_view.dart#L1), and [lib/view_models/report_controller.dart](lib/view_models/report_controller.dart#L1).
- If they ask where chat or AI is, point to [lib/view_models/chat_controller.dart](lib/view_models/chat_controller.dart#L1), [lib/data/services/gemini_service.dart](lib/data/services/gemini_service.dart#L1), and [lib/views/chat_view.dart](lib/views/chat_view.dart#L1).
- If they ask where settings are, point to [lib/view_models/settings_controller.dart](lib/view_models/settings_controller.dart#L1), [lib/views/settings_view.dart](lib/views/settings_view.dart#L1), and [lib/views/notification_sound_settings_view.dart](lib/views/notification_sound_settings_view.dart#L1).

## 15. If They Ask You To Change Something

This is the fastest way to find the right file.

- Change login validation or login behavior: edit [lib/view_models/auth_controller.dart](lib/view_models/auth_controller.dart#L1) first, then check [lib/views/login_view.dart](lib/views/login_view.dart#L1) if the button or field UI also needs to change.
- Change medicine fields, reminder logic, or stock rules: edit [lib/view_models/medicine_controller.dart](lib/view_models/medicine_controller.dart#L1) and [lib/data/models/medicine_model.dart](lib/data/models/medicine_model.dart#L1).
- Change how medicine reminders appear or behave: edit [lib/data/services/notification_service.dart](lib/data/services/notification_service.dart#L1) and, if the UI needs a change, [lib/views/medicine_action_dialog.dart](lib/views/medicine_action_dialog.dart#L1).
- Change appointment reminders or recurring appointments: edit [lib/view_models/appointment_controller.dart](lib/view_models/appointment_controller.dart#L1) and [lib/data/models/appointment_model.dart](lib/data/models/appointment_model.dart#L1).
- Change profile fields or health records: edit [lib/view_models/profile_controller.dart](lib/view_models/profile_controller.dart#L1), [lib/data/models/user_model.dart](lib/data/models/user_model.dart#L1), and [lib/views/edit_profile_view.dart](lib/views/edit_profile_view.dart#L1).
- Change dashboard layout or what appears on the home screen: edit [lib/views/home_view.dart](lib/views/home_view.dart#L1) and [lib/views/tabs/dashboard_view.dart](lib/views/tabs/dashboard_view.dart#L1).
- Change schedule/calendar behavior: edit [lib/view_models/schedule_controller.dart](lib/view_models/schedule_controller.dart#L1) and [lib/views/schedule_view.dart](lib/views/schedule_view.dart#L1).
- Change analytics charts or summary metrics: edit [lib/view_models/analytics_controller.dart](lib/view_models/analytics_controller.dart#L1) and [lib/views/analytics_view.dart](lib/views/analytics_view.dart#L1).
- Change reports or file uploads: edit [lib/view_models/report_controller.dart](lib/view_models/report_controller.dart#L1) and [lib/views/reports_view.dart](lib/views/reports_view.dart#L1).
- Change AI responses, safety blocking, or chat history: edit [lib/view_models/chat_controller.dart](lib/view_models/chat_controller.dart#L1), [lib/data/services/gemini_service.dart](lib/data/services/gemini_service.dart#L1), and [lib/data/services/safety_rules_service.dart](lib/data/services/safety_rules_service.dart#L1).
- Change theme or notification sounds: edit [lib/view_models/settings_controller.dart](lib/view_models/settings_controller.dart#L1), [lib/views/settings_view.dart](lib/views/settings_view.dart#L1), and [lib/views/notification_sound_settings_view.dart](lib/views/notification_sound_settings_view.dart#L1).

## 16. What To Read First If You Need To Edit Something

If a teacher points to a feature and says “change this”, start with the controller first, then open the matching view, then open the model or service only if the data or backend behavior must change.

- UI problem: start in the view file.
- Data problem: start in the model file.
- Logic problem: start in the controller.
- Storage or backend problem: start in the service.

That rule will save you time during the demo and is usually the safest way to navigate this project.

If you want, I can make the next version even more explicit by adding a per-file “important methods” list for every controller and service, so each file gets its own mini cheat sheet.

## 17. Mini Cheat Sheet For Controllers And Services

Use this when a teacher points at a feature and asks what method controls it.

### Controllers

#### [auth_controller.dart](lib/view_models/auth_controller.dart#L1)

- `validatePassword()` checks password length and format.
- `signUp()` creates the account and sends verification email.
- `login()` signs in the user.
- `logout()` clears session data and sends the user back to login.

#### [medicine_controller.dart](lib/view_models/medicine_controller.dart#L1)

- `onInit()` loads medicines and logs when the controller starts.
- `loadMedicines()` reads medicine data from Hive.
- `saveMedicine()` creates or updates a medicine.
- `deleteMedicine()` removes a medicine.
- `loadLogs()` reads medication history.
- `markAsTaken()` stores a taken dose log.
- `markAsSkippedExplicit()` stores a skipped dose log.
- `clearStatus()` removes a taken/skipped status for one dose.
- `isScheduledForDate()` checks whether a medicine should appear on a given day.
- `isTaken()` and `isMissed()` check dose status for the dashboard and schedule.
- `rescheduleAllNotifications()` refreshes all reminder alarms after sound changes.

#### [appointment_controller.dart](lib/view_models/appointment_controller.dart#L1)

- `onInit()` loads appointments when the controller starts.
- `loadAppointments()` reads appointments from Hive and sorts them.
- `saveAppointment()` creates or updates an appointment.
- `deleteAppointment()` removes an appointment and cancels its alert.
- `markCompleted()` moves an appointment to history.
- `_scheduleAlert()` sets the appointment notification.
- `rescheduleAllNotifications()` refreshes all appointment reminders.
- `prepareEdit()` fills the form when editing an existing appointment.

#### [profile_controller.dart](lib/view_models/profile_controller.dart#L1)

- `onInit()` loads profile data and attaches BMI listeners.
- `loadProfile()` loads local profile first and then syncs from Firebase.
- `prepareEditData()` fills the edit profile form.
- `updateProfile()` saves the edited profile locally and online.
- `pickImage()` lets the user pick a profile photo.
- `logout()` signs out and clears the local session.
- `addAllergy()` / `removeAllergy()` update allergy records.
- `addIllness()` / `removeIllness()` update chronic illness records.
- `addRestraint()` / `removeRestraint()` update health restriction records.

#### [schedule_controller.dart](lib/view_models/schedule_controller.dart#L1)

- `onInit()` connects the controller to medicine and appointment controllers.
- `onDaySelected()` changes the selected calendar day.
- `scheduleForDate()` builds the full schedule for one date.
- `markedDates` returns the set of dates that should show calendar markers.
- `appointmentsForDate()` filters appointments for a specific day.
- `medicinesForDate()` filters scheduled medicines for a specific day.
- `markMedicineTaken()` marks a dose as taken from the schedule screen.
- `findMedicine()` and `findAppointment()` locate items by ID.

#### [settings_controller.dart](lib/view_models/settings_controller.dart#L1)

- `onInit()` loads theme, sound settings, and timezone.
- `_loadSettings()` loads the saved dark/light mode.
- `_initTimeZone()` reads the device timezone.
- `toggleTheme()` switches between dark and light themes.
- `_loadNotificationSettings()` loads saved reminder sounds.
- `updateShortSound()` and `updateLongSound()` save the selected sound files.
- `toggleMedicineSound()` and `toggleAppointmentSound()` decide which channel uses which sound.
- `_saveNotificationSettings()` saves the settings and reschedules all reminders.
- `previewSound()` plays an audio sample.

#### [notification_settings_controller.dart](lib/view_models/notification_settings_controller.dart#L1)

- `onInit()` loads the saved notification settings.
- `previewSound()` plays the selected notification sound.
- `updateShortSound()`, `updateLongSound()`, `toggleMedicineNotificationType()`, and `toggleAppointmentNotificationType()` update the chosen sounds and save them.

#### [login_view_controller.dart](lib/view_models/login_view_controller.dart#L1)

- `togglePasswordVisibility()` shows or hides the login password.

#### [signup_view_controller.dart](lib/view_models/signup_view_controller.dart#L1)

- `togglePasswordVisibility()` shows or hides the password field.
- `toggleConfirmVisibility()` shows or hides the confirm-password field.
- `updatePasswordStrength()` updates the strength label as the user types.

#### [chat_controller.dart](lib/view_models/chat_controller.dart#L1)

- `onInit()` loads chat history, starts Gemini, and starts safety rule listening.
- `_loadChatHistory()` reads old messages from Hive.
- `_initGemini()` creates the Gemini chat session.
- `sendMessage()` handles user input, safety filtering, Gemini response, and error handling.
- `_restartChatSession()` resets the Gemini session after errors.
- `_addBotMessage()` stores an assistant message.
- `_persistMessage()` saves a message to Hive.
- `clearHistory()` clears the chat and starts a fresh conversation.

#### [analytics_controller.dart](lib/view_models/analytics_controller.dart#L1)

- `onInit()` loads logs and medicines.
- `loadData()` reloads analytics data from Hive.
- `refreshData()` manually refreshes the data.
- `getStatusDistribution()` builds the pie-chart summary.
- `getLast30DaysLogs()` filters recent logs.
- `getDailyTakenCounts()` builds a 7-day trend.
- `getMissedDoses()` lists skipped or missed logs.
- `getMedicineName()` resolves a medicine ID to a readable name.
- `getMonthlyWeeklyCounts()` builds the 4-week summary.
- `getIrregularMedicines()` finds medicines with a high missed rate.

#### [report_controller.dart](lib/view_models/report_controller.dart#L1)

- `onInit()` loads saved reports.
- `loadReports()` fetches reports from Hive.
- `filterReports()` filters them by title or category.
- `updateSearch()` updates the search query.
- `pickAndAddReport()` lets the user choose a file and save it as a report.
- Other CRUD methods in the file handle deleting and opening reports.

#### [wellness_controller.dart](lib/view_models/wellness_controller.dart#L1)

- `onInit()` loads journals, streaks, and daily challenge content.
- `loadJournal()` loads journal entries from Hive.
- `addEntry()` adds a new mood or journal entry.
- `loadStreak()` reads streak data.
- `calculateStreak()` updates the current streak value.
- `generateDailyChallenge()` creates or fetches the daily wellness challenge.

### Services

#### [hive_service.dart](lib/data/services/hive_service.dart#L1)

- `init()` initializes Hive and registers all adapters.
- `saveUserProfile()` and `getUserProfile()` manage offline profile storage.
- `saveMedicine()` / `getAllMedicines()` / `deleteMedicine()` manage medicines.
- `saveLog()` / `getAllLogs()` / `deleteLog()` manage medication logs.
- `addAppointment()` / `getAllAppointments()` / `updateAppointment()` / `deleteAppointment()` manage appointments.
- `saveJournal()` / `getAllJournals()` manage journal entries.
- `saveReport()` / `getAllReports()` manage report data.
- `saveChatMessage()` / `getAllChatMessages()` / `clearChatHistory()` manage AI chat history.
- `saveNotificationSettings()` / `getNotificationSettings()` manage reminder sound preferences.
- `clearSession()` clears the signed-in user session.

#### [notification_service.dart](lib/data/services/notification_service.dart#L1)

- `init()` sets up notification channels and permissions.
- `_onNotificationTappedBackground()` handles notification actions while the app is in the background.
- `scheduleNotification()` creates a new reminder notification.
- `cancel()` removes one reminder.
- `cancelAll()` removes all pending reminders.
- Other helper methods in the file manage channel creation, payload handling, and sound selection.

#### [firebase_auth_service.dart](lib/data/services/firebase_auth_service.dart#L1)

- `_handleException()` converts Firebase and timeout errors into readable messages.
- `signUp()` creates a Firebase Auth account.
- `login()` signs the user in.
- `googleSignIn()` logs the user in with Google.
- `sendPasswordReset()` starts the reset-password flow.
- `changePassword()` updates the password after recent login.
- `logout()` signs the user out.

#### [realtime_database_service.dart](lib/data/services/realtime_database_service.dart#L1)

- `saveUser()` writes a profile to Firebase Realtime Database.
- `getUser()` reads a profile from Firebase Realtime Database.

#### [gemini_service.dart](lib/data/services/gemini_service.dart#L1)

- `apiKey` reads the Gemini key from `.env`.
- `buildChatModel()` creates a configured Gemini model.

#### [safety_rules_service.dart](lib/data/services/safety_rules_service.dart#L1)

- `startListening()` watches Firebase for updated blocked keywords.
- `stopListening()` stops the listener.
- `isBlocked()` checks whether a message should be blocked.
- The file also keeps default blocked keywords for offline safety.

## 18. How To Answer “Where Do I Change This?” In One Sentence

- App startup or routes: change `main.dart`.
- Login/signup/logout: change `auth_controller.dart` and `firebase_auth_service.dart`.
- Medicine data or schedule logic: change `medicine_controller.dart` and `medicine_model.dart`.
- Appointment behavior: change `appointment_controller.dart` and `appointment_model.dart`.
- Profile or health records: change `profile_controller.dart` and `user_model.dart`.
- Dashboard layout: change `home_view.dart` or `dashboard_view.dart`.
- Schedule/calendar: change `schedule_controller.dart` and `schedule_view.dart`.
- Analytics and reports: change `analytics_controller.dart` / `analytics_view.dart` and `report_controller.dart` / `reports_view.dart`.
- Chat or AI safety: change `chat_controller.dart`, `gemini_service.dart`, and `safety_rules_service.dart`.
- Theme and notification sound settings: change `settings_controller.dart` and the related settings views.