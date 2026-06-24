import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/firebase_auth_service.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView>
    with TickerProviderStateMixin {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();

  final currentPassCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  bool isLoading = false;
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  Brightness _b = Brightness.dark;

  late AnimationController _bgCtrl;
  late AnimationController _entryCtrl;
  late Animation<double> _badgeAnim;
  late Animation<double> _titleAnim;
  late Animation<double> _infoCardAnim;
  late Animation<double> _field1Anim;
  late Animation<double> _field2Anim;
  late Animation<double> _field3Anim;
  late Animation<double> _btnAnim;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _badgeAnim = _buildAnim(0.00, 0.40);
    _titleAnim = _buildAnim(0.15, 0.50);
    _infoCardAnim = _buildAnim(0.28, 0.62);
    _field1Anim = _buildAnim(0.38, 0.72);
    _field2Anim = _buildAnim(0.48, 0.80);
    _field3Anim = _buildAnim(0.56, 0.88);
    _btnAnim = _buildAnim(0.65, 1.00);
  }

  Animation<double> _buildAnim(double start, double end) => CurvedAnimation(
        parent: _entryCtrl,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      );

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entryCtrl.dispose();
    currentPassCtrl.dispose();
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  void _changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      await _authService.changePassword(
        currentPassCtrl.text.trim(),
        newPassCtrl.text.trim(),
      );
      Get.back();
      Get.snackbar(
        "Success",
        "Password changed successfully",
        backgroundColor: const Color(0xFF34D399),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: const Color(0xFFF87171),
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  String? _validateNewPass(String? value) {
    if (value == null || value.length < 8) return "Minimum 8 characters required";
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).*$').hasMatch(value)) {
      return "Must contain 1 uppercase & 1 number";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    _b = b;
    return Scaffold(
      backgroundColor: AppThemeColors.scaffoldBg(b),
      body: AnimatedBuilder(
        animation: _bgCtrl,
        builder: (_, __) => Stack(
          children: [
            // Gradient background
            Container(decoration: AppThemeColors.backgroundDecoration(b)),
            // Animated orbs
            CustomPaint(
              painter: OrbPainter(t: _bgCtrl.value, alphaMultiplier: AppThemeColors.orbAlpha(b)),
              child: const SizedBox.expand(),
            ),
            // Content
            SafeArea(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // AppBar
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: AppThemeColors.primaryText(_b)),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Change Password",
            style: TextStyle(
              color: AppThemeColors.primaryText(_b),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // Lock badge
                  _Fade(anim: _badgeAnim, child: _buildLockBadge()),
                  const SizedBox(height: 24),

                  // Title & subtitle
                  _Fade(
                    anim: _titleAnim,
                    child: Column(
                      children: [
                        Text(
                          "Update Your Password",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppThemeColors.primaryText(_b),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Keep your MedCare account secure with a strong password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppThemeColors.secondaryText(_b),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Requirements card
                  _Fade(anim: _infoCardAnim, child: _buildRequirementsCard()),
                  const SizedBox(height: 28),

                  // Current password
                  _Fade(
                    anim: _field1Anim,
                    child: _buildGlassField(
                      controller: currentPassCtrl,
                      label: "Current Password",
                      hint: "Enter your current password",
                      icon: Icons.lock_outline_rounded,
                      obscure: !_showCurrent,
                      onToggle: () => setState(() => _showCurrent = !_showCurrent),
                      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // New password
                  _Fade(
                    anim: _field2Anim,
                    child: _buildGlassField(
                      controller: newPassCtrl,
                      label: "New Password",
                      hint: "Create a strong password",
                      icon: Icons.lock_reset_rounded,
                      obscure: !_showNew,
                      onToggle: () => setState(() => _showNew = !_showNew),
                      validator: _validateNewPass,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Confirm password
                  _Fade(
                    anim: _field3Anim,
                    child: _buildGlassField(
                      controller: confirmPassCtrl,
                      label: "Confirm New Password",
                      hint: "Re-enter your new password",
                      icon: Icons.verified_user_rounded,
                      obscure: !_showConfirm,
                      onToggle: () => setState(() => _showConfirm = !_showConfirm),
                      validator: (v) {
                        if (v != newPassCtrl.text) return "Passwords do not match";
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Update button
                  _Fade(anim: _btnAnim, child: _buildUpdateButton()),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLockBadge() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.elasticOut,
      builder: (_, v, child) => Transform.scale(scale: v, child: child),
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF4F46E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.45),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(Icons.lock_reset_rounded, size: 46, color: Colors.white),
      ),
    );
  }

  Widget _buildRequirementsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(_b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppThemeColors.glassBorder(_b),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3730A3).withValues(alpha: 0.20),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF818CF8).withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.info_outline_rounded,
                color: Color(0xFFC7D2FE), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PASSWORD REQUIREMENTS",
                  style: TextStyle(
                    color: Color(0xFFC7D2FE),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                _reqRow("Minimum 8 characters"),
                _reqRow("At least 1 uppercase letter"),
                _reqRow("At least 1 number"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reqRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              size: 14, color: Color(0xFF818CF8)),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: AppThemeColors.secondaryText(_b),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: TextStyle(color: AppThemeColors.primaryText(_b), fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: AppThemeColors.secondaryText(_b)),
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35)),
        prefixIcon: Icon(icon, color: AppThemeColors.secondaryText(_b)),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: AppThemeColors.secondaryText(_b),
            size: 20,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: AppThemeColors.glassBg(_b),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.20)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: Color(0xFFC7D2FE), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFCA5A5)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: Color(0xFFFCA5A5), width: 1.8),
        ),
        errorStyle: const TextStyle(color: Color(0xFFFCA5A5)),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Container(
      height: 52,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF4F46E5)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.40),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : _changePassword,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "UPDATE PASSWORD",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Fade + slide-up entrance helper
class _Fade extends StatelessWidget {
  final Animation<double> anim;
  final Widget child;
  const _Fade({required this.anim, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, (1 - anim.value) * 20),
          child: child,
        ),
      ),
    );
  }
}
