# Hive Schema Mapping and Code Verification

## Summary

The current codebase matches the Hive schema diagrams closely, with one naming mismatch and a few extra schema details.

- `userBox`, `medicineBox`, `medicineLogBox`, `appointmentBox`, `journalBox`, `reportBox`, `streakBox`, and `chatBox` are all present in code.
- `documentBox` is not present in code. The equivalent box in code is `reportBox`.
- No additional Hive model classes are required beyond the models already in the repository.
- There is also a separate `notificationSettingsBox` and a plain `settingsBox` for app preferences, but these are not part of the diagram boxes you provided.

---

## Matching Hive Boxes and Models

### `userBox`
- Stored value key: `current_user`
- Not a Hive typed object; the current user is stored as a `Map`.
- Fields used in code:
  - `uid`
  - `email`
  - `name` / `fullName`
  - `photoPath` / `photoUrl`
  - `gender`
  - `dateOfBirth`
  - `bloodGroup`
  - `height`
  - `weight`
  - `bmi`
  - `allergies`
  - `chronicIllnesses`
  - `restraints`

### `medicineBox`
- Model: `MedicineModel`
- Key: `medicineId`
- Fields:
  - `medicineId`
  - `name`
  - `dosage`
  - `type`
  - `stock`
  - `reminderTimes: List<DateTime>`
  - `isActive`
  - `frequencyType`
  - `specificDays`
  - `interval`
  - `cycleOnDays`
  - `cycleOffDays`
  - `startDate`
  - `dateEnded`

### `medicineLogBox`
- Model: `MedicineLogModel`
- Key: `logId`
- Fields:
  - `logId`
  - `medicineId`
  - `scheduledTime`
  - `actualTime`
  - `status`

### `appointmentBox`
- Model: `AppointmentModel`
- Key: `id`
- Fields:
  - `id`
  - `doctorName`
  - `category`
  - `dateTime`
  - `reminderMinutes`
  - `visitNotes`
  - `isCompleted`
- Additional code fields:
  - `isRecurring`
  - `recurringFrequency`

### `journalBox`
- Model: `JournalModel`
- Key: `id`
- Fields:
  - `id`
  - `date`
  - `mood`
  - `note`

### `reportBox`
- Model: `ReportModel`
- Key: `id`
- Fields:
  - `id`
  - `title`
  - `dateUploaded`
  - `category`
  - `filePath`

### `streakBox`
- Model: `StreakModel`
- The code uses a fixed key: `user_streak`
- Fields:
  - `currentStreak`
  - `maxStreak`
  - `lastLogDate`

### `chatBox`
- Model: `ChatMessageModel`
- Key: `id`
- Fields:
  - `id`
  - `text`
  - `isUser`
  - `timestamp`
- Additional code field:
  - `isBlocked`

---

## Extra Hive schema elements in code

The repository also contains these Hive storage objects that are outside the diagrams:

- `notificationSettingsBox` with `NotificationSettingsModel`
- plain `settingsBox` used in `main.dart` and `settings_controller.dart`

These are valid code-supported Hive boxes, but they are not part of your current schema diagrams.

---

## Final verification

Yes, the schema diagrams mostly match the code.

- The first diagram is correct for the current code.
- The second diagram is mostly correct.
- The only missing code equivalent in the diagram is `reportBox` instead of `documentBox`.
- There are no extra hidden Hive models beyond the ones listed above.

If you want, I can also update your diagram text to exactly match the current code field names.

---

## Diagram Fixes Needed

Based on the current Dart code, the following updates are required in `hive 2.png` to make the diagrams fully match the code:

1. **`appointmentBox`**
   - Add `isRecurring: bool`
   - Add `recurringFrequency: string?`
   - These are present in `lib/data/models/appointment_model.dart` and correspond to SRS-113.

2. **`chatBox`**
   - Add `isBlocked: bool`
   - This is present in `lib/data/models/chat_message_model.dart` and corresponds to UC-41.

3. **`documentBox` / `MedicalDocument`**
   - Rename the diagram node to `reportBox`
   - Rename the object to `ReportModel`
   - Rename `docId` to `id`
   - This matches `lib/data/models/report_model.dart` exactly.

