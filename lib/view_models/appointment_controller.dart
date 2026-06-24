import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../data/models/appointment_model.dart';
import '../data/models/notification_settings_model.dart' as import_models;
import '../data/services/hive_service.dart';
import '../data/services/notification_service.dart';

class AppointmentController extends GetxController {
  var appointments = <AppointmentModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var filterCategory = 'All'.obs;
  var filterDate = Rxn<DateTime>();

  // Form Input Controllers
  final doctorController = TextEditingController();
  final notesController = TextEditingController();

  // Form State
  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;
  var selectedCategory = 'General'.obs;
  var reminderOption = 60.obs; // Default 1 hour before
  var isRecurring = false.obs; // SRS-113
  var recurringFrequency = 'Weekly'.obs; // SRS-113 ('Weekly' or 'Monthly')

  final List<String> categories = [
    'General',
    'Dentist',
    'Cardiology',
    'Dermatology',
    'Therapy',
    'Other'
  ];

  final List<String> recurringFrequencies = ['Weekly', 'Monthly'];

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  void loadAppointments() {
    var all = HiveService.getAllAppointments();
    // SRS-109: Sort by date (Upcoming first)
    all.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    appointments.value = all;
  }

  // SRS-109: UI Helper lists
  List<AppointmentModel> get upcomingAppointments => _applyFilters(appointments
      .where((a) => !a.isCompleted && a.dateTime.isAfter(DateTime.now()))
      .toList(), sortingDesc: false);

  List<AppointmentModel> get historyAppointments => _applyFilters(appointments
      .where((a) => a.isCompleted || a.dateTime.isBefore(DateTime.now()))
      .toList(), sortingDesc: true);

