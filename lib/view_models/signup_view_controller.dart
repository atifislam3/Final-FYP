import 'package:get/get.dart';

/// Lightweight GetX controller that manages local UI state for [SignUpView].
/// Registered with Get.put() inside the view so it persists across rebuilds.
class SignupViewController extends GetxController {
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirm = true.obs;
  final RxString passwordStrength = ''.obs;

  static final _uppercaseRegex = RegExp(r'[A-Z]');
  static final _digitRegex = RegExp(r'[0-9]');

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmVisibility() {
    obscureConfirm.value = !obscureConfirm.value;
  }

  void updatePasswordStrength(String password) {
    if (password.isEmpty) {
      passwordStrength.value = '';
    } else if (password.length < 8) {
      passwordStrength.value = 'weak';
    } else if (!password.contains(_uppercaseRegex) ||
        !password.contains(_digitRegex)) {
      passwordStrength.value = 'medium';
    } else {
      passwordStrength.value = 'strong';
    }
  }
}
