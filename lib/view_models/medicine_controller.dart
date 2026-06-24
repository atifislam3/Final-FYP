import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../data/models/medicine_model.dart';
import '../data/models/medicine_log_model.dart';
import '../data/services/hive_service.dart';
import '../data/services/notification_service.dart';

class MedicineController extends GetxController with WidgetsBindingObserver {
  var medicines = <MedicineModel>[].obs;
  var isLoading = false.obs;

  // UI State for Add Form
  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final stockController = TextEditingController();
  final customTypeController = TextEditingController();

  var selectedType = 'Tablet'.obs;
  var frequency = 'Daily'.obs;
  var reminderTimes = <TimeOfDay>[].obs;
  var selectedDays = <int>[].obs;

  // New Cyclic/Interval State
  var interval = 1.obs;
  var cycleOn = 21.obs;
  var cycleOff = 7.obs;
  var startDate = DateTime.now().obs;

  // Dashboard State
  var selectedDate = DateTime.now().obs;
  var logs = <MedicineLogModel>[].obs;

  final List<String> defaultTypes = [
    'Tablet',
    'Capsule',
    'Syrup',
    'Injection',
    'Drops',
    'Inhaler',
    'Other'
  ];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadMedicines();
    loadLogs();
    rescheduleAllNotifications(); // SRS-74: Reschedule on startup
    // Auto-mark any dose from a previous day that was never recorded.
    // This covers the case where the user neither took the medicine nor
    // interacted with the notification — the dose silently becomes 'Skipped'
    // on the next app launch so it appears correctly in reports.
    _autoMarkPreviousDayMissedDoses();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When the app comes back to the foreground (e.g. after a background
    // notification action wrote a log directly to Hive), reload the in-memory
    // log list so the today screen and progress ring reflect the latest data.
    // Also run the auto-miss check so any dose that has been waiting 2+ hours
    // without acknowledgement is immediately marked as Skipped.
    if (state == AppLifecycleState.resumed) {
      loadLogs();
      _autoMarkPreviousDayMissedDoses();
    }
  }

  void loadMedicines() {
    medicines.value = HiveService.getAllMedicines();
  }

  void loadLogs() {
    logs.value = HiveService.getAllLogs();
  }

  // ── Auto-miss past unrecorded doses ──────────────────────────────────────
  //
  // Looks back up to 7 days. For each medicine, for each reminder time on
  // each past day where:
  //   • the medicine was scheduled (isScheduledForDate)
  //   • no log entry exists (neither Taken nor Skipped)
  // a 'Skipped' log entry is created so the dose appears as missed in
  // reports and analytics rather than silently absent.
  //
  // Previous-day doses: always auto-missed (user had the full day).
  // Today's doses: auto-missed only when 2+ hours have passed since the
  // scheduled time, giving the user a grace window to still take them.
  Future<void> _autoMarkPreviousDayMissedDoses() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    bool anyAdded = false;

    for (final med in medicines) {
      // ── Previous days (up to 7) ─────────────────────────────────────
      for (int daysBack = 1; daysBack <= 7; daysBack++) {
        final pastDay = today.subtract(Duration(days: daysBack));
        if (!isScheduledForDate(med, pastDay)) continue;

        for (final reminderDT in med.reminderTimes) {
          final scheduledDT = DateTime(
            pastDay.year, pastDay.month, pastDay.day,
            reminderDT.hour, reminderDT.minute,
          );

          // Skip if a log entry already exists for this slot (any status).
          final alreadyLogged = logs.any((log) =>
              log.medicineId == med.medicineId &&
              log.scheduledTime.year == scheduledDT.year &&
              log.scheduledTime.month == scheduledDT.month &&
              log.scheduledTime.day == scheduledDT.day &&
              log.scheduledTime.hour == scheduledDT.hour &&
              log.scheduledTime.minute == scheduledDT.minute);

          if (alreadyLogged) continue;

          final missedLog = MedicineLogModel(
            logId:
                '${med.medicineId}_${scheduledDT.millisecondsSinceEpoch}_automiss',
            medicineId: med.medicineId,
            scheduledTime: scheduledDT,
            actualTime: scheduledDT,
            status: 'Skipped',
          );
          await HiveService.addLog(missedLog);
          anyAdded = true;
        }
      }

      // ── Today's doses: auto-miss if 2+ hours overdue ─────────────────
      if (!isScheduledForDate(med, today)) continue;

      for (final reminderDT in med.reminderTimes) {
        final scheduledDT = DateTime(
          today.year, today.month, today.day,
          reminderDT.hour, reminderDT.minute,
        );

        // Only process doses whose scheduled time has passed by 2+ hours.
        if (now.difference(scheduledDT).inHours < 2) continue;

        final alreadyLogged = logs.any((log) =>
            log.medicineId == med.medicineId &&
            log.scheduledTime.year == scheduledDT.year &&
            log.scheduledTime.month == scheduledDT.month &&
            log.scheduledTime.day == scheduledDT.day &&
            log.scheduledTime.hour == scheduledDT.hour &&
            log.scheduledTime.minute == scheduledDT.minute);

        if (alreadyLogged) continue;

        final missedLog = MedicineLogModel(
          logId:
              '${med.medicineId}_${scheduledDT.millisecondsSinceEpoch}_automiss',
          medicineId: med.medicineId,
          scheduledTime: scheduledDT,
          actualTime: scheduledDT,
          status: 'Skipped',
        );
        await HiveService.addLog(missedLog);
        anyAdded = true;
      }
    }

