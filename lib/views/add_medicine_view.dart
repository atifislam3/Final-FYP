import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/medicine_controller.dart';
import '../data/models/medicine_model.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class AddMedicineView extends StatefulWidget {
  final MedicineModel? editMedicine;
  const AddMedicineView({super.key, this.editMedicine});

  @override
  State<AddMedicineView> createState() => _AddMedicineViewState();
}

class _AddMedicineViewState extends State<AddMedicineView>
    with TickerProviderStateMixin {
  late final MedicineController controller;
  Brightness _b = Brightness.dark;

  late final AnimationController _bgCtrl;
  late final AnimationController _entryCtrl;
  late final Animation<double> _bgAnim;
  late final Animation<double> _card1;
  late final Animation<double> _card2;
  late final Animation<double> _card3;
  late final Animation<double> _btnAnim;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MedicineController());

    if (widget.editMedicine != null) {
      controller.prepareEdit(widget.editMedicine!);
    } else {
      controller.nameController.clear();
      controller.dosageController.clear();
      controller.stockController.clear();
      controller.customTypeController.clear();
      controller.reminderTimes.clear();
      controller.selectedDays.clear();
      controller.frequency.value = 'Daily';
    }

    _bgCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4000))
      ..repeat(reverse: true);
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();

    _bgAnim = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);

    _card1 = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic));
    _card2 = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.20, 0.75, curve: Curves.easeOutCubic));
    _card3 = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.40, 0.95, curve: Curves.easeOutCubic));
    _btnAnim = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────────


  BoxDecoration get _glassCard => BoxDecoration(
        color: AppThemeColors.glassBg(_b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppThemeColors.glassBorder(_b), width: 1.2),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.20),
              blurRadius: 20,
              offset: const Offset(0, 8)),
        ],
      );

  InputDecoration _glassInput(String label, IconData icon, {String? hint}) => InputDecoration(
        labelText: label,
        labelStyle:
            TextStyle(color: AppThemeColors.secondaryText(_b), fontSize: 14),
        prefixIcon: Icon(icon, color: AppThemeColors.secondaryText(_b)),
        filled: true,
        fillColor: AppThemeColors.glassBg(_b),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                BorderSide(color: AppThemeColors.glassBorder(_b))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Color(0xFFC7D2FE), width: 1.8)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFCA5A5))),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFCA5A5), width: 1.8)),
        hintText: hint,
        hintStyle:
            TextStyle(color: AppThemeColors.hintText(_b), fontSize: 14),
      );

  Widget _sectionLabel(String text) => Text(
        text,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
            color: AppThemeColors.secondaryText(_b)),
      );

  Widget _staggered(Animation<double> anim, Widget child) =>
      AnimatedBuilder(
        animation: anim,
        builder: (_, __) => Opacity(
          opacity: anim.value.clamp(0.0, 1.0),
          child:
              Transform.translate(offset: Offset(0, 28 * (1 - anim.value)), child: child),
        ),
        child: child,
      );

  String _freqLabel(String key) {
    if (key == 'SpecificDays') return 'Specific Days';
    if (key == 'Interval') return 'Interval (Every X Days)';
    if (key == 'Cyclic') return 'Cyclic (On/Off)';
    return 'Every Day';
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    _b = b;
    final isEdit = widget.editMedicine != null;

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
          isEdit ? "Update Medicine" : "Add Medicine",
          style: TextStyle(
              color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // gradient background
          Container(decoration: AppThemeColors.backgroundDecoration(b)),
          // animated orbs
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(
                  t: _bgAnim.value, alphaMultiplier: AppThemeColors.orbAlpha(b)),
              size: Size.infinite,
            ),
          ),
          // scrollable content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              child: Column(
                children: [
                  // icon badge
                  _staggered(
                    _card1,
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF818CF8), Color(0xFF4F46E5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color:
                                    const Color(0xFF4F46E5).withValues(alpha: 0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 8)),
                          ],
                        ),
                        child: const Icon(Icons.medication_rounded,
                            color: Colors.white, size: 34),
                      ),
                    ),
                  ),

                  // ── SECTION 1: Basic Info ──────────────────────────────
                  _staggered(_card1, _buildBasicInfoCard()),
                  const SizedBox(height: 20),

                  // ── SECTION 2: Frequency ──────────────────────────────
                  _staggered(_card2, _buildFrequencyCard()),
                  const SizedBox(height: 20),

                  // ── SECTION 3: Reminders ──────────────────────────────
                  _staggered(_card3, _buildRemindersCard()),
                  const SizedBox(height: 28),

                  // ── Save / Update button ──────────────────────────────
                  _staggered(_btnAnim, _buildSaveButton(isEdit)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section cards ──────────────────────────────────────────────────────────

  Widget _buildBasicInfoCard() {
    return Container(
      decoration: _glassCard,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel("BASIC INFO"),
          const SizedBox(height: 16),

          // Medicine name
          TextFormField(
            controller: controller.nameController,
            style: TextStyle(color: AppThemeColors.primaryText(_b)),
            decoration:
                _glassInput("Medicine Name", Icons.label_outline),
          ),
          const SizedBox(height: 16),

          // Type chips
          _sectionLabel("TYPE"),
          const SizedBox(height: 10),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.defaultTypes.map((type) {
                  final selected = controller.selectedType.value == type;
                  return GestureDetector(
                    onTap: () => controller.selectedType.value = type,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(colors: [
                                Color(0xFF818CF8),
                                Color(0xFF4F46E5),
                              ])
                            : null,
                        color: selected
                            ? null
                            : AppThemeColors.glassDivider(_b),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: selected
                                ? Colors.transparent
                                : AppThemeColors.glassBorder(_b)),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppThemeColors.secondaryText(_b),
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13),
                      ),
                    ),
                  );
                }).toList(),
              )),

          Obx(() => controller.selectedType.value == 'Other'
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    controller: controller.customTypeController,
                    style: TextStyle(color: AppThemeColors.primaryText(_b)),
                    decoration:
                        _glassInput("Specify Type", Icons.edit_note),
                  ),
                )
              : const SizedBox()),

          const SizedBox(height: 16),

          // Dosage + Stock
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.dosageController,
                  style: TextStyle(color: AppThemeColors.primaryText(_b)),
                  decoration:
                      _glassInput("Dosage", Icons.scale_outlined, hint: "e.g. 500mg"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: controller.stockController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: AppThemeColors.primaryText(_b)),
                  decoration:
                      _glassInput("Stock", Icons.inventory_2_outlined),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyCard() {
    return Container(
      decoration: _glassCard,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel("SCHEDULE & FREQUENCY"),
          const SizedBox(height: 16),

          // Frequency dropdown
          Obx(() => DropdownButtonFormField<String>(
                value: controller.frequency.value,
                dropdownColor: _b == Brightness.light ? Colors.white : const Color(0xFF1E1B4B),
                style: TextStyle(color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppThemeColors.glassBg(_b),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: AppThemeColors.glassBorder(_b))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                          color: Color(0xFFC7D2FE), width: 1.8)),
                  labelText: "Frequency",
                  labelStyle: TextStyle(
                      color: AppThemeColors.secondaryText(_b)),
                  prefixIcon: Icon(Icons.event_repeat_rounded, color: AppThemeColors.secondaryText(_b)),
                ),
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppThemeColors.secondaryText(_b)),
                items: ["Daily", "SpecificDays", "Interval", "Cyclic"]
                    .map((val) => DropdownMenuItem(
                        value: val,
                        child: Text(_freqLabel(val),
                            style: TextStyle(color: AppThemeColors.primaryText(_b)))))
                    .toList(),
                onChanged: (v) => controller.frequency.value = v!,
              )),

          const SizedBox(height: 20),

          // Dynamic frequency UI
          Obx(() => _buildDynamicFreqUI(controller.frequency.value)),
        ],
      ),
    );
  }

  Widget _buildDynamicFreqUI(String freq) {
    if (freq == 'SpecificDays') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel("SELECT DAYS"),
          const SizedBox(height: 10),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    List.generate(7, (i) {
                  final day = i + 1;
                  final selected = controller.selectedDays.contains(day);
                  final label = const [
                    "Mon","Tue","Wed","Thu","Fri","Sat","Sun"
                  ][i];
                  return GestureDetector(
                    onTap: () => selected
                        ? controller.selectedDays.remove(day)
                        : controller.selectedDays.add(day),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(
                                colors: [Color(0xFF818CF8), Color(0xFF4F46E5)])
                            : null,
                        color: selected
                            ? null
                            : AppThemeColors.glassDivider(_b),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                            color: selected
                                ? Colors.transparent
                                : AppThemeColors.glassBorder(_b)),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppThemeColors.secondaryText(_b),
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12),
                      ),
                    ),
                  );
                }),
              )),
        ],
      );
    } else if (freq == 'Interval') {
      return Row(
        children: [
          Text("Every",
              style: TextStyle(
                  color: AppThemeColors.primaryText(_b), fontSize: 15)),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() => TextFormField(
                  initialValue: controller.interval.value.toString(),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: AppThemeColors.primaryText(_b)),
                  decoration: _glassInput("", Icons.repeat_rounded),
                  onChanged: (v) =>
                      controller.interval.value = int.tryParse(v) ?? 1,
                )),
          ),
          const SizedBox(width: 12),
          Text("days",
              style: TextStyle(
                  color: AppThemeColors.primaryText(_b), fontSize: 15)),
        ],
      );
    } else if (freq == 'Cyclic') {
      return Row(
        children: [
          Expanded(child: _buildStepper("Days ON", controller.cycleOn)),
          const SizedBox(width: 16),
          Expanded(child: _buildStepper("Days OFF", controller.cycleOff)),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildStepper(String label, RxInt value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(_b),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: AppThemeColors.glassBorder(_b)),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                  color: AppThemeColors.secondaryText(_b),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (value.value > 1) value.value--;
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppThemeColors.glassBorder(_b),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.remove, color: Colors.white, size: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Obx(() => Text("${value.value}",
                    style: TextStyle(
                        color: AppThemeColors.primaryText(_b),
                        fontWeight: FontWeight.bold,
                        fontSize: 18))),
              ),
              GestureDetector(
                onTap: () => value.value++,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF818CF8), Color(0xFF4F46E5)]),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersCard() {
    return Container(
      decoration: _glassCard,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _sectionLabel("REMINDER TIMES"),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.addTime(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppThemeColors.glassDivider(_b),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppThemeColors.hintText(_b)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded,
                          size: 16,
                          color: AppThemeColors.primaryText(_b)),
                      const SizedBox(width: 4),
                      Text("Add Time",
                          style: TextStyle(
                              color: AppThemeColors.primaryText(_b),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Obx(() {
            if (controller.reminderTimes.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text("No reminders set yet",
                      style: TextStyle(
                          color: AppThemeColors.hintText(_b),
                          fontSize: 13)),
                ),
              );
            }
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.reminderTimes.map((time) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppThemeColors.glassDivider(_b),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                        color: AppThemeColors.hintText(_b)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time_filled_rounded,
                          size: 14, color: Color(0xFFA5B4FC)),
                      const SizedBox(width: 6),
                      Text(time.format(context),
                          style: TextStyle(
                              color: AppThemeColors.primaryText(_b),
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => controller.reminderTimes.remove(time),
                        child: Icon(Icons.close_rounded,
                            size: 15,
                            color: AppThemeColors.secondaryText(_b)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSaveButton(bool isEdit) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF4F46E5)]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF4F46E5).withValues(alpha: 0.40),
                blurRadius: 16,
                offset: const Offset(0, 6)),
          ],
        ),
        child: ElevatedButton(
          onPressed: () =>
              controller.saveMedicine(id: widget.editMedicine?.medicineId),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(
            isEdit ? "Update Medicine" : "Save Medicine",
            style: TextStyle(
                color: AppThemeColors.primaryText(_b),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
