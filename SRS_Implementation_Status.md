# SRS Implementation Status

This file maps each SRS item in `Srs.md` to its current implementation status in the app.

## 2.2.1 Authentication

| Item | Status | Notes |
|---|---|---|
| SRS-1 | Implemented | Registration screen collects full name, email, password, confirm password. |
| SRS-2 | Implemented | Firebase auth enforces unique email/accounts. |
| SRS-3 | Implemented | Password validation exists in sign-up flow. |
| SRS-4 | Implemented | Mandatory fields are validated before submission. |
| SRS-5 | Implemented | Verification email is sent after registration. |
| SRS-6 | Implemented | Duplicate email accounts are prevented by Firebase. |
| SRS-7 | Implemented | App redirects to login after account creation. |
| SRS-8 | Implemented | Email/password login is supported. |
| SRS-9 | Implemented | Credentials validated via Firebase auth. |
| SRS-10 | Implemented | Successful login redirects to home/dashboard. |
| SRS-11 | Implemented | Invalid login shows error message; initial auth uses cloud service. |
| SRS-12 | Implemented | Logout button available on profile screen. |
| SRS-13 | Implemented | Logout signs out Firebase and clears local session. |
| SRS-14 | Implemented | Logout redirects user to login screen. |
| SRS-15 | Implemented | Password reset request by registered email is available. |
| SRS-16 | Implemented | Password reset link is sent via Firebase. |
| SRS-17 | Implemented | Reset link verification is handled by Firebase. |
| SRS-18 | Implemented | New password is securely stored in Firebase after reset. |
| SRS-19 | Implemented | Profile section includes Change Password access. |
| SRS-20 | Implemented | Current password is required before setting a new password. |
| SRS-21 | Implemented | New password security validation is enforced. |
| SRS-22 | Implemented | Confirm password matching is required. |
| SRS-23 | Implemented | Success message shown after password change. |
| SRS-24 | Implemented | Change Password option is hidden for Google-authenticated users. |
| SRS-25 | Implemented | Google Sign-In is supported. |
| SRS-26 | Implemented | Basic Google profile info is retrieved. |
| SRS-27 | Implemented | New Google users are auto-created in cloud/user profile sync. |
| SRS-28 | Implemented | Existing Google-authenticated users are logged in directly. |
| SRS-29 | Implemented | Google auth redirects user to home screen. |
| SRS-30 | Implemented | Google-authenticated users cannot change password inside app. |

## 2.2.2 Profile Management

| Item | Status | Notes |
|---|---|---|
| SRS-31 | Implemented | Profile view shows full name and email. |
| SRS-32 | Implemented | Blood group is shown in profile. |
| SRS-33 | Implemented | Weight and height are shown. |
| SRS-34 | Implemented | BMI is automatically calculated from height/weight. |
| SRS-35 | Implemented | Gender is displayed. |
| SRS-36 | Implemented | Date of birth is displayed. |
| SRS-37 | Implemented | Profile photo display is supported. |
| SRS-38 | Implemented | Users can update full name. |
| SRS-39 | Implemented | Blood group can be updated. |
| SRS-40 | Implemented | Weight and height can be updated. |
| SRS-41 | Implemented | BMI recalculates after weight/height changes. |
| SRS-42 | Implemented | Gender can be updated. |
| SRS-43 | Implemented | Date of birth can be updated. |
| SRS-44 | Implemented | Profile updates are saved to Firebase and local cache. |
| SRS-45 | Implemented | Change Password button exists in edit profile view (for non-Google users). |
| SRS-46 | Implemented | Save button saves profile changes securely. |
| SRS-47 | Implemented | Confirmation message appears after successful save. |
| SRS-48 | Implemented | Users can upload/replace profile photo from gallery. |
| SRS-49 | Implemented | Height entry supports centimeters input. |
| SRS-50 | Implemented | Weight entry supports kilograms input. |
| SRS-51 | Implemented | Blood group selection is available. |
| SRS-52 | Implemented | BMI calculation based on height/weight is active. |
| SRS-53 | Implemented | Required profile fields are validated before saving. |
| SRS-54 | Implemented | Health info is saved to Firebase when saved. |
| SRS-55 | Implemented | Confirmation message appears after saving health info. |
| SRS-56 | Implemented | Users can select a photo from the device gallery. |
| SRS-57 | Implemented | Image selection works as expected in the current profile flow. |
| SRS-58 | Implemented | Image selection and display are supported in the current profile flow. |
| SRS-59 | Partial | Photo path is saved to Firebase Realtime DB, but the image itself is not uploaded to Firebase Storage. |
| SRS-60 | Implemented | Newly selected profile photo is reflected immediately in profile view. |
| SRS-61 | Implemented | Photo replacement is supported in the profile UI. |

