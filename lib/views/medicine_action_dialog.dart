import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../view_models/medicine_controller.dart';
import '../data/models/medicine_model.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MedicineActionDialog — Material 3 push-notification in-app dialog
// Appears when the user taps a medicine reminder notification.
// Pure UI redesign; zero changes to business logic.
// ─────────────────────────────────────────────────────────────────────────────

class MedicineActionDialog extends StatefulWidget {
  final String medicineId;
  final DateTime scheduledTime;

  const MedicineActionDialog({
    Key? key,
    required this.medicineId,
    required this.scheduledTime,
  }) : super(key: key);

  @override
  State<MedicineActionDialog> createState() => _MedicineActionDialogState();
}

class _MedicineActionDialogState extends State<MedicineActionDialog>
    with TickerProviderStateMixin {
  // Entry animation (slide-up + fade + scale — M3 standard motion)
  late final AnimationController _entryCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  // Continuous orb background animation
  late final AnimationController _bgCtrl;

  // Continuous icon pulse
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    // ── Background orbs ──────────────────────────────────────────────────
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    // ── Entry: 480 ms, easeOutCubic (M3 spec) ───────────────────────────
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutBack),
    );

    // ── Icon pulse ───────────────────────────────────────────────────────
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _bgCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    final controller = Get.find<MedicineController>();
    final medicine = controller.medicines.firstWhereOrNull(
      (m) => m.medicineId == widget.medicineId,
    );

    if (medicine == null) {
      Future.microtask(() => Get.back());
      return const SizedBox.shrink();
    }

    final typeColor = _typeColor(medicine.type);
    final typeIcon  = _typeIcon(medicine.type);
    final isOverdue = DateTime.now()
        .isAfter(widget.scheduledTime.add(const Duration(minutes: 5)));
    final delay      = DateTime.now().difference(widget.scheduledTime);
    final delayLabel = delay.inMinutes > 0
        ? '${delay.inMinutes} min late'
        : 'On time';
    final timeStr = DateFormat('h:mm a').format(widget.scheduledTime);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── 1. Full-screen gradient ──────────────────────────────────
          Container(decoration: AppThemeColors.backgroundDecoration(b)),

          // ── 2. Animated orbs (matches rest of app) ───────────────────
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(t: _bgCtrl.value, alphaMultiplier: AppThemeColors.orbAlpha(b)),
              child: const SizedBox.expand(),
            ),
          ),

          // ── 3. Animated card ─────────────────────────────────────────
          AnimatedBuilder(
            animation: _entryCtrl,
            builder: (_, child) => FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: child,
                ),
              ),
            ),
            child: Center(
              child: _buildCard(
                context,
                controller,
                medicine,
                typeColor,
                typeIcon,
                isOverdue,
                timeStr,
                delayLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Main card ─────────────────────────────────────────────────────────────

  Widget _buildCard(
    BuildContext context,
    MedicineController controller,
    MedicineModel medicine,
    Color typeColor,
    IconData typeIcon,
    bool isOverdue,
    String timeStr,
    String delayLabel,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.13),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: typeColor.withValues(alpha: 0.28),
            blurRadius: 48,
            spreadRadius: 0,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 32,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Coloured accent strip at the top ────────────────────
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    typeColor.withValues(alpha: 0.0),
                    typeColor,
                    typeColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Pulsing icon ─────────────────────────────────
                  _buildPulsingIcon(typeIcon, typeColor),
                  const SizedBox(height: 18),

                  // ── "Time to take your medicine" label ───────────
                  Text(
                    'Time to take your medicine',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.55),
                      letterSpacing: 0.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // ── Medicine name (M3 headlineMedium scale) ──────
                  Text(
                    medicine.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.4,
                      height: 1.15,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // ── Info chips row (dosage + type) ───────────────
                  _buildChipsRow(medicine, typeColor),
                  const SizedBox(height: 14),

                  // ── Time / status badge ──────────────────────────
                  _buildTimeBadge(timeStr, delayLabel, isOverdue),
                  const SizedBox(height: 28),

                  // ── PRIMARY: Take button ─────────────────────────
                  _buildTakeButton(controller, medicine),
                  const SizedBox(height: 10),

                  // ── SECONDARY: Snooze + Skip side-by-side ────────
                  Row(
                    children: [
                      Expanded(
                          child: _buildSnoozeButton(controller, medicine)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildSkipButton(controller, medicine)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sub-widgets ───────────────────────────────────────────────────────────

  Widget _buildPulsingIcon(IconData icon, Color color) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, child) =>
          Transform.scale(scale: _pulseAnim.value, child: child),
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.10),
          border: Border.all(color: color.withValues(alpha: 0.50), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.32),
              blurRadius: 28,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Icon(icon, size: 44, color: Colors.white),
      ),
    );
  }

  Widget _buildChipsRow(MedicineModel medicine, Color typeColor) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: [
        _chip(
          medicine.dosage,
          Icons.medication_outlined,
          const Color(0xFF818CF8),
        ),
        _chip(
          medicine.type,
          Icons.category_outlined,
          typeColor,
        ),
      ],
    );
  }

  Widget _chip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.28), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color.withValues(alpha: 0.90)),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.90),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBadge(String timeStr, String delayLabel, bool isOverdue) {
    final badgeColor = isOverdue
        ? const Color(0xFFF59E0B)   // amber
        : const Color(0xFF34D399);  // emerald

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: badgeColor.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOverdue
                ? Icons.schedule_rounded
                : Icons.check_circle_outline_rounded,
            size: 14,
            color: badgeColor,
          ),
          const SizedBox(width: 6),
          Text(
            '$timeStr · $delayLabel',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: badgeColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTakeButton(
      MedicineController controller, MedicineModel medicine) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF059669), Color(0xFF10B981), Color(0xFF34D399)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withValues(alpha: 0.38),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FilledButton.icon(
          onPressed: () => _handleTake(controller, medicine),
          icon: const Icon(Icons.check_circle_rounded, size: 22),
          label: const Text(
            'Take Medicine',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSnoozeButton(
      MedicineController controller, MedicineModel medicine) {
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF60A5FA).withValues(alpha: 0.32),
            width: 1,
          ),
        ),
        child: TextButton.icon(
          onPressed: () => _handleSnooze(controller, medicine),
          icon: const Icon(Icons.snooze_rounded, size: 18,
              color: Color(0xFF60A5FA)),
          label: const Text(
            'Snooze',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF60A5FA),
            ),
          ),
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton(
      MedicineController controller, MedicineModel medicine) {
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.32),
            width: 1,
          ),
        ),
        child: TextButton.icon(
          onPressed: () => _handleMiss(controller, medicine),
          icon: const Icon(Icons.cancel_rounded, size: 18,
              color: Color(0xFFF59E0B)),
          label: const Text(
            'Skip',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF59E0B),
            ),
          ),
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }

  // ── Icon / colour maps per medicine type ─────────────────────────────────

  IconData _typeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'tablet':    return Icons.medication_rounded;
      case 'capsule':   return Icons.medication_liquid_rounded;
      case 'syrup':     return Icons.local_drink_rounded;
      case 'injection': return Icons.vaccines_rounded;
      case 'drops':     return Icons.water_drop_rounded;
      case 'inhaler':   return Icons.air_rounded;
      default:          return Icons.medical_services_rounded;
    }
  }

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'tablet':    return const Color(0xFF818CF8); // indigo
      case 'capsule':   return const Color(0xFFC084FC); // purple
      case 'syrup':     return const Color(0xFF34D399); // emerald
      case 'injection': return const Color(0xFFF87171); // red
      case 'drops':     return const Color(0xFF67E8F9); // cyan
      case 'inhaler':   return const Color(0xFF60A5FA); // blue
      default:          return const Color(0xFFA78BFA); // violet
    }
  }

  // ── Action handlers (unchanged logic) ────────────────────────────────────

  void _handleTake(MedicineController controller, MedicineModel medicine) {
    controller.handleNotificationAction('take', widget.medicineId, widget.scheduledTime);
    Get.back();
  }

  void _handleMiss(MedicineController controller, MedicineModel medicine) {
    controller.handleNotificationAction('miss', widget.medicineId, widget.scheduledTime);
    Get.back();
  }

  void _handleSnooze(MedicineController controller, MedicineModel medicine) {
    controller.handleNotificationAction('snooze', widget.medicineId, widget.scheduledTime);
    Get.back();
  }
}
