# Database Sample Queries

This file contains sample queries for your project using Hive and Firebase Realtime Database.

## 1. Hive

### Initialize Hive
```dart
await Hive.initFlutter();
await HiveService.init();
```

### Save a medicine
```dart
final medicine = MedicineModel(
  medicineId: 'med123',
  name: 'Paracetamol',
  dose: '500mg',
  frequency: 'Twice a day',
  // add additional fields as needed
);

await HiveService.addMedicine(medicine);
```

### Get all medicines
```dart
List<MedicineModel> medicines = HiveService.getAllMedicines();
```

### Update a medicine
```dart
final updatedMedicine = medicine.copyWith(dose: '650mg');
await HiveService.updateMedicine(updatedMedicine);
```

### Delete a medicine
```dart
await HiveService.deleteMedicine('med123');
```

### Get all appointments
```dart
List<AppointmentModel> appointments = HiveService.getAllAppointments();
```

### Add an appointment
```dart
await HiveService.addAppointment(appointment);
```

### Update an appointment
```dart
await HiveService.updateAppointment(appointment);
```

### Delete an appointment
```dart
await HiveService.deleteAppointment(appointmentId);
```

### Add a medicine log
```dart
await HiveService.addLog(
  MedicineLogModel(
    logId: 'log001',
    medicineId: 'med123',
    takenAt: DateTime.now(),
    status: 'taken',
  ),
);
```

### Query logs for a medicine
```dart
List<MedicineLogModel> logs = HiveService.getLogsForMedicine('med123');
```

### Save notification settings
```dart
await HiveService.saveNotificationSettings(settings);
```

### Read notification settings
```dart
NotificationSettingsModel? settings = HiveService.getNotificationSettings();
```

### Journal operations
```dart
await HiveService.addJournal(journal);
List<JournalModel> journals = HiveService.getAllJournals();
await HiveService.deleteJournal(journal.id);
```

### User session data
```dart
await HiveService.saveUserSession(user.uid);
String? uid = HiveService.getUserId();
Map<String, dynamic>? profile = HiveService.getUserProfile();
bool hasUser = HiveService.hasUser();
await HiveService.clearSession();
```

## 2. Firebase Realtime Database

### Save a user profile
```dart
await RealtimeDatabaseService().saveUser(user);
```

### Read a user profile
```dart
UserModel? user = await RealtimeDatabaseService().getUser(uid);
```

### Update only specific fields
```dart
await FirebaseDatabase.instance
    .ref()
    .child('users')
    .child(uid)
    .update({
      'displayName': 'Ali',
      'phone': '+1234567890',
    });
```

### Example query using `orderByChild` and `equalTo`
```dart
final snapshot = await FirebaseDatabase.instance
    .ref()
    .child('users')
    .orderByChild('email')
    .equalTo('test@example.com')
    .get();

if (snapshot.exists) {
  // handle matching users
}
```

### Read by path
```dart
final snapshot = await FirebaseDatabase.instance
    .ref()
    .child('users/$uid')
    .get();
```

## 3. Practical usage notes

- Use `HiveService` methods rather than opening boxes manually for app logic.
- `Hive` is best for offline local data: medicines, logs, appointments, journals, reports, settings.
- Firebase Realtime Database is best for synced remote user profile data.
- Keep the Firebase structure as:
  - `users/{uid}`
    - `name`
    - `email`
    - `phone`

## 4. Project-specific query patterns

### Local filter example
```dart
var box = Hive.box<MedicineModel>('medicineBox');
var dueToday = box.values
    .where((m) => m.nextDoseDate.day == DateTime.now().day)
    .toList();
```

### Firebase user path example
```dart
final userRef = FirebaseDatabase.instance.ref().child('users/$uid');
```