  List<AppointmentModel> _applyFilters(List<AppointmentModel> items,
      {required bool sortingDesc}) {
    final query = searchQuery.value.toLowerCase().trim();
    final selectedCat = filterCategory.value;
    final selectedDt = filterDate.value;

    final filtered = items.where((apt) {
      if (selectedCat != 'All' && apt.category != selectedCat) {
        return false;
      }
      if (selectedDt != null) {
        if (apt.dateTime.year != selectedDt.year ||
            apt.dateTime.month != selectedDt.month ||
            apt.dateTime.day != selectedDt.day) {
          return false;
        }
      }
      if (query.isEmpty) return true;
      final dateLabel =
          '${apt.dateTime.day.toString().padLeft(2, '0')} ${apt.dateTime.month} ${apt.dateTime.year}';
      return apt.doctorName.toLowerCase().contains(query) ||
          apt.category.toLowerCase().contains(query) ||
          dateLabel.contains(query);
    }).toList();

    filtered.sort((a, b) => sortingDesc
        ? b.dateTime.compareTo(a.dateTime)
        : a.dateTime.compareTo(b.dateTime));
    return filtered;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void setFilterCategory(String category) {
    filterCategory.value = category;
  }

  void setFilterDate(DateTime? date) {
    filterDate.value = date;
  }

  void clearFilters() {
    searchQuery.value = '';
    filterCategory.value = 'All';
    filterDate.value = null;
  }

  // --- ACTIONS ---

  Future<void> saveAppointment({String? id}) async {
    if (doctorController.text.isEmpty) {
      Get.snackbar("Error", "Doctor name is required",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      // Combine Date + Time
      final dt = DateTime(
          selectedDate.value.year,
          selectedDate.value.month,
          selectedDate.value.day,
          selectedTime.value.hour,
          selectedTime.value.minute);

      final newApt = AppointmentModel(
        id: id ?? const Uuid().v4(),
        doctorName: doctorController.text.trim(),
        category: selectedCategory.value,
        dateTime: dt,
        reminderMinutes: reminderOption.value > 0 ? reminderOption.value : null,
        visitNotes: notesController.text.trim(),
        isCompleted: false,
        isRecurring: reminderOption.value > 0 && isRecurring.value,
        recurringFrequency: (reminderOption.value > 0 && isRecurring.value)
            ? recurringFrequency.value
            : null,
      );

      if (id == null) {
        await HiveService.addAppointment(newApt); // Add
        Get.back();
        Get.snackbar("Success", "Appointment Scheduled!",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        await HiveService.updateAppointment(newApt); // Update
        Get.back();
        Get.snackbar("Success", "Appointment Updated!",
            backgroundColor: Colors.green, colorText: Colors.white);
      }

      // SRS-112: Schedule Notification
      _scheduleAlert(newApt);

      loadAppointments();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Delete an appointment by ID
  Future<void> deleteAppointment(String id) async {
    // Immediately remove from the observable list so any Obx rebuild
    // triggered during the async Hive delete cannot re-insert the already-
    // dismissed Dismissible widget and cause the brief red error screen.
    appointments.removeWhere((a) => a.id == id);
    NotificationService.cancel(id.hashCode);
    await HiveService.deleteAppointment(id);
    loadAppointments();
  }

  // SRS-111: Manual Complete
  Future<void> markCompleted(AppointmentModel apt) async {
    apt.isCompleted = true;
    await HiveService.updateAppointment(apt);
    NotificationService.cancel(apt.id.hashCode); // Cancel reminder
    loadAppointments();
    Get.snackbar("Completed", "Moved to history");
  }

  void _scheduleAlert(AppointmentModel apt, {bool showError = true}) {
    // 1. Cancel old alert first
    NotificationService.cancel(apt.id.hashCode);

    // 2. Schedule new if enabled
    if (apt.reminderMinutes != null && !apt.isCompleted) {
      final triggerTime =
          apt.dateTime.subtract(Duration(minutes: apt.reminderMinutes!));

      if (triggerTime.isAfter(DateTime.now())) {
        // SRS-113: Determine repeat interval for recurring reminders
        DateTimeComponents? repeatComponents;
        if (apt.isRecurring) {
          if (apt.recurringFrequency == 'Weekly') {
            repeatComponents = DateTimeComponents.dayOfWeekAndTime;
          } else if (apt.recurringFrequency == 'Monthly') {
            repeatComponents = DateTimeComponents.dayOfMonthAndTime;
          }
        }

        final settings = HiveService.getNotificationSettings() ??
            import_models.NotificationSettingsModel();

        NotificationService.scheduleNotification(
          id: apt.id.hashCode,
          title: "Appointment: ${apt.doctorName}",
          body: apt.isRecurring
              ? "${apt.recurringFrequency} visit reminder — ${apt.reminderMinutes} min until your appointment."
              : "Your appointment is in ${apt.reminderMinutes} minutes.",
          scheduledTime: triggerTime,
          useShortSound: settings.useShortForAppointments,
          matchDateTimeComponents: repeatComponents,
        );
      } else if (showError) {
        // UC-31 Extension 4a: Reminder time is already in the past
        Get.snackbar(
          "Invalid Reminder Time",
          "The reminder time has already passed. Please choose a later appointment date or a shorter lead time.",
          backgroundColor: const Color(0xFFF59E0B),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    }
  }

  // --- FORM HELPERS (Pre-fill data for Edit) ---
  void prepareEdit(AppointmentModel apt) {
    doctorController.text = apt.doctorName;
    notesController.text = apt.visitNotes ?? "";
    selectedCategory.value = apt.category;
    selectedDate.value = apt.dateTime;
    selectedTime.value = TimeOfDay.fromDateTime(apt.dateTime);
    reminderOption.value = apt.reminderMinutes ?? 0;
    isRecurring.value = apt.isRecurring;
    recurringFrequency.value = apt.recurringFrequency ?? 'Weekly';
  }

  /// Called when notification sound settings change — cancel & reschedule all
  /// active appointment reminders so they use the new sound channel.
  Future<void> rescheduleAllNotifications() async {
    for (final apt in appointments) {
      if (!apt.isCompleted) {
        _scheduleAlert(apt, showError: false);
      }
    }
  }

  void clearForm() {
    doctorController.clear();
    notesController.clear();
    selectedCategory.value = 'General';
    selectedDate.value = DateTime.now();
    selectedTime.value = TimeOfDay.now();
    reminderOption.value = 60;
    isRecurring.value = false;
    recurringFrequency.value = 'Weekly';
  }
}
