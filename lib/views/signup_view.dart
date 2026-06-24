import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/auth_controller.dart';
import '../view_models/signup_view_controller.dart';

// ─────────────────────────────────────────────────────────────
// MedCare Premium Sign-Up Screen
// Matches login_view premium glassmorphism style
// ─────────────────────────────────────────────────────────────

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final AnimationController _cardCtrl;
  late final Animation<double> _bgFloat;
  late final Animation<double> _cardOpacity;
  late final Animation<Offset> _cardSlide;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _cardCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _bgFloat = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);

    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardCtrl,
          curve: const Interval(0, 0.6, curve: Curves.easeOut)),
    );
    _cardSlide = Tween<Offset>(
        begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutCubic),
    );

    _cardCtrl.forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _cardCtrl.dispose();
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authCtrl = Get.find<AuthController>();
    final SignupViewController uiCtrl = Get.put(SignupViewController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _bgFloat,
            builder: (_, __) =>
                _SignupBg(t: _bgFloat.value, size: size),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.12),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: const Icon(Icons.arrow_back_rounded,
                              color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                    child: AnimatedBuilder(
                      animation: _cardCtrl,
                      builder: (_, child) => Opacity(
                        opacity: _cardOpacity.value,
                        child: SlideTransition(
                            position: _cardSlide, child: child),
                      ),
                      child: _buildCard(authCtrl, uiCtrl),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      AuthController authCtrl, SignupViewController uiCtrl) {
    return Column(
      children: [
        // Avatar icon
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (_, v, child) =>
              Transform.scale(scale: v, child: child),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFE0E7FF), Color(0xFFC7D2FE)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF818CF8).withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.person_add_rounded,
              size: 36,
              color: Color(0xFF3730A3),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Glass card
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3730A3).withValues(alpha: 0.25),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Join MedCare',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your health journey starts here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 28),

                // Full Name
                _GlassField(
                  controller: nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  icon: Icons.person_rounded,
                  validator: (v) => (v?.isEmpty ?? true)
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 14),

                // Email
                _GlassField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  icon: Icons.email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                  !GetUtils.isEmail(v ?? '')
                      ? 'Invalid email'
                      : null,
                ),
                const SizedBox(height: 14),

                // Password
                Obx(() => _GlassField(
                  controller: passController,
                  label: 'Password',
                  hint: 'Min 8 chars, 1 uppercase, 1 number',
                  icon: Icons.lock_rounded,
                  obscureText: uiCtrl.obscurePassword.value,
                  onChanged: uiCtrl.updatePasswordStrength,
                  validator: authCtrl.validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      uiCtrl.obscurePassword.value
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.white60,
                      size: 20,
                    ),
                    onPressed: uiCtrl.togglePasswordVisibility,
                  ),
                )),
                const SizedBox(height: 10),

                // Password strength (reactive via controller)
                Obx(() {
                  final strength = uiCtrl.passwordStrength.value;
                  if (strength.isEmpty) return const SizedBox.shrink();
                  final (double val, Color col, String lbl) = switch (strength) {
                    'weak'   => (0.25, const Color(0xFFF87171), 'Weak'),
                    'medium' => (0.60, const Color(0xFFFBBF24), 'Medium'),
                    _        => (1.00, const Color(0xFF34D399),  'Strong'),
                  };
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: val,
                          minHeight: 4,
                          backgroundColor:
                          Colors.white.withValues(alpha: 0.12),
                          valueColor: AlwaysStoppedAnimation<Color>(col),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lbl,
                        style: TextStyle(
                          color: col,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 14),

                // Confirm password
                Obx(() => _GlassField(
                  controller: confirmPassController,
                  label: 'Confirm Password',
                  hint: 'Re-enter password',
                  icon: Icons.lock_outline_rounded,
                  obscureText: uiCtrl.obscureConfirm.value,
                  validator: (v) => v != passController.text
                      ? 'Passwords do not match'
                      : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      uiCtrl.obscureConfirm.value
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.white60,
                      size: 20,
                    ),
                    onPressed: uiCtrl.toggleConfirmVisibility,
                  ),
                )),

                const SizedBox(height: 24),

                // Sign up button
                Obx(() => _PrimaryButton(
                  label: 'CREATE ACCOUNT',
                  icon: Icons.person_add_rounded,
                  isLoading: authCtrl.isLoading.value,
                  onPressed: authCtrl.isLoading.value
                      ? null
                      : () {
                    if (formKey.currentState!.validate()) {
                      authCtrl.signUp(
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        password: passController.text.trim(),
                        confirmPassword: confirmPassController.text.trim(),
                      );
                    }
                  },
                )),

                const SizedBox(height: 20),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                          color:
                          Colors.white.withValues(alpha: 0.2)),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                          color:
                          Colors.white.withValues(alpha: 0.2)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Google button
                _GoogleButton(
                  onPressed: () => authCtrl.googleLogin(),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Login link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.60),
                fontSize: 14,
              ),
            ),
            GestureDetector(
              onTap: () => Get.back(),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  }


// ── Signup Background ────────────────────────────────────────
class _SignupBg extends StatelessWidget {
  final double t;
  final Size size;
  const _SignupBg({required this.t, required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF1E0A3C),
                Color(0xFF4C1D95),
                Color(0xFF312E81),
                Color(0xFF1E1B4B),
              ],
              stops: [0.0, 0.35, 0.65, 1.0],
            ),
          ),
        ),
        CustomPaint(painter: _SignupOrbPainter(t: t)),
      ],
    );
  }
}

class _SignupOrbPainter extends CustomPainter {
  final double t;
  _SignupOrbPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    void orb(double cx, double cy, double r, Color c, double a) {
      final p = Paint()
        ..shader = RadialGradient(
          colors: [c.withValues(alpha: a), c.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
      canvas.drawCircle(Offset(cx, cy), r, p);
    }

    final dy = math.sin(t * math.pi) * 20;
    orb(size.width * 0.9, size.height * 0.12 + dy, 130,
        const Color(0xFF818CF8), 0.28);
    orb(size.width * 0.1, size.height * 0.35 - dy, 100,
        const Color(0xFFA78BFA), 0.22);
    orb(size.width * 0.55, size.height * 0.9 + dy * 0.5, 150,
        const Color(0xFF6366F1), 0.20);
  }

  @override
  bool shouldRepaint(_SignupOrbPainter old) => old.t != t;
}

// ── Shared Glass Field ───────────────────────────────────────
class _GlassField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;

  const _GlassField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle:
        TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 13),
        hintStyle:
        TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 14),
        prefixIcon:
        Icon(icon, color: Colors.white.withValues(alpha: 0.70), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.09),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
          BorderSide(color: Colors.white.withValues(alpha: 0.20)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
          BorderSide(color: Colors.white.withValues(alpha: 0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
          const BorderSide(color: Color(0xFFC7D2FE), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFF87171)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
          const BorderSide(color: Color(0xFFF87171), width: 1.8),
        ),
        errorStyle:
        const TextStyle(color: Color(0xFFFCA5A5), fontSize: 12),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

// ── Primary Button ───────────────────────────────────────────
class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF4F46E5)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.45),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: isLoading
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2.5),
            )
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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

// ── Google Button ────────────────────────────────────────────
class _GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _GoogleButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.10),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.22), width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: const Center(
                  child: Text(
                    'G',
                    style: TextStyle(
                      color: Color(0xFF4285F4),
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Continue with Google',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
