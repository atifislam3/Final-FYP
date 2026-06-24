import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/medicine_model.dart'; // Ensure this import is present
import '../models/medicine_log_model.dart';
import '../models/appointment_model.dart';
import '../models/journal_model.dart'; // NEW import
import '../models/report_model.dart'; // NEW import
import '../models/streak_model.dart'; // NEW import
import '../models/chat_message_model.dart'; // NEW import
import '../models/notification_settings_model.dart'; // NEW import

class HiveService {
  // Schema-defined Box Names (private, used internally throughout this class).
  static const String _userBoxName = "userBox";
  static const String _medicineBoxName = "medicineBox"; // NEW: For Module 3
  static const String _logBoxName = "medicineLogBox"; // NEW: For tracking
  static const String _keyCurrentUser = "current_user";
  static const String _appointmentBoxName = "appointmentBox";
  static const String _journalBoxName = "journalBox"; // NEW: For Module 4
  static const String _reportBoxName = "reportBox"; // NEW: For Module 5
  static const String _streakBoxName =
      "streakBox"; // NEW: For streak persistence
  static const String _chatBoxName = "chatBox"; // NEW: For chat history
  static const String _notificationSettingsBoxName =
      "notificationSettingsBox"; // NEW: For notification sound preferences

  // Public aliases for box names — used by the background notification handler
  // which runs in a separate Dart isolate and cannot import internal members.
  static const String medicineBoxName = _medicineBoxName;
  static const String logBoxName = _logBoxName;
  static const String notificationSettingsBoxName = _notificationSettingsBoxName;

  static Future<void> init() async {
    await Hive.initFlutter();

    // NEW: Register Adapter for MedicineModel
    // (Note: You must run 'flutter pub run build_runner build' for this to work)
    if (!Hive.isAdapterRegistered(1))
      Hive.registerAdapter(MedicineModelAdapter());
    if (!Hive.isAdapterRegistered(2))
      Hive.registerAdapter(MedicineLogModelAdapter()); // Register Log
    if (!Hive.isAdapterRegistered(3))
      Hive.registerAdapter(AppointmentModelAdapter()); // Register Appointment
    if (!Hive.isAdapterRegistered(4))
      Hive.registerAdapter(JournalModelAdapter()); // Register Journal
    if (!Hive.isAdapterRegistered(5))
      Hive.registerAdapter(ReportModelAdapter()); // Register Report
    if (!Hive.isAdapterRegistered(6))
      Hive.registerAdapter(StreakModelAdapter()); // Register Streak
    if (!Hive.isAdapterRegistered(7))
      Hive.registerAdapter(ChatMessageModelAdapter()); // Register Chat
    if (!Hive.isAdapterRegistered(8))
      Hive.registerAdapter(
          NotificationSettingsModelAdapter()); // Register Notification Settings

    await Hive.openBox(_userBoxName);
    await Hive.openBox<MedicineModel>(_medicineBoxName);
    await Hive.openBox<MedicineLogModel>(_logBoxName);
    await Hive.openBox<AppointmentModel>(_appointmentBoxName);
    await Hive.openBox<JournalModel>(_journalBoxName);
    await Hive.openBox<ReportModel>(_reportBoxName);
    await Hive.openBox<StreakModel>(_streakBoxName);
    await Hive.openBox<ChatMessageModel>(_chatBoxName);
    await Hive.openBox<NotificationSettingsModel>(_notificationSettingsBoxName);
  }

  // --------------------------------------------------------
  // SECTION: User Session (Your Existing Code)
  // --------------------------------------------------------
  static Future<void> saveUserSession(String uid) async {
    var box = Hive.box(_userBoxName);
    await box.put(_keyCurrentUser, {
      'uid': uid,
      'name': '',
      'email': '',
    });
  }

  static String? getUserId() {
    if (!Hive.isBoxOpen(_userBoxName)) return null;
    var box = Hive.box(_userBoxName);
    var data = box.get(_keyCurrentUser);
    if (data != null) {
      if (data is String) {
        try {
          final decoded = jsonDecode(data);
          if (decoded is Map) {
            return decoded['uid'] as String?;
          }
          return null;
        } catch (e) {
          return null;
        }
      }
      if (data is Map) {
        return data['uid'] as String?;
      }
    }
    return null;
  }

  static Future<void> saveUserProfile(Map<String, dynamic> userMap) async {
    var box = Hive.box(_userBoxName);
    await box.put(_keyCurrentUser, userMap);
  }

  static Map<String, dynamic>? getUserProfile() {
    if (!Hive.isBoxOpen(_userBoxName)) return null;
    var box = Hive.box(_userBoxName);
    var data = box.get(_keyCurrentUser);
    if (data != null) {
      if (data is String) {
        try {
          final decoded = jsonDecode(data);
          if (decoded is Map) {
            return Map<String, dynamic>.from(decoded);
          }
          return null;
        } catch (e) {
          return null;
        }
      }
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
    }
    return null;
  }

  static bool hasUser() {
    if (!Hive.isBoxOpen(_userBoxName)) return false;
    var box = Hive.box(_userBoxName);
    return box.containsKey(_keyCurrentUser);
  }

  static Future<void> clearSession() async {
    var box = Hive.box(_userBoxName);
    await box.delete(_keyCurrentUser);
  }

