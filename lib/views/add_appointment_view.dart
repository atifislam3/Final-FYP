import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../view_models/appointment_controller.dart';
import '../data/models/appointment_model.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class AddAppointmentView extends StatefulWidget {
  final AppointmentModel? existingApt;
  const AddAppointmentView({super.key, this.existingApt});

  @override
  State<AddAppointmentView> createState() => _AddAppointmentViewState();
}

class _AddAppointmentViewState extends State<AddAppointmentView>
    with TickerProviderStateMixin {
  late final AppointmentController _controller;
  Brightness _b = Brightness.dark;

  late final AnimationController _bgCtrl;
  late final AnimationController _entryCtrl;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AppointmentController>();
    if (widget.existingApt != null) {
      _controller.prepareEdit(widget.existingApt!);
    }
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
    _b = b;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Gradient background ────────────────────────────────────
          Container(decoration: AppThemeColors.backgroundDecoration(b)),
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(t: _bgCtrl.value, alphaMultiplier: AppThemeColors.orbAlpha(b)),
              size: Size.infinite,
            ),
          ),
          // ── Foreground ─────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _buildHeroBadge(),
                        const SizedBox(height: 28),
                        _buildSection(
                          delay: 0.0,
                          child: _buildConsultationSection(),
                        ),
                        _buildDivider(),
                        _buildSection(
                          delay: 0.15,
                          child: _buildWhenSection(context),
                        ),
                        _buildDivider(),
                        _buildSection(
                          delay: 0.30,
                          child: _buildRemindersSection(),
                        ),
                        _buildDivider(),
                        _buildSection(
                          delay: 0.45,
                          child: _buildNotesSection(),
                        ),
                        const SizedBox(height: 32),
                        _buildSection(
                          delay: 0.60,
                          child: _buildSaveButton(),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded, color: AppThemeColors.primaryText(_b)),
        onPressed: () => Get.back(),
      ),
      title: Text(
        widget.existingApt == null ? 'New Appointment' : 'Edit Appointment',
        style: TextStyle(
            color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.bold, fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  // ── Calendar hero badge ─────────────────────────────────────────────
  Widget _buildHeroBadge() {
    return FadeTransition(
      opacity: CurvedAnimation(
          parent: _entryCtrl,
          curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.event_rounded,
                  color: Colors.white, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              widget.existingApt == null
                  ? 'Schedule Appointment'
                  : 'Update Appointment',
              style: TextStyle(
                  color: AppThemeColors.primaryText(_b),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            Text(
              'Fill in the details below',
              style: TextStyle(
                  color: AppThemeColors.secondaryText(_b), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section wrapper with stagger animation ──────────────────────────
  Widget _buildSection({required double delay, required Widget child}) {
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
          child:
              Transform.translate(offset: Offset(0, 24 * (1 - t)), child: c),
        );
      },
      child: child,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        height: 1,
        color: AppThemeColors.glassDivider(_b),
      ),
    );
  }

  // ── Section label ───────────────────────────────────────────────────
  Widget _sectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
          color: const Color(0xFFC7D2FE).withValues(alpha: 0.85),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.3),
    );
  }

  // ── Consultation section ────────────────────────────────────────────
  Widget _buildConsultationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Consultation Details'),
        const SizedBox(height: 14),
        _glassField(
          controller: _controller.doctorController,
          label: 'Doctor or Clinic Name',
          icon: Icons.medical_services_outlined,
        ),
        const SizedBox(height: 14),
        Obx(() => _glassDropdown<String>(
              value: _controller.selectedCategory.value,
              label: 'Category',
              icon: Icons.category_outlined,
              items: _controller.categories,
              onChanged: (v) => _controller.selectedCategory.value = v!,
            )),
      ],
    );
  }

  // ── When section ────────────────────────────────────────────────────
  Widget _buildWhenSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('When'),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _controller.selectedDate.value,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (ctx, child) => _darkPickerTheme(ctx, child),
                  );
                  if (picked != null) {
                    _controller.selectedDate.value = picked;
                  }
                },
                child: Obx(() => _dateTimeCard(
                      value: DateFormat('EEE, MMM d')
                          .format(_controller.selectedDate.value),
                      label: 'Date',
                      icon: Icons.calendar_today_rounded,
                    )),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _controller.selectedTime.value,
                    builder: (ctx, child) => _darkPickerTheme(ctx, child),
                  );
                  if (picked != null) {
                    _controller.selectedTime.value = picked;
                  }
                },
                child: Obx(() => _dateTimeCard(
                      value: _controller.selectedTime.value.format(context),
                      label: 'Time',
                      icon: Icons.access_time_rounded,
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dateTimeCard(
      {required String value,
      required String label,
      required IconData icon}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppThemeColors.glassBorder(_b), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon,
                  size: 14, color: AppThemeColors.secondaryText(_b)),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: AppThemeColors.secondaryText(_b))),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColors.primaryText(_b))),
        ],
      ),
    );
  }

  Widget _darkPickerTheme(BuildContext ctx, Widget? child) {
    final isDark = AppThemeColors.brightnessOf(ctx) == Brightness.dark;
    return Theme(
      data: (isDark ? ThemeData.dark() : ThemeData.light()).copyWith(
        colorScheme: isDark
            ? const ColorScheme.dark(
                primary: Color(0xFF818CF8),
                onPrimary: Colors.white,
                surface: Color(0xFF1E1B4B),
                onSurface: Colors.white,
              )
            : const ColorScheme.light(
                primary: Color(0xFF6366F1),
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Color(0xFF1E1B4B),
              ),
        dialogBackgroundColor: isDark ? const Color(0xFF1E1B4B) : Colors.white,
      ),
      child: child!,
    );
  }

  // ── Reminders section ───────────────────────────────────────────────
  Widget _buildRemindersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Reminder'),
        const SizedBox(height: 14),
        // Lead-time dropdown (SRS-112)
        Obx(() => _glassDropdown<int>(
              value: _controller.reminderOption.value,
              label: 'Remind me',
              icon: Icons.notifications_active_outlined,
              items: const [0, 15, 30, 60, 1440],
              itemLabels: const [
                'No Reminder',
                '15 minutes before',
                '30 minutes before',
                '1 hour before',
                '1 day before',
              ],
              onChanged: (v) {
                _controller.reminderOption.value = v!;
                // Reset recurring when reminder is disabled
                if (v == 0) _controller.isRecurring.value = false;
              },
            )),
        // Recurring toggle – visible only when a reminder is set (SRS-113)
        Obx(() {
          if (_controller.reminderOption.value == 0) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              const SizedBox(height: 12),
              _glassToggleRow(
                icon: Icons.repeat_rounded,
                label: 'Recurring Reminder',
                subtitle: 'Repeat for regular visits',
                value: _controller.isRecurring.value,
                onChanged: (v) => _controller.isRecurring.value = v,
              ),
              // Frequency dropdown – visible only when recurring is enabled
              if (_controller.isRecurring.value) ...[
                const SizedBox(height: 12),
                _glassDropdown<String>(
                  value: _controller.recurringFrequency.value,
                  label: 'Repeat every',
                  icon: Icons.event_repeat_rounded,
                  items: _controller.recurringFrequencies,
                  onChanged: (v) => _controller.recurringFrequency.value = v!,
                ),
              ],
            ],
          );
        }),
      ],
    );
  }

  // ── Glass toggle row ────────────────────────────────────────────────
  Widget _glassToggleRow({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppThemeColors.glassBorder(_b), width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppThemeColors.secondaryText(_b)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: AppThemeColors.primaryText(_b),
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                Text(subtitle,
                    style: TextStyle(
                        color: AppThemeColors.secondaryText(_b),
                        fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF818CF8),
            activeTrackColor: const Color(0xFF818CF8).withValues(alpha: 0.30),
            inactiveTrackColor: AppThemeColors.glassBorder(_b),
            inactiveThumbColor: AppThemeColors.secondaryText(_b),
          ),
        ],
      ),
    );
  }

  // ── Visit notes section ─────────────────────────────────────────────
  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Visit Notes'),
        const SizedBox(height: 14),
        _glassField(
          controller: _controller.notesController,
          label: 'Questions for doctor, symptoms, etc.',
          icon: Icons.note_alt_outlined,
          maxLines: 4,
        ),
      ],
    );
  }

  // ── Save button ─────────────────────────────────────────────────────
  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () => _controller.saveAppointment(id: widget.existingApt?.id),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color(0xFF818CF8),
            Color(0xFF6366F1),
            Color(0xFF4F46E5),
          ]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.40),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          widget.existingApt == null
              ? 'Save Appointment'
              : 'Update Appointment',
          style: TextStyle(
              color: AppThemeColors.primaryText(_b),
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }

  // ── Glass text field ────────────────────────────────────────────────
  Widget _glassField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: AppThemeColors.primaryText(_b)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppThemeColors.secondaryText(_b)),
        prefixIcon: Icon(icon, color: AppThemeColors.secondaryText(_b)),
        filled: true,
        fillColor: AppThemeColors.glassBg(_b),
        alignLabelWithHint: maxLines > 1,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: AppThemeColors.glassBorder(_b), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFFC7D2FE), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFCA5A5)),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _glassDropdown<T>({
    required T value,
    required String label,
    required IconData icon,
    required List<T> items,
    List<String>? itemLabels,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      dropdownColor: _b == Brightness.light ? Colors.white : const Color(0xFF1E1B4B),
      icon: Icon(Icons.keyboard_arrow_down_rounded,
          color: AppThemeColors.secondaryText(_b)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppThemeColors.secondaryText(_b)),
        prefixIcon: Icon(icon, color: AppThemeColors.secondaryText(_b)),
        filled: true,
        fillColor: AppThemeColors.glassBg(_b),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: AppThemeColors.glassBorder(_b), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFFC7D2FE), width: 1.8),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
      ),
      items: items.asMap().entries.map((e) {
        final itemLabel = (itemLabels != null && e.key < itemLabels.length)
            ? itemLabels[e.key]
            : e.value.toString();
        return DropdownMenuItem<T>(
          value: e.value,
          child: Text(itemLabel, style: TextStyle(color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.w500)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
