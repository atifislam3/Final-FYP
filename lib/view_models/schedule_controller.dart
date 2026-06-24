import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/medicine_model.dart';
import '../data/models/appointment_model.dart';
import 'medicine_controller.dart';
import 'appointment_controller.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum ScheduleItemType { medicine, appointment }

enum ScheduleItemStatus { taken, missed, pending, upcoming }

// ─── ScheduleItem ─────────────────────────────────────────────────────────────

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
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.scheduledTime,
    required this.status,
    required this.color,
    this.category,
  });
}

// ─── ScheduleController ───────────────────────────────────────────────────────

class ScheduleController extends GetxController {
  // ── Dependencies ────────────────────────────────────────────────────────────
  late final MedicineController _medCtrl;
  late final AppointmentController _aptCtrl;

  // ── Reactive state ──────────────────────────────────────────────────────────
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // ── Date range (SRS-88: ±15 days) ───────────────────────────────────────────
  DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  DateTime get rangeStart => _today.subtract(const Duration(days: 15));
  DateTime get rangeEnd => _today.add(const Duration(days: 15));

  // ── Colors ──────────────────────────────────────────────────────────────────
  static const Color medicineColor = Color(0xFF6C63FF); // purple
  static const Color appointmentColor = Color(0xFF00BFA6); // teal

  @override
  void onInit() {
    super.onInit();
    _medCtrl = Get.find<MedicineController>();
    _aptCtrl = Get.find<AppointmentController>();
  }

  // ── Date selection (SRS-87, SRS-88) ─────────────────────────────────────────
  void onDaySelected(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    if (d.isBefore(rangeStart) || d.isAfter(rangeEnd)) {
      Get.snackbar(
        'Out of Range',
        'Calendar is limited to 15 days past and future',
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    selectedDate.value = d;
  }

  // ── Compute schedule items for any date ──────────────────────────────────────
  List<ScheduleItem> scheduleForDate(DateTime date) {
    final items = <ScheduleItem>[];
    final dateKey = DateTime(date.year, date.month, date.day);
    final now = DateTime.now();

    // Medicine doses (SRS-86)
    for (final med in _medCtrl.medicines) {
      if (!_medCtrl.isScheduledForDate(med, dateKey)) continue;
      for (final timeSlot in med.reminderTimes) {
        final scheduled = DateTime(
          dateKey.year,
          dateKey.month,
          dateKey.day,
          timeSlot.hour,
          timeSlot.minute,
        );

        final taken = _medCtrl.isTaken(med.medicineId, dateKey, timeSlot);
        final isPast = scheduled.isBefore(now);

        ScheduleItemStatus status;
        if (taken) {
          status = ScheduleItemStatus.taken;
        } else if (isPast) {
          status = ScheduleItemStatus.missed;
        } else if (isSameDay(dateKey, _today)) {
          status = ScheduleItemStatus.pending;
        } else {
          status = ScheduleItemStatus.upcoming;
        }

        items.add(ScheduleItem(
          id: '${med.medicineId}_${scheduled.millisecondsSinceEpoch}',
          type: ScheduleItemType.medicine,
          title: med.name,
          subtitle: med.dosage,
          scheduledTime: scheduled,
          status: status,
          color: medicineColor,
          category: med.type,
        ));
      }
    }

    // Appointments (SRS-86)
    for (final apt in _aptCtrl.appointments) {
      final aptDate = DateTime(
        apt.dateTime.year,
        apt.dateTime.month,
        apt.dateTime.day,
      );
      if (!isSameDay(aptDate, dateKey)) continue;

      ScheduleItemStatus status;
      if (apt.isCompleted) {
        status = ScheduleItemStatus.taken; // completed → "taken" (done)
      } else if (apt.dateTime.isBefore(now)) {
        status = ScheduleItemStatus.missed;
      } else {
        status = ScheduleItemStatus.upcoming;
      }

      items.add(ScheduleItem(
        id: apt.id,
        type: ScheduleItemType.appointment,
        title: apt.doctorName,
        subtitle: apt.category,
        scheduledTime: apt.dateTime,
        status: status,
        color: appointmentColor,
        category: apt.category,
      ));
    }

    // Sort chronologically (SRS-86)
    items.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return items;
  }

  // ── Reactive items for selected date ────────────────────────────────────────
  List<ScheduleItem> get itemsForSelectedDate =>
      scheduleForDate(selectedDate.value);

  // ── Marked dates (SRS-85: event indicators) ─────────────────────────────────
  Set<DateTime> get markedDates {
    final dates = <DateTime>{};

    for (final med in _medCtrl.medicines) {
      // Check each day in the valid ±15 range
      final rangeLength = rangeEnd.difference(rangeStart).inDays;
      for (int i = 0; i <= rangeLength; i++) {
        final d = rangeStart.add(Duration(days: i));
        if (_medCtrl.isScheduledForDate(med, d)) {
          dates.add(DateTime(d.year, d.month, d.day));
        }
      }
    }

    for (final apt in _aptCtrl.appointments) {
      final d = DateTime(apt.dateTime.year, apt.dateTime.month, apt.dateTime.day);
      dates.add(d);
    }

    return dates;
  }

  // ── Helper: appointment for a date ──────────────────────────────────────────
  List<AppointmentModel> appointmentsForDate(DateTime date) {
    return _aptCtrl.appointments.where((a) {
      return a.dateTime.year == date.year &&
          a.dateTime.month == date.month &&
          a.dateTime.day == date.day;
    }).toList();
  }

  // ── Helper: medicine doses for a date ───────────────────────────────────────
  List<MedicineModel> medicinesForDate(DateTime date) {
    return _medCtrl.medicines
        .where((m) => _medCtrl.isScheduledForDate(m, date))
        .toList();
  }

  // ── Mark medicine dose as taken (slide-to-dismiss) ───────────────────────────
  Future<void> markMedicineTaken(MedicineModel med, DateTime scheduledTime) async {
    await _medCtrl.markAsTaken(med, scheduledTime, scheduledTime);
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // ── Find medicine by id ──────────────────────────────────────────────────────
  MedicineModel? findMedicine(String id) =>
      _medCtrl.medicines.firstWhereOrNull((m) => m.medicineId == id);

  // ── Find appointment by id ──────────────────────────────────────────────────
  AppointmentModel? findAppointment(String id) =>
      _aptCtrl.appointments.firstWhereOrNull((a) => a.id == id);
}