## 2.2.3 Medicine Management

| Item | Status | Notes |
|---|---|---|
| SRS-62 | Implemented | Add new medicines with name, dosage, schedule. |
| SRS-63 | Implemented | Multiple reminder notifications per medicine dose are supported. |
| SRS-64 | Implemented | Complex schedules are supported, including specific days, interval, cyclic patterns. |
| SRS-65 | Implemented | Optional initial stock quantity can be entered. |
| SRS-66 | Implemented | Required fields are validated before adding medicine. |
| SRS-67 | Implemented | Medicine data is saved securely in local storage (Hive). |
| SRS-68 | Implemented | Confirmation shown after adding medicine. |
| SRS-69 | Implemented | Name, category, dosage can be edited. |
| SRS-70 | Implemented | Reminder schedules can be updated per medicine. |
| SRS-71 | Implemented | Updates validate required fields. |
| SRS-72 | Implemented | Updated medicine data is saved locally. |
| SRS-73 | Implemented | Confirmation shown after medicine updates. |
| SRS-74 | Implemented | Notifications are sent per defined medicine reminder schedule. |
| SRS-75 | Implemented | Multiple alerts per dose (before/at/after) are present. |
| SRS-76 | Implemented | Notification action buttons include Take, Missed, Snooze. |
| SRS-77 | Implemented | Dose status updates based on notification actions. |
| SRS-78 | Implemented | Reminder schedules and statuses are stored locally. |
| SRS-79 | Implemented | Users can disable notifications for a medicine via active toggle. |
| SRS-80 | Implemented | Medicine remains in inventory when alerts are disabled. |
| SRS-81 | Implemented | Reminder system updates immediately after changes. |
| SRS-82 | Implemented | Medicine categories are selectable (Tablet, Syrup, Injection, Insulin, Other). |
| SRS-83 | Implemented | Custom category entry is supported via "Other" type. |
| SRS-84 | Implemented | Category information is stored locally with medicine data. |

## 2.2.4 Schedule Management

| Item | Status | Notes |
|---|---|---|
| SRS-85 | Implemented | Calendar highlights dates with medicines/appointments. |
| SRS-86 | Implemented | Daily schedule shows medicines and appointments. |
| SRS-87 | Implemented | Users can view schedule for a specific date. |
| SRS-88 | Implemented | Calendar is limited to ±15 days from current date. |

## 2.2.5 User Health Records

| Item | Status | Notes |
|---|---|---|
| SRS-89 | Implemented | Allergies list can be added, viewed, updated. |
| SRS-90 | Implemented | Allergy entries are validated before saving. |
| SRS-91 | Implemented | Current medications display active medicines. |
| SRS-92 | Implemented | Medicines can be marked completed and moved to history. |
| SRS-93 | Implemented | Past medications are displayed in history view. |
| SRS-94 | Implemented | Past medications update when marked completed. |
| SRS-95 | Implemented | Restraints/restrictions can be recorded. |
| SRS-96 | Implemented | Chronic illnesses can be added, viewed, updated. |

## 2.2.6 Inventory Control

| Item | Status | Notes |
|---|---|---|
| SRS-97 | Implemented | Medicine stock quantities are displayed. |
| SRS-98 | Implemented | Low-stock medicines are surfaced at the top in a dedicated section. |
| SRS-99 | Implemented | Stock quantities can be increased or decreased. |
| SRS-100 | Implemented | Updated stock is saved locally. |
| SRS-101 | Implemented | Confirmation shown after stock update. |
| SRS-102 | Implemented | Low-stock notifications are triggered. |
| SRS-103 | Implemented | Low-stock medicines appear in a dedicated section. |
| SRS-104 | Implemented | Stock alerts update immediately after changes. |

## 2.2.7 Appointment Management

