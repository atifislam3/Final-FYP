// lib/data/services/realtime_database_service.dart
import 'dart:convert';
import '../models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseService {
  // Get reference to the database root
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<void> saveUser(UserModel user) async {
    try {
      // In Realtime DB, we access path like: users/uid
      await _db.child('users').child(user.uid).set(user.toMap());
    } catch (e) {
      throw 'Error saving profile: $e';
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final snapshot = await _db.child('users').child(uid).get();

      if (snapshot.exists && snapshot.value != null) {
        final val = snapshot.value;

        // Strictly check if the data is a Map (a proper JSON tree).
        if (val is Map) {
          // Convert safely without forced dynamic casting
          final data = Map<String, dynamic>.from(val);
          return UserModel.fromMap(data);
        } else {
          // If the data is a String or anything else, it is corrupted.
          // Return null to tell the AuthController to create a fresh profile.
          return null;
        }
      }
      return null;
    } catch (e) {
      // Catch the exact exception thrown by Firebase SDK when it fails to 
      // parse a corrupted string node back into a Map internally.
      if (e.toString().contains("type 'String' is not a subtype of type 'Map<dynamic, dynamic>'")) {
        return null; // Return null so the app creates a new valid profile to overwrite it.
      }
      
      throw 'Error fetching profile: $e';
    }
  }
}
