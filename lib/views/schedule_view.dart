
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../view_models/schedule_controller.dart';
import '../view_models/medicine_controller.dart';
import 'widgets/schedule_item_card.dart';
import 'widgets/animated_empty_state.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';



/// Module 4 – Schedule Management View (Premium UI)
class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView>
    with TickerProviderStateMixin {
  late final ScheduleController _ctrl;
  Brightness _b = Brightness.dark;
  DateTime _focusedDay = DateTime.now();

  late final AnimationController _bgCtrl;
  late final AnimationController _entryCtrl;
  late final Animation<double> _headerAnim;
  late final Animation<double> _calAnim;
  late final Animation<double> _listAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<ScheduleController>();
    _focusedDay = _ctrl.selectedDate.value;

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
    _calAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.2, 0.75, curve: Curves.easeOutCubic),
    );
    _listAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  // ── Background ──────────────────────────────────────────────────────────────

  Widget _buildBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(decoration: AppThemeColors.backgroundDecoration(_b)),
        AnimatedBuilder(
          animation: _bgCtrl,
          builder: (_, __) => CustomPaint(
            painter: OrbPainter(t: _bgCtrl.value, alphaMultiplier: AppThemeColors.orbAlpha(_b)),
          ),
        ),
      ],
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _headerAnim,
      builder: (_, child) => Opacity(
        opacity: _headerAnim.value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - _headerAnim.value)),
          child: child,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
          left: 24,
          right: 24,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MY SCHEDULE',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                        color: AppThemeColors.secondaryText(_b),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stay on track',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
                Obx(() => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppThemeColors.glassDivider(_b),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppThemeColors.glassBorder(_b),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_rounded,
                              color: AppThemeColors.primaryText(_b),
                              size: 16),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('EEE, MMM d')
                                .format(_ctrl.selectedDate.value),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Your health events at a glance',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppThemeColors.secondaryText(_b),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Calendar (glass card) ───────────────────────────────────────────────────

  Widget _buildCalendar() {
    return AnimatedBuilder(
      animation: _calAnim,
      builder: (_, child) => Opacity(
        opacity: _calAnim.value,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - _calAnim.value)),
          child: child,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppThemeColors.glassBg(_b),
            borderRadius: BorderRadius.circular(24),
            border:
                Border.all(color: AppThemeColors.glassBorder(_b), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3730A3).withValues(alpha: 0.20),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Obx(() {
              final selected = _ctrl.selectedDate.value;
              final marked = _ctrl.markedDates;

              return TableCalendar(
                firstDay: _ctrl.rangeStart,
                lastDay: _ctrl.rangeEnd,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, selected),
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(selected, selectedDay)) {
                    _ctrl.onDaySelected(selectedDay);
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                availableGestures: AvailableGestures.horizontalSwipe,
                calendarFormat: CalendarFormat.month,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left_rounded,
                      color: AppThemeColors.secondaryText(_b)),
                  rightChevronIcon: Icon(Icons.chevron_right_rounded,
                      color: AppThemeColors.secondaryText(_b)),
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppThemeColors.hintText(_b),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppThemeColors.secondaryText(_b), width: 1.5),
                  ),
                  selectedTextStyle: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  disabledTextStyle: GoogleFonts.poppins(
                    color: AppThemeColors.hintText(_b),
                  ),
                  outsideTextStyle: GoogleFonts.poppins(
                    color: AppThemeColors.hintText(_b),
                  ),
                  defaultTextStyle: GoogleFonts.poppins(
                    color: AppThemeColors.primaryText(_b),
                  ),
                  weekendTextStyle: GoogleFonts.poppins(
                    color: AppThemeColors.primaryText(_b),
                  ),
                  markersMaxCount: 1,
                  markerSize: 6,
                  markerMargin: const EdgeInsets.only(top: 2),
                  markerDecoration: const BoxDecoration(
                    color: Color(0xFF818CF8),
                    shape: BoxShape.circle,
                  ),
                ),
                eventLoader: (day) {
                  final d = DateTime(day.year, day.month, day.day);
                  return marked.contains(d) ? [1] : [];
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if (events.isEmpty) return const SizedBox.shrink();
                    final d = DateTime(day.year, day.month, day.day);
                    final hasMed = _ctrl.medicinesForDate(d).isNotEmpty;
                    final hasApt = _ctrl.appointmentsForDate(d).isNotEmpty;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (hasMed) _dot(const Color(0xFF818CF8)),
                        if (hasApt) _dot(const Color(0xFF34D399)),
                      ],
                    );
                  },
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppThemeColors.secondaryText(_b),
                  ),
                  weekendStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppThemeColors.secondaryText(_b),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 6,
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  // ── Section header ──────────────────────────────────────────────────────────

  Widget _buildSectionHeader(List<ScheduleItem> items) {
    final medCount =
        items.where((i) => i.type == ScheduleItemType.medicine).length;
    final aptCount =
        items.where((i) => i.type == ScheduleItemType.appointment).length;

    return Obx(() {
      final date = _ctrl.selectedDate.value;
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('EEEE, MMMM d').format(date),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppThemeColors.primaryText(_b),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final now = DateTime.now();
                    _ctrl.onDaySelected(now);
                    setState(() {
                      _focusedDay = now;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.40),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'Today',
                      style: TextStyle(
                        color: AppThemeColors.primaryText(_b),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (items.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  _summaryBadge('$medCount Medicines', const Color(0xFF818CF8),
                      Icons.medication_rounded),
                  const SizedBox(width: 8),
                  _summaryBadge('$aptCount Appointments',
                      const Color(0xFF34D399), Icons.person_pin_circle_rounded),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _summaryBadge(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ── Schedule list ────────────────────────────────────────────────────────────

  Widget _buildScheduleList() {
    return AnimatedBuilder(
      animation: _listAnim,
      builder: (_, child) => Opacity(
        opacity: _listAnim.value,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - _listAnim.value)),
          child: child,
        ),
      ),
      child: Obx(() {
        final items = _ctrl.itemsForSelectedDate;
        final medCtrl = Get.find<MedicineController>();

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: items.isEmpty
              ? SizedBox(
                  key: const ValueKey('empty'),
                  height: 260,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppThemeColors.glassBg(_b),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppThemeColors.glassBorder(_b)),
                          ),
                          child: const AnimatedEmptyState(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nothing scheduled',
                          style: TextStyle(
                            color: AppThemeColors.primaryText(_b),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'No medicines or appointments for this day',
                          style: TextStyle(
                            color: AppThemeColors.secondaryText(_b),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  key: ValueKey('list_${_ctrl.selectedDate.value}'),
                  children: [
                    _buildSectionHeader(items),
                    ...items.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final item = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(
                              milliseconds: 400 + (idx * 60).clamp(0, 480)),
                          curve: Curves.easeOutCubic,
                          builder: (_, v, child) => Opacity(
                            opacity: v,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - v)),
                              child: child,
                            ),
                          ),
                          child: ScheduleItemCard(
                            key: ValueKey(item.id),
                            item: item,
                            index: idx,
                            onDismissed: item.type ==
                                        ScheduleItemType.medicine &&
                                    item.status == ScheduleItemStatus.pending
                                ? () async {
                                    final med = _ctrl.findMedicine(
                                        item.id.split('_').first);
                                    if (med != null) {
                                      await medCtrl.markAsTaken(
                                          med,
                                          item.scheduledTime,
                                          item.scheduledTime);
                                    }
                                  }
                                : null,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                ),
        );
      }),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    _b = b;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppThemeColors.scaffoldBg(b),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          SafeArea(
            top: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCalendar(),
                  ),
                ),
                SliverToBoxAdapter(child: _buildScheduleList()),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
