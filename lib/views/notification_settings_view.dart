import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/notification_settings_controller.dart';
import '../utils/platform_utils.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView>
    with TickerProviderStateMixin {
  Brightness _b = Brightness.dark;

  late final AnimationController _bgCtrl;
  late final AnimationController _entryCtrl;

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
    _b = b;
    final controller = Get.put(NotificationSettingsController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Gradient background ──────────────────────────────────
          Container(decoration: AppThemeColors.backgroundDecoration(b)),
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(t: _bgCtrl.value, alphaMultiplier: AppThemeColors.orbAlpha(b)),
              size: Size.infinite,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppThemeColors.primaryText(b)),
                    onPressed: () => Get.back(),
                  ),
                  title: Text(
                    'Notification Settings',
                    style: TextStyle(
                        color: AppThemeColors.primaryText(_b),
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  centerTitle: true,
                ),
                Expanded(
                  child: PlatformUtils.isWeb
                      ? _buildWebWarning()
                      : _buildMobileSettings(controller),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Web warning ──────────────────────────────────────────────────────
  Widget _buildWebWarning() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFFFBBF24).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: const Color(0xFFFBBF24).withValues(alpha: 0.35),
                width: 1.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBBF24).withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.web_rounded,
                    color: Color(0xFFFBBF24), size: 36),
              ),
              const SizedBox(height: 20),
              Text(
                'Web Platform Detected',
                style: TextStyle(
                    color: AppThemeColors.primaryText(_b),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(height: 12),
              Text(
                'Custom notification sounds are only available on mobile platforms (Android/iOS).',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppThemeColors.secondaryText(_b),
                    fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Web browsers use system notification sounds.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppThemeColors.secondaryText(_b),
                    fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Mobile settings ──────────────────────────────────────────────────
  Widget _buildMobileSettings(NotificationSettingsController controller) {
    return Obx(() {
      final settings = controller.settings.value;
      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          // Bell hero badge
          _staggered(
            delay: 0.0,
            child: _buildHeroBadge(),
          ),
          const SizedBox(height: 24),

          // Medicine sounds section
          _staggered(
            delay: 0.10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel('💊  Medicine Reminders'),
                const SizedBox(height: 4),
                Text(
                  'Sound type for medicine notifications',
                  style: TextStyle(
                      color: AppThemeColors.secondaryText(_b),
                      fontSize: 12),
                ),
                const SizedBox(height: 14),
                _buildSoundTypeSelector(
                  useShort: settings.useShortForMedicine,
                  onChanged: controller.toggleMedicineNotificationType,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Appointment sounds section
          _staggered(
            delay: 0.20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel('📅  Appointment Reminders'),
                const SizedBox(height: 4),
                Text(
                  'Sound type for appointment notifications',
                  style: TextStyle(
                      color: AppThemeColors.secondaryText(_b),
                      fontSize: 12),
                ),
                const SizedBox(height: 14),
                _buildSoundTypeSelector(
                  useShort: settings.useShortForAppointments,
                  onChanged: controller.toggleAppointmentNotificationType,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Available sounds section
          _staggered(
            delay: 0.30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel('🔊  Short Sounds'),
                const SizedBox(height: 4),
                Text('2–3 seconds',
                    style: TextStyle(
                        color: AppThemeColors.secondaryText(_b),
                        fontSize: 12)),
                const SizedBox(height: 14),
                ...controller.shortSounds.map((sound) => _buildSoundCard(
                      sound,
                      isSelected:
                          settings.shortSoundName == sound.fileName,
                      onPreview: () =>
                          controller.previewSound(sound.assetPath),
                      onSelect: () =>
                          controller.updateShortSound(sound.fileName),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _staggered(
            delay: 0.40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel('🔊  Long Sounds'),
                const SizedBox(height: 4),
                Text('4–6 seconds',
                    style: TextStyle(
                        color: AppThemeColors.secondaryText(_b),
                        fontSize: 12)),
                const SizedBox(height: 14),
                ...controller.longSounds.map((sound) => _buildSoundCard(
                      sound,
                      isSelected:
                          settings.longSoundName == sound.fileName,
                      onPreview: () =>
                          controller.previewSound(sound.assetPath),
                      onSelect: () =>
                          controller.updateLongSound(sound.fileName),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      );
    });
  }

  Widget _buildHeroBadge() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.45),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.notifications_rounded,
                color: Colors.white, size: 32),
          ),
          const SizedBox(height: 12),
          Text('Notification Sounds',
              style: TextStyle(
                  color: AppThemeColors.primaryText(_b),
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          Text('Customize reminders for each category',
              style: TextStyle(
                  color: AppThemeColors.secondaryText(_b), fontSize: 13)),
        ],
      ),
    );
  }

  // ── Sound type selector (short / long) ───────────────────────────────
  Widget _buildSoundTypeSelector({
    required bool useShort,
    required void Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(_b),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppThemeColors.glassBorder(_b), width: 1.2),
      ),
      child: Column(
        children: [
          _soundTypeOption(
            title: 'Short Sound',
            subtitle: 'Quick, subtle notification (2–3 seconds)',
            icon: Icons.notifications_outlined,
            isSelected: useShort,
            isTop: true,
            onTap: () => onChanged(true),
          ),
          Container(
              height: 1,
              color: AppThemeColors.glassDivider(_b)),
          _soundTypeOption(
            title: 'Long Sound',
            subtitle: 'Extended, attention-grabbing (4–6 seconds)',
            icon: Icons.notifications_active_outlined,
            isSelected: !useShort,
            isTop: false,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }

  Widget _soundTypeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required bool isTop,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isTop ? const Radius.circular(20) : Radius.zero,
        bottom: !isTop ? const Radius.circular(20) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6366F1).withValues(alpha: 0.25)
                    : AppThemeColors.glassBg(_b),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: isSelected
                      ? const Color(0xFF818CF8)
                      : AppThemeColors.secondaryText(_b)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: AppThemeColors.primaryText(_b),
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          color: AppThemeColors.secondaryText(_b),
                          fontSize: 12)),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected
                    ? const LinearGradient(colors: [
                        Color(0xFF818CF8),
                        Color(0xFF6366F1),
                      ])
                    : null,
                color: isSelected
                    ? null
                    : AppThemeColors.glassBorder(_b),
                border: isSelected
                    ? null
                    : Border.all(
                        color: AppThemeColors.hintText(_b)),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ── Sound card ────────────────────────────────────────────────────────
  Widget _buildSoundCard(
    NotificationSound sound, {
    required bool isSelected,
    required VoidCallback onPreview,
    required VoidCallback onSelect,
  }) {
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppThemeColors.glassBg(_b),
          borderRadius: BorderRadius.circular(20),
          border: Border(
            left: BorderSide(
              color: isSelected
                  ? const Color(0xFF818CF8)
                  : Colors.transparent,
              width: isSelected ? 3 : 0,
            ),
            top: BorderSide(
                color: AppThemeColors.glassBorder(_b), width: 1.2),
            right: BorderSide(
                color: AppThemeColors.glassBorder(_b), width: 1.2),
            bottom: BorderSide(
                color: AppThemeColors.glassBorder(_b), width: 1.2),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.20),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6366F1).withValues(alpha: 0.25)
                      : AppThemeColors.glassBg(_b),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.music_note_rounded,
                    color: isSelected
                        ? const Color(0xFF818CF8)
                        : AppThemeColors.secondaryText(_b),
                    size: 20),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sound.name,
                        style: TextStyle(
                            color: AppThemeColors.primaryText(_b),
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                    const SizedBox(height: 4),
                    // Duration badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppThemeColors.glassBg(_b),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppThemeColors.glassBorder(_b)),
                      ),
                      child: Text('Duration: ${sound.duration}',
                          style: TextStyle(
                              color: AppThemeColors.secondaryText(_b),
                              fontSize: 11)),
                    ),
                  ],
                ),
              ),
              // Preview button
              GestureDetector(
                onTap: onPreview,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppThemeColors.glassBg(_b),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppThemeColors.glassBorder(_b)),
                  ),
                  child: Icon(Icons.play_arrow_rounded,
                      color: AppThemeColors.primaryText(_b),
                      size: 20),
                ),
              ),
              const SizedBox(width: 10),
              // Checkmark
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color(0xFF818CF8),
                      Color(0xFF6366F1),
                    ]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
          color: const Color(0xFFC7D2FE).withValues(alpha: 0.85),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2),
    );
  }

  Widget _staggered({required double delay, required Widget child}) {
    return AnimatedBuilder(
      animation: _entryCtrl,
      builder: (_, c) {
        final t = CurvedAnimation(
          parent: _entryCtrl,
          curve: Interval(delay, (delay + 0.4).clamp(0.0, 1.0),
              curve: Curves.easeOutCubic),
        ).value;
        return Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, 24 * (1 - t)), child: c),
        );
      },
      child: child,
    );
  }
}