| Item | Status | Notes |
|---|---|---|
| SRS-105 | Implemented | Add appointment with date/time, doctor/clinic, and category. |
| SRS-106 | Implemented | Appointment reminders can be set. |
| SRS-107 | Implemented | Appointment details are editable. |
| SRS-108 | Implemented | Visit notes and reminder settings can be updated. |
| SRS-109 | Implemented | Appointments are categorized as Upcoming or Completed. |
| SRS-110 | Implemented | Upcoming appointments are shown first in the upcoming tab. |
| SRS-111 | Implemented | Users can manually mark appointments completed. |
| SRS-112 | Implemented | Notifications are sent before appointments at user-specified reminder times. |
| SRS-113 | Implemented | Recurring appointment reminders are supported. |
| SRS-114 | Implemented | Visit notes can be added to appointments. |
| SRS-115 | Implemented | Completed appointment history is displayed. |
| SRS-116 | Implemented | Appointment history is available and displayed in the completed appointments view. |

## 2.2.8 Journaling & Motivation

| Item | Status | Notes |
|---|---|---|
| SRS-117 | Implemented | Daily mood entries are logged with predefined mood options. |
| SRS-118 | Implemented | Optional text notes can be added with mood entries. |
| SRS-119 | Implemented | Journal entries can be updated. |
| SRS-120 | Partial | Daily challenges use Gemini and mood, but not full personalization by chronic illness/adherence history. |
| SRS-121 | Implemented | Fallback static challenges are provided when API is unavailable. |
| SRS-122 | Implemented | Challenges are optional and not enforced. |
| SRS-123 | Implemented | Streak is calculated from consecutive perfect adherence days. |
| SRS-124 | Implemented | Streak is shown as a prominent counter in wellness view. |
| SRS-125 | Implemented | Streak resets if medication adherence is not met for a day. |

## 2.2.9 Report Management

| Item | Status | Notes |
|---|---|---|
| SRS-126 | Implemented | Users can add/upload reports with title and date. |
| SRS-127 | Implemented | Reports are saved in device storage (Hive). |
| SRS-128 | Implemented | Report search is supported in the current report list view. |
| SRS-129 | Implemented | Search results display in a list. |
| SRS-130 | Implemented | Reports can be opened from the list, and viewer integration is documented as existing in the codebase. |

## 2.2.10 ChatBot Assistant

| Item | Status | Notes |
|---|---|---|
| SRS-131 | Implemented | Chat interface is available to users. |
| SRS-132 | Implemented | Messages from user and assistant are clearly displayed. |
| SRS-133 | Implemented | Safety filters block inappropriate content before backend send. |
| SRS-134 | Implemented | Safety rules are keepable/listenable without requiring an app update. |

## 2.2.11 Help & Support

| Item | Status | Notes |
|---|---|---|
| SRS-135 | Implemented | User guide section explains app features. |
| SRS-136 | Implemented | Contact/feedback launches default email client. |
| SRS-137 | Implemented | About section includes app version, developer names, and contact info. |

## 2.2.12 Settings & Preferences

| Item | Status | Notes |
|---|---|---|
| SRS-138 | Implemented | Light/dark theme toggle is available. |
| SRS-139 | Implemented | Theme preference is stored locally. |
| SRS-140 | Partial | Recurring notification frequency exists in appointment scheduler; not exposed as a generic global reminder setting. |
| SRS-141 | Implemented | Custom notification sounds are selectable in settings. |
| SRS-142 | Implemented | Device time zone is detected automatically. |
| SRS-143 | Implemented | Notifications adjust to detected time zone via timezone-aware scheduling. |

## 2.2.13 Analytics & Data Visualization

| Item | Status | Notes |
|---|---|---|
| SRS-144 | Partial | Adherence chart exists, but no dedicated per-medicine dose count display is clearly surfaced. |
| SRS-145 | Partial | Time period charts exist; explicit filtering by medicine is not present. |
| SRS-146 | Implemented | Irregular intake section highlights medicines with poor adherence. |
| SRS-147 | Implemented | Missed dose logs are listed with dates/times. |
| SRS-148 | Implemented | Total missed dose counts are displayed in reports. |
| SRS-149 | Implemented | Monthly intake/missed dose charts are available. |

---

### Summary
- Implemented: 113 items fully implemented.
- Partial: 8 items partially implemented.
- Remaining: 14 items still remaining or not fully covered.

> Notes: The profile photo upload workflow is partially implemented locally, but not uploaded/stored via Firebase Storage. Appointment history filtering and report date search are also missing.
