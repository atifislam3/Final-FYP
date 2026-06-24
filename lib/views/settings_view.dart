import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/settings_controller.dart';
import 'help_support_view.dart';
import 'notification_sound_settings_view.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final AnimationController _entryCtrl;
  late final SettingsController _controller;

  late final Animation<double> _appearanceAnim;
  late final Animation<double> _dateTimeAnim;
  late final Animation<double> _notifAnim;
  late final Animation<double> _supportAnim;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<SettingsController>();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _appearanceAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    );
    _dateTimeAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.15, 0.7, curve: Curves.easeOutCubic),
    );
    _notifAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.3, 0.85, curve: Curves.easeOutCubic),
    );
    _supportAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOutCubic),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: AppThemeColors.primaryText(b)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
              color: AppThemeColors.primaryText(b),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(decoration: AppThemeColors.backgroundDecoration(b)),
          // Animated orbs
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(
                t: _bgCtrl.value,
                alphaMultiplier: AppThemeColors.orbAlpha(b),
              ),
              child: const SizedBox.expand(),
            ),
          ),
          // Content
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              children: [
                // Gear badge header
                _buildGearBadge(),
                const SizedBox(height: 28),

                // Appearance section
                _buildAnimatedSection(
                  animation: _appearanceAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("Appearance", b),
                      const SizedBox(height: 10),
                      _buildGlassCard(
                        b: b,
                        child: Obx(() => _buildSwitchTile(
                              b: b,
                              title: "Dark Theme",
                              subtitle: "Toggle between Light and Dark mode",
                              icon: Icons.dark_mode_rounded,
                              accentColor: colorScheme.primary,
                              value: _controller.isDarkMode.value,
                              onChanged: (val) => _controller.toggleTheme(val),
                            )),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Date & Time section
                _buildAnimatedSection(
                  animation: _dateTimeAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("Date & Time", b),
                      const SizedBox(height: 10),
                      _buildGlassCard(
                        b: b,
                        child: Obx(() => _buildInfoTile(
                              b: b,
                              title: "Time Zone",
                              subtitle: _controller.currentTimeZone.value,
                              icon: Icons.public_rounded,
                              accentColor: colorScheme.secondary,
                              trailing: const Icon(Icons.check_circle_outline,
                                  color: Color(0xFF34D399), size: 20),
                            )),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          "Reminders will automatically adjust to this time zone.",
                          style: TextStyle(
                              fontSize: 12, color: AppThemeColors.hintText(b)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Notifications section
                _buildAnimatedSection(
                  animation: _notifAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("Notifications", b),
                      const SizedBox(height: 10),
                      _buildGlassCard(
                        b: b,
                        child: Column(
                          children: [
                            Obx(() => _buildInfoTile(
                                  b: b,
                                  title: "Notification Sound",
                                  subtitle: _controller.notificationSound.value,
                                  icon: Icons.notifications_active_rounded,
                                  accentColor: colorScheme.primary,
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: AppThemeColors.secondaryText(b),
                                  ),
                                  onTap: () => Get.to(() =>
                                      const NotificationSoundSettingsView()),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Support section
                _buildAnimatedSection(
                  animation: _supportAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("Support", b),
                      const SizedBox(height: 10),
                      _buildGlassCard(
                        b: b,
                        child: _buildInfoTile(
                          b: b,
                          title: "Help & Support",
                          subtitle: "User guide, feedback, and app info",
                          icon: Icons.help_center_rounded,
                          accentColor: colorScheme.secondary,
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: AppThemeColors.secondaryText(b),
                          ),
                          onTap: () => Get.to(() => const HelpSupportView()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGearBadge() {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: AnimatedBuilder(
        animation: _bgCtrl,
        builder: (_, __) {
          final dy = math.sin(_bgCtrl.value * math.pi) * 4.0;
          return Transform.translate(
            offset: Offset(0, dy),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primaryContainer,
                    colorScheme.tertiary
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.50),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.settings_rounded,
                  color: Colors.white, size: 38),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedSection({
    required Animation<double> animation,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - animation.value)),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Brightness b) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.0,
        color: AppThemeColors.hintText(b),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, required Brightness b}) {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppThemeColors.glassBorder(b), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3730A3).withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: child,
      ),
    );
  }

  Widget _buildSwitchTile({
    required Brightness b,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppThemeColors.primaryText(b)),
        ),
        subtitle: Text(
          subtitle,
          style:
              TextStyle(fontSize: 12, color: AppThemeColors.secondaryText(b)),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: accentColor, size: 20),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
        inactiveThumbColor: AppThemeColors.hintText(b),
        inactiveTrackColor: AppThemeColors.glassBorder(b),
      ),
    );
  }

  Widget _buildInfoTile({
    required Brightness b,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppThemeColors.primaryText(b)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: 12, color: AppThemeColors.secondaryText(b)),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
