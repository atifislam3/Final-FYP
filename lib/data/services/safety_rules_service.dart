// lib/data/services/safety_rules_service.dart
//
// UC-41 / SRS-133 / SRS-134 — Apply Safety Filters & Rules
//
// This service keeps the client-side safety keyword list in sync with the
// Firebase Realtime Database so developers can push rule updates without
// requiring users to update the app (SRS-134).
//
// Firebase Realtime Database structure:
// {
//   "chat_safety_rules": {
//     "blocked_keywords": [
//       "suicide", "suicidal", "self harm", "self-harm", "selfharm",
//       "kill myself", "hurt myself", "end my life", "take my life",
//       "want to die", "harm myself", "cut myself",
//       "overdose on purpose", "intentional overdose", "how to overdose"
//     ]
//   }
// }
//
// To update the rules: edit the list in the Firebase Console at the path
// above. All running app instances pick up the change on the next message.

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class SafetyRulesService {
  static const String _rulesPath = 'chat_safety_rules/blocked_keywords';

  // Hardcoded defaults — applied when Firebase is unreachable (SRS-133
  // ensures blocking always works even in offline scenarios).
  static const List<String> _defaultBlockedKeywords = [
    'suicide',
    'suicidal',
    'self harm',
    'self-harm',
    'selfharm',
    'kill myself',
    'hurt myself',
    'end my life',
    'take my life',
    'want to die',
    'harm myself',
    'cut myself',
    'overdose on purpose',
    'intentional overdose',
    'how to overdose',
  ];

  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  List<String> _blockedKeywords = List.from(_defaultBlockedKeywords);
  StreamSubscription<DatabaseEvent>? _subscription;

  // ── Public API ────────────────────────────────────────────────────────────

  /// Starts a real-time listener on the Firebase rules node.
  /// The in-memory keyword list is updated automatically whenever a developer
  /// pushes a change to the backend (SRS-134).
  void startListening() {
    _subscription = _db.child(_rulesPath).onValue.listen(
      (event) {
        if (!event.snapshot.exists || event.snapshot.value == null) return;
        final fetched = _parseKeywords(event.snapshot.value);
        if (fetched.isNotEmpty) {
          // Store keywords pre-lowercased to avoid repeated string transforms
          // on each call to isBlocked() (hot path).
          _blockedKeywords = fetched.map((kw) => kw.toLowerCase()).toList();
          debugPrint(
              '[SafetyRulesService] Rules updated: ${_blockedKeywords.length} keywords.');
        }
      },
      onError: (Object e) {
        debugPrint(
            '[SafetyRulesService] Listener error, keeping cached rules: $e');
      },
    );
  }

  /// Cancels the Firebase listener. Call from the owning controller's
  /// [onClose].
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Returns `true` when [message] matches at least one blocked keyword/phrase.
  /// Keywords are stored pre-lowercased so only the input needs transforming.
  bool isBlocked(String message) {
    final lower = message.toLowerCase();
    return _blockedKeywords.any((kw) => lower.contains(kw));
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Parses the raw Firebase snapshot value into a `List<String>`.
  /// Firebase Realtime Database can return a JSON array as either a
  /// Dart [List] or a [Map] with integer keys — handle both.
  List<String> _parseKeywords(Object? raw) {
    if (raw is List) {
      final result = raw.whereType<String>().toList();
      final skipped = raw.length - result.length;
      if (skipped > 0) {
        debugPrint(
            '[SafetyRulesService] Warning: $skipped non-string value(s) '
            'ignored in blocked_keywords — check Firebase configuration.');
      }
      return result;
    }
    if (raw is Map) {
      final result = raw.values.whereType<String>().toList();
      final skipped = raw.length - result.length;
      if (skipped > 0) {
        debugPrint(
            '[SafetyRulesService] Warning: $skipped non-string value(s) '
            'ignored in blocked_keywords — check Firebase configuration.');
      }
      return result;
    }
    debugPrint(
        '[SafetyRulesService] Warning: unexpected data type ${raw.runtimeType} '
        'for blocked_keywords — check Firebase configuration.');
    return [];
  }
}
