import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/settings_controller.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class _SoundOption {
  final String displayName;
  final String fileName;
  const _SoundOption(this.displayName, this.fileName);
}

const _shortSounds = [
  _SoundOption('Bell Notification', 'mixkit_bell_notification_933'),
];

const _longSounds = [
  _SoundOption('Marimba', 'mixkit_marimba_waiting_ringtone_1360'),
];

class NotificationSoundSettingsView extends StatefulWidget {
  const NotificationSoundSettingsView({super.key});

  @override
  State<NotificationSoundSettingsView> createState() =>
      _NotificationSoundSettingsViewState();
}

class _NotificationSoundSettingsViewState
    extends State<NotificationSoundSettingsView> with TickerProviderStateMixin {
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
    final colorScheme = Theme.of(context).colorScheme;
    _b = b;
    final controller = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Gradient background ──────────────────────────────────
          SizedBox.expand(
            child: Container(
              decoration: AppThemeColors.backgroundDecoration(_b),
            ),
          ),
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(
                  t: _bgCtrl.value,
                  alphaMultiplier: AppThemeColors.orbAlpha(b)),
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
                    icon: Icon(Icons.arrow_back_ios_rounded,
                        color: AppThemeColors.primaryText(b)),
                    onPressed: () => Get.back(),
                  ),
                  title: Text(
                    'Notification Sounds',
                    style: TextStyle(
                        color: AppThemeColors.primaryText(_b),
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  centerTitle: true,
                ),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    children: [
                      // Info banner
                      _staggered(
                        delay: 0.0,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: colorScheme.primary.withOpacity(0.18),
                                width: 1.2),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline_rounded,
                                  color: colorScheme.primary, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Tap ▶ to preview the short and long notification sounds.',
                                  style: TextStyle(
                                      color: AppThemeColors.secondaryText(_b),
                                      fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ── Short sounds ────────────────────────────
                      _staggered(
                        delay: 0.10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionLabel('🔔  Short Notification'),
                            const SizedBox(height: 4),
                            Text(
                              'Quick, subtle alert — great for medicine reminders',
                              style: TextStyle(
                                  color: AppThemeColors.secondaryText(_b),
                                  fontSize: 12),
                            ),
                            const SizedBox(height: 14),
                            Obx(() => _soundList(
                                  controller: controller,
                                  sounds: _shortSounds,
                                  selectedKey:
                                      controller.selectedShortSound.value,
                                  isShort: true,
                                  onSelect: controller.updateShortSound,
                                )),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Long sounds ─────────────────────────────
                      _staggered(
                        delay: 0.20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionLabel('🔔🔔  Long Notification'),
                            const SizedBox(height: 4),
                            Text(
                              'Extended, prominent alert — you can assign it to either medicine or appointment reminders',
                              style: TextStyle(
                                  color: AppThemeColors.secondaryText(_b),
                                  fontSize: 12),
                            ),
                            const SizedBox(height: 14),
                            Obx(() => _soundList(
                                  controller: controller,
                                  sounds: _longSounds,
                                  selectedKey:
                                      controller.selectedLongSound.value,
                                  isShort: false,
                                  onSelect: controller.updateLongSound,
                                )),
                          ],
                        ),
                      ),

                      // ── Divider ─────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Container(
                            height: 1, color: AppThemeColors.glassDivider(_b)),
                      ),

                      // ── Usage preferences ───────────────────────
                      _staggered(
                        delay: 0.30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionLabel('⚙️  REMINDER TYPE'),
                            const SizedBox(height: 14),
                            Obx(() => _buildSelectionCard(
                                  title: 'Medicine reminders',
                                  subtitle:
                                      'Choose short or long sound for medicine alerts',
                                  icon: Icons.medication_rounded,
                                  isShortSelected:
                                      controller.useShortForMedicine.value,
                                  onSelect: (isShort) {
                                    if (controller.useShortForMedicine.value !=
                                        isShort) {
                                      controller.toggleMedicineSound(isShort);
                                    }
                                  },
                                )),
                            const SizedBox(height: 12),
                            Obx(() => _buildSelectionCard(
                                  title: 'Appointment reminders',
                                  subtitle:
                                      'Choose short or long sound for appointment alerts',
                                  icon: Icons.calendar_today_rounded,
                                  isShortSelected:
                                      controller.useShortForAppointments.value,
                                  onSelect: (isShort) {
                                    if (controller
                                            .useShortForAppointments.value !=
                                        isShort) {
                                      controller
                                          .toggleAppointmentSound(isShort);
                                    }
                                  },
                                )),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tip
                      _staggered(
                        delay: 0.40,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppThemeColors.glassBg(_b),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppThemeColors.glassBorder(_b)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('💡', style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Sound changes are applied immediately by recreating notification channels and rescheduling reminders in the current session.',
                                  style: TextStyle(
                                      color: AppThemeColors.hintText(_b),
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
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

  // ── Sound list ────────────────────────────────────────────────────────
  Widget _soundList({
    required SettingsController controller,
    required List<_SoundOption> sounds,
    required String selectedKey,
    required bool isShort,
    required void Function(String) onSelect,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: sounds.map((sound) {
        final isSelected = selectedKey == sound.fileName;
        return GestureDetector(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withOpacity(0.18)
                  : AppThemeColors.glassDivider(_b),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary.withOpacity(0.60)
                    : AppThemeColors.glassBorder(_b),
                width: 1.2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Row(
                children: [
                  // Left accent bar for selected state
                  if (isSelected)
                    Container(
                      width: 3,
                      height: 52,
                      color: colorScheme.primary,
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      child: Row(
                        children: [
                          // Selection indicator
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? colorScheme.primary
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
                          const SizedBox(width: 14),
                          // Sound name
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sound.displayName,
                                  style: TextStyle(
                                      color: AppThemeColors.primaryText(_b),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isShort
                                      ? 'Short  •  ~2 seconds'
                                      : 'Long  •  ~5 seconds',
                                  style: TextStyle(
                                      color: AppThemeColors.secondaryText(_b),
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          // Preview button
                          GestureDetector(
                            onTap: () => controller.previewSound(
                                sound.fileName, isShort),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color:
                                        colorScheme.primary.withOpacity(0.30)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.play_arrow_rounded,
                                      color: colorScheme.primary, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Preview',
                                    style: TextStyle(
                                      color: AppThemeColors.primaryText(_b),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Glass selection card ───────────────────────────────────────────────
  Widget _buildSelectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isShortSelected,
    required void Function(bool) onSelect,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(_b),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppThemeColors.glassBorder(_b), width: 1.2),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: colorScheme.primary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              color: AppThemeColors.primaryText(_b),
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: TextStyle(
                              color: AppThemeColors.secondaryText(_b),
                              fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: AppThemeColors.glassBorder(_b)),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => onSelect(true),
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Text('Short',
                            style: TextStyle(
                                color: isShortSelected
                                    ? colorScheme.primary
                                    : AppThemeColors.primaryText(_b),
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        const SizedBox(height: 2),
                        Text('~2 seconds',
                            style: TextStyle(
                                color: AppThemeColors.secondaryText(_b),
                                fontSize: 12)),
                        const SizedBox(height: 12),
                        Icon(
                            isShortSelected
                                ? Icons.check_circle_rounded
                                : Icons.circle_outlined,
                            color: isShortSelected
                                ? colorScheme.primary
                                : AppThemeColors.glassBorder(_b)
                                    .withOpacity(0.5),
                            size: 22),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  width: 1, height: 80, color: AppThemeColors.glassBorder(_b)),
              Expanded(
                child: InkWell(
                  onTap: () => onSelect(false),
                  borderRadius:
                      const BorderRadius.only(bottomRight: Radius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Text('Long',
                            style: TextStyle(
                                color: !isShortSelected
                                    ? colorScheme.primary
                                    : AppThemeColors.primaryText(_b),
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        const SizedBox(height: 2),
                        Text('~25 seconds',
                            style: TextStyle(
                                color: AppThemeColors.secondaryText(_b),
                                fontSize: 12)),
                        const SizedBox(height: 12),
                        Icon(
                            !isShortSelected
                                ? Icons.check_circle_rounded
                                : Icons.circle_outlined,
                            color: !isShortSelected
                                ? colorScheme.primary
                                : AppThemeColors.glassBorder(_b)
                                    .withOpacity(0.5),
                            size: 22),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
          color: AppThemeColors.hintText(_b),
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