  // --------------------------------------------------------
  // SECTION: Medicine Management (NEW for Module 3)
  // --------------------------------------------------------

  // SRS-67: Save new medicine
  static Future<void> addMedicine(MedicineModel medicine) async {
    var box = Hive.box<MedicineModel>(_medicineBoxName);
    await box.put(medicine.medicineId, medicine);
  }

  // Retrieve all for List View
  static List<MedicineModel> getAllMedicines() {
    var box = Hive.box<MedicineModel>(_medicineBoxName);
    return box.values.toList();
  }

  // SRS-72: Update medicine
  static Future<void> updateMedicine(MedicineModel medicine) async {
    var box = Hive.box<MedicineModel>(_medicineBoxName);
    await box.put(medicine.medicineId, medicine);
  }

  // SRS-80: Delete/Remove medicine
  static Future<void> deleteMedicine(String id) async {
    var box = Hive.box<MedicineModel>(_medicineBoxName);
    await box.delete(id);
  }

  // --------------------------------------------------------
  // SECTION: Medicine Log Tracking (NEW)
  // --------------------------------------------------------

  static Future<void> addLog(MedicineLogModel log) async {
    var box = Hive.box<MedicineLogModel>(_logBoxName);
    await box.put(log.logId, log);
  }

  // Get all logs for a specific Medicine ID
  static List<MedicineLogModel> getLogsForMedicine(String medId) {
    var box = Hive.box<MedicineLogModel>(_logBoxName);
    return box.values.where((log) => log.medicineId == medId).toList();
  }

  // Get all logs
  static List<MedicineLogModel> getAllLogs() {
    var box = Hive.box<MedicineLogModel>(_logBoxName);
    return box.values.toList();
  }

  static Future<void> deleteLog(String logId) async {
    var box = Hive.box<MedicineLogModel>(_logBoxName);
    await box.delete(logId);
  }

  static Future<void> addAppointment(AppointmentModel apt) async {
    var box = Hive.box<AppointmentModel>(_appointmentBoxName);
    await box.put(apt.id, apt);
  }

  static Future<void> updateAppointment(AppointmentModel apt) async {
    var box = Hive.box<AppointmentModel>(_appointmentBoxName);
    await box.put(apt.id, apt);
  }

  static Future<void> deleteAppointment(String id) async {
    var box = Hive.box<AppointmentModel>(_appointmentBoxName);
    await box.delete(id);
  }

  static List<AppointmentModel> getAllAppointments() {
    var box = Hive.box<AppointmentModel>(_appointmentBoxName);
    return box.values.toList();
  }

  // --------------------------------------------------------
  // SECTION: Journaling (NEW for Module 4)
  // --------------------------------------------------------

  static Future<void> addJournal(JournalModel journal) async {
    var box = Hive.box<JournalModel>(_journalBoxName);
    await box.put(journal.id, journal);
  }

  static List<JournalModel> getAllJournals() {
    var box = Hive.box<JournalModel>(_journalBoxName);
    return box.values.toList();
  }

  static Future<void> deleteJournal(String id) async {
    var box = Hive.box<JournalModel>(_journalBoxName);
    await box.delete(id);
  }

  // --------------------------------------------------------
  // SECTION: Report Management (NEW for Module 5)
  // --------------------------------------------------------

  static Future<void> addReport(ReportModel report) async {
    var box = Hive.box<ReportModel>(_reportBoxName);
    await box.put(report.id, report);
  }

  static List<ReportModel> getAllReports() {
    var box = Hive.box<ReportModel>(_reportBoxName);
    if (!box.isOpen) return [];
    return box.values.toList();
  }

  static Future<void> deleteReport(String id) async {
    var box = Hive.box<ReportModel>(_reportBoxName);
    await box.delete(id);
  }

  // --------------------------------------------------------
  // SECTION: Streak Management (NEW for persistence)
  // --------------------------------------------------------

  static Future<void> saveStreak(StreakModel streak) async {
    var box = Hive.box<StreakModel>(_streakBoxName);
    await box.put('user_streak', streak);
  }

  static StreakModel? getStreak() {
    var box = Hive.box<StreakModel>(_streakBoxName);
    return box.get('user_streak');
  }

  // --------------------------------------------------------
  // SECTION: Chat History Management (NEW for persistence)
  // --------------------------------------------------------

  static Future<void> saveChatMessage(ChatMessageModel message) async {
    var box = Hive.box<ChatMessageModel>(_chatBoxName);
    await box.put(message.id, message);
  }

  static List<ChatMessageModel> getAllChatMessages() {
    var box = Hive.box<ChatMessageModel>(_chatBoxName);
    return box.values.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  static Future<void> clearChatHistory() async {
    var box = Hive.box<ChatMessageModel>(_chatBoxName);
    await box.clear();
  }

  // --------------------------------------------------------
  // SECTION: Notification Settings Management (NEW)
  // --------------------------------------------------------

  static Future<void> saveNotificationSettings(
      NotificationSettingsModel settings) async {
    var box = Hive.box<NotificationSettingsModel>(_notificationSettingsBoxName);
    await box.put('user_notification_settings', settings);
  }

  static NotificationSettingsModel? getNotificationSettings() {
    var box = Hive.box<NotificationSettingsModel>(_notificationSettingsBoxName);
    return box.get('user_notification_settings');
  }
}
