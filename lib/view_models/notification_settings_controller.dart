import 'package:get/get.dart';
import '../data/models/notification_settings_model.dart';
import '../data/services/hive_service.dart';
import '../data/services/notification_service.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationSettingsController extends GetxController {
  // Non-final so it can be replaced with a fresh instance on each preview.
  AudioPlayer _audioPlayer = AudioPlayer();

  // Available notification sounds
  final List<NotificationSound> shortSounds = [
    NotificationSound(
      name: 'Bell Notification',
      fileName: 'mixkit_bell_notification_933',
      assetPath: 'sounds/short/mixkit-bell-notification-933.wav',
      duration: '2s',
    ),
  ];

  final List<NotificationSound> longSounds = [
    NotificationSound(
      name: 'Marimba Waiting',
      fileName: 'mixkit_marimba_waiting_ringtone_1360',
      assetPath: 'sounds/long/mixkit-marimba-waiting-ringtone-1360.mp3',
      duration: '4s',
    ),
  ];

  // Current settings
  late Rx<NotificationSettingsModel> settings;

  @override
  void onInit() {
    super.onInit();
    // Load current settings from Hive
    final savedSettings =
        HiveService.getNotificationSettings() ?? NotificationSettingsModel();
    settings = savedSettings.obs;
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  // Preview a sound — creates a fresh AudioPlayer each time to avoid stale
  // MediaPlayer state issues on Android (especially for larger WAV files).
  Future<void> previewSound(String assetPath) async {
    // Stop & dispose the current player before creating a new one.
    try {
      await _audioPlayer.stop();
      await _audioPlayer.dispose();
    } catch (_) {}

    // Replace with a fresh instance.
    _audioPlayer = AudioPlayer();

    try {
      // Set the audio context so Android plays through the notification/ring
      // stream rather than media (avoids some codec rejections on certain devices).
      await _audioPlayer.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            audioFocus: AndroidAudioFocus.gain,
            usageType: AndroidUsageType.notification,
            contentType: AndroidContentType.sonification,
          ),
        ),
      );
      // AssetSource expects path relative to the assets/ directory.
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print('Error playing sound preview: $e');
      Get.snackbar(
        'Preview Unavailable',
        'Sound will still play correctly in notifications.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Update short sound
  void updateShortSound(String fileName) {
    settings.value = settings.value.copyWith(shortSoundName: fileName);
    _saveSettings();
  }

  // Update long sound
  void updateLongSound(String fileName) {
    settings.value = settings.value.copyWith(longSoundName: fileName);
    _saveSettings();
  }

  // Toggle medicine notification type
  void toggleMedicineNotificationType(bool useShort) {
    settings.value = settings.value.copyWith(useShortForMedicine: useShort);
    _saveSettings();
  }

  // Toggle appointment notification type
  void toggleAppointmentNotificationType(bool useShort) {
    settings.value = settings.value.copyWith(useShortForAppointments: useShort);
    _saveSettings();
  }

  // Save settings to Hive and recreate notification channels
  Future<void> _saveSettings() async {
    await HiveService.saveNotificationSettings(settings.value);

    // Recreate notification channels with new sounds
    // This requires reinitializing the notification service
    await NotificationService.init();

    Get.snackbar(
      'Settings Saved',
      'Notification settings updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}

// Model for notification sound options
class NotificationSound {
  final String name;
  final String fileName;
  final String assetPath;
  final String duration;

  NotificationSound({
    required this.name,
    required this.fileName,
    required this.assetPath,
    required this.duration,
  });
}
