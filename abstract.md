# MedCare — Personal Medicine Reminder App

| Field | Details |
|-------|---------|
| **Project Title** | Personal Medicine Reminder App (MedCare) |
| **Organization** | Federal Urdu University of Arts, Science and Technology |
| **Objectives** | 1. To develop a centralized mobile application that helps users manage their daily medication schedules through intelligent reminders and dose tracking. |
| | 2. To enable users to easily add, schedule, and monitor medicines with support for complex dosage routines including daily, interval-based, and cyclic schedules. |
| | 3. To provide comprehensive health management features including appointment tracking, health records, inventory control, wellness journaling, and AI-powered health assistance. |
| | 4. To implement a reliable offline-first system with cloud sync, interactive push notifications, analytics, and streak tracking to ensure consistent medication adherence and improved health outcomes. |
| **Undertaken By** | Atif Islam |
| | _(add partner name if applicable)_ |
| **Supervised By** | _(add supervisor name)_ |
| **Date Started** | Feb 16, 2026 |
| **Date Completed** | Jun 26, 2026 |
| **Technologies Used** | • Framework: Flutter (Dart) |
| | • Backend & Auth: Firebase (Authentication, Realtime Database) |
| | • Local Storage: Hive (Offline-First) |
| | • State Management: GetX |
| | • Notifications: flutter_local_notifications |
| | • AI Assistant: Google Gemini API |
| | • Charts: fl_chart |
| | • Media: image_picker, file_picker |
| **System Used** | _(add your system specs, e.g., 5th Gen Core i5 @ 2.60 GHz, 8 GB RAM, 256 SSD)_ |

---

## Abstract

In today's fast-paced world, managing personal health and medication schedules remains a critical yet often neglected responsibility for individuals dealing with chronic illnesses, multiple prescriptions, or complex dosage routines. Forgetting a dose, missing an appointment, or losing track of medicine inventory can lead to serious health consequences. The absence of a centralized, intelligent, and offline-capable health management tool leaves patients vulnerable to inconsistent care and poor health outcomes.

**MedCare** is a cross-platform mobile application built to bridge this gap by providing users with a comprehensive, all-in-one personal health companion that combines intelligent medicine reminders, appointment tracking, health record management, and AI-powered wellness features into a single, seamless experience.

A user registers or logs in via email/password or Google Sign-In, then lands on a dynamic dashboard displaying today's scheduled medicines and upcoming appointments. The medicine management module supports complex scheduling — Daily, Specific Days, Interval-Based (every X days), and Cyclic (X days on, Y days off) — with interactive push notifications featuring **Take**, **Snooze**, and **Miss** action buttons that work even when the app is killed. Each dose follows a structured lifecycle: **Pending → Taken → Missed**. The appointment module allows scheduling with configurable reminders, recurring frequencies, visit notes, and full history tracking. A unified calendar merges both medicines and appointments into a single ±15 day timeline.

Beyond reminders, MedCare includes an inventory control system with low-stock alerts, a wellness module with mood journaling, daily AI-generated challenges, and a visual streak tracker for medication adherence. An AI-powered chatbot assistant built on **Google Gemini** provides interactive health guidance with safety filters. Users can also upload and manage health documents, view analytics with adherence charts and missed dose reports, and maintain comprehensive health records including allergies, chronic illnesses, and dietary restraints — all synced between local and cloud storage.

Built with **Flutter (Dart)** for a seamless cross-platform experience, **Firebase** (Authentication, Realtime Database) as the cloud backend, **Hive** for offline-first local storage, **GetX** for reactive state management, **flutter_local_notifications** for the reminder engine, and **Google Gemini AI** for intelligent health assistance, MedCare delivers a reliable, scalable, and user-friendly solution to empower individuals in taking complete control of their medication adherence and overall wellness.
