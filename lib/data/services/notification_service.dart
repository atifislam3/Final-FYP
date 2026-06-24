import 'dart:ui' show Color;
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import '../../views/medicine_action_dialog.dart';
import '../models/notification_settings_model.dart';
import '../models/medicine_log_model.dart';
import '../models/medicine_model.dart';
import 'hive_service.dart';
import '../../utils/platform_utils.dart';
import '../../view_models/medicine_controller.dart';

// ── Background notification action handler ─────────────────────────────────
//
// Called by the OS when a notification action button is pressed and the
// Flutter engine is NOT in the foreground (app backgrounded or killed).
// Runs in a separate Dart isolate — no GetX, no UI.
//
// For Take / Miss: opens Hive directly and writes the log entry so the
// dose is recorded even if the user never opens the app.
// For Snooze:  schedules a new notification after 10 minutes.
@pragma('vm:entry-point')
Future<void> _onNotificationTappedBackground(
    NotificationResponse response) async {
  print('🔔 BG notification action: ${response.actionId}');

  final payload = response.payload;
  final actionId = response.actionId;
  if (payload == null || actionId == null) return;

  final parts = payload.split('|');
  if (parts.length != 2) return;

  final medicineId = parts[0];
  final DateTime scheduledTime;
  try {
    scheduledTime = DateTime.parse(parts[1]);
  } catch (_) {
    return;
  }

  // Dismiss the notification immediately so it disappears from the shade
  // regardless of whether the Hive logging below succeeds.
  try {
    final plugin = FlutterLocalNotificationsPlugin();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await plugin.initialize(const InitializationSettings(android: androidInit));
    if (response.id != null) {
      await plugin.cancel(response.id!);
      print('🗑️ BG: Notification ${response.id} dismissed');
    }
  } catch (e) {
    print('⚠️ BG: Could not dismiss notification: $e');
  }

  try {
    // Initialize Hive for this background isolate.
    // Adapter registration is idempotent (guarded by isAdapterRegistered).
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MedicineModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(MedicineLogModelAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(NotificationSettingsModelAdapter());
    }

    final logBox = await Hive.openBox<MedicineLogModel>(HiveService.logBoxName);
    // Medicine box needed for snooze (to retrieve name/dosage).
    final medBox =
        await Hive.openBox<MedicineModel>(HiveService.medicineBoxName);

    switch (actionId) {
      case 'take':
        // Normalise to today's date + reminder hour:minute.
        // Daily-repeating notifications carry the original schedule date in
        // their payload, which may be weeks old.  Using today ensures that
        // isTaken() finds the log entry on the current day's dashboard.
        final now = DateTime.now();
        final normalizedTake = DateTime(
            now.year, now.month, now.day,
            scheduledTime.hour, scheduledTime.minute);

        MedicineLogModel? existingLog;
        for (var l in logBox.values) {
          if (l.medicineId == medicineId &&
              l.scheduledTime.year == normalizedTake.year &&
              l.scheduledTime.month == normalizedTake.month &&
              l.scheduledTime.day == normalizedTake.day &&
              l.scheduledTime.hour == normalizedTake.hour &&
              l.scheduledTime.minute == normalizedTake.minute) {
            existingLog = l;
            break;
          }
        }

        if (existingLog != null) {
          if (existingLog.status == 'Taken') break; // Already taken
          if (existingLog.status == 'Skipped') {
            await logBox.delete(existingLog.logId); // Overwrite skipped
          }
        }

        final log = MedicineLogModel(
          logId:
              '${medicineId}_${normalizedTake.millisecondsSinceEpoch}_bgtake',
          medicineId: medicineId,
          scheduledTime: normalizedTake,
          actualTime: DateTime.now(),
          status: 'Taken',
        );
        await logBox.put(log.logId, log);

        // Decrement stock
        MedicineModel? medTake;
        for (final m in medBox.values) {
          if (m.medicineId == medicineId) { medTake = m; break; }
        }
        if (medTake != null && medTake.stock > 0) {
          medTake.stock--;
          await medBox.put(medTake.medicineId, medTake);
        }
        print('✅ BG: Dose marked as Taken for $medicineId');
        break;

      case 'miss':
        // Same date normalisation as 'take'.
        final nowMiss = DateTime.now();
        final normalizedMiss = DateTime(
            nowMiss.year, nowMiss.month, nowMiss.day,
            scheduledTime.hour, scheduledTime.minute);

        MedicineLogModel? existingLogMiss;
        for (var l in logBox.values) {
          if (l.medicineId == medicineId &&
              l.scheduledTime.year == normalizedMiss.year &&
              l.scheduledTime.month == normalizedMiss.month &&
              l.scheduledTime.day == normalizedMiss.day &&
              l.scheduledTime.hour == normalizedMiss.hour &&
              l.scheduledTime.minute == normalizedMiss.minute) {
            existingLogMiss = l;
            break;
          }
        }

        if (existingLogMiss != null) {
          if (existingLogMiss.status == 'Skipped') break; // Already missed
          if (existingLogMiss.status == 'Taken') {
            await logBox.delete(existingLogMiss.logId); // Overwrite taken
            // Increment stock back
            MedicineModel? medMiss;
            for (final m in medBox.values) {
              if (m.medicineId == medicineId) { medMiss = m; break; }
            }
            if (medMiss != null) {
              medMiss.stock++;
              await medBox.put(medMiss.medicineId, medMiss);
            }
          }
        }

        final logMiss = MedicineLogModel(
          logId:
              '${medicineId}_${normalizedMiss.millisecondsSinceEpoch}_bgmiss',
          medicineId: medicineId,
          scheduledTime: normalizedMiss,
          actualTime: DateTime.now(),
          status: 'Skipped',
        );
        await logBox.put(logMiss.logId, logMiss);
        print('❌ BG: Dose marked as Skipped for $medicineId');
        break;

      case 'snooze':
        // Retrieve medicine name/dosage for the follow-up notification.
        MedicineModel? med;
        for (final m in medBox.values) {
          if (m.medicineId == medicineId) {
            med = m;
            break;
          }
        }

        // Get the saved notification settings so we can use the right channel.
        final settingsBox = await Hive.openBox<NotificationSettingsModel>(
            HiveService.notificationSettingsBoxName);
        final settings = settingsBox.get('user_notification_settings') ??
            NotificationSettingsModel();

        await _scheduleSnoozeBg(
          medicineId: medicineId,
          originalTime: scheduledTime,
          name: med?.name ?? 'Medicine',
          dosage: med?.dosage ?? '',
          settings: settings,
        );
        print('⏰ BG: Snoozed for $medicineId — reminder in 10 min');
        break;

      default:
        print('⚠️ BG: Unknown action $actionId');
    }
  } catch (e, st) {
    print('❌ BG notification handler error: $e\n$st');
  }
}

