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
  var notificationSound = "Default".obs;

  // Notification sound settings
  var selectedShortSound = 'mixkit_bell_notification_933'.obs;
  var selectedLongSound = 'mixkit_marimba_waiting_ringtone_1360'.obs;
  var useShortForMedicine = true.obs;
  var useShortForAppointments = false.obs;

  final AudioPlayer _audioPlayer = AudioPlayer();

  static const String _boxName = "settingsBox";
  static const String _keyTheme = "isDarkMode";

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _loadNotificationSettings();
    _initTimeZone();
  }

  Future<void> _loadSettings() async {
    var box = await Hive.openBox(_boxName);
    isDarkMode.value = box.get(_keyTheme, defaultValue: false);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> _initTimeZone() async {
    try {
      currentTimeZone.value =
          (await FlutterTimezone.getLocalTimezone()) as String;
    } catch (e) {
      currentTimeZone.value = "UTC (Fallback)";
    }
  }

  void toggleTheme(bool isDark) async {
    isDarkMode.value = isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));
    var box = await Hive.openBox(_boxName);
    await box.put(_keyTheme, isDark);
  }

  void updateNotificationSound(String sound) {
    notificationSound.value = sound;
  }

  // ================= NOTIFICATION SOUND SETTINGS =================

  Future<void> _loadNotificationSettings() async {
    final settings = HiveService.getNotificationSettings();
    if (settings != null) {
      selectedShortSound.value = settings.shortSoundName;
      selectedLongSound.value = settings.longSoundName;
      useShortForMedicine.value = settings.useShortForMedicine;
      useShortForAppointments.value = settings.useShortForAppointments;
      notificationSound.value =
          '${_formatSoundName(settings.shortSoundName)} | ${_formatSoundName(settings.longSoundName)}';
    }
  }

  String _formatSoundName(String soundName) {
    return soundName
        .replaceAll('mixkit_', '')
        .replaceAll('_', ' ')
        .split(' ')
        .take(2)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Future<void> updateShortSound(String soundName) async {
    selectedShortSound.value = soundName;
    await _saveNotificationSettings();
  }

  Future<void> updateLongSound(String soundName) async {
    selectedLongSound.value = soundName;
    await _saveNotificationSettings();
  }

  Future<void> toggleMedicineSound(bool useShort) async {
    useShortForMedicine.value = useShort;
    await _saveNotificationSettings();
  }

  Future<void> toggleAppointmentSound(bool useShort) async {
    useShortForAppointments.value = useShort;
    await _saveNotificationSettings();
  }

  Future<void> _saveNotificationSettings() async {
    final settings = NotificationSettingsModel(
      shortSoundName: selectedShortSound.value,
      longSoundName: selectedLongSound.value,
      useShortForMedicine: useShortForMedicine.value,
      useShortForAppointments: useShortForAppointments.value,
    );
    await HiveService.saveNotificationSettings(settings);
    notificationSound.value =
        '${_formatSoundName(selectedShortSound.value)} | ${_formatSoundName(selectedLongSound.value)}';

    // Recreate notification channels with the new sound
    await NotificationService.init();

    // Cancel ALL pending notifications and reschedule with new sound.
    // Required because Android locks a channel's sound after first creation —
    // NotificationService.init() creates a new channel ID per sound name,
    // so rescheduling puts all alarms on the correct new channel.
    await NotificationService.cancelAll();

    try {
      final medController = Get.find<MedicineController>();
      await medController.rescheduleAllNotifications();
    } catch (_) {}

    try {
      final aptController = Get.find<AppointmentController>();
      await aptController.rescheduleAllNotifications();
    } catch (_) {}

    Get.snackbar(
      '🔔 Settings Saved',
      'Notification sound preferences updated',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // ================= SOUND PREVIEW =================

  Future<void> previewSound(String soundName, bool isShort) async {
    try {
      // Stored key uses underscores; filename uses dashes
      final fileName = soundName.replaceAll('_', '-');
      final ext = soundName.contains('marimba') ? '.mp3' : '.wav';
      final assetPath = isShort
          ? 'sounds/short/$fileName$ext'
          : 'sounds/long/$fileName$ext';
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print('Error playing sound preview: $e');
      Get.snackbar(
        'Preview Error',
        'Could not preview sound',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
