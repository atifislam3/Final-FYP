import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../view_models/medicine_controller.dart';
import '../../view_models/appointment_controller.dart';
import '../../view_models/profile_controller.dart';
import '../../data/models/medicine_model.dart';
import '../../data/models/appointment_model.dart';
import '../widgets/animated_list_item.dart';
import '../widgets/orb_painter.dart';
import '../../utils/app_theme_colors.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with TickerProviderStateMixin {
  final MedicineController medController = Get.find<MedicineController>();
  final AppointmentController aptController = Get.find<AppointmentController>();
  final ProfileController profileController = Get.find<ProfileController>();

  late final AnimationController _bgCtrl;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
    _focusedDay = DateUtils.dateOnly(medController.selectedDate.value);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
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
          // ── 1. Gradient background ────────────────────────────────
          Container(decoration: AppThemeColors.backgroundDecoration(b)),
          // ── 2. Animated orbs ──────────────────────────────────────
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(
                t: _bgCtrl.value,
                alphaMultiplier: AppThemeColors.orbAlpha(b),
              ),
            ),
          ),
          // ── 3. Scrollable content ─────────────────────────────────
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildPremiumHeader(context),
              _buildCalendarSliver(context),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 80),
                sliver: Obx(() {
                  final todaysMeds = medController.dailyMedicines;
                  final todaysApts = aptController.appointments.where((apt) {
                    return isSameDay(
                        apt.dateTime, medController.selectedDate.value);
                  }).toList();

                  if (todaysMeds.isEmpty && todaysApts.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(b),
                    );
                  }

                  List<Widget> sections = [];
                  final morning = _filterByTime(todaysMeds, todaysApts, 5, 11);
                  final afternoon =
                      _filterByTime(todaysMeds, todaysApts, 11, 17);
                  final evening = _filterByTime(todaysMeds, todaysApts, 17, 24);

                  if (morning.isNotEmpty) {
                    sections.add(
                        _buildSectionHeader('🌅 Morning', '5AM - 11AM', b));
                    sections.addAll(_buildItems(morning, b: b));
                  }
                  if (afternoon.isNotEmpty) {
                    sections.add(
                        _buildSectionHeader('🌞 Afternoon', '11AM - 5PM', b));
                    sections.addAll(
                        _buildItems(afternoon, b: b, offset: morning.length));
                  }
                  if (evening.isNotEmpty) {
                    sections
                        .add(_buildSectionHeader('🌙 Evening', '5PM - 4AM', b));
                    sections.addAll(_buildItems(evening,
                        b: b, offset: morning.length + afternoon.length));
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => sections[index],
                      childCount: sections.length,
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Header with calendar ───────────────────────────────────────────────────

  Widget _buildPremiumHeader(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Orb decorations in header
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppThemeColors.primaryText(b).withValues(alpha: 0.04),
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: 20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppThemeColors.primaryText(b).withValues(alpha: 0.03),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('EEEE, d MMM')
                                  .format(DateTime.now())
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.8,
                                color: AppThemeColors.secondaryText(b),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Obx(() => Text(
                                  "Hi, ${profileController.currentUser.value?.fullName.split(' ')[0] ?? 'Friend'} 👋",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: AppThemeColors.primaryText(b),
                                    letterSpacing: -0.5,
                                  ),
                                )),
                            const SizedBox(height: 2),
                            Text(
                              'Stay on track today',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppThemeColors.secondaryText(b),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        // Animated Progress Ring
                        Obx(() => TweenAnimationBuilder(
                              // Key resets the animation on every date change,
                              // preventing a backward animation (e.g. 88% → 0%)
                              // that would pass near-zero values through
                              // CircularProgressIndicator(strokeCap: StrokeCap.round)
                              // and trigger a dart:ui/painting.dart assertion.
                              key: ValueKey(medController
                                  .selectedDate.value.millisecondsSinceEpoch),
                              tween: Tween<double>(
                                  begin: 0,
                                  end: medController.getDailyProgress()),
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.easeOutExpo,
                              builder: (context, double value, _) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: CircularProgressIndicator(
                                        value: 1,
                                        color: colorScheme.onSurface
                                            .withValues(alpha: 0.18),
                                        strokeWidth: 6,
                                      ),
                                    ),
                                    // Only render the coloured arc when it
                                    // has a visible size. CircularProgressIndicator
                                    // with strokeCap: StrokeCap.round throws a
                                    // dart:ui/painting.dart assertion when value
                                    // is exactly (or very close to) 0, because
                                    // Skia cannot draw a rounded-cap arc of
                                    // zero degrees.
                                    if (value > 0.01)
                                      SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: CircularProgressIndicator(
                                          value: value,
                                          color: colorScheme.tertiary,
                                          strokeWidth: 6,
                                          strokeCap: StrokeCap.round,
                                        ),
                                      ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${(value * 100).toInt()}%',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color:
                                                AppThemeColors.primaryText(b),
                                          ),
                                        ),
                                        Text(
                                          'done',
                                          style: TextStyle(
                                            fontSize: 9,
                                            color:
                                                AppThemeColors.secondaryText(b),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Calendar sliver (scrolls with content) ────────────────────────────────

  Widget _buildCalendarSliver(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(bottom: 12),
        color: Colors.transparent,
        child: Obx(() {
          final selectedDate = medController.selectedDate.value;
          final today = DateUtils.dateOnly(DateTime.now());
          return TableCalendar(
            firstDay: today.subtract(const Duration(days: 30)),
            lastDay: today.add(const Duration(days: 30)),
            focusedDay: _focusedDay,
              currentDay: today,
              calendarFormat: CalendarFormat.week,
              headerVisible: false,
              availableGestures: AvailableGestures.horizontalSwipe,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: AppThemeColors.secondaryText(b),
                  fontWeight: FontWeight.bold,
                ),
                weekendStyle: TextStyle(
                  color: AppThemeColors.secondaryText(b),
                  fontWeight: FontWeight.bold,
                ),
              ),
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppThemeColors.primaryText(b),
                ),
                weekendTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppThemeColors.primaryText(b),
                ),
                outsideTextStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppThemeColors.hintText(b),
                ),
                selectedDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.primaryContainer],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                selectedTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                todayDecoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  border: Border.all(color: colorScheme.secondary),
                ),
                todayTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppThemeColors.primaryText(b),
                ),
                defaultDecoration: BoxDecoration(
                ),
                weekendDecoration: BoxDecoration(
                ),
              ),
              eventLoader: (day) => _getEventsForDay(day),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 6,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color:
                              isSameDay(date, medController.selectedDate.value)
                                  ? colorScheme.onPrimary
                                  : colorScheme.tertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
              onDaySelected: (selected, focused) {
                if (!isSameDay(medController.selectedDate.value, selected)) {
                  medController.onDateSelected(selected);
                  _focusedDay = DateUtils.dateOnly(focused);
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = DateUtils.dateOnly(focusedDay);
              },
              selectedDayPredicate: (date) =>
                  isSameDay(medController.selectedDate.value, date),
            );
        }),
      ),
    );
  }

  // ── Item builders ─────────────────────────────────────────────────────────

  List<Widget> _buildItems(List<Map<String, dynamic>> items,
      {required Brightness b, int offset = 0}) {
    return List.generate(items.length, (index) {
      final item = items[index];
      final child = item['type'] == 'medicine'
          ? _buildMedicineCard(item['data'], item['time'], b)
          : _buildAppointmentCard(item['data'], b);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: AnimatedListItem(
          index: offset + index,
          child: child,
        ),
      );
    });
  }

  Widget _buildSectionHeader(String title, String subtitle, Brightness b) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppThemeColors.glassBg(b),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppThemeColors.glassBorder(b)),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppThemeColors.primaryText(b),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppThemeColors.secondaryText(b),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineCard(
      MedicineModel med, DateTime timeSlot, Brightness b) {
    String? doseStatus = medController.getDoseStatus(
        med.medicineId, medController.selectedDate.value, timeSlot);
    bool isTaken = doseStatus == 'Taken';
    bool isSkipped = doseStatus == 'Skipped';

    final statusColor = isTaken
        ? const Color(0xFF34D399)
        : isSkipped
            ? const Color(0xFFF87171)
            : const Color(0xFF818CF8);

    // Medicines on past days are read-only — the user cannot mark them taken.
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final selDate = medController.selectedDate.value;
    final selDateOnly = DateTime(selDate.year, selDate.month, selDate.day);
    final isPastDay = selDateOnly.isBefore(todayDate);

    final typeColors = {
      'Tablet': const Color(0xFF60A5FA),
      'Capsule': const Color(0xFFC084FC),
      'Syrup': const Color(0xFFFB923C),
      'Injection': const Color(0xFFF87171),
    };
    final accentColor = typeColors[med.type] ?? const Color(0xFF818CF8);

    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: (isTaken || isSkipped)
              ? statusColor.withValues(alpha: 0.35)
              : AppThemeColors.glassBorder(b),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3730A3).withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Left accent bar
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 4, color: accentColor),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isPastDay
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        _showDoseOptions(context, med, timeSlot, doseStatus, b);
                      },
                borderRadius: BorderRadius.circular(24),
                splashColor: AppThemeColors.glassBorder(b),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                  child: Row(
                    children: [
                      // Time column
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('h:mm').format(timeSlot),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppThemeColors.primaryText(b),
                            ),
                          ),
                          Text(
                            DateFormat('a').format(timeSlot),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppThemeColors.secondaryText(b),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppThemeColors.glassBorder(b),
                      ),
                      const SizedBox(width: 16),
                      // Main content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              med.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: (isTaken || isSkipped)
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: (isTaken || isSkipped)
                                    ? AppThemeColors.hintText(b)
                                    : AppThemeColors.primaryText(b),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.monitor_weight_outlined,
                                    size: 14,
                                    color: AppThemeColors.secondaryText(b)),
                                const SizedBox(width: 4),
                                Text(
                                  med.dosage,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppThemeColors.secondaryText(b),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Checkbox
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: (isTaken || isSkipped)
                              ? statusColor
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: (isTaken || isSkipped)
                                ? statusColor
                                : AppThemeColors.glassBorder(b)
                                    .withValues(alpha: 0.6),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withValues(
                                  alpha: (isTaken || isSkipped) ? 0.40 : 0.0),
                              blurRadius: (isTaken || isSkipped) ? 8 : 0,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: (isTaken || isSkipped)
                            ? Icon(isTaken ? Icons.check : Icons.close,
                                color: Colors.white, size: 18)
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel apt, Brightness b) {
    final categoryColors = {
      'General': const Color(0xFF60A5FA),
      'Dentist': const Color(0xFF34D399),
      'Cardiology': const Color(0xFFF87171),
      'Dermatology': const Color(0xFFFB923C),
      'Therapy': const Color(0xFFC084FC),
    };
    final color = categoryColors[apt.category] ?? const Color(0xFF818CF8);

    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withValues(alpha: 0.30),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.calendar_month_rounded, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appointment: ${DateFormat('h:mm a').format(apt.dateTime)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    apt.doctorName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppThemeColors.primaryText(b),
                    ),
                  ),
                  Text(
                    apt.category,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppThemeColors.secondaryText(b),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Brightness b) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppThemeColors.glassBg(b),
              border: Border.all(color: AppThemeColors.glassBorder(b)),
            ),
            child: const Icon(Icons.spa_outlined,
                size: 60, color: Color(0xFF34D399)),
          ),
          const SizedBox(height: 20),
          Text(
            'All Clear for Today!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppThemeColors.primaryText(b),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No medicines or appointments.',
            style: TextStyle(
              color: AppThemeColors.secondaryText(b),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ── Logic helpers ─────────────────────────────────────────────────────────

  List<Map<String, dynamic>> _filterByTime(List<MedicineModel> allMeds,
      List<AppointmentModel> allApts, int startHour, int endHour) {
    List<Map<String, dynamic>> items = [];
    for (var med in allMeds) {
      for (var time in med.reminderTimes) {
        bool isInRange = (startHour < endHour)
            ? (time.hour >= startHour && time.hour < endHour)
            : (time.hour >= startHour || time.hour < 4);
        if (isInRange) {
          items.add({'type': 'medicine', 'data': med, 'time': time});
        }
      }
    }
    for (var apt in allApts) {
      bool isInRange = (startHour < endHour)
          ? (apt.dateTime.hour >= startHour && apt.dateTime.hour < endHour)
          : (apt.dateTime.hour >= startHour || apt.dateTime.hour < 4);
      if (isInRange) {
        items.add({'type': 'appointment', 'data': apt, 'time': apt.dateTime});
      }
    }
    items.sort((a, b) {
      DateTime t1 = a['time'] is DateTime
          ? a['time']
          : DateTime(2000, 1, 1, (a['time'] as TimeOfDay).hour,
              (a['time'] as TimeOfDay).minute);
      DateTime t2 = b['time'] is DateTime
          ? b['time']
          : DateTime(2000, 1, 1, (b['time'] as TimeOfDay).hour,
              (b['time'] as TimeOfDay).minute);
      return (t1.hour * 60 + t1.minute).compareTo(t2.hour * 60 + t2.minute);
    });
    return items;
  }

  List<String> _getEventsForDay(DateTime day) {
    try {
      final hasMedicines = medController.medicines
          .any((med) => medController.isScheduledForDate(med, day));

      final hasAppointments =
          aptController.appointments.any((apt) => isSameDay(apt.dateTime, day));

      if (hasMedicines || hasAppointments) return ['event'];
      return [];
    } catch (e, st) {
      debugPrint('⚠️ _getEventsForDay error for $day: $e');
      debugPrint(st.toString());
      return [];
    }
  }

  void _showDoseOptions(BuildContext context, MedicineModel med,
      DateTime timeSlot, String? doseStatus, Brightness b) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            color: b == Brightness.dark
                ? const Color(0xFF1E1040)
                : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border:
                Border.all(color: AppThemeColors.glassBorder(b), width: 1.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppThemeColors.glassBorder(b),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Mark Status',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColors.primaryText(b),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${med.name} at ${DateFormat('h:mm a').format(timeSlot)}',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF818CF8),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Missed Button
                  _buildStatusOption(
                    icon: Icons.close_rounded,
                    label: 'Missed',
                    color: const Color(0xFFF87171),
                    isSelected: doseStatus == 'Skipped',
                    b: b,
                    onTap: () {
                      medController.markAsSkipped(med, timeSlot);
                      Navigator.pop(ctx);
                    },
                  ),
                  if (doseStatus != null) ...[
                    const SizedBox(width: 32),
                    // Clear Button
                    _buildStatusOption(
                      icon: Icons.undo_rounded,
                      label: 'Clear',
                      color: AppThemeColors.secondaryText(b),
                      isSelected: false,
                      b: b,
                      onTap: () {
                        medController.clearDoseLog(
                            med, medController.selectedDate.value, timeSlot);
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                  const SizedBox(width: 32),
                  // Taken Button
                  _buildStatusOption(
                    icon: Icons.check_rounded,
                    label: 'Taken',
                    color: const Color(0xFF34D399),
                    isSelected: doseStatus == 'Taken',
                    b: b,
                    onTap: () {
                      medController.markAsTaken(
                          med, medController.selectedDate.value, timeSlot);
                      Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption({
    required IconData icon,
    required String label,
    required Color color,
    required bool isSelected,
    required Brightness b,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.2)
                  : color.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? color : color.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: AppThemeColors.primaryText(b),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
