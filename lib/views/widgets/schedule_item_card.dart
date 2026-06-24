import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../view_models/schedule_controller.dart';
import '../../data/models/medicine_model.dart';

// ─── Colors & constants ────────────────────────────────────────────────────────
const _medColor = ScheduleController.medicineColor; // 0xFF6C63FF
const _aptColor = ScheduleController.appointmentColor; // 0xFF00BFA6

/// Glassmorphism-style card for a single [ScheduleItem].
///
/// • Left accent bar colored by item type
/// • Leading icon circle
/// • Status chip with color coding
/// • Slide-to-dismiss gesture to mark pending medicine doses as taken
class ScheduleItemCard extends StatefulWidget {
  final ScheduleItem item;
  final int index;
  final VoidCallback? onDismissed;

  const ScheduleItemCard({
    super.key,
    required this.item,
    required this.index,
    this.onDismissed,
  });

  @override
  State<ScheduleItemCard> createState() => _ScheduleItemCardState();
}

class _ScheduleItemCardState extends State<ScheduleItemCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    // ── Staggered entry animation ─────────────────────────────────────────────
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
    _fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeIn);

    // Delay per index (staggered, 50 ms apart)
    Future.delayed(Duration(milliseconds: 50 * widget.index), () {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Color get _accentColor =>
      widget.item.type == ScheduleItemType.medicine ? _medColor : _aptColor;

  IconData get _leadingIcon {
    if (widget.item.type == ScheduleItemType.appointment) {
      return Icons.person_pin_circle_rounded;
    }
    return _medicineIcon(widget.item.category ?? 'Tablet');
  }

  IconData _medicineIcon(String type) {
    switch (type.toLowerCase()) {
      case 'syrup':
        return Icons.local_drink_rounded;
      case 'injection':
        return Icons.colorize_rounded;
      case 'insulin':
        return Icons.vaccines_rounded;
      case 'drops':
        return Icons.water_drop_rounded;
      case 'inhaler':
        return Icons.air_rounded;
      case 'capsule':
        return Icons.medication_liquid_rounded;
      default:
        return Icons.medication_rounded; // tablet / other
    }
  }

  String get _formattedTime =>
      DateFormat('hh:mm a').format(widget.item.scheduledTime);

  // ── Status chip ─────────────────────────────────────────────────────────────

  Widget _statusChip(BuildContext context) {
    late Color bg;
    late Color fg;
    late String label;
    late IconData icon;

    switch (widget.item.status) {
      case ScheduleItemStatus.taken:
        bg = Colors.green.withOpacity(0.15);
        fg = Colors.green.shade700;
        label = 'Taken';
        icon = Icons.check_circle_rounded;
        break;
      case ScheduleItemStatus.missed:
        bg = Colors.red.withOpacity(0.15);
        fg = Colors.red.shade700;
        label = 'Missed';
        icon = Icons.cancel_rounded;
        break;
      case ScheduleItemStatus.pending:
        bg = Colors.orange.withOpacity(0.15);
        fg = Colors.orange.shade800;
        label = 'Pending';
        icon = Icons.hourglass_bottom_rounded;
        break;
      case ScheduleItemStatus.upcoming:
        bg = Colors.blue.withOpacity(0.15);
        fg = Colors.blue.shade700;
        label = 'Upcoming';
        icon = Icons.event_rounded;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final card = Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: isDark
            ? scheme.surface.withOpacity(0.85)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _accentColor.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Content — determines the card height; left-padded to clear the bar
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 12, 12, 12),
              child: Row(
                  children: [
                    // Leading icon circle
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_leadingIcon,
                          color: _accentColor, size: 22),
                    ),
                    const SizedBox(width: 12),

                    // Title + subtitle + status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.item.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: scheme.onSurface.withOpacity(0.55),
                            ),
                          ),
                          const SizedBox(height: 6),
                          _statusChip(context),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Time
                    Text(
                      _formattedTime,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _accentColor,
                      ),
                    ),
                  ],
                ),
            ),

            // Left accent bar — Positioned so it fills the full card height
            // without requiring IntrinsicHeight (avoids expensive multi-pass layout)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 5, color: _accentColor),
            ),
          ],
        ),
      ),
    );

    // ── Slide-to-dismiss for pending medicine items ──────────────────────────
    final canDismiss = widget.item.type == ScheduleItemType.medicine &&
        widget.item.status == ScheduleItemStatus.pending &&
        widget.onDismissed != null;

    final animated = FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: card),
    );

    if (!canDismiss) return animated;

    return Dismissible(
      key: ValueKey(widget.item.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.green.shade600,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text('Mark Taken',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      onDismissed: (_) => widget.onDismissed!(),
      child: animated,
    );
  }
}
