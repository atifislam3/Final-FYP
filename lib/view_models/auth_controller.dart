import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/firebase_auth_service.dart';
import '../data/services/hive_service.dart';
import '../data/services/realtime_database_service.dart';
import '../data/models/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final RealtimeDatabaseService _dbService = RealtimeDatabaseService();
  var isLoading = false.obs;
  // FIX 1: Actual Password Validation Logic (SRS-3, SRS-21)
  // This was returning "null" before, effectively disabling validation.
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 8) return "Min 8 characters required";
    // Regex for 1 Uppercase & 1 Number
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).*$').hasMatch(value)) {
      return "Must have 1 Uppercase & 1 Number";
    }
    return null;
  }

  // Sign Up Logic
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // SRS-22: Confirm Password Match (Double check in controller)
    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.signUp(email, password, name);

      if (user != null) {
        // FIX 2: Send Verification Email (SRS-5)
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }

        // Note: We DO NOT save the session here because the user must login first.
        // SRS-7: Redirect to Login Screen, NOT Profile
        Get.offAllNamed('/login');

        Get.snackbar(
            "Success", "Account created! Verification link sent to $email",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 5));
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Login Logic
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final user = await _authService.login(email, password);

      if (user != null) {
        await user.reload();
        if (!user.emailVerified) {
          Get.snackbar("Email Verification Required",
              "Please verify your email first. Check your inbox.",
              backgroundColor: Colors.orange,
              colorText: Colors.white,
              duration: const Duration(seconds: 5));
          return;
        }

        await HiveService.saveUserSession(user.uid);
        Get.offAllNamed('/home'); // Correct navigation after login
        Get.snackbar("Welcome Back", "Login Successful",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Login Failed", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Google Login
  Future<void> googleLogin() async {
    isLoading.value = true;
    try {
      // 1. Trigger Google Sign In Flow
      final user = await _authService.signInWithGoogle();

      if (user != null) {
        // 2. Save Session Locally
        await HiveService.saveUserSession(user.uid);

        // 3. SRS-27: Check if User Profile exists in Database
        final existingUser = await _dbService.getUser(user.uid);

        if (existingUser == null) {
          // PROFILE DOES NOT EXIST -> Create it now (SRS-27)
          UserModel newUser = UserModel(
            uid: user.uid,
            email: user.email ?? '',
            fullName: user.displayName ?? 'Google User',
            photoUrl: user.photoURL,
            // Initialize other fields as null/empty for now
          );

          // Save to Firebase Realtime DB
          await _dbService.saveUser(newUser);

          // Save to Hive for Offline Access
          await HiveService.saveUserProfile(newUser.toHiveMap());
        } else {
          // PROFILE EXISTS -> Just sync it to Hive
          await HiveService.saveUserProfile(existingUser.toHiveMap());
        }

        // 4. Redirect to Home (SRS-29)
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar("Google Sign-In Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot Password
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    isLoading.value = true;
    try {
      await _authService.sendPasswordResetEmail(email);
      Get.back();
      Get.snackbar("Email Sent", "Check your inbox for reset link",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Change Password
  Future<void> updatePassword(
      String currentPass, String newPass, String confirmPass) async {
    if (newPass != confirmPass) {
      Get.snackbar("Error", "New passwords do not match",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    // Re-use the validation logic
    String? error = validatePassword(newPass);
    if (error != null) {
      Get.snackbar("Weak Password", error,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      await _authService.changePassword(currentPass, newPass);
      Get.back();
      Get.snackbar("Success", "Password updated successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
