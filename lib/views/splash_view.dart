import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/hive_service.dart';

// ─────────────────────────────────────────────────────────────
// MedCare Premium Splash Screen
// Deep purple/indigo gradient · animated orbs · no Flutter logo
// ─────────────────────────────────────────────────────────────

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with TickerProviderStateMixin {
  // Primary entrance controller (2.8 s)
  late final AnimationController _entrance;

  // Ambient orb float controller (looping)
  late final AnimationController _float;

  // Progress bar fill controller
  late final AnimationController _progress;

  // Pulse ring for logo
  late final AnimationController _pulse;

  // Derived entrance animations
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _ringScale;
  late final Animation<double> _ringOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineOpacity;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _pillsOpacity;
  late final Animation<double> _progressOpacity;

  @override
  void initState() {
    super.initState();

    // ── Controllers ───────────────────────────────────────────
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _progress = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    // ── Entrance animations ───────────────────────────────────

    // Outer glow ring expands first
    _ringScale = Tween<double>(begin: 0.4, end: 1.1).animate(
      CurvedAnimation(
        parent: _entrance,
        curve: const Interval(0.0, 0.30, curve: Curves.easeOutExpo),
      ),
    );
    _ringOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entrance,
        curve: const Interval(0.0, 0.18, curve: Curves.easeIn),
      ),
    );

    // Logo springs in after ring
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entrance,
        curve: const Interval(0.10, 0.38, curve: Curves.elasticOut),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entrance,
        curve: const Interval(0.10, 0.22, curve: Curves.easeIn),
      ),
    );

    // App name slides up
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entrance,
        curve: const Interval(0.35, 0.55, curve: Curves.easeOut),
      ),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entrance,
        curve: const Interval(0.35, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    // Tagline slides up after name
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entrance,
        curve: const Interval(0.48, 0.65, curve: Curves.easeOut),
      ),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entrance,
        curve: const Interval(0.48, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    // Feature pills appear
    _pillsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entrance,
        curve: const Interval(0.60, 0.78, curve: Curves.easeOut),
      ),
    );

    // Progress bar fades in
    _progressOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entrance,
        curve: const Interval(0.70, 0.85, curve: Curves.easeIn),
      ),
    );

    // ── Start ─────────────────────────────────────────────────
    _entrance.forward();

    Future.delayed(
      const Duration(milliseconds: 600),
      () { if (mounted) _progress.forward(); },
    );

    // Navigate after 3.2 s total
    Future.delayed(const Duration(milliseconds: 3200), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    final isLoggedIn = HiveService.hasUser();
    Get.offAllNamed(isLoggedIn ? '/home' : '/login');
  }

  @override
  void dispose() {
    _entrance.dispose();
    _float.dispose();
    _progress.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── 1. Deep gradient background ───────────────────────
          const _GradientBg(),

          // ── 2. Ambient floating orbs ──────────────────────────
          AnimatedBuilder(
            animation: _float,
            builder: (_, __) => _AmbientOrbs(t: _float.value, size: size),
          ),

          // ── 3. Foreground content ─────────────────────────────
          SafeArea(
            child: AnimatedBuilder(
              animation: _entrance,
              builder: (_, __) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // ── Logo stack ───────────────────────────────
                  _buildLogo(),

                  const SizedBox(height: 40),

                  // ── App Name ─────────────────────────────────
                  FadeTransition(
                    opacity: _textOpacity,
                    child: SlideTransition(
                      position: _textSlide,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, Color(0xFFCDD0FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          'MedCare',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.5,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Tagline ───────────────────────────────────
                  FadeTransition(
                    opacity: _taglineOpacity,
                    child: SlideTransition(
                      position: _taglineSlide,
                      child: Text(
                        'Your Personal Health Companion',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.72),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Feature pills ─────────────────────────────
                  Opacity(
                    opacity: _pillsOpacity.value,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: const [
                        _FeaturePill(icon: Icons.notifications_active_rounded, label: 'Smart Reminders'),
                        _FeaturePill(icon: Icons.bar_chart_rounded, label: 'Analytics'),
                        _FeaturePill(icon: Icons.smart_toy_rounded, label: 'AI Assistant'),
                      ],
                    ),
                  ),

                  const Spacer(flex: 3),

                  // ── Progress bar ──────────────────────────────
                  Opacity(
                    opacity: _progressOpacity.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Column(
                        children: [
                          AnimatedBuilder(
                            animation: _progress,
                            builder: (_, __) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: _progress.value,
                                minHeight: 3,
                                backgroundColor: Colors.white.withValues(alpha: 0.15),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Initialising…',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer pulse ring
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, __) {
              final pulse = math.sin(_pulse.value * math.pi);
              return Transform.scale(
                scale: 1.0 + 0.15 * pulse,
                child: Opacity(
                  opacity: (0.35 - 0.25 * pulse).clamp(0.0, 1.0),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Inner ring entrance
          Opacity(
            opacity: _ringOpacity.value.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: _ringScale.value,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.22),
                      Colors.white.withValues(alpha: 0.04),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.5),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Icon
          Opacity(
            opacity: _logoOpacity.value.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: _logoScale.value,
              child: const _MedCareLogoIcon(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Gradient Background ──────────────────────────────────────
class _GradientBg extends StatelessWidget {
  const _GradientBg();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E0A3C), // Very deep purple
            Color(0xFF3730A3), // Indigo 700
            Color(0xFF4C1D95), // Violet 900
            Color(0xFF1E1B4B), // Indigo 950
          ],
          stops: [0.0, 0.35, 0.65, 1.0],
        ),
      ),
    );
  }
}

// ── Ambient Floating Orbs ────────────────────────────────────
class _AmbientOrbs extends StatelessWidget {
  final double t;
  final Size size;
  const _AmbientOrbs({required this.t, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OrbPainter(t: t, size: size),
    );
  }
}

class _OrbPainter extends CustomPainter {
  final double t;
  final Size size;
  _OrbPainter({required this.t, required this.size});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final w = canvasSize.width;
    final h = canvasSize.height;

    void drawOrb(double cx, double cy, double r, Color color, double alpha) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [color.withValues(alpha: alpha), color.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
      canvas.drawCircle(Offset(cx, cy), r, paint);
    }

    final dy1 = math.sin(t * math.pi) * 30;
    final dy2 = math.cos(t * math.pi) * 25;
    final dy3 = math.sin((t + 0.4) * math.pi) * 20;

    drawOrb(w * 0.15, h * 0.18 + dy1, 130, const Color(0xFF818CF8), 0.28);
    drawOrb(w * 0.85, h * 0.25 + dy2, 110, const Color(0xFFA78BFA), 0.22);
    drawOrb(w * 0.5, h * 0.82 + dy3, 150, const Color(0xFF6366F1), 0.25);
    drawOrb(w * 0.75, h * 0.72 + dy1 * 0.5, 90, const Color(0xFF7C3AED), 0.20);
    drawOrb(w * 0.2, h * 0.62 + dy2 * 0.7, 80, const Color(0xFF4338CA), 0.18);
  }

  @override
  bool shouldRepaint(_OrbPainter old) => old.t != t;
}

// ── MedCare Logo Icon — uses the app_icon asset ──────────────
class _MedCareLogoIcon extends StatelessWidget {
  const _MedCareLogoIcon();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Image.asset(
        'assets/images/app_icon.png',
        width: 88,
        height: 88,
        fit: BoxFit.cover,
      ),
    );
  }
}

// ── Feature Pill ─────────────────────────────────────────────
class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeaturePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.20),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.85)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
