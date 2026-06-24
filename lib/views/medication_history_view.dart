import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../view_models/medicine_controller.dart';
import '../data/models/medicine_model.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class MedicationHistoryView extends StatefulWidget {
  const MedicationHistoryView({super.key});

  @override
  State<MedicationHistoryView> createState() => _MedicationHistoryViewState();
}

class _MedicationHistoryViewState extends State<MedicationHistoryView>
    with TickerProviderStateMixin {
  static const double _itemDelayIncrement = 0.08;
  static const double _maxItemDelay = 0.60;

  Brightness _b = Brightness.dark;

  late final AnimationController _bgCtrl;
  late final AnimationController _entryCtrl;
  late final TabController _tabController;

  late final Animation<double> _headerAnim;
  late final Animation<double> _listAnim;

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

    _tabController = TabController(length: 2, vsync: this);

    _headerAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
    );
    _listAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.20, 1.0, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entryCtrl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    _b = b;
    final controller = Get.find<MedicineController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppThemeColors.primaryText(b)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Medication History",
          style: TextStyle(
              color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.bold, fontSize: 18),
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
              painter: OrbPainter(t: _bgCtrl.value, alphaMultiplier: AppThemeColors.orbAlpha(b)),
              child: const SizedBox.expand(),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Animated header / tab bar
                AnimatedBuilder(
                  animation: _headerAnim,
                  builder: (_, child) => Opacity(
                    opacity: _headerAnim.value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - _headerAnim.value)),
                      child: child,
                    ),
                  ),
                  child: _buildGlassTabBar(),
                ),
                const SizedBox(height: 16),
                // Tab views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Active tab
                      Obx(() {
                        final activeMeds = controller.medicines
                            .where((m) => m.isActive)
                            .toList();
                        if (activeMeds.isEmpty) {
                          return _buildEmptyState(
                              "No active medications found.",
                              Icons.medication_outlined);
                        }
                        return _buildAnimatedList(
                          controller: controller,
                          meds: activeMeds,
                          isActive: true,
                        );
                      }),
                      // History tab
                      Obx(() {
                        final historyMeds = controller.medicines
                            .where((m) => !m.isActive)
                            .toList();
                        if (historyMeds.isEmpty) {
                          return _buildEmptyState(
                              "No past medications found.",
                              Icons.history_rounded);
                        }
                        return _buildAnimatedList(
                          controller: controller,
                          meds: historyMeds,
                          isActive: false,
                        );
                      }),
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

  Widget _buildGlassTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppThemeColors.glassDivider(_b),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppThemeColors.glassBorder(_b), width: 1.2),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppThemeColors.glassBorder(_b),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppThemeColors.hintText(_b), width: 1),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: AppThemeColors.primaryText(_b),
          unselectedLabelColor: AppThemeColors.secondaryText(_b),
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          tabs: const [
            Tab(text: "Active"),
            Tab(text: "History"),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedList({
    required MedicineController controller,
    required List<MedicineModel> meds,
    required bool isActive,
  }) {
    return AnimatedBuilder(
      animation: _listAnim,
      builder: (_, __) => ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        itemCount: meds.length,
        itemBuilder: (context, index) {
          final itemDelay =
              (index * _itemDelayIncrement).clamp(0.0, _maxItemDelay);
          final itemProgress =
              (((_listAnim.value - itemDelay) / (1.0 - itemDelay))
                  .clamp(0.0, 1.0));
          return Opacity(
            opacity: itemProgress,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - itemProgress)),
              child: _buildMedCard(
                  context, controller, meds[index],
                  isActive: isActive),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppThemeColors.glassBg(_b),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppThemeColors.glassBorder(_b), width: 1.2),
            ),
            child:
                Icon(icon, size: 52, color: AppThemeColors.hintText(_b)),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
                color: AppThemeColors.secondaryText(_b), fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildMedCard(
    BuildContext context,
    MedicineController controller,
    MedicineModel med, {
    required bool isActive,
  }) {
    final accentColor =
        isActive ? const Color(0xFF818CF8) : AppThemeColors.hintText(_b);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(_b),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? const Color(0xFF818CF8).withValues(alpha: 0.35)
              : AppThemeColors.glassDivider(_b),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? const Color(0xFF6366F1).withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: isActive ? 0.20 : 0.10),
                border: Border.all(
                    color: accentColor.withValues(alpha: 0.40), width: 1.5),
              ),
              child: Icon(
                Icons.medication_rounded,
                color: isActive
                    ? const Color(0xFF818CF8)
                    : AppThemeColors.hintText(_b),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    med.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isActive
                          ? AppThemeColors.primaryText(_b)
                          : AppThemeColors.hintText(_b),
                      decoration: isActive ? null : TextDecoration.lineThrough,
                      decorationColor: AppThemeColors.hintText(_b),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "${med.dosage} • ${med.type}",
                    style: TextStyle(
                        fontSize: 12,
                        color: AppThemeColors.secondaryText(_b)),
                  ),
                  if (!isActive && med.dateEnded != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      "Ended: ${DateFormat('MMM dd, yyyy').format(med.dateEnded!)}",
                      style: const TextStyle(
                          color: Color(0xFFF87171), fontSize: 11),
                    ),
                  ],
                ],
              ),
            ),
            // Action
            if (isActive)
              _buildActionButton(
                icon: Icons.archive_outlined,
                color: const Color(0xFFFBBF24),
                onTap: () =>
                    _showCompleteDialog(context, controller, med),
              )
            else
              _buildActionButton(
                icon: Icons.refresh_rounded,
                color: const Color(0xFF34D399),
                onTap: () =>
                    _showReactivateDialog(context, controller, med),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: color.withValues(alpha: 0.35), width: 1),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  void _showCompleteDialog(
      BuildContext context, MedicineController controller, MedicineModel med) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: _b == Brightness.light ? Colors.white : const Color(0xFF1E1B4B),
            gradient: null,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
                color: AppThemeColors.glassBorder(_b), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3730A3).withValues(alpha: 0.40),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: const Color(0xFFFBBF24).withValues(alpha: 0.40),
                      width: 1.5),
                ),
                child: const Icon(Icons.archive_outlined,
                    color: Color(0xFFFBBF24), size: 32),
              ),
              const SizedBox(height: 20),
              Text(
                "Complete Medication?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColors.primaryText(_b),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Are you sure you want to mark '${med.name}' as completed? It will move to history.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: AppThemeColors.secondaryText(_b),
                    height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppThemeColors.glassBg(_b),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppThemeColors.glassBorder(_b),
                              width: 1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppThemeColors.secondaryText(_b)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.completeMedicine(med);
                        Get.back();
                        Get.snackbar(
                          "Archived",
                          "${med.name} moved to history.",
                          backgroundColor: const Color(0xFF4F46E5),
                          colorText: Colors.white,
                        );
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF818CF8),
                              Color(0xFF6366F1),
                              Color(0xFF4F46E5)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6366F1)
                                  .withValues(alpha: 0.40),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Complete",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SRS-92 Alternate Flow: Confirm re-activating a completed medicine
  void _showReactivateDialog(
      BuildContext context, MedicineController controller, MedicineModel med) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: _b == Brightness.light ? Colors.white : const Color(0xFF1E1B4B),
            gradient: null,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
                color: AppThemeColors.glassBorder(_b), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3730A3).withValues(alpha: 0.40),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF34D399).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: const Color(0xFF34D399).withValues(alpha: 0.40),
                      width: 1.5),
                ),
                child: const Icon(Icons.refresh_rounded,
                    color: Color(0xFF34D399), size: 32),
              ),
              const SizedBox(height: 20),
              Text(
                "Re-activate Medication?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColors.primaryText(_b),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Move '${med.name}' back to your active medications and re-enable reminders?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: AppThemeColors.secondaryText(_b),
                    height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppThemeColors.glassBg(_b),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppThemeColors.glassBorder(_b),
                              width: 1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppThemeColors.secondaryText(_b)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.reactivateMedicine(med);
                        Get.back();
                        Get.snackbar(
                          "Re-activated",
                          "${med.name} moved back to active medications.",
                          backgroundColor: const Color(0xFF34D399),
                          colorText: Colors.white,
                        );
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF34D399),
                              Color(0xFF059669),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF059669)
                                  .withValues(alpha: 0.40),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Re-activate",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
