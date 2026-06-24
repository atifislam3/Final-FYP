import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../view_models/analytics_controller.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView>
    with TickerProviderStateMixin {
  late final AnalyticsController _controller;
  Brightness _b = Brightness.dark;

  late AnimationController _bgCtrl;
  late AnimationController _entryCtrl;
  late Animation<double> _headerAnim;
  late Animation<double> _card1Anim;
  late Animation<double> _card2Anim;
  late Animation<double> _card3Anim;
  late Animation<double> _card4Anim;
  late Animation<double> _card5Anim;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(AnalyticsController());

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _headerAnim = _buildAnim(0.00, 0.35);
    _card1Anim = _buildAnim(0.15, 0.50);
    _card2Anim = _buildAnim(0.28, 0.63);
    _card3Anim = _buildAnim(0.40, 0.75);
    _card4Anim = _buildAnim(0.52, 0.87);
    _card5Anim = _buildAnim(0.63, 1.00);
  }

  Animation<double> _buildAnim(double start, double end) => CurvedAnimation(
        parent: _entryCtrl,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      );

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
    return Scaffold(
      backgroundColor: AppThemeColors.scaffoldBg(b),
      body: AnimatedBuilder(
        animation: _bgCtrl,
        builder: (_, __) => Stack(
          children: [
            // Gradient background
            Container(decoration: AppThemeColors.backgroundDecoration(b)),
            // Animated orbs
            CustomPaint(
              painter: OrbPainter(t: _bgCtrl.value),
              child: const SizedBox.expand(),
            ),
            // Content
            SafeArea(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // AppBar
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: AppThemeColors.primaryText(_b)),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Health Analytics",
            style: TextStyle(
              color: AppThemeColors.primaryText(_b),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => _controller.refreshData(),
            color: Colors.white,
            backgroundColor: const Color(0xFF4F46E5),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AnimFade(anim: _headerAnim, child: _buildHeader()),
                  const SizedBox(height: 20),
                  _AnimFade(anim: _headerAnim, child: _buildFilterBar()),
                  const SizedBox(height: 28),
                  _AnimFade(
                    anim: _card1Anim,
                    child: _buildSection("Adherence Overview",
                        Icons.pie_chart_rounded, _buildAdherenceChart()),
                  ),
                  const SizedBox(height: 24),
                  _AnimFade(
                    anim: _card2Anim,
                    child: _buildSection("Weekly Activity",
                        Icons.bar_chart_rounded, _buildWeeklyChart()),
                  ),
                  const SizedBox(height: 24),
                  _AnimFade(
                    anim: _card3Anim,
                    child: _buildSection("Missed Doses Report",
                        Icons.warning_amber_rounded, _buildMissedReport()),
                  ),
                  const SizedBox(height: 24),
                  _AnimFade(
                    anim: _card4Anim,
                    child: _buildSection("Monthly Summary",
                        Icons.calendar_month_rounded, _buildMonthlyChart()),
                  ),
                  const SizedBox(height: 24),
                  _AnimFade(
                    anim: _card5Anim,
                    child: _buildSection("Irregular Intake",
                        Icons.report_problem_rounded,
                        _buildIrregularIntake()),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      final data = _controller.getStatusDistribution();
      final taken = (data['Taken'] ?? 0).toInt();
      final missed = (data['Missed'] ?? 0).toInt();
      final total = taken + missed;
      final pct = total > 0 ? ((taken / total) * 100).round() : 0;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: _glassDecoration(),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ADHERENCE RATE",
                    style: TextStyle(
                      color: AppThemeColors.secondaryText(_b),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "$pct%",
                    style: TextStyle(
                      color: AppThemeColors.primaryText(_b),
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$taken taken · $missed missed",
                    style: TextStyle(
                      color: AppThemeColors.secondaryText(_b),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF34D399), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF34D399).withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.favorite_rounded,
                  color: Colors.white, size: 30),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSection(String title, IconData icon, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF818CF8), size: 18),
            const SizedBox(width: 8),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                color: AppThemeColors.secondaryText(_b),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  // --- PIE CHART ---
  Widget _buildAdherenceChart() {
    return Obx(() {
      final data = _controller.getStatusDistribution();
      final taken = data['Taken'] ?? 0;
      final missed = data['Missed'] ?? 0;
      final total = taken + missed;

      if (total == 0) return _emptyState("No data available yet");

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: _glassDecoration(),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 44,
                        sections: [
                          PieChartSectionData(
                            color: const Color(0xFF34D399),
                            value: taken,
                            title:
                                '${((taken / total) * 100).toStringAsFixed(0)}%',
                            radius: 54,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: const Color(0xFFF87171),
                            value: missed,
                            title:
                                '${((missed / total) * 100).toStringAsFixed(0)}%',
                            radius: 54,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _legendPill(
                          const Color(0xFF34D399), "Taken", taken.toInt()),
                      const SizedBox(height: 10),
                      _legendPill(
                          const Color(0xFFF87171), "Missed", missed.toInt()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _legendPill(Color color, String label, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.40), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            "$label  $count",
            style: TextStyle(
              color: AppThemeColors.primaryText(_b),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // --- BAR CHART ---
  Widget _buildWeeklyChart() {
    return Obx(() {
      final counts = _controller.getDailyTakenCounts();
      final hasData = counts.values.any((v) => v > 0);

      if (!hasData) return _emptyState("Start taking logs to see trends");

      return Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        decoration: _glassDecoration(),
        child: SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppThemeColors.glassBg(_b),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final daysAgo = 6 - value.toInt();
                      final date =
                          DateTime.now().subtract(Duration(days: daysAgo));
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('E').format(date)[0],
                          style: TextStyle(
                            color: AppThemeColors.secondaryText(_b),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(7, (index) {
                final daysAgo = 6 - index;
                final count = counts[daysAgo] ?? 0;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: count.toDouble(),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      width: 18,
                      borderRadius: BorderRadius.circular(6),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: (counts.values.isEmpty
                                ? 1
                                : counts.values
                                    .reduce(math.max)
                                    .toDouble()) +
                            1,
                        color: AppThemeColors.glassBg(_b),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      );
    });
  }

  // --- MISSED REPORT ---
  Widget _buildMissedReport() {
    return Obx(() {
      final missedLogs = _controller.getMissedDoses();

      if (missedLogs.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: _glassDecoration(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF34D399).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_outline_rounded,
                    size: 40, color: Color(0xFF34D399)),
              ),
              const SizedBox(height: 14),
              Text(
                "Great job! No missed doses.",
                style: TextStyle(
                  color: AppThemeColors.primaryText(_b),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "You're staying on track with your medication",
                style: TextStyle(
                  color: AppThemeColors.secondaryText(_b),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: missedLogs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final log = missedLogs[index];
          final medName = _controller.getMedicineName(log.medicineId);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppThemeColors.glassBg(_b),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFF87171).withValues(alpha: 0.25),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3730A3).withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF87171).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.warning_amber_rounded,
                      color: Color(0xFFF87171), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medName,
                        style: TextStyle(
                          color: AppThemeColors.primaryText(_b),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('MMM dd • hh:mm a')
                            .format(log.scheduledTime),
                        style: TextStyle(
                          color: AppThemeColors.secondaryText(_b),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF87171).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    log.status,
                    style: const TextStyle(
                      color: Color(0xFFFCA5A5),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  // --- MONTHLY CHART (SRS-150) ---
  Widget _buildMonthlyChart() {
    return Obx(() {
      final weekData = _controller.getMonthlyWeeklyCounts();
      final hasData =
          weekData.values.any((w) => (w['taken'] ?? 0) + (w['missed'] ?? 0) > 0);

      if (!hasData) return _emptyState("No data for the last 4 weeks");

      final maxVal = weekData.values
          .map((w) => (w['taken'] ?? 0) + (w['missed'] ?? 0))
          .fold<int>(0, (a, b) => a > b ? a : b)
          .toDouble();

      final weekLabels = ['3w ago', '2w ago', '1w ago', 'This wk'];

      return Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        decoration: _glassDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Legend
            Row(
              children: [
                _legendPill(const Color(0xFF34D399), "Taken",
                    weekData.values.fold(0, (s, w) => s + (w['taken'] ?? 0))),
                const SizedBox(width: 8),
                _legendPill(const Color(0xFFF87171), "Missed",
                    weekData.values.fold(0, (s, w) => s + (w['missed'] ?? 0))),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  groupsSpace: 14,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: AppThemeColors.glassBg(_b),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final i = value.toInt();
                          if (i < 0 || i >= weekLabels.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              weekLabels[i],
                              style: TextStyle(
                                color: AppThemeColors.secondaryText(_b),
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(4, (i) {
                    final taken = (weekData[i]?['taken'] ?? 0).toDouble();
                    final missed = (weekData[i]?['missed'] ?? 0).toDouble();
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: taken,
                          color: const Color(0xFF34D399),
                          width: 14,
                          borderRadius: BorderRadius.circular(5),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxVal + 1,
                            color: AppThemeColors.glassBg(_b),
                          ),
                        ),
                        BarChartRodData(
                          toY: missed,
                          color: const Color(0xFFF87171),
                          width: 14,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // --- IRREGULAR INTAKE (SRS-147) ---
  Widget _buildIrregularIntake() {
    return Obx(() {
      final irregular = _controller.getIrregularMedicines();

      if (irregular.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: _glassDecoration(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF34D399).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_outline_rounded,
                    size: 36, color: Color(0xFF34D399)),
              ),
              const SizedBox(height: 12),
              Text(
                "No irregular intake detected",
                style: TextStyle(
                  color: AppThemeColors.primaryText(_b),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "All medicines taken with >70% adherence this month",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppThemeColors.secondaryText(_b),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        children: irregular.map((item) {
          final pct = ((item['missedRate'] as double) * 100).round();
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppThemeColors.glassBg(_b),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFFFBBF24).withValues(alpha: 0.35),
                  width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.trending_down_rounded,
                      color: Color(0xFFFBBF24), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'] as String,
                        style: TextStyle(
                          color: AppThemeColors.primaryText(_b),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${item['missed']} of ${item['total']} doses missed",
                        style: TextStyle(
                          color: AppThemeColors.secondaryText(_b),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBBF24).withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "$pct% missed",
                    style: const TextStyle(
                      color: Color(0xFFFBBF24),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildFilterBar() {
    return Obx(() {
      final selectedMed = _controller.selectedMedicineId.value;
      final selectedPer = _controller.selectedPeriod.value;

      return Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: _glassDecoration().copyWith(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.medication_rounded, size: 18, color: AppThemeColors.secondaryText(_b)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMed,
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppThemeColors.secondaryText(_b)),
                        dropdownColor: AppThemeColors.scaffoldBg(_b),
                        items: [
                          DropdownMenuItem(
                            value: 'All',
                            child: Text('All Medicines',
                                style: TextStyle(color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.w500)),
                          ),
                          ..._controller.medicines.map((m) => DropdownMenuItem(
                                value: m.medicineId,
                                child: Text(m.name,
                                    style: TextStyle(
                                        color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.w500)),
                              )),
                        ],
                        onChanged: (val) {
                          if (val != null) _controller.setFilterMedicine(val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: _glassDecoration().copyWith(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.date_range_rounded, size: 18, color: AppThemeColors.secondaryText(_b)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPer,
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppThemeColors.secondaryText(_b)),
                        dropdownColor: AppThemeColors.scaffoldBg(_b),
                        items: ['All', 'Daily', 'Weekly', 'Monthly']
                            .map((p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p,
                                      style: TextStyle(
                                          color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.w500)),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) _controller.setFilterPeriod(val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _emptyState(String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: _glassDecoration(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppThemeColors.glassBg(_b),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.medication_rounded,
                size: 36, color: AppThemeColors.hintText(_b)),
          ),
          const SizedBox(height: 14),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppThemeColors.secondaryText(_b),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _glassDecoration() => BoxDecoration(
        color: AppThemeColors.glassBg(_b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppThemeColors.glassBorder(_b),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3730A3).withValues(alpha: 0.20),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      );
}

class _AnimFade extends StatelessWidget {
  final Animation<double> anim;
  final Widget child;
  const _AnimFade({required this.anim, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, (1 - anim.value) * 24),
          child: child,
        ),
      ),
    );
  }
}
