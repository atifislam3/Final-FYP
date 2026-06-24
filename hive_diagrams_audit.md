# Hive Schema Diagrams vs Codebase Audit

This document outlines the exact differences between the provided database diagrams (`hive 1.png` and `hive 2.png`) and the actual implementation in `lib/data/models/` and `HiveService`.

## 🖼️ `hive 1.png` (Matches Perfectly) ✅

The first diagram is **100% accurate** and matches the code perfectly.

* **`userBox`**: All fields mapped accurately to `user_model.dart` and `hive_service.dart` (including local-only fields like `allergies`, `chronicIllnesses`, `restraints`).
* **`medicineBox` (`MedicineModel`)**: Correctly lists all 14 fields, including the exact scheduling logic variables (`frequencyType`, `interval`, `cycleOnDays`, `cycleOffDays`, `startDate`, `dateEnded`, etc.).
* **`medicineLogBox` (`MedicineLogModel`)**: Correctly matches all 5 fields (`logId`, `medicineId`, `scheduledTime`, `actualTime`, `status`).

---

## 🖼️ `hive 2.png` (Needs Minor Fixes) ❌

The second diagram is mostly correct, but there are a few **missing fields** and one **name mismatch** when compared to the current code. Here is exactly what needs to be updated in the diagram:

### 1. `appointmentBox` (Missing Fields)
The code (`AppointmentModel`) has two extra properties related to recurring appointments that are missing from the diagram. 
**Required Diagram Updates:**
* Add `isRecurring` (bool)
* Add `recurringFrequency` (String?)

### 2. `chatBox` (Missing Field)
The code (`ChatMessageModel`) has an extra safety feature property that is missing from the diagram.
**Required Diagram Updates:**
* Add `isBlocked` (bool) - *Used for UC-41 safety filters.*

### 3. `documentBox` (Name Mismatch)
The diagram lists a box named **`documentBox`** with a **`MedicalDocument`** object containing a `docId`. The actual code implements this differently.
**Required Diagram Updates:**
* Rename box to **`reportBox`**
* Rename model to **`ReportModel`**
* Rename `docId` to **`id`**

### 4. `notificationSettingsBox` (Missing Entirely)
The code contains a `NotificationSettingsModel` and `notificationSettingsBox` to store customized alert sounds, which is completely missing from the diagrams.
**Required Diagram Updates (Optional):**
* Create a new box named **`notificationSettingsBox`**
* Model name: **`NotificationSettingsModel`**
* Fields to add: 
  * `shortSoundName` (String)
  * `longSoundName` (String)
  * `useShortForMedicine` (bool)
  * `useShortForAppointments` (bool)

*(Note: The code also uses a general `settingsBox` in `main.dart` for things like the `isDarkMode` toggle, which could also be added for completeness.)*