/// Schedules a snooze follow-up notification from the background isolate.
Future<void> _scheduleSnoozeBg({
  required String medicineId,
  required DateTime originalTime,
  required String name,
  required String dosage,
  required NotificationSettingsModel settings,
}) async {
  // Set up timezone.
  tz_data.initializeTimeZones();
  try {
    final tzName = (await FlutterTimezone.getLocalTimezone()).toString();
    tz.setLocalLocation(tz.getLocation(tzName));
  } catch (_) {
    tz.setLocalLocation(tz.UTC);
  }

  final plugin = FlutterLocalNotificationsPlugin();
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  await plugin.initialize(
    const InitializationSettings(android: androidInit),
    onDidReceiveBackgroundNotificationResponse: _onNotificationTappedBackground,
  );

  final useShort = settings.useShortForMedicine;
  final channelId = useShort
      ? 'med_short_${settings.shortSoundName}'
      : 'med_long_${settings.longSoundName}';
  final channelName =
      useShort ? 'Medicine Reminders (Short)' : 'Medicine Reminders (Long)';
  final soundName = useShort ? settings.shortSoundName : settings.longSoundName;

  final snoozeTime = DateTime.now().add(const Duration(minutes: 10));

  // Use inexactAllowWhileIdle for background snooze — we don't have access to
  // the platform plugin here to check exact alarm permission, and inexact is
  // sufficient for a snooze (a minute or two of drift is acceptable).
  await plugin.zonedSchedule(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    '💊 $name (Snoozed)',
    'Dosage: $dosage — tap Take when ready',
    tz.TZDateTime.from(snoozeTime, tz.local),
    NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.max,
        priority: Priority.high,
        audioAttributesUsage: !useShort ? AudioAttributesUsage.alarm : AudioAttributesUsage.notification,
        additionalFlags: !useShort ? Int32List.fromList(<int>[4]) : null,
        color: const Color(0xFF6366F1),
        sound:
            RawResourceAndroidNotificationSound(soundName.replaceAll('-', '_')),
        actions: const <AndroidNotificationAction>[
          AndroidNotificationAction('take', 'Take ✅',
            showsUserInterface: true, cancelNotification: true),
          AndroidNotificationAction('snooze', 'Snooze ⏰',
            showsUserInterface: true, cancelNotification: true),
          AndroidNotificationAction('miss', 'Miss ❌',
            showsUserInterface: true, cancelNotification: true),
        ],
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    // Keep the original scheduled time as the payload reference so
    // Take/Miss logs are associated with the right dose slot.
    payload: '$medicineId|${originalTime.toIso8601String()}',
  );
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _isTestMode = false;

  // ── Pending notification from cold-start tap ─────────────────────────────
  // When the user taps the notification body while the app is still on the
  // splash screen, GetX navigation isn't ready and Get.to() silently fails.
  // We park the payload here; HomeView drains it after mounting.
  static String? _pendingMedicineId;
  static DateTime? _pendingScheduledTime;

  /// Called by HomeView once it has mounted to check for a parked payload.
  /// Returns a record with the medicine ID and scheduled time, or null.
  static ({String medicineId, DateTime scheduledTime})? consumePendingNotification() {
    final id = _pendingMedicineId;
    final time = _pendingScheduledTime;
    if (id == null || time == null) return null;
    _pendingMedicineId = null;
    _pendingScheduledTime = null;
    return (medicineId: id, scheduledTime: time);
  }

  // ── Dynamic channel IDs ──────────────────────────────────────────────────
  // Channel IDs encode the sound filename so that when the user picks a
  // different sound, a BRAND NEW Android channel is created with the new
  // sound, bypassing the OS lock on existing channel sounds.
  static const String _shortPrefix = 'med_short_';
  static const String _longPrefix = 'med_long_';

  static String _shortChannelId(NotificationSettingsModel s) =>
      '$_shortPrefix${s.shortSoundName}';
  static String _longChannelId(NotificationSettingsModel s) =>
      '$_longPrefix${s.longSoundName}';

  // ================= INIT =================

  static Future<void> init({bool isTestMode = false}) async {
    _isTestMode = isTestMode;
    if (PlatformUtils.isWeb) {
      print('🌐 Running on web - skipping native notification setup');
      return;
    }

    print('🔧 Initializing NotificationService...');
    tz_data.initializeTimeZones();
    await _setLocalTimezone();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final initResult = await _notifications.initialize(
      const InitializationSettings(android: androidSettings),
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse:
          _onNotificationTappedBackground,
    );

    print('  Notification init result: $initResult');

    // ── Migrate stale sound settings ────────────────────────────────────────
    // If the user had 'Happy Bells' saved as their long sound from a previous
    // version, reset it to 'Marimba' (the new default). This prevents a channel
    // ID mismatch that would cause the notification to fire silently.
    final savedSettings = HiveService.getNotificationSettings();
    if (savedSettings != null &&
        savedSettings.longSoundName == 'mixkit_happy_bells_notification_937') {
      final migrated = savedSettings.copyWith(
          longSoundName: 'mixkit_marimba_waiting_ringtone_1360');
      await HiveService.saveNotificationSettings(migrated);
      print('  ⚙️  Migrated long sound setting → Marimba');
    }

    if (!_isTestMode) {
      await _requestPermissions();
    }
    await _createChannels();
    print('✅ NotificationService initialized');
  }

  static Future<void> _setLocalTimezone() async {
    try {
      final String tzName =
          (await FlutterTimezone.getLocalTimezone()).toString();
      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
  }

  // ================= PERMISSIONS =================

  static Future<void> _requestPermissions() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    // Request POST_NOTIFICATIONS
    await android?.requestNotificationsPermission();
    // Request EXACT ALARMS for Android 14+ so they aren't delayed
    await android?.requestExactAlarmsPermission();
  }

  /// Returns true if the app can schedule exact alarms on this device.
  static Future<bool> _canScheduleExactAlarms() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return false;
    // canScheduleExactNotifications returns null on older APIs (pre-31),
    // where exact alarms are always allowed, so we default to true.
    return (await android.canScheduleExactNotifications()) ?? true;
  }

  // ================= CHANNELS =================

  static Future<void> _createChannels() async {
    final settings =
        HiveService.getNotificationSettings() ?? NotificationSettingsModel();

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // Short-sound channel — ID is unique per sound file name
    await androidPlugin?.createNotificationChannel(AndroidNotificationChannel(
      _shortChannelId(settings),
      'Medicine Reminders (Short)',
      description: 'Short medicine reminder notifications',
      importance: Importance.max,
      audioAttributesUsage: AudioAttributesUsage.notification,
      sound: RawResourceAndroidNotificationSound(
          settings.shortSoundName.replaceAll('-', '_')),
    ));

    // Long-sound channel — ID is unique per sound file name
    await androidPlugin?.createNotificationChannel(AndroidNotificationChannel(
      _longChannelId(settings),
      'Medicine Reminders (Long)',
      description: 'Long medicine reminder notifications',
      importance: Importance.max,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      sound: RawResourceAndroidNotificationSound(
          settings.longSoundName.replaceAll('-', '_')),
    ));

    // Low stock channel
    await androidPlugin?.createNotificationChannel(const AndroidNotificationChannel(
      'low_stock_channel',
      'Low Stock Alerts',
      description: 'Notifications for low medicine stock',
      importance: Importance.high,
    ));
  }

  // ================= ACTION HANDLER =================

  static void _onNotificationTapped(NotificationResponse response) {
    print('🔔 Notification tapped!');
    print('  Payload: ${response.payload}');
    print('  Action ID: ${response.actionId}');

    final payload = response.payload;
    if (payload == null) {
      print('❌ No payload found');
      return;
    }

    final parts = payload.split('|');
    if (parts.length != 2) {
      print('❌ Invalid payload format');
      return;
    }

    final medicineId = parts[0];
    final time = DateTime.parse(parts[1]);

    print('  Medicine ID: $medicineId');
    print('  Scheduled Time: $time');

    if (response.actionId != null) {
      // Capture actionId in a local variable so the closure holds a
      // definitively non-null reference. Use an async IIFE because the
      // callback must remain synchronous (void).
      final actionId = response.actionId!;
      () async {
        // Cancel the notification if we have its ID.
        if (response.id != null) {
          await _notifications.cancel(response.id!);
        }
        // Try the GetX controller path first (app is in foreground).
        // Fall back to direct-Hive write if the controller isn't available
        // (e.g. app was cold-started by the action tap).
        try {
          Get.find<MedicineController>(); // throws if not registered
          await _handleNotificationAction(actionId, medicineId, time);
        } catch (e) {
          // GetX controller not yet registered — write directly to Hive.
          print('⚠️ FG: Controller unavailable ($e), falling back to direct Hive write');
          await _handleActionDirectHive(actionId, medicineId, time);
        }
      }();
      return;
    }

    // Default tap (no action button) — open the in-app dialog.
    print('  → Attempting to open action dialog; current route: ${Get.currentRoute}');
    // Check whether the app has already navigated past the splash screen.
    // If so, we can navigate directly. If not (still on /splash or unrouted),
    // park the payload so HomeView can show the dialog once it mounts.
    final isAppReady = Get.currentRoute == '/home' ||
        Get.currentRoute.startsWith('/home') ||
        Get.isOverlaysOpen;
    if (isAppReady) {
      // App is in foreground on home — navigate directly.
      Get.to(
        () => MedicineActionDialog(
          medicineId: medicineId,
          scheduledTime: time,
        ),
        fullscreenDialog: true,
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      // App is cold-starting or still on splash — park payload for HomeView.
      print('  → App not on home yet (${Get.currentRoute}), parking payload');
      _pendingMedicineId = medicineId;
      _pendingScheduledTime = time;
    }
  }

  /// Direct-Hive fallback used when the GetX MedicineController is not yet
  /// registered (cold-start triggered by a notification action tap).
  static Future<void> _handleActionDirectHive(
      String actionId, String medicineId, DateTime scheduledTime) async {
    try {
      final logBox = Hive.box<MedicineLogModel>(HiveService.logBoxName);
      final medBox = Hive.box<MedicineModel>(HiveService.medicineBoxName);
      final now = DateTime.now();
      final normalized = DateTime(
          now.year, now.month, now.day,
          scheduledTime.hour, scheduledTime.minute);

      MedicineLogModel? existingLog;
      for (var l in logBox.values) {
        if (l.medicineId == medicineId &&
            l.scheduledTime.year == normalized.year &&
            l.scheduledTime.month == normalized.month &&
            l.scheduledTime.day == normalized.day &&
            l.scheduledTime.hour == normalized.hour &&
            l.scheduledTime.minute == normalized.minute) {
          existingLog = l;
          break;
        }
      }

      switch (actionId) {
        case 'take':
          if (existingLog != null) {
            if (existingLog.status == 'Taken') break; // Already taken
            if (existingLog.status == 'Skipped') {
              await logBox.delete(existingLog.logId); // Overwrite skipped
            }
          }
          final log = MedicineLogModel(
            logId: '${medicineId}_${normalized.millisecondsSinceEpoch}_fgtake',
            medicineId: medicineId,
            scheduledTime: normalized,
            actualTime: now,
            status: 'Taken',
          );
          await logBox.put(log.logId, log);

          MedicineModel? medTake;
          for (final m in medBox.values) {
            if (m.medicineId == medicineId) { medTake = m; break; }
          }
          if (medTake != null && medTake.stock > 0) {
            medTake.stock--;
            await medBox.put(medTake.medicineId, medTake);
          }
          print('✅ FG-Hive: Dose marked as Taken for $medicineId');
          break;

        case 'miss':
          if (existingLog != null) {
            if (existingLog.status == 'Skipped') break; // Already missed
            if (existingLog.status == 'Taken') {
              await logBox.delete(existingLog.logId); // Overwrite taken
              // Increment stock back
              MedicineModel? medMiss;
              for (final m in medBox.values) {
                if (m.medicineId == medicineId) { medMiss = m; break; }
              }
              if (medMiss != null) {
                medMiss.stock++;
                await medBox.put(medMiss.medicineId, medMiss);
              }
            }
          }
          final logMiss = MedicineLogModel(
            logId: '${medicineId}_${normalized.millisecondsSinceEpoch}_fgmiss',
            medicineId: medicineId,
            scheduledTime: normalized,
            actualTime: now,
            status: 'Skipped',
          );
          await logBox.put(logMiss.logId, logMiss);
          print('❌ FG-Hive: Dose marked as Skipped for $medicineId');
          break;
        case 'snooze':
          await snooze(medicineId, scheduledTime, 10);
          print('⏰ FG-Hive: Snoozed for $medicineId');
          break;
        default:
          print('⚠️ FG-Hive: Unknown action $actionId');
      }
    } catch (e, st) {
      print('❌ FG-Hive fallback error: $e\n$st');
    }
  }

  static Future<void> _handleNotificationAction(
      String actionId, String medicineId, DateTime scheduledTime) async {
    print('🎯 Handling action: $actionId');
    try {
      final controller = Get.find<MedicineController>();
      // Ensure controller has rehydrated its in-memory lists so a cold
      // start won't hit an empty `medicines` list.
      controller.loadMedicines();
      controller.loadLogs();
      final medicine = controller.medicines.firstWhereOrNull(
        (med) => med.medicineId == medicineId,
      );

      if (medicine == null) {
        print('❌ Medicine not found: $medicineId');
        return;
      }

      // For daily-repeating notifications the payload date is the ORIGINAL
      // schedule date, which may be weeks in the past.  Normalise to today
      // so that isTaken() and getDailyProgress() find the correct log entry.
      final now = DateTime.now();
      final normalizedTime = DateTime(
          now.year, now.month, now.day,
          scheduledTime.hour, scheduledTime.minute);

      switch (actionId) {
        case 'take':
          print('  TAKEN from notification');
          // Pass normalizedTime as both date and timeSlot so the log entry
          // is stored against today's date at the reminder's hour:minute.
          await controller.markAsTaken(medicine, normalizedTime, normalizedTime);
          Get.snackbar(
            '✓ Taken',
            '${medicine.name} marked as taken',
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade900,
            duration: const Duration(milliseconds: 1500),
          );
          break;
        case 'miss':
          print('  MISSED from notification');
          await controller.markAsSkipped(medicine, normalizedTime);
          Get.snackbar(
            '✗ Missed',
            '${medicine.name} marked as missed',
            backgroundColor: Colors.orange.shade100,
            colorText: Colors.orange.shade900,
            duration: const Duration(seconds: 2),
          );
          break;
        case 'snooze':
          print('  SNOOZED from notification');
          await snooze(medicineId, scheduledTime, 10);
          Get.snackbar(
            '⏰ Snoozed',
            'Reminding you in 10 minutes',
            backgroundColor: Colors.blue.shade100,
            colorText: Colors.blue.shade900,
            duration: const Duration(seconds: 2),
          );
          break;
        default:
          print('  ⚠️ Unknown action: $actionId');
      }
    } catch (e) {
      print('❌ Error handling notification action: $e');
    }
  }

  // ================= SCHEDULE MEDICINE =================

  static Future<void> scheduleMedicine({
    required int id,
    required String medicineId,
    required String name,
    required String dosage,
    required DateTime time,
    Repeat? repeat,
    DateTime? payloadTime,
  }) async {
    if (PlatformUtils.isWeb) {
      print('🌐 Web platform - notification scheduling not supported');
      return;
    }

    final settings =
        HiveService.getNotificationSettings() ?? NotificationSettingsModel();

    final useShort = settings.useShortForMedicine;
    final channelId =
        useShort ? _shortChannelId(settings) : _longChannelId(settings);
    final channelName =
        useShort ? 'Medicine Reminders (Short)' : 'Medicine Reminders (Long)';
    final soundName =
        useShort ? settings.shortSoundName : settings.longSoundName;

    // Use exact alarms if the permission is granted; otherwise fall back to
    // inexact (delivery may be a few minutes late but notifications WILL arrive).
    final canExact = await _canScheduleExactAlarms();
    final scheduleMode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    await _notifications.zonedSchedule(
      id,
      '💊 $name',
      'Dosage: $dosage',
      tz.TZDateTime.from(time, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.max,
          priority: Priority.high,
          audioAttributesUsage: !useShort ? AudioAttributesUsage.alarm : AudioAttributesUsage.notification,
          additionalFlags: !useShort ? Int32List.fromList(<int>[4]) : null,
          // Tints the small icon and action buttons to match the app's primary
          // Indigo 500 colour, replacing the default wine/maroon device tint.
          color: const Color(0xFF6366F1),
          // Expanded (BigText) notification — shown when the user swipes down
          // the notification card to reveal the full content.
          styleInformation: BigTextStyleInformation(
            'It\'s time to take your <b>${_escapeHtml(name)}</b>.\n'
            'Dosage: ${_escapeHtml(dosage)}\n\n'
            'Tap <i>Take</i> to confirm ✅, '
            '<i>Snooze</i> for a 10-minute reminder ⏰, '
            'or <i>Miss</i> to skip ❌.',
            htmlFormatBigText: true,
            contentTitle: '💊 Medicine Reminder',
            htmlFormatContentTitle: false,
            summaryText: 'MedCare',
            htmlFormatSummaryText: false,
          ),
          sound: RawResourceAndroidNotificationSound(
              soundName.replaceAll('-', '_')),
          actions: <AndroidNotificationAction>[
            // showsUserInterface: true — brings the app to the foreground so
            // the action is processed by the reliable _onNotificationTapped
            // handler (which has full access to GetX controllers and Hive).
            // The background handler remains as a safety net for killed-app state.
              const AndroidNotificationAction('take', 'Take ✅',
                showsUserInterface: true, cancelNotification: true),
              const AndroidNotificationAction('snooze', 'Snooze ⏰',
                showsUserInterface: true, cancelNotification: true),
              const AndroidNotificationAction('miss', 'Miss ❌',
                showsUserInterface: true, cancelNotification: true),
          ],
        ),
      ),
      androidScheduleMode: scheduleMode,
      matchDateTimeComponents: repeat == Repeat.daily
          ? DateTimeComponents.time
          : repeat == Repeat.weekly
              ? DateTimeComponents.dayOfWeekAndTime
              : null,
      payload: '$medicineId|${(payloadTime ?? time).toIso8601String()}',
    );
  }

  // ================= GENERIC NOTIFICATION (Appointments etc.) =================

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    bool useShortSound = false,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    if (PlatformUtils.isWeb) {
      print('🌐 Web platform - notification scheduling not supported');
      return;
    }

    final settings =
        HiveService.getNotificationSettings() ?? NotificationSettingsModel();

    final channelId =
        useShortSound ? _shortChannelId(settings) : _longChannelId(settings);
    final channelName = useShortSound
        ? 'Medicine Reminders (Short)'
        : 'Medicine Reminders (Long)';
    final soundName =
        useShortSound ? settings.shortSoundName : settings.longSoundName;

    final canExact = await _canScheduleExactAlarms();
    final scheduleMode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.max,
          priority: Priority.high,
          audioAttributesUsage: !useShortSound ? AudioAttributesUsage.alarm : AudioAttributesUsage.notification,
          additionalFlags: !useShortSound ? Int32List.fromList(<int>[4]) : null,
          sound: RawResourceAndroidNotificationSound(
              soundName.replaceAll('-', '_')),
        ),
      ),
      androidScheduleMode: scheduleMode,
      matchDateTimeComponents: matchDateTimeComponents,
    );
  }

  // ================= ALERTS =================

  static Future<void> showLowStockNotification(dynamic medicine) async {
    if (PlatformUtils.isWeb) return;

    final id = medicine.medicineId.hashCode ^ 9999;
    
    await _notifications.show(
      id,
      'Low Stock Alert: ${medicine.name}',
      'You only have ${medicine.stock} left. Please restock soon.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'low_stock_channel',
          'Low Stock Alerts',
          importance: Importance.high,
          priority: Priority.high,
          color: Color(0xFFE53935), // Urgent Red Color
        ),
      ),
    );
  }

  // ================= SNOOZE =================

  static Future<void> snooze(
      String medicineId, DateTime original, int minutes) async {
    final snoozeTime = DateTime.now().add(Duration(minutes: minutes));
    await scheduleMedicine(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000 & 0x7FFFFFFF,
      medicineId: medicineId,
      name: 'Medicine Reminder',
      dosage: 'Snoozed — please take it now',
      time: snoozeTime,
      payloadTime: original,
    );
  }

  // ================= CANCEL =================

  static Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  // ================= HELPERS =================

  /// Escapes HTML special characters so user-entered medicine names / dosages
  /// are safe to embed inside HTML-formatted notification text.
  static String _escapeHtml(String text) => text
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;');
}

// ================= ENUM =================

enum Repeat { none, daily, weekly }