    // Reload the in-memory list from Hive so it stays consistent.
    if (anyAdded) loadLogs();
  }

  // --- DASHBOARD HELPERS ---

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
  }

  // Get medicines scheduled for the selected date
  List<MedicineModel> get dailyMedicines {
    return medicines
        .where((med) => isScheduledForDate(med, selectedDate.value))
        .toList();
  }

  // Calculate daily progress (percentage of doses taken)
  double getDailyProgress() {
    final todaysMeds = dailyMedicines;
    if (todaysMeds.isEmpty) return 0.0;

    int totalDoses = 0;
    int takenDoses = 0;

    for (var med in todaysMeds) {
      for (var time in med.reminderTimes) {
        totalDoses++;
        if (isTaken(med.medicineId, selectedDate.value, time)) {
          takenDoses++;
        }
      }
    }

    return totalDoses > 0 ? takenDoses / totalDoses : 0.0;
  }

  // Check if a specific dose is taken
  bool isTaken(String medId, DateTime date, DateTime timeSlot) {
    final dateKey = DateTime(date.year, date.month, date.day);
    final timeKey = DateTime(dateKey.year, dateKey.month, dateKey.day,
        timeSlot.hour, timeSlot.minute);

    return logs.any((log) =>
        log.medicineId == medId &&
        log.scheduledTime.year == timeKey.year &&
        log.scheduledTime.month == timeKey.month &&
        log.scheduledTime.day == timeKey.day &&
        log.scheduledTime.hour == timeKey.hour &&
        log.scheduledTime.minute == timeKey.minute &&
        log.status == 'Taken');
  }

  // Get the precise status of a dose ('Taken', 'Skipped', or null)
  String? getDoseStatus(String medId, DateTime date, DateTime timeSlot) {
    final dateKey = DateTime(date.year, date.month, date.day);
    final timeKey = DateTime(dateKey.year, dateKey.month, dateKey.day,
        timeSlot.hour, timeSlot.minute);

    final log = logs.firstWhereOrNull((log) =>
        log.medicineId == medId &&
        log.scheduledTime.year == timeKey.year &&
        log.scheduledTime.month == timeKey.month &&
        log.scheduledTime.day == timeKey.day &&
        log.scheduledTime.hour == timeKey.hour &&
        log.scheduledTime.minute == timeKey.minute);

    return log?.status;
  }

  // Clear an existing log (undo taken/skipped)
  Future<void> clearDoseLog(MedicineModel med, DateTime date, DateTime timeSlot) async {
    final dateKey = DateTime(date.year, date.month, date.day);
    final timeKey = DateTime(dateKey.year, dateKey.month, dateKey.day,
        timeSlot.hour, timeSlot.minute);

    final logToRemove = logs.firstWhereOrNull((log) =>
        log.medicineId == med.medicineId &&
        log.scheduledTime.year == timeKey.year &&
        log.scheduledTime.month == timeKey.month &&
        log.scheduledTime.day == timeKey.day &&
        log.scheduledTime.hour == timeKey.hour &&
        log.scheduledTime.minute == timeKey.minute);

    if (logToRemove != null) {
      if (logToRemove.status == 'Taken') {
        med.stock++;
        await HiveService.updateMedicine(med);
        loadMedicines();
      }
      await HiveService.deleteLog(logToRemove.logId);
      loadLogs();
      Get.snackbar(
        "Cleared",
        "${med.name} status cleared",
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Mark a dose as taken
  Future<void> markAsTaken(
      MedicineModel med, DateTime date, DateTime timeSlot) async {
    // Overwrite existing log if present (and restore stock if it was 'Taken')
    await clearDoseLog(med, date, timeSlot);

    final dateKey = DateTime(date.year, date.month, date.day);
    final scheduledTime = DateTime(dateKey.year, dateKey.month, dateKey.day,
        timeSlot.hour, timeSlot.minute);

    final log = MedicineLogModel(
      logId: const Uuid().v4(),
      medicineId: med.medicineId,
      scheduledTime: scheduledTime,
      actualTime: DateTime.now(),
      status: 'Taken',
    );

    await HiveService.addLog(log);
    loadLogs();

    // Update stock
    if (med.stock > 0) {
      med.stock--;
      await HiveService.updateMedicine(med);
      loadMedicines();
      
      if (med.stock <= 5) {
        NotificationService.showLowStockNotification(med);
      }
    }

    Get.snackbar(
      "✓ Taken",
      "${med.name} marked as taken",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Mark a dose as skipped/missed
  Future<void> markAsSkipped(MedicineModel med, DateTime scheduledTime) async {
    // Overwrite existing log if present (and restore stock if it was 'Taken')
    await clearDoseLog(med, scheduledTime, scheduledTime);

    final dateKey =
        DateTime(scheduledTime.year, scheduledTime.month, scheduledTime.day);
    final timeKey = DateTime(dateKey.year, dateKey.month, dateKey.day,
        scheduledTime.hour, scheduledTime.minute);

    final log = MedicineLogModel(
      logId: const Uuid().v4(),
      medicineId: med.medicineId,
      scheduledTime: timeKey,
      actualTime: DateTime.now(),
      status: 'Skipped',
    );

    await HiveService.addLog(log);
    loadLogs();
  }

  // --- LOGIC: DATE FILTERING (SRS-64) ---
  bool isScheduledForDate(MedicineModel med, DateTime date) {
    if (!med.isActive) return false;

    try {
      final target = DateTime(date.year, date.month, date.day);

      // Fallback for old data with no startDate: apply only stock check
      if (med.startDate == null) return _stockCoversDate(med, target);

      // Compare Dates (strip time)
      final start =
          DateTime(med.startDate!.year, med.startDate!.month, med.startDate!.day);
      final diffDays = target.difference(start).inDays;

      if (diffDays < 0) return false; // Before start date

      // Frequency check
      final bool onSchedule;
      switch (med.frequencyType) {
        case 'Daily':
          onSchedule = true;
          break;
        case 'SpecificDays':
          onSchedule = med.specificDays?.contains(target.weekday) ?? false;
          break;
        case 'Interval':
          onSchedule = (diffDays % (med.interval ?? 1)) == 0;
          break;
        case 'Cyclic':
          // SRS-64: Cyclic Logic (e.g., 21 on, 7 off = 28 day loop)
          final totalCycle = (med.cycleOnDays ?? 1) + (med.cycleOffDays ?? 0);
          final positionInCycle = diffDays % totalCycle;
          onSchedule = positionInCycle < (med.cycleOnDays ?? 1);
          break;
        default:
          return false;
      }

      if (!onSchedule) return false;

      // Stock-depletion check: only show future dates the remaining stock can cover
      return _stockCoversDate(med, target);
    } catch (e, st) {
      print('⚠️ isScheduledForDate error for ${med.name} on $date: $e');
      print(st);
      return false;
    }
  }

  /// Returns true if [target] is within the reach of the medicine's remaining
  /// stock. Past dates and today are always allowed (history is valid and
  /// today's dose uses current stock). For future dates the number of
  /// scheduled dose-slots from today up to (but not including) [target] must
  /// be less than the remaining stock.
  bool _stockCoversDate(MedicineModel med, DateTime target) {
    try {
      final now = DateTime.now();
      final todayKey = DateTime(now.year, now.month, now.day);

      // Historical dates: always show regardless of current stock level
      // (past schedule entries are historical and should remain visible).
      if (target.isBefore(todayKey)) return true;

      // Today: show only when there is at least one dose in stock.
      if (!target.isAfter(todayKey)) return med.stock > 0;

      // Future dates with no stock at all → hide immediately.
      if (med.stock <= 0) return false;

      // Count how many scheduled dose-slots fall between today (inclusive) and
      // target (exclusive). Each scheduled day consumes reminderTimes.length
      // doses. The loop is bounded by the ±15-day calendar window (≤15 iterations).
      final dosesPerDay = med.reminderTimes.length;
      int dosesBeforeTarget = 0;
      DateTime cursor = todayKey;

      while (cursor.isBefore(target)) {
        if (_isOnFrequencySchedule(med, cursor)) {
          dosesBeforeTarget += dosesPerDay;
          if (dosesBeforeTarget >= med.stock) return false;
        }
        cursor = cursor.add(const Duration(days: 1));
      }

      return true;
    } catch (e, st) {
      print('⚠️ _stockCoversDate error for ${med.name} on $target: $e');
      print(st);
      return false;
    }
  }

  /// Pure frequency-pattern check with no stock or isActive guard.
  /// Used by [_stockCoversDate] to count upcoming scheduled days.
  bool _isOnFrequencySchedule(MedicineModel med, DateTime date) {
    try {
      if (med.startDate == null) return true; // fallback: always scheduled

      final target = DateTime(date.year, date.month, date.day);
      final start = DateTime(
          med.startDate!.year, med.startDate!.month, med.startDate!.day);
      final diffDays = target.difference(start).inDays;
      if (diffDays < 0) return false;

      switch (med.frequencyType) {
        case 'Daily':
          return true;
        case 'SpecificDays':
          return med.specificDays?.contains(target.weekday) ?? false;
        case 'Interval':
          return (diffDays % (med.interval ?? 1)) == 0;
        case 'Cyclic':
          final totalCycle = (med.cycleOnDays ?? 1) + (med.cycleOffDays ?? 0);
          return (diffDays % totalCycle) < (med.cycleOnDays ?? 1);
        default:
          return false;
      }
    } catch (e, st) {
      print('⚠️ _isOnFrequencySchedule error for ${med.name} on $date: $e');
      print(st);
      return false;
    }
  }

  // --- CRUD OPERATIONS ---
  Future<void> saveMedicine({String? id}) async {
    if (!_validate()) return;

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
        specificDays:
            frequency.value == 'SpecificDays' ? selectedDays.toList() : null,
        interval: frequency.value == 'Interval' ? interval.value : null,
        cycleOnDays: frequency.value == 'Cyclic' ? cycleOn.value : null,
        cycleOffDays: frequency.value == 'Cyclic' ? cycleOff.value : null,
        startDate: startDate.value,
        isActive: true,
      );

      if (id == null) {
        await HiveService.addMedicine(med);
        // SRS-68: Confirmation
        Get.back();
        Get.snackbar("Added", "${med.name} added to schedule!",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        await HiveService.updateMedicine(med);
        // SRS-73: Confirmation
        Get.back();
        Get.snackbar("Updated", "${med.name} details updated",
            backgroundColor: Colors.green, colorText: Colors.white);
      }

      // Sync Notifications (SRS-81)
      _rescheduleNotifications(med);
      loadMedicines();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle medicine active status (SRS-79)
  Future<void> toggleStatus(MedicineModel med) async {
    med.isActive = !med.isActive;
    await HiveService.updateMedicine(med);

    if (med.isActive) {
      _rescheduleNotifications(med);
      Get.snackbar("Alerts On", "Reminders enabled for ${med.name}",
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      // Cancel notifications
      int baseId = med.medicineId.hashCode;
      for (int i = 0; i < 10; i++) {
        NotificationService.cancel(baseId + i);
      }
      Get.snackbar("Alerts Off", "Reminders disabled for ${med.name}",
          backgroundColor: Colors.orange, colorText: Colors.white);
    }
    medicines.refresh();
  }

  // Allow external updates (e.g. from History View)
  Future<void> updateMedicine(MedicineModel med) async {
    await HiveService.updateMedicine(med);
    medicines.refresh();
  }

  // SRS-91/SRS-92: Mark medicine as completed (UC-21 step 8-10)
  // Sets isActive=false, records dateEnded, and cancels all notifications.
  Future<void> completeMedicine(MedicineModel med) async {
    med.isActive = false;
    med.dateEnded = DateTime.now();
    await HiveService.updateMedicine(med);
    int baseId = med.medicineId.hashCode;
    for (int i = 0; i < 20; i++) {
      // Cancel all possible IDs (same range as _rescheduleNotifications)
      NotificationService.cancel(baseId + i);
    }
    medicines.refresh();
  }

  // SRS-92 Alternate Flow: Re-activate a completed medicine (UC-21 alternate flow)
  // Sets isActive=true, clears dateEnded, and reschedules notifications.
  Future<void> reactivateMedicine(MedicineModel med) async {
    med.isActive = true;
    med.dateEnded = null;
    await HiveService.updateMedicine(med);
    _rescheduleNotifications(med);
    medicines.refresh();
  }

  // SRS-80: Delete medicine
  Future<void> deleteMedicine(MedicineModel med) async {
    // Cancel all possible notification IDs (same range as _rescheduleNotifications)
    int baseId = (med.medicineId.hashCode & 0x7FFFFFFF) % 100000000;
    for (int i = 0; i < 20; i++) {
      NotificationService.cancel(baseId + i);
    }
    medicines.remove(med);
    await HiveService.deleteMedicine(med.medicineId);
    Get.snackbar("Deleted", "${med.name} has been removed",
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  // --- INVENTORY CONTROL (SRS 2.2.6) ---

  // --- INVENTORY CONTROL (SRS 2.2.6) ---

  // SRS-98: Display medicines with stock <= 5 at the top
  List<MedicineModel> get sortedMedicines {
    // Filter to only show active medicines
    List<MedicineModel> sorted = medicines.where((m) => m.isActive).toList();
    sorted.sort((a, b) {
      bool aLow = a.stock <= 5;
      bool bLow = b.stock <= 5;
      if (aLow && !bLow) return -1; // a comes first
      if (!aLow && bLow) return 1; // b comes first
      return 0;
    });
    return sorted;
  }

  // SRS-99: Update Stock
  Future<void> updateStock(MedicineModel med, int newQty) async {
    med.stock = newQty;
    await HiveService.updateMedicine(med);
    medicines.refresh();

    // SRS-101: Confirmation
    Get.snackbar(
      "Stock Updated",
      "${med.name} stock set to $newQty",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
    );
  }

  // Helper: Reschedule (SRS-74)
  void _rescheduleNotifications(MedicineModel med) {
    // 1. Cancel old ID range
    int baseId = (med.medicineId.hashCode & 0x7FFFFFFF) % 100000000;
    for (int i = 0; i < 20; i++) {
      // Increased range for safety
      NotificationService.cancel(baseId + i);
    }

    // 2. Schedule new if active
    if (med.isActive) {
      for (int i = 0; i < med.reminderTimes.length; i++) {
        final timeOfDay = TimeOfDay.fromDateTime(med.reminderTimes[i]);

        // OPTIMIZATION: Use Native Daily Recurrence for 'Daily' frequency
        if (med.frequencyType == 'Daily') {
          // For Daily, we schedule ONCE with recurrence
          // Need to find the NEXT occurrence of this time
          DateTime now = DateTime.now();
          DateTime scheduledDate = DateTime(
              now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
          // 1-minute grace period to prevent race conditions pushing alarms to tomorrow
          if (scheduledDate.isBefore(now.subtract(const Duration(minutes: 1)))) {
            scheduledDate = scheduledDate.add(const Duration(days: 1));
          }

          NotificationService.scheduleMedicine(
            id: baseId + i,
            medicineId: med.medicineId,
            name: med.name,
            dosage: med.dosage,
            time: scheduledDate,
            repeat: Repeat.daily,
          );
        } else {
          // Complex Schedules (Cyclic, Interval, SpecificDays)
          // Manual calculation for next valid occurrence
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

  // Calculate next valid time based on schedule type
  DateTime? _getNextValidOccurrence(MedicineModel med, TimeOfDay time) {
    DateTime now = DateTime.now();
    DateTime candidate =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    // If time passed for today (with 1 min grace), start checking from tomorrow
    if (candidate.isBefore(now.subtract(const Duration(minutes: 1)))) {
      candidate = candidate.add(const Duration(days: 1));
    }

    // Check up to 365 days ahead (safe limit)
    for (int i = 0; i < 365; i++) {
      if (isScheduledForDate(med, candidate)) {
        return candidate;
      }
      candidate = candidate.add(const Duration(days: 1));
    }
    return null;
  }

  // SRS-77: Update status from Notification Actions
  Future<void> handleNotificationAction(
      String action, String medId, DateTime scheduledTime) async {
    print('📱 MedicineController.handleNotificationAction called');
    print('  Action: $action');
    print('  Medicine ID: $medId');
    print('  Scheduled Time: $scheduledTime');
    
    // Ensure in-memory lists are up-to-date in case this was invoked
    // during a cold-start / notification-triggered app launch.
    loadMedicines();
    loadLogs();

    // Find the medicine
    final med = medicines.firstWhereOrNull((m) => m.medicineId == medId);
    if (med == null) {
      print('❌ Medicine not found!');
      return;
    }

    print('  Medicine found: ${med.name}');

    // Normalise the payload date to today so log entries are stored against
    // the current day's hour:minute, not the original (potentially weeks-old)
    // date embedded in a daily-recurring notification payload.
    final now = DateTime.now();
    final normalizedTime = DateTime(
        now.year, now.month, now.day,
        scheduledTime.hour, scheduledTime.minute);

    if (action == 'take') {
      print('  → Executing TAKE action');
      await markAsTaken(med, normalizedTime, normalizedTime);
      _rescheduleNotifications(med);
      Get.snackbar(
        '✓ Taken',
        '${med.name} marked as taken',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
      print('  ✅ TAKE action completed');
    } else if (action == 'miss') {
      print('  → Executing MISS action');
      await markAsSkipped(med, normalizedTime);
      Get.snackbar(
        '✗ Missed',
        '${med.name} marked as missed',
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      print('  ✅ MISS action completed');
    } else if (action == 'snooze') {
      print('  → Executing SNOOZE action');
      // Snooze for 10 minutes
      final snoozeTime = DateTime.now().add(const Duration(minutes: 10));
      int id = (med.medicineId.hashCode + (DateTime.now().millisecondsSinceEpoch ~/ 1000)) & 0x7FFFFFFF;

      await NotificationService.scheduleMedicine(
        id: id,
        medicineId: med.medicineId,
        name: med.name,
        dosage: med.dosage,
        time: snoozeTime,
        repeat: Repeat.none,
      );

      Get.snackbar(
        '⏰ Snoozed',
        'Reminding you in 10 minutes',
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue.shade900,
      );
      print('  ✅ SNOOZE action completed - next reminder at $snoozeTime');
    } else {
      print('❌ Unknown action: $action');
    }
  }

  // Reload all reminders (App Startup)
  Future<void> rescheduleAllNotifications() async {
    for (var med in medicines) {
      _rescheduleNotifications(med);
    }
  }

  bool _validate() {
    if (nameController.text.isEmpty) {
      Get.snackbar("Missing Info", "Please enter medicine name",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    // SRS-66: dosage is a required field
    if (dosageController.text.trim().isEmpty) {
      Get.snackbar("Missing Info", "Please enter dosage (e.g. 500mg)",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    // SRS-64/SRS-66: at least one day must be selected for SpecificDays schedule
    if (frequency.value == 'SpecificDays' && selectedDays.isEmpty) {
      Get.snackbar("Missing Info", "Please select at least one day",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (reminderTimes.isEmpty) {
      Get.snackbar("Missing Info", "Set at least one reminder time",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return true;
  }

  List<DateTime> _toDateTimeList(List<TimeOfDay> times) {
    final now = DateTime.now();
    return times
        .map((t) => DateTime(now.year, now.month, now.day, t.hour, t.minute))
        .toList();
  }

  // UI Helpers
  void addTime(BuildContext context) async {
    final picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && !reminderTimes.contains(picked)) {
      reminderTimes.add(picked);
    }
  }

  void prepareEdit(MedicineModel med) {
    nameController.text = med.name;
    dosageController.text = med.dosage;
    stockController.text = med.stock.toString();
    selectedType.value = defaultTypes.contains(med.type) ? med.type : 'Other';
    if (selectedType.value == 'Other') customTypeController.text = med.type;

    frequency.value = med.frequencyType;
    if (med.specificDays != null) selectedDays.value = med.specificDays!;
    if (med.interval != null) interval.value = med.interval!;
    if (med.cycleOnDays != null) cycleOn.value = med.cycleOnDays!;
    if (med.cycleOffDays != null) cycleOff.value = med.cycleOffDays!;
    if (med.startDate != null) startDate.value = med.startDate!;

    reminderTimes.value =
        med.reminderTimes.map((d) => TimeOfDay.fromDateTime(d)).toList();
  }
}