4. **`settingsBox` / `notificationSettingsBox`**
   - Add a new diagram branch for `settingsBox` or `notificationSettingsBox`.
   - Suggested diagram text:
     - Box: `notificationSettingsBox`
     - Object: `NotificationSettingsModel`
     - Key: `user_notification_settings`
   - Fields from `lib/data/models/notification_settings_model.dart` with types:
     - `shortSoundName: string`
     - `longSoundName: string`
     - `useShortForMedicine: bool`
     - `useShortForAppointments: bool`

These are the only diagram updates needed. The rest of the schema boxes already match the code.

---

## Detailed Code-to-Diagram Field Mapping

### `userBox` vs `UserModel`
- `uid` → `UserModel.uid`
- `email` → `UserModel.email`
- `name` / `fullName` → `UserModel.fullName`
- `photoPath` / `photoUrl` → `UserModel.photoUrl`
- `gender` → `UserModel.gender`
- `dateOfBirth` → `UserModel.dateOfBirth`
- `bloodGroup` → `UserModel.bloodGroup`
- `height` → `UserModel.height`
- `weight` → `UserModel.weight`
- `bmi` → computed by `UserModel.bmiValue` and stored in `toMap()` / `toHiveMap()`
- `allergies` → `UserModel.allergies`
- `chronicIllnesses` → `UserModel.chronicIllnesses`
- `restraints` → `UserModel.restraints`

### `medicineBox` vs `MedicineModel`
- `medicineId` → `MedicineModel.medicineId`
- `name` → `MedicineModel.name`
- `dosage` → `MedicineModel.dosage`
- `type` → `MedicineModel.type`
- `stock` → `MedicineModel.stock`
- `reminderTimes` → `MedicineModel.reminderTimes`
- `isActive` → `MedicineModel.isActive`
- `frequencyType` → `MedicineModel.frequencyType`
- `specificDays` → `MedicineModel.specificDays`
- `interval` → `MedicineModel.interval`
- `cycleOnDays` → `MedicineModel.cycleOnDays`
- `cycleOffDays` → `MedicineModel.cycleOffDays`
- `startDate` → `MedicineModel.startDate`
- `dateEnded` → `MedicineModel.dateEnded`

### `medicineLogBox` vs `MedicineLogModel`
- `logId` → `MedicineLogModel.logId`
- `medicineId` → `MedicineLogModel.medicineId`
- `scheduledTime` → `MedicineLogModel.scheduledTime`
- `actualTime` → `MedicineLogModel.actualTime`
- `status` → `MedicineLogModel.status`

### `appointmentBox` vs `AppointmentModel`
- `id` → `AppointmentModel.id`
- `doctorName` → `AppointmentModel.doctorName`
- `category` → `AppointmentModel.category`
- `dateTime` → `AppointmentModel.dateTime`
- `reminderMinutes` → `AppointmentModel.reminderMinutes`
- `visitNotes` → `AppointmentModel.visitNotes`
- `isCompleted` → `AppointmentModel.isCompleted`
- `isRecurring` → `AppointmentModel.isRecurring` (extra in code)
- `recurringFrequency` → `AppointmentModel.recurringFrequency` (extra in code)

### `journalBox` vs `JournalModel`
- `id` → `JournalModel.id`
- `date` → `JournalModel.date`
- `mood` → `JournalModel.mood`
- `note` → `JournalModel.note`

### `reportBox` vs `ReportModel`
- `id` → `ReportModel.id`
- `title` → `ReportModel.title`
- `dateUploaded` → `ReportModel.dateUploaded`
- `category` → `ReportModel.category`
- `filePath` → `ReportModel.filePath`

### `streakBox` vs `StreakModel`
- `currentStreak` → `StreakModel.currentStreak`
- `maxStreak` → `StreakModel.maxStreak`
- `lastLogDate` → `StreakModel.lastLogDate`

### `chatBox` vs `ChatMessageModel`
- `id` → `ChatMessageModel.id`
- `text` → `ChatMessageModel.text`
- `isUser` → `ChatMessageModel.isUser`
- `timestamp` → `ChatMessageModel.timestamp`
- `isBlocked` → `ChatMessageModel.isBlocked` (extra in code)
