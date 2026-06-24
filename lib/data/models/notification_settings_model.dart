import 'package:hive/hive.dart';

part 'notification_settings_model.g.dart';

@HiveType(typeId: 8)
class NotificationSettingsModel {
  @HiveField(0)
  String shortSoundName;

  @HiveField(1)
  String longSoundName;

  @HiveField(2)
  bool useShortForMedicine;

  @HiveField(3)
  bool useShortForAppointments;

  NotificationSettingsModel({
    this.shortSoundName = 'mixkit_bell_notification_933', // User's short sound
    this.longSoundName =
        'mixkit_marimba_waiting_ringtone_1360', // User's long sound
    this.useShortForMedicine = true,
    this.useShortForAppointments = false,
  });

  // Convert to Map for debugging/logging
  Map<String, dynamic> toMap() {
    return {
      'shortSoundName': shortSoundName,
      'longSoundName': longSoundName,
      'useShortForMedicine': useShortForMedicine,
      'useShortForAppointments': useShortForAppointments,
    };
  }

  // Create from Map
  factory NotificationSettingsModel.fromMap(Map<String, dynamic> map) {
    return NotificationSettingsModel(
      shortSoundName: map['shortSoundName'] ?? 'mixkit_bell_notification_933',
      longSoundName: map['longSoundName'] ?? 'mixkit_marimba_waiting_ringtone_1360',
      useShortForMedicine: map['useShortForMedicine'] ?? true,
      useShortForAppointments: map['useShortForAppointments'] ?? false,
    );
  }

  // Copy with method for easy updates
  NotificationSettingsModel copyWith({
    String? shortSoundName,
    String? longSoundName,
    bool? useShortForMedicine,
    bool? useShortForAppointments,
  }) {
    return NotificationSettingsModel(
      shortSoundName: shortSoundName ?? this.shortSoundName,
      longSoundName: longSoundName ?? this.longSoundName,
      useShortForMedicine: useShortForMedicine ?? this.useShortForMedicine,
      useShortForAppointments:
          useShortForAppointments ?? this.useShortForAppointments,
    );
  }
}
