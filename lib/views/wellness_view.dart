import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../view_models/wellness_controller.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class WellnessView extends StatefulWidget {
  const WellnessView({super.key});

  @override
  State<WellnessView> createState() => _WellnessViewState();
}

class _WellnessViewState extends State<WellnessView>
    with TickerProviderStateMixin {
  Brightness _b = Brightness.dark;

  late AnimationController bgCtrl;
  late AnimationController entryCtrl;
  late TabController tabController;
  final WellnessController controller = Get.put(WellnessController());

  @override
  void initState() {
    super.initState();
    bgCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4000))
      ..repeat(reverse: true);
    entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    bgCtrl.dispose();
    entryCtrl.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    _b = b;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppThemeColors.scaffoldBg(b).withValues(alpha: 0.92),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Wellness & Mood",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppThemeColors.primaryText(_b),
              fontSize: 20),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Container(
              decoration: BoxDecoration(
                color: AppThemeColors.glassBg(_b),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppThemeColors.glassBorder(_b), width: 1.2),
              ),
              child: TabBar(
                controller: tabController,
                tabs: const [
                  Tab(text: "Journal", icon: Icon(Icons.spa_rounded, size: 18)),
                  Tab(
                      text: "Motivation",
                      icon:
                          Icon(Icons.local_fire_department_rounded, size: 18)),
                ],
                indicator: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF818CF8),
                      Color(0xFF6366F1),
                      Color(0xFF4F46E5)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: AppThemeColors.primaryText(_b),
                unselectedLabelColor: AppThemeColors.secondaryText(_b),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(decoration: AppThemeColors.backgroundDecoration(b)),
          AnimatedBuilder(
            animation: bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(
                  t: bgCtrl.value, alphaMultiplier: AppThemeColors.orbAlpha(b)),
              size: Size.infinite,
            ),
          ),
          SafeArea(
            child: TabBarView(
              controller: tabController,
              children: [_buildJournalTab(), _buildMotivationTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalTab() {
    final moods = [
      {'label': 'Happy', 'emoji': '😊'},
      {'label': 'Neutral', 'emoji': '😐'},
      {'label': 'Sad', 'emoji': '😔'},
      {'label': 'Stressed', 'emoji': '😫'},
      {'label': 'Energetic', 'emoji': '🤩'},
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      physics: const BouncingScrollPhysics(),
      children: [
        Text("How do you feel today?",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppThemeColors.primaryText(_b))),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: moods.map((m) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Obx(() {
                  final isSelected = controller.dailyMood.value == m['label'];
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      controller.dailyMood.value = m['label'] as String;
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(colors: [
                                Color(0xFF818CF8),
                                Color(0xFF6366F1),
                                Color(0xFF4F46E5)
                              ])
                            : null,
                        color: isSelected ? null : AppThemeColors.glassBg(_b),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : AppThemeColors.glassBorder(_b),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1)
                                .withValues(alpha: isSelected ? 0.40 : 0.0),
                            blurRadius: isSelected ? 12 : 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          AnimatedScale(
                            scale: isSelected ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Text(m['emoji'] as String,
                                style: const TextStyle(fontSize: 36)),
                          ),
                          const SizedBox(height: 4),
                          Text(m['label'] as String,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: AppThemeColors.primaryText(_b),
                                fontSize: 12,
                              )),
                        ],
                      ),
                    ),
                  );
                }),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: AppThemeColors.glassBg(_b),
            borderRadius: BorderRadius.circular(24),
            border:
                Border.all(color: AppThemeColors.glassBorder(_b), width: 1.2),
          ),
          child: TextField(
            onChanged: (val) => controller.noteController.value = val,
            maxLines: 4,
            style:
                TextStyle(color: AppThemeColors.primaryText(_b), fontSize: 15),
            decoration: InputDecoration(
              hintText: "Add a note about your day (optional)...",
              hintStyle: TextStyle(color: AppThemeColors.hintText(_b)),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            if (controller.dailyMood.value.isEmpty) {
              Get.snackbar("Required", "Please select a mood first",
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(20),
                  backgroundColor: AppThemeColors.glassBorder(_b),
                  colorText: Colors.white);
              return;
            }
            controller.addEntry(
                controller.dailyMood.value, controller.noteController.value);
          },
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF818CF8),
                  Color(0xFF6366F1),
                  Color(0xFF4F46E5)
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.40),
                    blurRadius: 16,
                    offset: const Offset(0, 6))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.check_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text("Log to Journal",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            const Icon(Icons.history_rounded,
                size: 20, color: Color(0xFF818CF8)),
            const SizedBox(width: 8),
            Text("Recent Entries",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppThemeColors.primaryText(_b))),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.journalHistory.isEmpty) return _buildEmptyHistory();
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.journalHistory.length,
            itemBuilder: (context, index) =>
                _buildTimelineItem(controller.journalHistory[index], index),
          );
        }),
      ],
    );
  }

  Widget _buildTimelineItem(dynamic entry, int index) {
    return GestureDetector(
        onTap: () => _showEditEntrySheet(context, entry),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppThemeColors.glassBg(_b),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppThemeColors.glassBorder(_b), width: 1.2),
                    ),
                    child: Text(_getEmojiForMood(entry.mood),
                        style: const TextStyle(fontSize: 22)),
                  ),
                  if (index < controller.journalHistory.length - 1)
                    Container(
                        width: 2,
                        height: 40,
                        color: AppThemeColors.glassBorder(_b)),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppThemeColors.glassBg(_b),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: AppThemeColors.glassBorder(_b), width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.mood,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppThemeColors.primaryText(_b))),
                          Text(DateFormat('MMM d, h:mm a').format(entry.date),
                              style: TextStyle(
                                  color: AppThemeColors.secondaryText(_b),
                                  fontSize: 12)),
                        ],
                      ),
                      if (entry.note != null && entry.note!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(entry.note!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppThemeColors.secondaryText(_b))),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _showEditEntrySheet(BuildContext context, dynamic entry) {
    final noteController = TextEditingController(text: entry.note);
    String selectedMood = entry.mood;

    final moods = [
      {'label': 'Happy', 'emoji': '😊'},
      {'label': 'Neutral', 'emoji': '😐'},
      {'label': 'Sad', 'emoji': '😔'},
      {'label': 'Stressed', 'emoji': '😫'},
      {'label': 'Energetic', 'emoji': '🤩'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
                top: 24,
                left: 20,
                right: 20),
            decoration: BoxDecoration(
              color: AppThemeColors.glassBg(_b),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border:
                  Border.all(color: AppThemeColors.glassBorder(_b), width: 1.2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                        color: AppThemeColors.glassBorder(_b),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Text("Edit Journal Entry",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppThemeColors.primaryText(_b))),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: moods.map((m) {
                      final isSelected = selectedMood == m['label'];
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => selectedMood = m['label'] as String);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(colors: [
                                    Color(0xFF818CF8),
                                    Color(0xFF6366F1),
                                    Color(0xFF4F46E5)
                                  ])
                                : null,
                            color: isSelected
                                ? null
                                : AppThemeColors.glassDivider(_b),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : AppThemeColors.glassBorder(_b)),
                          ),
                          child: Column(
                            children: [
                              Text(m['emoji'] as String,
                                  style: const TextStyle(fontSize: 28)),
                              Text(m['label'] as String,
                                  style: TextStyle(
                                      color: AppThemeColors.primaryText(_b),
                                      fontSize: 10)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: AppThemeColors.glassDivider(_b),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppThemeColors.glassBorder(_b)),
                  ),
                  child: TextField(
                    controller: noteController,
                    maxLines: 3,
                    style: TextStyle(color: AppThemeColors.primaryText(_b)),
                    decoration: InputDecoration(
                      hintText: "Update your note...",
                      hintStyle: TextStyle(color: AppThemeColors.hintText(_b)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.deleteEntry(entry.id);
                          Get.back();
                        },
                        child: Container(
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFF87171).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: const Color(0xFFF87171)
                                    .withValues(alpha: 0.3)),
                          ),
                          child: const Text("Delete",
                              style: TextStyle(
                                  color: Color(0xFFF87171),
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          entry.mood = selectedMood;
                          entry.note = noteController.text.trim();
                          controller.updateEntry(entry);
                          Get.back();
                        },
                        child: Container(
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color(0xFF818CF8),
                              Color(0xFF6366F1),
                              Color(0xFF4F46E5)
                            ]),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text("Save",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildEmptyHistory() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppThemeColors.glassBg(_b),
                shape: BoxShape.circle,
                border: Border.all(color: AppThemeColors.glassBorder(_b)),
              ),
              child: Icon(Icons.history_edu,
                  size: 40, color: AppThemeColors.hintText(_b)),
            ),
            const SizedBox(height: 16),
            Text("No entries yet",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppThemeColors.primaryText(_b))),
            const SizedBox(height: 4),
            Text("Start logging your mood to see trends!",
                style: TextStyle(color: AppThemeColors.secondaryText(_b))),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      physics: const BouncingScrollPhysics(),
      children: [
        _StreakCounter(controller: controller),
        const SizedBox(height: 32),
        Row(
          children: [
            Icon(Icons.emoji_events_rounded, color: Color(0xFF818CF8)),
            SizedBox(width: 8),
            Text("Daily Challenge",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppThemeColors.primaryText(_b))),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => Container(
              decoration: BoxDecoration(
                color: AppThemeColors.glassBg(_b),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: AppThemeColors.glassBorder(_b), width: 1.2),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF818CF8),
                          Color(0xFF6366F1),
                          Color(0xFF4F46E5)
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text("Today's Challenge",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        if (controller.isChallengeLoading.value)
                          const CircularProgressIndicator(
                              color: Color(0xFF818CF8))
                        else
                          Text(controller.dailyChallenge.value,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  color: Color(0xFF34D399))),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: controller.generateDailyChallenge,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppThemeColors.glassDivider(_b),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppThemeColors.glassBorder(_b)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.refresh_rounded,
                                    color: AppThemeColors.secondaryText(_b),
                                    size: 18),
                                const SizedBox(width: 8),
                                Text("New Challenge",
                                    style: TextStyle(
                                        color: AppThemeColors.primaryText(_b),
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  String _getEmojiForMood(String mood) {
    switch (mood) {
      case 'Happy':
        return '😊';
      case 'Neutral':
        return '😐';
      case 'Sad':
        return '😔';
      case 'Stressed':
        return '😫';
      case 'Energetic':
        return '🤩';
      default:
        return '🙂';
    }
  }
}

class _StreakCounter extends StatefulWidget {
  final WellnessController controller;
  const _StreakCounter({required this.controller});

  @override
  State<_StreakCounter> createState() => _StreakCounterState();
}

class _StreakCounterState extends State<_StreakCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;
  Brightness _b = Brightness.dark;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _b = AppThemeColors.brightnessOf(context);
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, child) => Transform.scale(scale: _pulse.value, child: child),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: AppThemeColors.glassBg(_b),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppThemeColors.glassBorder(_b), width: 1.2),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF34D399).withValues(alpha: 0.12),
                blurRadius: 32,
                spreadRadius: 4)
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppThemeColors.glassBg(_b),
                border: Border.all(
                    color: const Color(0xFF34D399).withValues(alpha: 0.50),
                    width: 2),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF34D399).withValues(alpha: 0.25),
                      blurRadius: 20,
                      spreadRadius: 4)
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Text("${widget.controller.currentStreak.value}",
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: AppThemeColors.primaryText(_b),
                          height: 1.0))),
                  const Text("DAYS",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: Color(0xFF34D399))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Icon(Icons.local_fire_department_rounded,
                color: Color(0xFF34D399), size: 28),
            const SizedBox(height: 8),
            Text("CURRENT STREAK",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: AppThemeColors.secondaryText(_b))),
          ],
        ),
      ),
    );
  }
}
