import 'package:get/get.dart';

/// Lightweight GetX controller that manages local UI state for [LoginView].
/// Registered with Get.put() inside the view so it persists across rebuilds.
class LoginViewController extends GetxController {
  final RxBool obscurePassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
}
