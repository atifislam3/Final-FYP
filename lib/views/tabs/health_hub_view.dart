import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../appointments_view.dart';
import '../health_records_view.dart';
import '../analytics_view.dart';
import '../wellness_view.dart';
import '../reports_view.dart';
import '../chat_view.dart';
import '../widgets/orb_painter.dart';
import '../../utils/app_theme_colors.dart';

class HealthHubView extends StatefulWidget {
  const HealthHubView({super.key});

  @override
  State<HealthHubView> createState() => _HealthHubViewState();
}

class _HealthHubViewState extends State<HealthHubView>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final AnimationController _entryCtrl;
  late final Animation<double> _headerAnim;
  late final Animation<double> _aiCardAnim;
  late final Animation<double> _gridAnim;

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _headerAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
    );
    _aiCardAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.2, 0.75, curve: Curves.easeOutBack),
    );
    _gridAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.35, 1.0, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppThemeColors.scaffoldBg(b),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Gradient background ────────────────────────────────────
          Container(decoration: AppThemeColors.backgroundDecoration(b)),
          // ── Animated orbs ──────────────────────────────────────────
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(
                t: _bgCtrl.value,
                alphaMultiplier: AppThemeColors.orbAlpha(b),
              ),
            ),
          ),
          // ── Content ───────────────────────────────────────────────
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: AnimatedBuilder(
                    animation: _headerAnim,
                    builder: (_, child) => Opacity(
                      opacity: _headerAnim.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - _headerAnim.value)),
                        child: child,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppThemeColors.glassBg(b),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppThemeColors.glassBorder(b),
                              ),
                            ),
                            child: Text(
                              'HEALTH HUB',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0,
                                color: AppThemeColors.primaryText(b),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Your Medical\nDashboard',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: AppThemeColors.primaryText(b),
                              height: 1.1,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'All health tools in one place',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppThemeColors.secondaryText(b),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Body content
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // AI Card
                      AnimatedBuilder(
                        animation: _aiCardAnim,
                        builder: (_, child) => Opacity(
                          opacity: _aiCardAnim.value.clamp(0.0, 1.0),
                          child: Transform.scale(
                            scale: 0.92 + 0.08 * _aiCardAnim.value.clamp(0.0, 1.0),
                            child: child,
                          ),
                        ),
                        child: _buildAICard(context),
                      ),
                      const SizedBox(height: 28),

                      // Section title
                      AnimatedBuilder(
                        animation: _gridAnim,
                        builder: (_, child) => Opacity(
                          opacity: _gridAnim.value,
                          child: child,
                        ),
                        child: Text(
                          'QUICK ACCESS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.0,
                            color: AppThemeColors.hintText(b),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 2-col grid
                      AnimatedBuilder(
                        animation: _gridAnim,
                        builder: (_, child) => Opacity(
                          opacity: _gridAnim.value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - _gridAnim.value)),
                            child: child,
                          ),
                        ),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.05,
                          children: [
                            _buildGridCard(
                              index: 0,
                              title: 'Appointments',
                              subtitle: 'Manage Visits',
                              icon: Icons.calendar_month_rounded,
                              gradient: [
                                const Color(0xFF667EEA),
                                const Color(0xFF764BA2)
                              ],
                              onTap: () => Get.to(() => const AppointmentsView()),
                            ),
                            _buildGridCard(
                              index: 1,
                              title: 'Analytics',
                              subtitle: 'Adherence & Trends',
                              icon: Icons.bar_chart_rounded,
                              gradient: [
                                const Color(0xFFf093fb),
                                const Color(0xFFf5576c)
                              ],
                              onTap: () => Get.to(() => const AnalyticsView()),
                            ),
                            _buildGridCard(
                              index: 2,
                              title: 'My Vitals',
                              subtitle: 'Body Metrics',
                              icon: Icons.monitor_heart_rounded,
                              gradient: [
                                const Color(0xFF4facfe),
                                const Color(0xFF00f2fe)
                              ],
                              onTap: () => Get.to(() => const HealthRecordsView()),
                            ),
                            _buildGridCard(
                              index: 3,
                              title: 'Medical Docs',
                              subtitle: 'Prescriptions',
                              icon: Icons.folder_shared_rounded,
                              gradient: [
                                const Color(0xFF4e54c8),
                                const Color(0xFF8f94fb)
                              ],
                              onTap: () => Get.to(() => const ReportsView()),
                            ),
                            _buildGridCard(
                              index: 4,
                              title: 'Wellness',
                              subtitle: 'Mood & Streak',
                              icon: Icons.spa_rounded,
                              gradient: [
                                const Color(0xFFfa709a),
                                const Color(0xFFfee140)
                              ],
                              onTap: () => Get.to(() => const WellnessView()),
                            ),
                            _buildGridCard(
                              index: 5,
                              title: 'AI Assistant',
                              subtitle: 'Ask Anything',
                              icon: Icons.smart_toy_rounded,
                              gradient: [
                                const Color(0xFF30cfd0),
                                const Color(0xFF667eea)
                              ],
                              onTap: () => Get.to(() => const ChatView()),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAICard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.45),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.to(() => const ChatView()),
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'AI POWERED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'AI Health\nAssistant',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Ask anything about your health',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25)),
                      ),
                      child: const Icon(
                        Icons.smart_toy_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridCard({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + index * 80),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - v)),
          child: child,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(22),
            splashColor: Colors.white.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, size: 26, color: Colors.white),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
