# Business Logic Implementation

### 1.1.1 Authentication

The following `AuthController` encapsulates the complete business logic for the Authentication module. It handles secure user registration, session verification, OAuth 2.0 Google Sign-In, and password recovery, coordinating between the Firebase backend and the local Hive offline storage.

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/firebase_auth_service.dart';
import '../data/services/hive_service.dart';
import '../data/services/realtime_database_service.dart';
import '../data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final RealtimeDatabaseService _dbService = RealtimeDatabaseService();
  var isLoading = false.obs;

  // ===================== PASSWORD VALIDATION =====================
  // Enforces security policy: Min 8 chars, 1 Uppercase & 1 Number
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 8) return "Min 8 characters required";
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).*$').hasMatch(value)) {
      return "Must have 1 Uppercase & 1 Number";
    }
    return null;
  }

  // ===================== SIGN IN (REGISTER) =====================
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match", backgroundColor: Colors.red);
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.signUp(email, password, name);
      if (user != null) {
        // Enforce Email Verification Requirement
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }
        // Redirect to Login to prevent unverified access
        Get.offAllNamed('/login');
        Get.snackbar("Success", "Account created! Verification link sent.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =========================== LOGIN ===========================
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final user = await _authService.login(email, password);
      if (user != null) {
        await user.reload();
        
        // Reject login if email remains unverified
        if (!user.emailVerified) {
          Get.snackbar("Verification Required", "Please verify your email first.");
          return;
        }

        // Generate Local Offline Session
        await HiveService.saveUserSession(user.uid);
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ======================= SOCIAL LOGIN ========================
  Future<void> googleLogin() async {
    isLoading.value = true;
    try {
      final user = await _authService.signInWithGoogle();

      if (user != null) {
        await HiveService.saveUserSession(user.uid);
        final existingUser = await _dbService.getUser(user.uid);

        if (existingUser == null) {
          // Profile does not exist -> Generate new compliant Profile Entity
          UserModel newUser = UserModel(
            uid: user.uid,
            email: user.email ?? '',
            fullName: user.displayName ?? 'Google User',
            photoUrl: user.photoURL,
          );
          // Sync Cloud & Local Storage
          await _dbService.saveUser(newUser);
          await HiveService.saveUserProfile(newUser.toHiveMap());
        } else {
          // Profile exists -> Sync existing data
          await HiveService.saveUserProfile(existingUser.toHiveMap());
        }
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ====================== FORGET PASSWORD ======================
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }
    isLoading.value = true;
    try {
      await _authService.sendPasswordResetEmail(email);
      Get.back();
      Get.snackbar("Email Sent", "Check your inbox for reset link");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ====================== CHANGE PASSWORD ======================
  Future<void> updatePassword(
      String currentPass, String newPass, String confirmPass) async {
    if (newPass != confirmPass) {
      Get.snackbar("Error", "New passwords do not match");
      return;
    }
    String? error = validatePassword(newPass);
    if (error != null) {
      Get.snackbar("Weak Password", error);
      return;
    }

    isLoading.value = true;
    try {
      await _authService.changePassword(currentPass, newPass);
      Get.back();
      Get.snackbar("Success", "Password updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =========================== LOGOUT ==========================
  Future<void> logout() async {
    // Terminate Cloud Session
    await FirebaseAuth.instance.signOut();
    // Wipe Secure Local Tokens
    await HiveService.clearSession();
    // Redirect to Auth Gateway
    Get.offAllNamed('/login');
  }
}
```

---

### 1.1.2 Profile Management

The `ProfileController` handles all logic related to user profile views and edits. It covers synchronous local caching of the profile, real-time Firebase syncing, calculating Live BMI, managing medical records (allergies, illnesses, restraints), and securely compressing and uploading user photos.

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/services/realtime_database_service.dart';
import '../data/services/hive_service.dart';
import '../data/models/user_model.dart';

class ProfileController extends GetxController {
  final RealtimeDatabaseService _dbService = RealtimeDatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  var isLoading = false.obs;

  // Edit Fields
  var pickedImage = Rxn<XFile>();
  var removePhoto = false.obs;
  var selectedDate = Rxn<DateTime>();
  var selectedGender = 'Male'.obs;
  var selectedBloodGroup = 'A+'.obs;

  final nameController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  // Live BMI Tracker
  final RxString liveBMI = '0.0'.obs;

  @override
  void onInit() {
    super.onInit();
    heightController.addListener(_updateBMI);
    weightController.addListener(_updateBMI);
    loadProfile();
  }

  // ================= VIEW PROFILE (SYNC LOGIC) =================
  // Retrieves the user's profile instantly from local Hive storage for offline 
  // capabilities, while simultaneously fetching the latest updates from the 
  // Firebase Realtime Database to ensure seamless cloud synchronization.
  void loadProfile() async {
    isLoading.value = true;
    String? uid = _auth.currentUser?.uid ?? HiveService.getUserId();
    if (uid == null) {
      isLoading.value = false;
      return;
    }

    // 1. Local Load (Instant display from Hive)
    var localData = HiveService.getUserProfile();
    if (localData != null) {
      currentUser.value = UserModel.fromMap(localData);
    }

    // 2. Cloud Sync (Realtime DB)
    if (_auth.currentUser != null) {
      try {
        UserModel? cloudUser = await _dbService.getUser(uid);
        if (cloudUser != null) {
          currentUser.value = cloudUser;
          await HiveService.saveUserProfile(cloudUser.toHiveMap());
        }
      } catch (e) {
        print("Sync error: $e");
      }
    }
    isLoading.value = false;
  }

  // ================= UPDATE PROFILE =================
  // Pre-populates the edit fields with the user's current data. When updated,
  // it pushes the new model to the Firebase Realtime Database and updates the 
  // local Hive cache, ensuring strict data consistency across both storage mediums.
  void prepareEditData() {
    final user = currentUser.value;
    removePhoto.value = false;
    if (user != null) {
      nameController.text = user.fullName;
      heightController.text = user.height?.toString() ?? '';
      weightController.text = user.weight?.toString() ?? '';
      selectedDate.value = user.dateOfBirth;
      if (user.gender != null) selectedGender.value = user.gender!;
      if (user.bloodGroup != null) selectedBloodGroup.value = user.bloodGroup!;
      _updateBMI();
    }
  }

  Future<void> updateProfile() async {
    if (currentUser.value == null) return;
    isLoading.value = true;
    try {
      UserModel updatedUser = UserModel(
        uid: currentUser.value!.uid,
        email: currentUser.value!.email,
        fullName: nameController.text.trim(),
        photoUrl: removePhoto.value
            ? ''
            : pickedImage.value?.path ?? currentUser.value?.photoUrl,
        gender: selectedGender.value,
        dateOfBirth: selectedDate.value,
        bloodGroup: selectedBloodGroup.value,
        height: double.tryParse(heightController.text),
        weight: double.tryParse(weightController.text),
        allergies: currentUser.value!.allergies,
        chronicIllnesses: currentUser.value!.chronicIllnesses,
        restraints: currentUser.value!.restraints,
      );

      // Save to Cloud and Sync Local Storage
      await _dbService.saveUser(updatedUser);
      await HiveService.saveUserProfile(updatedUser.toHiveMap());
      currentUser.value = updatedUser;
      
      Get.back();
      Get.snackbar("Success", "Profile updated!", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // ================= UPLOAD PHOTO (COMPRESSION) =================
  // Handles gallery selection and strict file type validation (JPG, PNG, WEBP).
  // Critically, it compresses the image locally to optimize storage space and 
  // minimize bandwidth consumption before the profile is updated.
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    if (!_isSupportedImage(image.path)) {
      Get.snackbar('Unsupported Image', 'Select a JPG, PNG, or WEBP image.');
      return;
    }

    final XFile? compressedImage = await _compressImage(image);
    if (compressedImage != null) {
      pickedImage.value = compressedImage;
      removePhoto.value = false;
    }
  }

  bool _isSupportedImage(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.jpg') || lower.endsWith('.jpeg') ||
           lower.endsWith('.png') || lower.endsWith('.webp');
  }

  Future<XFile?> _compressImage(XFile image) async {
    try {
      final file = File(image.path);
      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return null;

      final resized = img.copyResize(decoded, width: 800);
      final encoded = img.encodeJpg(resized, quality: 85);
      final tempFile = File('${Directory.systemTemp.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(encoded);
      return XFile(tempFile.path);
    } catch (e) {
      return null;
    }
  }

  void removeImage() {
    pickedImage.value = null;
    removePhoto.value = true;
  }

  // ================= BASIC HEALTH INFORMATION =================
  // Dynamically tracks and recalculates the user's Body Mass Index (BMI) in 
  // real-time as they adjust their height and weight. Also manages the CRUD 
  // operations for critical medical records (allergies, illnesses, restraints).
  void _updateBMI() {
    double h = double.tryParse(heightController.text) ?? 0;
    double w = double.tryParse(weightController.text) ?? 0;
    if (h <= 0 || w <= 0) {
      liveBMI.value = '0.0';
    } else {
      liveBMI.value = (w / ((h / 100) * (h / 100))).toStringAsFixed(1);
    }
  }

  Future<void> addAllergy(String allergy) async {
    if (currentUser.value == null || allergy.trim().isEmpty) return;
    currentUser.update((user) {
      user?.allergies.add(allergy.trim());
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }

  Future<void> removeAllergy(String allergy) async {
    if (currentUser.value == null) return;
    currentUser.update((user) {
      user?.allergies.remove(allergy);
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }

  Future<void> addIllness(String illness) async {
    if (currentUser.value == null || illness.trim().isEmpty) return;
    currentUser.update((user) {
      user?.chronicIllnesses.add(illness.trim());
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }

  Future<void> removeIllness(String illness) async {
    if (currentUser.value == null) return;
    currentUser.update((user) {
      user?.chronicIllnesses.remove(illness);
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }

  Future<void> addRestraint(String restraint) async {
    if (currentUser.value == null || restraint.trim().isEmpty) return;
    currentUser.update((user) {
      user?.restraints.add(restraint.trim());
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }

  Future<void> removeRestraint(String restraint) async {
    if (currentUser.value == null) return;
    currentUser.update((user) {
      user?.restraints.remove(restraint);
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }

  @override
  void onClose() {
    heightController.removeListener(_updateBMI);
    weightController.removeListener(_updateBMI);
    nameController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.onClose();
  }
}
```

---

### 1.7.3 Medicine Management

The `MedicineController` is the core of the application, managing complex scheduling, dynamic inventory tracking, and notification integrations. It covers creating and categorizing medicines, evaluating cyclic/interval schedules, handling interactive foreground/background notification actions (Take, Miss, Snooze), and safely disabling or removing alerts.

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../data/models/medicine_model.dart';
import '../data/models/medicine_log_model.dart';
import '../data/services/hive_service.dart';
import '../data/services/notification_service.dart';

class MedicineController extends GetxController with WidgetsBindingObserver {
  var medicines = <MedicineModel>[].obs;
  var logs = <MedicineLogModel>[].obs;
  var isLoading = false.obs;

  // Form Controllers
  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final stockController = TextEditingController();
  final customTypeController = TextEditingController();

  var frequency = 'Daily'.obs;
  var reminderTimes = <TimeOfDay>[].obs;
  var selectedDays = <int>[].obs;
  var interval = 1.obs;
  var cycleOn = 21.obs;
  var cycleOff = 7.obs;
  var startDate = DateTime.now().obs;

  // ================= CATEGORIZE MEDICINES =================
  // Provides predefined, standard medical categories (Tablets, Syrups, etc.) 
  // while allowing users to specify a custom type if their medication format 
  // is not listed.
  var selectedType = 'Tablet'.obs;
  final List<String> defaultTypes = [
    'Tablet', 'Capsule', 'Syrup', 'Injection', 'Drops', 'Inhaler', 'Other'
  ];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadMedicines();
    rescheduleAllNotifications();
  }

  void loadMedicines() {
    medicines.value = HiveService.getAllMedicines();
  }

  // ================= ADD & UPDATE MEDICINE =================
  // Handles the creation and modification of medicine records. It processes the 
  // complex scheduling parameters (Cyclic, Specific Days, Intervals), updates the 
  // local database, and immediately synchronizes the native OS notifications.
  Future<void> saveMedicine({String? id}) async {
    if (nameController.text.isEmpty || dosageController.text.isEmpty) {
      Get.snackbar("Error", "Missing required fields");
      return;
    }

    isLoading.value = true;
    try {
      String type = selectedType.value == 'Other'
          ? customTypeController.text.trim()
          : selectedType.value;

      final med = MedicineModel(
        medicineId: id ?? const Uuid().v4(),
        name: nameController.text.trim(),
        dosage: dosageController.text.trim(),
        type: type,
        stock: int.tryParse(stockController.text) ?? 0,
        reminderTimes: _toDateTimeList(reminderTimes),
        frequencyType: frequency.value,
        specificDays: frequency.value == 'SpecificDays' ? selectedDays.toList() : null,
        interval: frequency.value == 'Interval' ? interval.value : null,
        cycleOnDays: frequency.value == 'Cyclic' ? cycleOn.value : null,
        cycleOffDays: frequency.value == 'Cyclic' ? cycleOff.value : null,
        startDate: startDate.value,
        isActive: true,
      );

      if (id == null) {
        await HiveService.addMedicine(med);
        Get.snackbar("Added", "${med.name} added to schedule!");
      } else {
        await HiveService.updateMedicine(med);
        Get.snackbar("Updated", "${med.name} details updated");
      }

      // Automatically sync notifications for this medicine
      _rescheduleNotifications(med);
      loadMedicines();
      Get.back();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void prepareEdit(MedicineModel med) {
    nameController.text = med.name;
    dosageController.text = med.dosage;
    stockController.text = med.stock.toString();
    selectedType.value = defaultTypes.contains(med.type) ? med.type : 'Other';
    if (selectedType.value == 'Other') customTypeController.text = med.type;
    frequency.value = med.frequencyType;
    reminderTimes.value = med.reminderTimes.map((d) => TimeOfDay.fromDateTime(d)).toList();
    // (Other parameters populated similarly...)
  }

  // ================= MEDICINE REMINDERS (SCHEDULING) =================
  // Cancels existing OS-level alarms and calculates the precise next valid 
  // occurrence based on the user's custom frequency logic (Daily vs Interval/Cyclic).
  void _rescheduleNotifications(MedicineModel med) {
    int baseId = med.medicineId.hashCode;
    
    // Clear old ID range to prevent phantom alarms
    for (int i = 0; i < 20; i++) {
      NotificationService.cancel(baseId + i);
    }

    if (med.isActive) {
      for (int i = 0; i < med.reminderTimes.length; i++) {
        final timeOfDay = TimeOfDay.fromDateTime(med.reminderTimes[i]);

        if (med.frequencyType == 'Daily') {
          // Native Daily Recurrence for performance optimization
          DateTime scheduledDate = _getNextDailyTime(timeOfDay);
          NotificationService.scheduleMedicine(
            id: baseId + i,
            medicineId: med.medicineId,
            name: med.name,
            dosage: med.dosage,
            time: scheduledDate,
            repeat: Repeat.daily,
          );
        } else {
          // Manual calculation for complex recurring schedules
          final nextTime = _getNextValidOccurrence(med, timeOfDay);
          if (nextTime != null) {
            NotificationService.scheduleMedicine(
              id: baseId + i,
              medicineId: med.medicineId,
              name: med.name,
              dosage: med.dosage,
              time: nextTime,
              repeat: Repeat.none,
            );
          }
        }
      }
    }
  }

  // ================= MEDICINE REMINDERS (ACTION HANDLING) =================
  // Acts as the callback receiver when a user interacts with a notification 
  // outside the app. Logs the dose as Taken, Missed, or Snoozes the alarm 
  // for 10 minutes.
  Future<void> handleNotificationAction(
      String action, String medId, DateTime scheduledTime) async {
      
    final med = medicines.firstWhereOrNull((m) => m.medicineId == medId);
    if (med == null) return;

    final normalizedTime = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day,
        scheduledTime.hour, scheduledTime.minute);

    if (action == 'take') {
      await markAsTaken(med, normalizedTime, normalizedTime);
      _rescheduleNotifications(med); // Reschedule next occurrence
    } else if (action == 'miss') {
      await markAsSkipped(med, normalizedTime);
    } else if (action == 'snooze') {
      final snoozeTime = DateTime.now().add(const Duration(minutes: 10));
      int id = med.medicineId.hashCode + DateTime.now().millisecondsSinceEpoch;

      await NotificationService.scheduleMedicine(
        id: id,
        medicineId: med.medicineId,
        name: med.name,
        dosage: med.dosage,
        time: snoozeTime,
        repeat: Repeat.none,
      );
    }
  }

  // ================= REMOVE / DISABLE MEDICINE ALERTS =================
  // Safely deactivates or completely deletes a medicine record. In both scenarios,
  // it rigorously cleans up the OS notification registry to ensure alarms do not
  // ring for disabled or deleted medications.
  Future<void> toggleStatus(MedicineModel med) async {
    med.isActive = !med.isActive;
    await HiveService.updateMedicine(med);

    if (med.isActive) {
      _rescheduleNotifications(med);
      Get.snackbar("Alerts On", "Reminders enabled");
    } else {
      int baseId = med.medicineId.hashCode;
      for (int i = 0; i < 20; i++) NotificationService.cancel(baseId + i);
      Get.snackbar("Alerts Off", "Reminders disabled");
    }
    medicines.refresh();
  }

  Future<void> deleteMedicine(MedicineModel med) async {
    int baseId = med.medicineId.hashCode;
    for (int i = 0; i < 20; i++) {
      NotificationService.cancel(baseId + i);
    }
    medicines.remove(med);
    await HiveService.deleteMedicine(med.medicineId);
    Get.snackbar("Deleted", "${med.name} removed");
  }

  // Completing a course sets active to false and preserves historical data
  Future<void> completeMedicine(MedicineModel med) async {
    med.isActive = false;
    med.dateEnded = DateTime.now();
    await HiveService.updateMedicine(med);
    int baseId = med.medicineId.hashCode;
    for (int i = 0; i < 20; i++) NotificationService.cancel(baseId + i);
    medicines.refresh();
  }

  // Utility helpers...
  Future<void> rescheduleAllNotifications() async {
    for (var med in medicines) {
      _rescheduleNotifications(med);
    }
  }

  List<DateTime> _toDateTimeList(List<TimeOfDay> times) {
    final now = DateTime.now();
    return times.map((t) => DateTime(now.year, now.month, now.day, t.hour, t.minute)).toList();
  }

  DateTime _getNextDailyTime(TimeOfDay timeOfDay) {
    DateTime now = DateTime.now();
    DateTime scheduledDate = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
  
  // Method signature for complex scheduling algorithm (simplified for documentation)
  DateTime? _getNextValidOccurrence(MedicineModel med, TimeOfDay time) {
    // Computes cyclic / interval dates ...
    return null; 
  }
  
  // Method signatures for logging (simplified for documentation)
  Future<void> markAsTaken(MedicineModel med, DateTime date, DateTime timeSlot) async {}
  Future<void> markAsSkipped(MedicineModel med, DateTime scheduledTime) async {}
}
```

---

### 1.7.4 Schedule Management

The `ScheduleController` consolidates all user activities (Medicines and Appointments) into a unified timeline. It governs the calendar UI, enforces strict date boundaries for performance and historical context, and processes multi-entity data into standardized `ScheduleItem` models for seamless rendering.

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/medicine_model.dart';
import '../data/models/appointment_model.dart';
import 'medicine_controller.dart';
import 'appointment_controller.dart';

enum ScheduleItemType { medicine, appointment }
enum ScheduleItemStatus { taken, missed, pending, upcoming }

class ScheduleItem {
  final String id;
  final ScheduleItemType type;
  final String title;
  final String subtitle;
  final DateTime scheduledTime;
  final ScheduleItemStatus status;
  final Color color;
  final String? category;

  const ScheduleItem({
    required this.id, required this.type, required this.title,
    required this.subtitle, required this.scheduledTime,
    required this.status, required this.color, this.category,
  });
}

class ScheduleController extends GetxController {
  late final MedicineController _medCtrl;
  late final AppointmentController _aptCtrl;

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    _medCtrl = Get.find<MedicineController>();
    _aptCtrl = Get.find<AppointmentController>();
  }

  // ================= DATE RANGE LIMITATION =================
  // Defines strict boundaries for the calendar (±15 days from today). 
  // This prevents infinite scrolling, reduces memory load when calculating 
  // complex cyclical patterns, and keeps the user focused on relevant data.
  DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  DateTime get rangeStart => _today.subtract(const Duration(days: 15));
  DateTime get rangeEnd => _today.add(const Duration(days: 15));

  // ================= DATE SELECTION & VALIDATION =================
  // Handles user interaction with the calendar. It rigorously checks the 
  // selected date against the allowed limits and rejects out-of-bounds dates 
  // with a visual warning to the user.
  void onDaySelected(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    if (d.isBefore(rangeStart) || d.isAfter(rangeEnd)) {
      Get.snackbar(
        'Out of Range',
        'Calendar is limited to 15 days past and future',
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
      );
      return;
    }
    selectedDate.value = d;
  }

  // ================= DAILY / DATE SCHEDULE VIEW =================
  // Dynamically generates the unified agenda for any given date. It iterates 
  // through all medicines and appointments, transforms them into abstract 
  // ScheduleItems, resolves their statuses (taken/missed/pending), and sorts 
  // them chronologically for the UI.
  List<ScheduleItem> scheduleForDate(DateTime date) {
    final items = <ScheduleItem>[];
    final dateKey = DateTime(date.year, date.month, date.day);
    final now = DateTime.now();

    // 1. Process Medicine Doses
    for (final med in _medCtrl.medicines) {
      if (!_medCtrl.isScheduledForDate(med, dateKey)) continue;
      
      for (final timeSlot in med.reminderTimes) {
        final scheduled = DateTime(
          dateKey.year, dateKey.month, dateKey.day,
          timeSlot.hour, timeSlot.minute,
        );

        final taken = _medCtrl.isTaken(med.medicineId, dateKey, timeSlot);
        final isPast = scheduled.isBefore(now);

        ScheduleItemStatus status;
        if (taken) status = ScheduleItemStatus.taken;
        else if (isPast) status = ScheduleItemStatus.missed;
        else if (isSameDay(dateKey, _today)) status = ScheduleItemStatus.pending;
        else status = ScheduleItemStatus.upcoming;

        items.add(ScheduleItem(
          id: '${med.medicineId}_${scheduled.millisecondsSinceEpoch}',
          type: ScheduleItemType.medicine,
          title: med.name,
          subtitle: med.dosage,
          scheduledTime: scheduled,
          status: status,
          color: const Color(0xFF6C63FF),
          category: med.type,
        ));
      }
    }

    // 2. Process Appointments
    for (final apt in _aptCtrl.appointments) {
      final aptDate = DateTime(apt.dateTime.year, apt.dateTime.month, apt.dateTime.day);
      if (!isSameDay(aptDate, dateKey)) continue;

      ScheduleItemStatus status;
      if (apt.isCompleted) status = ScheduleItemStatus.taken; 
      else if (apt.dateTime.isBefore(now)) status = ScheduleItemStatus.missed;
      else status = ScheduleItemStatus.upcoming;

      items.add(ScheduleItem(
        id: apt.id,
        type: ScheduleItemType.appointment,
        title: apt.doctorName,
        subtitle: apt.category,
        scheduledTime: apt.dateTime,
        status: status,
        color: const Color(0xFF00BFA6),
        category: apt.category,
      ));
    }

    // Sort chronologically
    items.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return items;
  }

  // Reactive getter for the current view
  List<ScheduleItem> get itemsForSelectedDate => scheduleForDate(selectedDate.value);

  // ================= CALENDAR VIEW (EVENT MARKERS) =================
  // Computes a set of dates that contain at least one scheduled event. 
  // The UI uses this to render 'dots' or highlights on the monthly calendar, 
  // giving users a birds-eye view of their upcoming commitments.
  Set<DateTime> get markedDates {
    final dates = <DateTime>{};

    for (final med in _medCtrl.medicines) {
      final rangeLength = rangeEnd.difference(rangeStart).inDays;
      for (int i = 0; i <= rangeLength; i++) {
        final d = rangeStart.add(Duration(days: i));
        if (_medCtrl.isScheduledForDate(med, d)) {
          dates.add(DateTime(d.year, d.month, d.day));
        }
      }
    }

    for (final apt in _aptCtrl.appointments) {
      dates.add(DateTime(apt.dateTime.year, apt.dateTime.month, apt.dateTime.day));
    }

    return dates;
  }

  // Utility logic
  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> markMedicineTaken(MedicineModel med, DateTime scheduledTime) async {
    await _medCtrl.markAsTaken(med, scheduledTime, scheduledTime);
  }
}
```

---

### 1.7.5 User Health Records

The User Health Records module aggregates sensitive medical data. In the application architecture, this logic spans across the `ProfileController` (handling static medical history) and the `MedicineController` (handling dynamic medication statuses). For documentation purposes, the integrated logic is represented below, showcasing how data is filtered, added, and synchronized securely.

```dart
import 'package:get/get.dart';
import '../data/services/hive_service.dart';
import '../data/models/user_model.dart';
import '../data/models/medicine_model.dart';
import 'profile_controller.dart';
import 'medicine_controller.dart';

class HealthRecordsLogic {
  final ProfileController profileCtrl = Get.find<ProfileController>();
  final MedicineController medicineCtrl = Get.find<MedicineController>();

  // ================= CURRENT & PAST MEDICATIONS =================
  // Dynamically filters the global medicine list based on the 'isActive' flag.
  // Current medications are actively scheduled and trigger OS reminders, while
  // past medications represent completed courses preserved strictly for medical history.
  
  List<MedicineModel> get currentMedications {
    return medicineCtrl.medicines.where((med) => med.isActive).toList();
  }

  List<MedicineModel> get pastMedications {
    return medicineCtrl.medicines.where((med) => !med.isActive).toList();
  }

  // ================= ALLERGIES LIST =================
  // Manages the user's known allergies. Updates are pushed to the user's 
  // reactive model and synced instantly to local Hive storage for offline 
  // access, ensuring critical data is always available.
  Future<void> addAllergy(String allergy) async {
    final user = profileCtrl.currentUser.value;
    if (user == null || allergy.trim().isEmpty) return;
    
    profileCtrl.currentUser.update((u) {
      u?.allergies.add(allergy.trim());
    });
    await HiveService.saveUserProfile(profileCtrl.currentUser.value!.toHiveMap());
  }

  Future<void> removeAllergy(String allergy) async {
    profileCtrl.currentUser.update((u) {
      u?.allergies.remove(allergy);
    });
    await HiveService.saveUserProfile(profileCtrl.currentUser.value!.toHiveMap());
  }

  // ================= CHRONIC ILLNESSES =================
  // Maintains a record of long-term health conditions to provide essential 
  // context for the user's overall medication regimen.
  Future<void> addIllness(String illness) async {
    final user = profileCtrl.currentUser.value;
    if (user == null || illness.trim().isEmpty) return;
    
    profileCtrl.currentUser.update((u) {
      u?.chronicIllnesses.add(illness.trim());
    });
    await HiveService.saveUserProfile(profileCtrl.currentUser.value!.toHiveMap());
  }

  Future<void> removeIllness(String illness) async {
    profileCtrl.currentUser.update((u) {
      u?.chronicIllnesses.remove(illness);
    });
    await HiveService.saveUserProfile(profileCtrl.currentUser.value!.toHiveMap());
  }

  // ================= RESTRAINTS =================
  // Tracks medical restraints or contraindications (e.g., "Cannot take NSAIDs", 
  // "Allergic to Penicillin variants") which are critical for safe medicine scheduling.
  Future<void> addRestraint(String restraint) async {
    final user = profileCtrl.currentUser.value;
    if (user == null || restraint.trim().isEmpty) return;
    
    profileCtrl.currentUser.update((u) {
      u?.restraints.add(restraint.trim());
    });
    await HiveService.saveUserProfile(profileCtrl.currentUser.value!.toHiveMap());
  }

  Future<void> removeRestraint(String restraint) async {
    profileCtrl.currentUser.update((u) {
      u?.restraints.remove(restraint);
    });
    await HiveService.saveUserProfile(profileCtrl.currentUser.value!.toHiveMap());
  }
}
```

---

### 1.7.6 Inventory Control

The Inventory Control module tracks medication quantities in real-time. Embedded primarily within the `MedicineController`, this logic automatically decrements stock upon dosage consumption, dynamically re-orders lists to prioritize low-stock items, and triggers proactive OS-level warnings when supplies run critically low.

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/medicine_model.dart';
import '../data/services/hive_service.dart';
import '../data/services/notification_service.dart';

class InventoryControlLogic extends GetxController {
  // Reactive list observing the global medication database
  var medicines = <MedicineModel>[].obs;

  // ================= VIEW CURRENT STOCK (SMART SORTING) =================
  // Retrieves the active medication inventory. It uses a custom sorting 
  // algorithm to automatically bubble up medications with critically low 
  // stock (<= 5 doses) to the very top of the UI, ensuring immediate user visibility.
  List<MedicineModel> get sortedMedicines {
    List<MedicineModel> sorted = medicines.where((m) => m.isActive).toList();
    
    sorted.sort((a, b) {
      bool aLow = a.stock <= 5;
      bool bLow = b.stock <= 5;
      if (aLow && !bLow) return -1; // 'a' floats to the top
      if (!aLow && bLow) return 1;  // 'b' floats to the top
      return 0; // Maintains original order if both are fine or both are low
    });
    
    return sorted;
  }

  // ================= UPDATE CURRENT STOCK =================
  // Allows users to manually overwrite stock quantities (e.g., after returning 
  // from a pharmacy refill). Instantly updates the local Hive database and 
  // triggers a reactive UI refresh.
  Future<void> updateStock(MedicineModel med, int newQty) async {
    med.stock = newQty;
    await HiveService.updateMedicine(med);
    medicines.refresh();

    Get.snackbar(
      "Stock Updated",
      "${med.name} stock set to $newQty",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
    );
  }

  // ================= STOCK ALERTS (AUTO-DECREMENT) =================
  // This critical business logic fires every time a user marks a dose as 'Taken'. 
  // It handles automatic inventory deduction and checks against the low-stock threshold.
  // If the threshold is breached, it dispatches an urgent OS-level notification.
  Future<void> _processInventoryOnDoseTaken(MedicineModel med) async {
    if (med.stock > 0) {
      // 1. Auto-decrement stock upon consumption
      med.stock--;
      await HiveService.updateMedicine(med);
      medicines.refresh();
      
      // 2. Low Quantity Alert Trigger
      if (med.stock <= 5) {
        // Dispatches a native system notification advising an immediate pharmacy refill
        NotificationService.showLowStockNotification(med);
      }
    }
  }
}
```

---

### 1.7.7 Appointment Management

The `AppointmentController` orchestrates the user's medical calendar. It manages the lifecycle of doctor visits, computes intelligent push-notification reminders based on user-defined lead times, handles recurring visits, and automatically partitions data into active and historical views.

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../data/models/appointment_model.dart';
import '../data/services/hive_service.dart';
import '../data/services/notification_service.dart';

class AppointmentController extends GetxController {
  var appointments = <AppointmentModel>[].obs;
  
  // ================= APPOINTMENT HISTORY (UPCOMING VS PAST) =================
  // Dynamically filters the global appointment list. Upcoming appointments 
  // must be active and in the future. Past appointments include anything 
  // explicitly marked as completed or where the date has already physically passed.
  List<AppointmentModel> get upcomingAppointments => appointments
      .where((a) => !a.isCompleted && a.dateTime.isAfter(DateTime.now()))
      .toList()
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  List<AppointmentModel> get historyAppointments => appointments
      .where((a) => a.isCompleted || a.dateTime.isBefore(DateTime.now()))
      .toList()
    ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

  // ================= ADD & EDIT APPOINTMENT (WITH VISIT NOTES) =================
  // Consolidates form data (including rich visit notes) into a unified model.
  // It handles both the creation of new records and the modification of existing 
  // ones, seamlessly syncing them to the local Hive database.
  Future<void> saveAppointment({String? id}) async {
    final dt = DateTime(selectedDate.value.year, selectedDate.value.month,
        selectedDate.value.day, selectedTime.value.hour, selectedTime.value.minute);

    final newApt = AppointmentModel(
      id: id ?? const Uuid().v4(),
      doctorName: doctorController.text.trim(),
      category: selectedCategory.value,
      dateTime: dt,
      reminderMinutes: reminderOption.value > 0 ? reminderOption.value : null,
      visitNotes: notesController.text.trim(), // Captures specialized medical notes
      isCompleted: false,
      isRecurring: reminderOption.value > 0 && isRecurring.value,
      recurringFrequency: isRecurring.value ? recurringFrequency.value : null,
    );

    if (id == null) {
      await HiveService.addAppointment(newApt);
    } else {
      await HiveService.updateAppointment(newApt);
    }

    // Automatically trigger notification scheduling algorithm upon save
    _scheduleAlert(newApt);
    loadAppointments();
  }

  // ================= APPOINTMENT REMINDER (SCHEDULING) =================
  // Calculates the precise notification trigger time by subtracting the user's 
  // requested lead time (e.g., 60 minutes) from the actual appointment time. 
  // It natively supports both one-off alerts and recurring (Weekly/Monthly) schedules.
  void _scheduleAlert(AppointmentModel apt) {
    // 1. Cancel old alert first to strictly prevent phantom duplicate alarms
    NotificationService.cancel(apt.id.hashCode);

    // 2. Schedule new alarm if reminders are enabled
    if (apt.reminderMinutes != null && !apt.isCompleted) {
      final triggerTime = apt.dateTime.subtract(Duration(minutes: apt.reminderMinutes!));

      if (triggerTime.isAfter(DateTime.now())) {
        DateTimeComponents? repeatComponents;
        if (apt.isRecurring) {
          repeatComponents = apt.recurringFrequency == 'Weekly'
              ? DateTimeComponents.dayOfWeekAndTime
              : DateTimeComponents.dayOfMonthAndTime;
        }

        NotificationService.scheduleNotification(
          id: apt.id.hashCode,
          title: "Appointment: ${apt.doctorName}",
          body: "Your appointment is in ${apt.reminderMinutes} minutes.",
          scheduledTime: triggerTime,
          useShortSound: true, // Dynamically maps to user's sound preference inside service
          matchDateTimeComponents: repeatComponents,
        );
      }
    }
  }

  // ================= APPOINTMENT STATUS =================
  // Manually moves an active appointment into the historical archive.
  // Critically, it destroys any pending OS-level alarms to prevent the user 
  // from being erroneously reminded about a visit they have already concluded.
  Future<void> markCompleted(AppointmentModel apt) async {
    apt.isCompleted = true;
    await HiveService.updateAppointment(apt);
    
    // Rigorously clean up native alarms
    NotificationService.cancel(apt.id.hashCode); 
    loadAppointments();
  }
}
```

---

### 1.7.8 Journaling & Motivation

The `WellnessController` provides a holistic approach to patient health by tracking emotional well-being alongside physical medication adherence. It encompasses the Mood & Notes Journal, generates AI-powered User Challenges via Google's Gemini API, and calculates a Visual Streak Tracker based on 100% daily medication adherence.

```dart
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../data/models/journal_model.dart';
import '../data/models/streak_model.dart';
import '../data/services/gemini_service.dart';
import '../data/services/hive_service.dart';
import 'medicine_controller.dart';

class WellnessController extends GetxController {
  final MedicineController _medController = Get.find<MedicineController>();

  var journalHistory = <JournalModel>[].obs;
  var currentStreak = 0.obs;
  var maxStreak = 0.obs;
  var dailyChallenge = "Loading challenge...".obs;

  @override
  void onInit() {
    super.onInit();
    loadJournal();
    calculateStreak();
    generateDailyChallenge();
  }

  // ================= MOOD & NOTES JOURNAL =================
  // Captures the user's daily emotional state and custom notes.
  // Entries are immediately persisted to the local Hive database and 
  // automatically sorted chronologically (newest first) for the UI.
  Future<void> addEntry(String mood, String? note) async {
    final entry = JournalModel(
      id: const Uuid().v4(),
      date: DateTime.now(),
      mood: mood,
      note: note,
    );

    await HiveService.addJournal(entry);
    loadJournal(); // Reloads and sorts the history
    Get.snackbar("Saved", "Mood logged successfully!");
  }

  void loadJournal() {
    journalHistory.value = HiveService.getAllJournals();
    // Sort by date descending (newest at the top)
    journalHistory.sort((a, b) => b.date.compareTo(a.date));
  }

  // ================= VISUAL STREAK TRACKER =================
  // Evaluates historical medication logs to calculate consecutive days 
  // of 100% adherence. It checks each day backwards from today. 
  // A "perfect day" is defined as a day where every scheduled dose was taken.
  void calculateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int streak = 0;

    // Check Today first
    if (_wasPerfectDay(today)) streak++;

    // Check Yesterday backwards iteratively
    DateTime checkDate = today.subtract(const Duration(days: 1));
    while (_wasPerfectDay(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    currentStreak.value = streak;
    if (streak > maxStreak.value) maxStreak.value = streak;

    // Persist highest score
    _saveStreak();
  }

  bool _wasPerfectDay(DateTime date) {
    // Retrieves all medicines physically scheduled for the specific date
    final scheduledMeds = _medController.medicines
        .where((m) => _medController.isScheduledForDate(m, date))
        .toList();

    if (scheduledMeds.isEmpty) return false;

    // Cross-references each dose against the MedicineLog database
    for (var med in scheduledMeds) {
      for (var time in med.reminderTimes) {
        if (!_medController.isTaken(med.medicineId, date, time)) {
          return false; // Broken adherence
        }
      }
    }
    return true; // 100% Adherence achieved
  }

  // ================= USER CHALLENGES (AI INTEGRATION) =================
  // Uses the Gemini AI Service to dynamically generate a personalized 
  // daily wellness challenge based on the user's current mood. Includes a 
  // robust offline/fallback mechanism (SRS-121) if the API is unreachable.
  Future<void> generateDailyChallenge() async {
    final fallbackChallenges = [
      "Drink 8 glasses of water today 💧",
      "Take a 15-minute walk outside 🚶",
      "Eat a colorful fruit or vegetable 🍎",
      "Meditate for 5 minutes 🧘",
    ];

    try {
      final mood = journalHistory.isNotEmpty ? journalHistory.first.mood : "neutral";
      final prompt =
          "Generate ONE short, motivating daily health challenge (max 12 words) for a medicine app user who is feeling \$mood today. Make it actionable, positive, and health-focused. Return only the challenge text with a relevant emoji at the end.";

      final text = await GeminiService.generateText(prompt);
      if (text != null) {
        dailyChallenge.value = text;
      } else {
        dailyChallenge.value = (fallbackChallenges..shuffle()).first;
      }
    } catch (e) {
      // Offline fallback
      dailyChallenge.value = (fallbackChallenges..shuffle()).first;
    }
  }
  
  Future<void> _saveStreak() async {
    // Implementation omitted for brevity
  }
}
```

---

### 1.7.9 Patient Report Management

The `ReportController` acts as a centralized vault for all physical health documents. It allows users to securely archive, categorize, and dynamically search through sensitive medical files (like prescriptions and lab results) without leaving the app ecosystem.

```dart
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';
import '../data/models/report_model.dart';
import '../data/services/hive_service.dart';

class ReportController extends GetxController {
  var reports = <ReportModel>[].obs;
  var filteredReports = <ReportModel>[].obs;
  
  var searchQuery = ''.obs;
  var selectedCategory = 'All'.obs;
  var selectedDate = Rxn<DateTime>();

  final List<String> categories = [
    'All',
    'Prescription',
    'Lab Result',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  // ================= UPLOAD MEDICAL DOCUMENTS =================
  // Bridges the app with the native OS file system using FilePicker.
  // Securely logs the file's absolute path, category, and metadata into Hive.
  Future<void> pickAndAddReport({required String title, required String category}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;

      final newReport = ReportModel(
        id: const Uuid().v4(),
        title: title,
        dateUploaded: DateTime.now(),
        category: category,
        filePath: filePath, // Stores a permanent reference to the local file
      );

      await HiveService.addReport(newReport);
      loadReports();
      Get.snackbar("Success", "Report added successfully.");
    }
  }

  // ================= SMART SEARCH & FILTERING =================
  // Reactively cascades through the entire archive. Applies a triple-layer filter
  // combining Category matches, exact Date matches, and a fuzzy-string Search Query 
  // checking against both the Title and the formatted Date strings.
  void filterReports() {
    final query = searchQuery.value.toLowerCase().trim();
    final selectedCat = selectedCategory.value;
    final selectedDt = selectedDate.value;

    filteredReports.value = reports.where((r) {
      if (selectedCat != 'All' && r.category != selectedCat) return false;
      
      if (selectedDt != null) {
        if (r.dateUploaded.year != selectedDt.year ||
            r.dateUploaded.month != selectedDt.month ||
            r.dateUploaded.day != selectedDt.day) {
          return false;
        }
      }

      if (query.isEmpty) return true;

      final dateLabel = DateFormat('dd MMM yyyy').format(r.dateUploaded);
      return r.title.toLowerCase().contains(query) ||
          r.category.toLowerCase().contains(query) ||
          dateLabel.toLowerCase().contains(query);
    }).toList();

    // Sort heavily prioritizes the most recently uploaded files
    filteredReports.sort((a, b) => b.dateUploaded.compareTo(a.dateUploaded));
  }

  // ================= DOCUMENT VIEWER =================
  // Intelligent dispatch system: Internalizes PDF rendering for seamless UX, 
  // but intelligently offloads obscure file types to the native OS handlers.
  Future<void> openReport(String filePath) async {
    if (filePath.toLowerCase().endsWith('.pdf')) {
      Get.toNamed('/reportPdf', arguments: filePath);
      return;
    }

    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      Get.snackbar("Error", "Could not open file: \${result.message}");
    }
  }

  // ================= RECORD DELETION =================
  Future<void> deleteReport(String id) async {
    await HiveService.deleteReport(id);
    loadReports();
    Get.snackbar("Deleted", "Report removed.");
  }
}
```

---

### 1.7.11 ChatBot Assistant

The `ChatController` serves as the primary intelligence hub for the MedCare application. It integrates Google's `GenerativeModel` API to offer health-focused, conversational AI assistance while actively intercepting user input through a `SafetyRulesService` to block emergency queries before hitting external networks.

```dart
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';
import '../data/models/chat_message_model.dart';
import '../data/services/gemini_service.dart';
import '../data/services/hive_service.dart';
import '../data/services/safety_rules_service.dart';

class ChatController extends GetxController {
  var messages = <ChatMessageModel>[].obs;
  var isLoading = false.obs;
  var isInitialized = false.obs;

  GenerativeModel? _model;
  ChatSession? _chat;

  // UC-41 / SRS-133 / SRS-134: Client-side safety pre-filter
  final SafetyRulesService _safetyRules = SafetyRulesService();

  @override
  void onInit() {
    super.onInit();
    _loadChatHistory();
    _initGemini();
    // SRS-134: Start listening for backend rule updates
    _safetyRules.startListening();
  }

  // ================= AI INITIALIZATION =================
  // Sets up the Gemini API with strict system instructions
  // restricting the bot's persona strictly to health-related matters.
  void _initGemini() {
    try {
      _model = GeminiService.buildChatModel(
        systemInstruction:
            "You are a friendly, concise health assistant for a personal medicine reminder app called MedCare. "
            "Help users with medication questions, dosage reminders, health tips, and general wellness advice. "
            "IMPORTANT: Never provide emergency medical diagnosis — always advise consulting a doctor for serious concerns. ",
      );
      _chat = _model!.startChat();
      isInitialized.value = true;
    } catch (e) {
      isInitialized.value = false;
    }
  }

  // ================= MESSAGE PROCESSING & SAFETY (UC-41) =================
  // Handles incoming queries. Actively routes the string through a dynamic 
  // Safety Filter before passing it to the Gemini backend.
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    // 1. Instantly render user message
    final userMsg = ChatMessageModel(
      id: const Uuid().v4(),
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMsg);
    _persistMessage(userMsg);
    isLoading.value = true;

    // 2. Pre-flight Safety Filter (SRS-133)
    // Aborts network request instantly if malicious/emergency terms are detected.
    if (_safetyRules.isBlocked(trimmed)) {
      isLoading.value = false;
      _addBotMessage(
        "🚨 I cannot answer this query. "
        "If this is an emergency, please call 911 or your local emergency services immediately.",
        isBlocked: true,
      );
      return;
    }

    // 3. Network Request Generation
    try {
      final response = await _chat!
          .sendMessage(Content.text(trimmed))
          .timeout(const Duration(seconds: 30));

      if (response.text != null && response.text!.isNotEmpty) {
        _addBotMessage(response.text!);
      }
    } on GenerativeAIException catch (e) {
      _addBotMessage("⚠️ API Error: Please try again later.");
      _restartChatSession();
    } catch (e) {
      _addBotMessage("⚠️ Network error. Please check your internet connection.");
      _restartChatSession();
    } finally {
      isLoading.value = false;
    }
  }

  // ================= PERSISTENCE =================
  // Silently caches the conversation via Hive for session restoration.
  void _persistMessage(ChatMessageModel msg) {
    HiveService.saveChatMessage(msg);
  }
}
```

---

### 1.7.12 Help & Support

The `HelpSupportView` acts as a static, user-facing documentation hub embedded directly into the application. Since it does not require complex reactive state management, its logic is tightly coupled with the UI and relies on external intent routing (`url_launcher`) for communication.

```dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class HelpSupportView extends StatefulWidget {
  const HelpSupportView({super.key});

  @override
  State<HelpSupportView> createState() => _HelpSupportViewState();
}

class _HelpSupportViewState extends State<HelpSupportView> with TickerProviderStateMixin {
  // ================= EXTERNAL COMMUNICATION (Contact/Feedback) =================
  // Utilizes the url_launcher package to offload email composition to the user's 
  // native OS email client, prepopulating the subject and body for bug reports or feedback.
  Future<void> _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@medcare.com',
      queryParameters: {
        'subject': 'Feedback for Personal Medicine Reminder',
        'body': 'Hello Support Team, \\n\\n',
      },
    );
    if (!await launchUrl(emailLaunchUri)) {
      Get.snackbar(
        "Error",
        "Could not launch email client",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  // ================= USER GUIDE INTERFACE =================
  // A clean, modular ExpansionTile system explaining core modules
  Widget _buildGuideCard({
    required IconData icon,
    required String title,
    required String content,
    required Color accentColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(Brightness.dark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppThemeColors.glassBorder(Brightness.dark), width: 1.2),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: accentColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(content),
          ),
        ],
      ),
    );
  }

  // ================= ABOUT SECTION =================
  // Displays critical app metadata including versions, developers, and copyright
  Widget _buildAboutCard() {
    return Column(
      children: [
        _buildInfoRow("Developers", "Atif Islam & Muhammad Awais Ali"),
        _buildInfoRow("Contact", "support@medcare.com"),
        _buildInfoRow("Copyright", "© 2026 MedCare"),
      ],
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
  }
}
```

---

### 1.7.13 Settings & Preferences

The `SettingsController` manages the global application state regarding user preferences. It handles theme toggling, timezone detection, and complex notification sound configurations. It actively syncs with `HiveService` for persistence and `NotificationService` for immediate audio updates.

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/models/notification_settings_model.dart';
import '../data/services/hive_service.dart';
import '../data/services/notification_service.dart';
import 'medicine_controller.dart';
import 'appointment_controller.dart';

class SettingsController extends GetxController {
  var isDarkMode = false.obs;
  var currentTimeZone = "Unknown".obs;
  
  // Notification sound settings
  var selectedShortSound = 'mixkit_bell_notification_933'.obs;
  var selectedLongSound = 'mixkit_marimba_waiting_ringtone_1360'.obs;
  var useShortForMedicine = true.obs;
  var useShortForAppointments = false.obs;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _loadNotificationSettings();
    _initTimeZone();
  }

  // ================= APP THEME (Light/Dark) =================
  // Toggles the global GetX ThemeMode, updates the system UI overlay 
  // (status bar text color), and persists the choice in Hive.
  void toggleTheme(bool isDark) async {
    isDarkMode.value = isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));
    var box = await Hive.openBox("settingsBox");
    await box.put("isDarkMode", isDark);
  }

  // ================= TIME ZONE DETECTION (UC-47) =================
  // Automatically detects the device's current timezone to ensure
  // local notifications are fired accurately regardless of travel.
  Future<void> _initTimeZone() async {
    try {
      currentTimeZone.value = (await FlutterTimezone.getLocalTimezone()) as String;
    } catch (e) {
      currentTimeZone.value = "UTC (Fallback)";
    }
  }

  // ================= NOTIFICATION SOUND SETTINGS =================
  // Saves the selected audio profiles into Hive, physically rebuilds 
  // the Android Notification Channels to bypass OS-level channel locks, 
  // and dynamically reschedules all active alarms.
  Future<void> _saveNotificationSettings() async {
    final settings = NotificationSettingsModel(
      shortSoundName: selectedShortSound.value,
      longSoundName: selectedLongSound.value,
      useShortForMedicine: useShortForMedicine.value,
      useShortForAppointments: useShortForAppointments.value,
    );
    
    await HiveService.saveNotificationSettings(settings);

    // Recreate notification channels with the new sound
    await NotificationService.init();

    // Cancel ALL pending notifications and reschedule with new sound.
    // Required because Android locks a channel's sound after first creation.
    await NotificationService.cancelAll();

    try {
      final medController = Get.find<MedicineController>();
      await medController.rescheduleAllNotifications();
    } catch (_) {}

    try {
      final aptController = Get.find<AppointmentController>();
      await aptController.rescheduleAllNotifications();
    } catch (_) {}
  }

  // ================= SOUND PREVIEW =================
  // Live previews the chosen local asset using AudioPlayers
  Future<void> previewSound(String soundName, bool isShort) async {
    final fileName = soundName.replaceAll('_', '-');
    final ext = soundName.contains('marimba') ? '.mp3' : '.wav';
    final assetPath = isShort ? 'sounds/short/$fileName$ext' : 'sounds/long/$fileName$ext';
    
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(assetPath));
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
  }
}
```

---

### 1.7.14 Analytics & Data Visualization

The `AnalyticsController` processes historical consumption data from `HiveService` to generate comprehensive adherence reports. It transforms raw log models into statistical datasets formatted directly for dynamic UI charts (like Pie Charts and Bar Graphs).

```dart
import 'package:get/get.dart';
import '../data/models/medicine_log_model.dart';
import '../data/models/medicine_model.dart';
import '../data/services/hive_service.dart';

class AnalyticsController extends GetxController {
  var logs = <MedicineLogModel>[].obs;
  var medicines = <MedicineModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    logs.value = HiveService.getAllLogs();
    medicines.value = HiveService.getAllMedicines();
  }

  // ================= FILTERS (SRS-145) =================
  // Global filter state modifying the underlying dataset for all charts
  var selectedMedicineId = 'All'.obs;
  var selectedPeriod = 'Monthly'.obs; // 'All', 'Daily', 'Weekly', 'Monthly'

  List<MedicineLogModel> getFilteredLogs() {
    var filtered = logs.toList();

    if (selectedMedicineId.value != 'All') {
      filtered = filtered.where((l) => l.medicineId == selectedMedicineId.value).toList();
    }

    final now = DateTime.now();
    if (selectedPeriod.value == 'Daily') {
      filtered = filtered.where((l) => now.difference(l.scheduledTime).inDays == 0 && l.scheduledTime.day == now.day).toList();
    } else if (selectedPeriod.value == 'Weekly') {
      filtered = filtered.where((l) => now.difference(l.scheduledTime).inDays < 7).toList();
    } else if (selectedPeriod.value == 'Monthly') {
      filtered = filtered.where((l) => now.difference(l.scheduledTime).inDays < 30).toList();
    }

    return filtered;
  }

  // ================= MEDICINE CONSUMPTION REPORTS =================
  // Generates aggregated status distribution (Taken vs Missed) specifically 
  // formatted for the Overview Pie Chart.
  Map<String, double> getStatusDistribution() {
    final filtered = getFilteredLogs();
    if (filtered.isEmpty) {
      return {'Taken': 0, 'Missed': 0, 'Skipped': 0};
    }

    int taken = filtered.where((l) => l.status == 'Taken').length;
    int skipped = filtered.where((l) => l.status == 'Skipped' || l.status == 'Miss' || l.status == 'Missed').length;

    return {
      'Taken': taken.toDouble(),
      'Missed': skipped.toDouble(),
    };
  }

  // ================= MONTHLY SUMMARY (Charts) (SRS-150) =================
  // Processes logs over a rolling 28-day window and buckets them into 4 distinct weeks.
  // Outputs nested maps containing exact 'taken' and 'missed' counts per week 
  // for the stacked Bar Chart visualization.
  Map<int, Map<String, int>> getMonthlyWeeklyCounts() {
    final now = DateTime.now();
    final Map<int, Map<String, int>> weekData = {
      0: {'taken': 0, 'missed': 0},
      1: {'taken': 0, 'missed': 0},
      2: {'taken': 0, 'missed': 0},
      3: {'taken': 0, 'missed': 0},
    };

    for (var log in logs) {
      final diff = now.difference(log.scheduledTime).inDays;
      if (diff < 0 || diff >= 28) continue;
      
      final weekIndex = 3 - (diff ~/ 7); // 3=this week, 0=3 weeks ago
      if (log.status == 'Taken') {
        weekData[weekIndex]!['taken'] = (weekData[weekIndex]!['taken'] ?? 0) + 1;
      } else if (log.status == 'Skipped' || log.status == 'Miss' || log.status == 'Missed') {
        weekData[weekIndex]!['missed'] = (weekData[weekIndex]!['missed'] ?? 0) + 1;
      }
    }
    return weekData;
  }

  // ================= MISSED DOSES REPORT (SRS-147) =================
  // Proactively scans the last 28 days to isolate specific medications 
  // suffering from an irregular intake rate (>30% missed rate).
  List<Map<String, dynamic>> getIrregularMedicines() {
    final now = DateTime.now();
    final cutoff = now.subtract(const Duration(days: 28));
    final recentLogs = logs.where((l) => l.scheduledTime.isAfter(cutoff)).toList();

    final Map<String, List<MedicineLogModel>> logsByMed = {};
    for (var log in recentLogs) {
      logsByMed.putIfAbsent(log.medicineId, () => []).add(log);
    }

    final List<Map<String, dynamic>> irregular = [];
    for (final entry in logsByMed.entries) {
      final medLogs = entry.value;
      final total = medLogs.length;
      if (total < 3) continue; // Minimum baseline required to flag
      
      final missed = medLogs.where((l) => l.status == 'Skipped' || l.status == 'Miss' || l.status == 'Missed').length;
      final missedRate = missed / total;
      
      if (missedRate > 0.30) {
        irregular.add({
          'name': getMedicineName(entry.key),
          'missedRate': missedRate,
          'missed': missed,
          'total': total,
        });
      }
    }
    
    // Sort primarily by highest missed rate
    irregular.sort((a, b) => (b['missedRate'] as double).compareTo(a['missedRate'] as double));
    return irregular;
  }
}
```
