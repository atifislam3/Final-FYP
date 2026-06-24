import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/auth_controller.dart';

// ─────────────────────────────────────────────────────────────
// MedCare Premium Forgot Password Screen
// Matches the login/signup glassmorphism aesthetic
// ─────────────────────────────────────────────────────────────

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final AnimationController _cardCtrl;
  late final Animation<double> _bgFloat;
  late final Animation<double> _cardOpacity;
  late final Animation<Offset> _cardSlide;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _cardCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _bgFloat = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);

    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardCtrl,
          curve: const Interval(0, 0.6, curve: Curves.easeOut)),
    );
    _cardSlide = Tween<Offset>(
        begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutCubic),
    );

    _cardCtrl.forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _cardCtrl.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _bgFloat,
            builder: (_, __) => _ForgotBg(t: _bgFloat.value, size: size),
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
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: AnimatedBuilder(
                        animation: _cardCtrl,
                        builder: (_, child) => Opacity(
                          opacity: _cardOpacity.value,
                          child: SlideTransition(
                              position: _cardSlide, child: child!),
                        ),
                        child: _buildContent(authController),
                      ),
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

  Widget _buildContent(AuthController authController) {
    return Column(
      children: [
        // Lock icon
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 900),
          curve: Curves.elasticOut,
          builder: (_, v, child) => Transform.scale(scale: v, child: child),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFE0E7FF), Color(0xFFC7D2FE)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF818CF8).withValues(alpha: 0.5),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              size: 40,
              color: Color(0xFF3730A3),
            ),
          ),
        ),

        const SizedBox(height: 28),

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
          padding: const EdgeInsets.all(28),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Reset Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "No worries! Enter your email and we'll send a reset link.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.60),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Email field
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                  !GetUtils.isEmail(v ?? '') ? 'Invalid email' : null,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Enter your registered email',
                    labelStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 13),
                    hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.35),
                        fontSize: 14),
                    prefixIcon: Icon(Icons.email_rounded,
                        color: Colors.white.withValues(alpha: 0.70), size: 20),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.09),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.20)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.18)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                          color: Color(0xFFC7D2FE), width: 1.8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                      const BorderSide(color: Color(0xFFF87171)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                          color: Color(0xFFF87171), width: 1.8),
                    ),
                    errorStyle: const TextStyle(
                        color: Color(0xFFFCA5A5), fontSize: 12),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                ),

                const SizedBox(height: 28),

                // Send button
                Obx(() => Container(
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF818CF8),
                        Color(0xFF6366F1),
                        Color(0xFF4F46E5)
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1)
                            .withValues(alpha: 0.45),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: authController.isLoading.value
                          ? null
                          : () {
                        if (formKey.currentState!.validate()) {
                          authController.resetPassword(
                            emailController.text.trim(),
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: authController.isLoading.value
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                            : const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.send_rounded,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'SEND RESET LINK',
                              style: TextStyle(
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
                )),

                const SizedBox(height: 20),

                // Back link
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back_rounded,
                          size: 16,
                          color: Colors.white.withValues(alpha: 0.70)),
                      const SizedBox(width: 6),
                      Text(
                        'Back to Sign In',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.80),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Background ───────────────────────────────────────────────
class _ForgotBg extends StatelessWidget {
  final double t;
  final Size size;
  const _ForgotBg({required this.t, required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1E0A3C),
                Color(0xFF312E81),
                Color(0xFF3730A3),
                Color(0xFF1E1B4B),
              ],
              stops: [0, 0.3, 0.7, 1],
            ),
          ),
        ),
        CustomPaint(painter: _ForgotOrbPainter(t: t)),
      ],
    );
  }
}

class _ForgotOrbPainter extends CustomPainter {
  final double t;
  _ForgotOrbPainter({required this.t});

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
    orb(size.width * 0.15, size.height * 0.20 + dy, 120,
        const Color(0xFF818CF8), 0.28);
    orb(size.width * 0.85, size.height * 0.15 - dy, 100,
        const Color(0xFFA78BFA), 0.22);
    orb(size.width * 0.50, size.height * 0.85 + dy * 0.5, 140,
        const Color(0xFF6366F1), 0.20);
  }

  @override
  bool shouldRepaint(_ForgotOrbPainter old) => old.t != t;
}
