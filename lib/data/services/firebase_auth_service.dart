// lib/data/services/firebase_auth_service.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static const Duration _timeout = Duration(seconds: 30);

  // Helper for Exception Handling
  String _handleException(dynamic e) {
    if (e is TimeoutException) {
      return 'Connection timed out. Check your internet and try again.';
    }
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use': return 'Email is already registered.';
        case 'invalid-email': return 'Invalid email format.';
        case 'weak-password': return 'Password is too weak.';
        case 'user-not-found': return 'No user found with this email.';
        case 'wrong-password': return 'Incorrect password.';
        case 'requires-recent-login': return 'Please re-login to change password.';
        case 'network-request-failed': return 'Network error. Check your connection and try again.';
        default: return e.message ?? 'An unknown error occurred.';
      }
    }
    return e.toString();
  }

  // UPDATED: Now accepts 'name' to satisfy SRS-1
  Future<User?> signUp(String email, String password, String name) async {
    try {
      UserCredential result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(_timeout);

      // Immediately update the profile name
      if (result.user != null) {
        await result.user!.updateDisplayName(name).timeout(_timeout);
        await result.user!.reload().timeout(_timeout);
      }
      return _auth.currentUser;
    } catch (e) {
      throw _handleException(e);
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(_timeout);
      return result.user;
    } catch (e) {
      throw _handleException(e);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email).timeout(_timeout);
    } catch (e) {
      throw _handleException(e);
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw 'User not logged in';

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred).timeout(_timeout);
      await user.updatePassword(newPassword).timeout(_timeout);
    } catch (e) {
      throw _handleException(e);
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Google Sign-In shows UI and waits for user interaction — no timeout here.
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // Token retrieval is a local/fast operation — no timeout needed.
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Only the Firebase network call needs a timeout.
      UserCredential result =
          await _auth.signInWithCredential(credential).timeout(_timeout);
      return result.user;
    } catch (e) {
      throw _handleException(e);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}