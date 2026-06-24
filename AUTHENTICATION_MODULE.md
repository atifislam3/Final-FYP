### 1.1.1 Authentication (Business Logic / AuthViewModel)

The following `AuthController` encapsulates the complete business logic for the Authentication module. It handles secure user registration, session verification, OAuth 2.0 Google Sign-In, and password recovery, coordinating between the Firebase backend and the local Hive offline storage.

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/firebase_auth_service.dart';
import '../data/services/hive_service.dart';
import '../data/services/realtime_database_service.dart';
import '../data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final RealtimeDatabaseService _dbService = RealtimeDatabaseService();
  var isLoading = false.obs;

  // ===================== PASSWORD VALIDATION =====================
  // Enforces security policy: Min 8 chars, 1 Uppercase & 1 Number
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 8) return "Min 8 characters required";
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).*$').hasMatch(value)) {
      return "Must have 1 Uppercase & 1 Number";
    }
    return null;
  }

  // ===================== SIGN IN (REGISTER) =====================
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match", backgroundColor: Colors.red);
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.signUp(email, password, name);
      if (user != null) {
        // Enforce Email Verification Requirement
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }
        // Redirect to Login to prevent unverified access
        Get.offAllNamed('/login');
        Get.snackbar("Success", "Account created! Verification link sent.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =========================== LOGIN ===========================
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final user = await _authService.login(email, password);
      if (user != null) {
        await user.reload();
        
        // Reject login if email remains unverified
        if (!user.emailVerified) {
          Get.snackbar("Verification Required", "Please verify your email first.");
          return;
        }

        // Generate Local Offline Session
        await HiveService.saveUserSession(user.uid);
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ======================= SOCIAL LOGIN ========================
  Future<void> googleLogin() async {
    isLoading.value = true;
    try {
      final user = await _authService.signInWithGoogle();

      if (user != null) {
        await HiveService.saveUserSession(user.uid);
        final existingUser = await _dbService.getUser(user.uid);

        if (existingUser == null) {
          // Profile does not exist -> Generate new compliant Profile Entity
          UserModel newUser = UserModel(
            uid: user.uid,
            email: user.email ?? '',
            fullName: user.displayName ?? 'Google User',
            photoUrl: user.photoURL,
          );
          // Sync Cloud & Local Storage
          await _dbService.saveUser(newUser);
          await HiveService.saveUserProfile(newUser.toHiveMap());
        } else {
          // Profile exists -> Sync existing data
          await HiveService.saveUserProfile(existingUser.toHiveMap());
        }
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ====================== FORGET PASSWORD ======================
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }
    isLoading.value = true;
    try {
      await _authService.sendPasswordResetEmail(email);
      Get.back();
      Get.snackbar("Email Sent", "Check your inbox for reset link");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ====================== CHANGE PASSWORD ======================
  Future<void> updatePassword(
      String currentPass, String newPass, String confirmPass) async {
    if (newPass != confirmPass) {
      Get.snackbar("Error", "New passwords do not match");
      return;
    }
    String? error = validatePassword(newPass);
    if (error != null) {
      Get.snackbar("Weak Password", error);
      return;
    }

    isLoading.value = true;
    try {
      await _authService.changePassword(currentPass, newPass);
      Get.back();
      Get.snackbar("Success", "Password updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =========================== LOGOUT ==========================
  Future<void> logout() async {
    // Terminate Cloud Session
    await FirebaseAuth.instance.signOut();
    // Wipe Secure Local Tokens
    await HiveService.clearSession();
    // Redirect to Auth Gateway
    Get.offAllNamed('/login');
  }
}
```
