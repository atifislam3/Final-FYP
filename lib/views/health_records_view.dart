import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/profile_controller.dart';
import '../view_models/medicine_controller.dart';
import '../data/models/user_model.dart';
import 'medication_history_view.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class HealthRecordsView extends StatefulWidget {
  const HealthRecordsView({super.key});

  @override
  State<HealthRecordsView> createState() => _HealthRecordsViewState();
}

class _HealthRecordsViewState extends State<HealthRecordsView>
    with TickerProviderStateMixin {
  Brightness _b = Brightness.dark;

  late final AnimationController _bgCtrl;
  late final AnimationController _entryCtrl;
  late final Animation<double> _bgAnim;

  // stagger animations per section
  late final Animation<double> _s0; // vitals
  late final Animation<double> _s1; // chronic
  late final Animation<double> _s2; // allergies
  late final Animation<double> _s3; // restraints
  late final Animation<double> _s4; // current meds
  late final Animation<double> _s5; // past meds

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4000))
      ..repeat(reverse: true);
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100))
      ..forward();
    _bgAnim = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);

    _s0 = _interval(0.00, 0.45);
    _s1 = _interval(0.12, 0.55);
    _s2 = _interval(0.24, 0.65);
    _s3 = _interval(0.36, 0.75);
    _s4 = _interval(0.48, 0.85);
    _s5 = _interval(0.60, 0.95);
  }

  Animation<double> _interval(double start, double end) => CurvedAnimation(
        parent: _entryCtrl,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      );

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  // ── design tokens ─────────────────────────────────────────────────────────


  BoxDecoration get _glassCard => BoxDecoration(
        color: AppThemeColors.glassBg(_b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppThemeColors.glassBorder(_b), width: 1.2),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.18),
              blurRadius: 18,
              offset: const Offset(0, 6)),
        ],
      );

  Widget _sectionLabel(String text) => Text(
        text,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
            color: AppThemeColors.secondaryText(_b)),
      );

  Widget _staggered(Animation<double> anim, Widget child) => AnimatedBuilder(
        animation: anim,
        builder: (_, __) => Opacity(
          opacity: anim.value.clamp(0.0, 1.0),
          child: Transform.translate(
              offset: Offset(0, 28 * (1 - anim.value)), child: child),
        ),
        child: child,
      );

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    _b = b;
    final controller = Get.find<ProfileController>();
    final medController = Get.find<MedicineController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppThemeColors.primaryText(b)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Health Records",
          style: TextStyle(
              color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Get.to(() => const MedicationHistoryView()),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppThemeColors.glassDivider(_b),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppThemeColors.glassBorder(_b)),
                ),
                child: Icon(Icons.history_edu_rounded,
                    color: AppThemeColors.primaryText(_b), size: 20),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(decoration: AppThemeColors.backgroundDecoration(_b)),
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(
                  t: _bgAnim.value, alphaMultiplier: AppThemeColors.orbAlpha(_b)),
              size: Size.infinite,
            ),
          ),
          SafeArea(
            child: Obx(() {
              final user = controller.currentUser.value;
              if (user == null) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              }
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: Column(
                        children: [
                          // ── icon badge ──────────────────────────────
                          Center(
                            child: Container(
                              width: 72,
                              height: 72,
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFF472B6),
                                    Color(0xFF818CF8),
                                    Color(0xFF4F46E5),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0xFF4F46E5)
                                          .withValues(alpha: 0.45),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8)),
                                ],
                              ),
                              child: const Icon(Icons.monitor_heart_rounded,
                                  color: Colors.white, size: 34),
                            ),
                          ),

                          // ── Vitals card ──────────────────────────────
                          _staggered(_s0, _buildVitalsCard(user)),
                          const SizedBox(height: 20),

                          // ── Chronic illnesses ─────────────────────────
                          _staggered(
                            _s1,
                            _buildListSection(
                              title: "CHRONIC ILLNESSES",
                              icon: Icons.personal_injury_rounded,
                              accentColor: const Color(0xFFF87171),
                              items: user.chronicIllnesses,
                              onAdd: () => _showAddDialog(
                                  context, "Chronic Illness",
                                  (v) => controller.addIllness(v)),
                              onDelete: (v) => controller.removeIllness(v),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── Allergies ─────────────────────────────────
                          _staggered(
                            _s2,
                            _buildListSection(
                              title: "ALLERGIES",
                              icon: Icons.warning_amber_rounded,
                              accentColor: const Color(0xFFFBBF24),
                              items: user.allergies,
                              onAdd: () => _showAddDialog(
                                  context, "Allergy",
                                  (v) => controller.addAllergy(v)),
                              onDelete: (v) => controller.removeAllergy(v),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── Restraints ────────────────────────────────
                          _staggered(
                            _s3,
                            _buildListSection(
                              title: "RESTRAINTS & RESTRICTIONS",
                              icon: Icons.do_not_touch_rounded,
                              accentColor: const Color(0xFFC084FC),
                              items: user.restraints,
                              onAdd: () => _showAddDialog(
                                  context, "Restraint",
                                  (v) => controller.addRestraint(v)),
                              onDelete: (v) => controller.removeRestraint(v),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── Current medications ───────────────────────
                          _staggered(
                            _s4,
                            _buildMedicationsCard(medController, showActive: true),
                          ),
                          const SizedBox(height: 20),

                          // ── Past medications ──────────────────────────
                          _staggered(
                            _s5,
                            _buildMedicationsCard(medController,
                                showActive: false),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Vitals card ────────────────────────────────────────────────────────────

  Widget _buildVitalsCard(UserModel user) {
    return Container(
      decoration: _glassCard,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF472B6).withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.monitor_heart_rounded,
                    color: Color(0xFFF472B6), size: 18),
              ),
              const SizedBox(width: 10),
              _sectionLabel("VITALS OVERVIEW"),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _vitalStat("BMI", "${user.bmiValue}", "kg/m²",
                  const Color(0xFF60A5FA)),
              _vitalDivider(),
              _vitalStat("Blood", user.bloodGroup ?? "—", "Type",
                  const Color(0xFFF87171)),
              _vitalDivider(),
              _vitalStat("Height", "${user.height ?? '—'}", "cm",
                  const Color(0xFF4ADE80)),
              _vitalDivider(),
              _vitalStat("Weight", "${user.weight ?? '—'}", "kg",
                  const Color(0xFFFBBF24)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vitalStat(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color)),
        const SizedBox(height: 4),
        Text("$label\n$unit",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 10,
                color: AppThemeColors.secondaryText(_b),
                height: 1.3)),
      ],
    );
  }

  Widget _vitalDivider() => Container(
        width: 1,
        height: 44,
        color: AppThemeColors.glassBorder(_b),
      );

  // ── List section (Chronic / Allergies / Restraints) ───────────────────────

  Widget _buildListSection({
    required String title,
    required IconData icon,
    required Color accentColor,
    required List<String> items,
    required VoidCallback onAdd,
    required Function(String) onDelete,
  }) {
    return Container(
      decoration: _glassCard,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accentColor, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(child: _sectionLabel(title)),
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppThemeColors.glassDivider(_b),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppThemeColors.glassBorder(_b)),
                  ),
                  child: Icon(Icons.add_rounded,
                      size: 16,
                      color: AppThemeColors.primaryText(_b)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: items.isEmpty
                ? _emptyChipState()
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: items.map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: accentColor.withValues(alpha: 0.30)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(item,
                                style: TextStyle(
                                    color: AppThemeColors.primaryText(_b),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => onDelete(item),
                              child: Icon(Icons.close_rounded,
                                  size: 14,
                                  color: AppThemeColors.secondaryText(_b)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _emptyChipState() => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text("No records added",
              style: TextStyle(
                  color: AppThemeColors.hintText(_b), fontSize: 13)),
        ),
      );

  // ── Medications section ────────────────────────────────────────────────────

  Widget _buildMedicationsCard(MedicineController medController,
      {required bool showActive}) {
    const activeColor = Color(0xFF818CF8);
    const pastColor = Color(0xFF6B7280);
    final accentColor = showActive ? activeColor : pastColor;

    final typeColors = const {
      'Tablet': Color(0xFF60A5FA),
      'Capsule': Color(0xFFC084FC),
      'Syrup': Color(0xFFFB923C),
      'Injection': Color(0xFFF87171),
    };

    return Container(
      decoration: _glassCard,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  showActive
                      ? Icons.medication_rounded
                      : Icons.history_rounded,
                  color: accentColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              _sectionLabel(
                  showActive ? "CURRENT MEDICATIONS" : "PAST MEDICATIONS"),
            ],
          ),
          const SizedBox(height: 14),
          Obx(() {
            final meds = medController.medicines
                .where((m) => showActive ? m.isActive : !m.isActive)
                .toList();

            if (meds.isEmpty) {
              return _emptyChipState();
            }

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: meds.map((med) {
                final typeColor =
                    typeColors[med.type] ?? activeColor;

                return GestureDetector(
                  onLongPress: showActive
                      ? () => _showMarkCompleteDialog(medController, med)
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: showActive
                          ? typeColor.withValues(alpha: 0.12)
                          : AppThemeColors.glassBg(_b),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: showActive
                              ? typeColor.withValues(alpha: 0.30)
                              : AppThemeColors.glassBorder(_b)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.medication_rounded,
                            size: 14,
                            color: showActive
                                ? typeColor
                                : AppThemeColors.hintText(_b)),
                        const SizedBox(width: 6),
                        Text(
                          "${med.name} • ${med.dosage}",
                          style: TextStyle(
                            color: showActive
                                ? AppThemeColors.primaryText(_b)
                                : AppThemeColors.hintText(_b),
                            fontSize: 13,
                            fontWeight: showActive
                                ? FontWeight.w500
                                : FontWeight.normal,
                            decoration: showActive
                                ? null
                                : TextDecoration.lineThrough,
                            decorationColor:
                                AppThemeColors.hintText(_b),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  // ── dialogs ────────────────────────────────────────────────────────────────

  void _showAddDialog(
      BuildContext context, String label, Function(String) onSave) {
    final textController = TextEditingController();
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _b == Brightness.light ? Colors.white : const Color(0xFF1E1B4B),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: AppThemeColors.glassBorder(_b), width: 1.2),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.30),
                  blurRadius: 24,
                  offset: const Offset(0, 8)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add $label",
                  style: TextStyle(
                      color: AppThemeColors.primaryText(_b),
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter $label name",
                  hintStyle: TextStyle(
                      color: AppThemeColors.hintText(_b)),
                  filled: true,
                  fillColor: AppThemeColors.glassDivider(_b),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: AppThemeColors.glassBorder(_b))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                          color: Color(0xFFC7D2FE), width: 1.8)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppThemeColors.glassDivider(_b),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppThemeColors.glassBorder(_b)),
                        ),
                        child: Text("Cancel",
                            style: TextStyle(color: AppThemeColors.primaryText(_b))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (textController.text.trim().isNotEmpty) {
                          onSave(textController.text.trim());
                          Get.back();
                        }
                      },
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color(0xFF818CF8),
                            Color(0xFF6366F1),
                            Color(0xFF4F46E5),
                          ]),
                          borderRadius: BorderRadius.circular(12),
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
        ),
      ),
    );
  }

  void _showMarkCompleteDialog(MedicineController medController, dynamic med) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _b == Brightness.light ? Colors.white : const Color(0xFF1E1B4B),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: AppThemeColors.glassBorder(_b), width: 1.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFF818CF8).withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_outline_rounded,
                    color: Color(0xFF818CF8), size: 26),
              ),
              const SizedBox(height: 14),
              Text(med.name,
                  style: TextStyle(
                      color: AppThemeColors.primaryText(_b),
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                "Mark as completed? It will be moved to past medications.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppThemeColors.secondaryText(_b),
                    fontSize: 13),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppThemeColors.glassDivider(_b),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppThemeColors.glassBorder(_b)),
                        ),
                        child: Text("Cancel",
                            style: TextStyle(color: AppThemeColors.primaryText(_b))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        medController.completeMedicine(med);
                        Get.back();
                      },
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color(0xFF818CF8),
                            Color(0xFF6366F1),
                            Color(0xFF4F46E5),
                          ]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text("Mark Done",
                            style: TextStyle(                              color: Colors.white,
                                fontWeight: FontWeight.bold)),
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
