import 'package:flutter/foundation.dart' show kIsWeb;

/// Platform detection utilities for cross-platform compatibility
class PlatformUtils {
  /// Returns true if running on web (Chrome, Firefox, Safari, etc.)
  static bool get isWeb => kIsWeb;

  /// Returns true if running on mobile platforms (Android, iOS)
  static bool get isMobile => !kIsWeb;

  /// Returns true if the platform supports custom notification sounds
  /// Currently only Android supports custom notification sounds
  static bool get supportsCustomNotifications => !kIsWeb;

  /// Returns true if the platform supports exact alarm scheduling
  static bool get supportsExactAlarms => !kIsWeb;

  /// Returns true if the platform supports timezone-based scheduling
  static bool get supportsTimezoneScheduling => !kIsWeb;

  /// Returns a user-friendly platform name
  static String get platformName => kIsWeb ? 'Web' : 'Mobile';
}
