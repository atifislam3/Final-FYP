import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../view_models/profile_controller.dart';
import 'change_password_view.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView>
    with TickerProviderStateMixin {
  Brightness _b = Brightness.dark;

  late AnimationController _bgCtrl;
  late AnimationController _entryCtrl;
  late Animation<double> _avatarAnim;
  late Animation<double> _personalAnim;
  late Animation<double> _healthAnim;
  late Animation<double> _bmiAnim;
  late Animation<double> _btnAnim;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4000))
      ..repeat(reverse: true);
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();

    _avatarAnim = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut));
    _personalAnim = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.15, 0.50, curve: Curves.easeOut));
    _healthAnim = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.30, 0.65, curve: Curves.easeOut));
    _bmiAnim = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.45, 0.80, curve: Curves.easeOut));
    _btnAnim = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.60, 1.0, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  InputDecoration _glassField(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppThemeColors.secondaryText(_b)),
      prefixIcon: icon != null
          ? Icon(icon, color: AppThemeColors.secondaryText(_b), size: 20)
          : null,
      filled: true,
      fillColor: AppThemeColors.glassBg(_b),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            BorderSide(color: Colors.white.withValues(alpha: 0.18), width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            BorderSide(color: Colors.white.withValues(alpha: 0.18), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFC7D2FE), width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    _b = b;
    final ProfileController controller = Get.find();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text('Edit Profile',
            style: TextStyle(
                color: AppThemeColors.primaryText(_b),
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _bgCtrl,
        builder: (context, child) {
          return Stack(
            children: [
              Container(decoration: AppThemeColors.backgroundDecoration(b)),
              CustomPaint(
                painter: OrbPainter(t: _bgCtrl.value, alphaMultiplier: AppThemeColors.orbAlpha(b)),
                child: const SizedBox.expand(),
              ),
              child!,
            ],
          );
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar picker
              FadeTransition(
                opacity: _avatarAnim,
                child: SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0, -0.2), end: Offset.zero)
                      .animate(_avatarAnim),
                  child: _buildAvatarPicker(controller),
                ),
              ),
              const SizedBox(height: 28),

              // Personal Info section
              FadeTransition(
                opacity: _personalAnim,
                child: SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0, 0.2), end: Offset.zero)
                      .animate(_personalAnim),
                  child: _buildPersonalSection(controller),
                ),
              ),
              const SizedBox(height: 20),

              // Health Metrics section
              FadeTransition(
                opacity: _healthAnim,
                child: SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0, 0.2), end: Offset.zero)
                      .animate(_healthAnim),
                  child: _buildHealthSection(controller),
                ),
              ),
              const SizedBox(height: 20),

              // BMI card
              FadeTransition(
                opacity: _bmiAnim,
                child: SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0, 0.2), end: Offset.zero)
                      .animate(_bmiAnim),
                  child: _buildBMICard(controller),
                ),
              ),
              const SizedBox(height: 28),

              // Save button & change password
              FadeTransition(
                opacity: _btnAnim,
                child: SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0, 0.2), end: Offset.zero)
                      .animate(_btnAnim),
                  child: _buildActions(controller),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPicker(ProfileController controller) {
    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => controller.pickImage(),
            child: Obx(() {
              ImageProvider? imageProvider;
              final picked = controller.pickedImage.value;
              final currentUrl = controller.currentUser.value?.photoUrl;

              if (picked != null) {
                imageProvider = FileImage(File(picked.path));
              } else if (currentUrl != null && currentUrl.isNotEmpty) {
                if (currentUrl.startsWith('http')) {
                  imageProvider = NetworkImage(currentUrl);
                } else {
                  imageProvider = FileImage(File(currentUrl));
                }
              }

              return Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF818CF8),
                      Color(0xFF6366F1),
                      Color(0xFF4F46E5)
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.45),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _b == Brightness.light ? const Color(0xFFEDE9FE) : const Color(0xFF1E0A3C)),
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: _b == Brightness.light ? const Color(0xFFEEF2FF) : const Color(0xFF312E81),
                    backgroundImage: imageProvider,
                    child: imageProvider == null
                        ? const Icon(Icons.add_a_photo_rounded,
                            size: 38, color: Color(0xFF818CF8))
                        : null,
                  ),
                ),
              );
            }),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 8),
                ],
              ),
              child: const Icon(Icons.camera_alt_rounded,
                  size: 16, color: Colors.white),
            ),
          ),
          Obx(() {
            final hasImage = controller.pickedImage.value != null ||
                (controller.currentUser.value?.photoUrl?.isNotEmpty ?? false);
            if (!hasImage) return const SizedBox.shrink();
            return Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: controller.removeImage,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 16, color: Colors.white),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPersonalSection(ProfileController controller) {
    return _glassCard(
      title: "Personal Info",
      icon: Icons.person_outline,
      child: Column(
        children: [
          TextFormField(
            controller: controller.nameController,
            style: TextStyle(color: AppThemeColors.primaryText(_b)),
            decoration: _glassField("Full Name", icon: Icons.badge_outlined),
          ),
          const SizedBox(height: 14),
          // Date of Birth
          Obx(() => GestureDetector(
                onTap: () => _pickDate(controller),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                        width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cake_outlined,
                          size: 20,
                          color: AppThemeColors.secondaryText(_b)),
                      const SizedBox(width: 12),
                      Text(
                        controller.selectedDate.value == null
                            ? "Date of Birth"
                            : DateFormat('dd MMM yyyy')
                                .format(controller.selectedDate.value!),
                        style: TextStyle(
                          color: controller.selectedDate.value == null
                              ? AppThemeColors.secondaryText(_b)
                              : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 14),
          // Gender dropdown
          Obx(() => _buildGlassDropdown<String>(
                label: "Gender",
                icon: Icons.wc,
                value: controller.selectedGender.value.isEmpty
                    ? null
                    : controller.selectedGender.value,
                items: const ['Male', 'Female', 'Other'],
                onChanged: (v) => controller.selectedGender.value = v!,
              )),
        ],
      ),
    );
  }

  Widget _buildHealthSection(ProfileController controller) {
    return _glassCard(
      title: "Health Metrics",
      icon: Icons.monitor_heart_outlined,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.heightController,
                  style: TextStyle(color: AppThemeColors.primaryText(_b)),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      _glassField("Height (cm)", icon: Icons.height),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: controller.weightController,
                  style: TextStyle(color: AppThemeColors.primaryText(_b)),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: _glassField("Weight (kg)",
                      icon: Icons.monitor_weight_outlined),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Obx(() => _buildGlassDropdown<String>(
                label: "Blood Group",
                icon: Icons.bloodtype_outlined,
                value: controller.selectedBloodGroup.value.isEmpty
                    ? null
                    : controller.selectedBloodGroup.value,
                items: const [
                  'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
                ],
                onChanged: (v) => controller.selectedBloodGroup.value = v!,
              )),
        ],
      ),
    );
  }

  Widget _buildBMICard(ProfileController controller) {
    return Obx(() {
      // liveBMI is a reactive RxString; parse to double for numeric comparisons.
      final bmi = double.tryParse(controller.liveBMI.value) ?? 0.0;
      final Color bmiColor = bmi <= 0
          ? const Color(0xFF818CF8)
          : bmi < 18.5
              ? const Color(0xFF60A5FA)
              : bmi < 25
                  ? const Color(0xFF34D399)
                  : bmi < 30
                      ? const Color(0xFFFBBF24)
                      : const Color(0xFFFF6B6B);
      final String category = bmi <= 0
          ? "Enter height & weight"
          : bmi < 18.5
              ? "Underweight"
              : bmi < 25
                  ? "Normal Weight"
                  : bmi < 30
                      ? "Overweight"
                      : "Obese";

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppThemeColors.glassBg(_b),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: bmiColor.withValues(alpha: 0.35), width: 1.5),
          boxShadow: [
            BoxShadow(
                color: bmiColor.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bmiColor.withValues(alpha: 0.18)),
              child: Icon(Icons.health_and_safety_outlined,
                  color: bmiColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Live BMI",
                      style: TextStyle(
                          color: AppThemeColors.secondaryText(_b),
                          fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(
                    bmi > 0 ? bmi.toStringAsFixed(1) : "--",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: bmiColor,
                        height: 1),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: bmiColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(category,
                  style: TextStyle(
                      color: bmiColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildActions(ProfileController controller) {
    return Column(
      children: [
        Obx(() => GestureDetector(
              onTap: controller.isLoading.value
                  ? null
                  : () => controller.updateProfile(),
              child: AnimatedOpacity(
                opacity: controller.isLoading.value ? 0.6 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(colors: [
                      Color(0xFF818CF8),
                      Color(0xFF6366F1),
                      Color(0xFF4F46E5)
                    ]),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.40),
                          blurRadius: 16,
                          offset: const Offset(0, 6)),
                    ],
                  ),
                  child: Center(
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text("Save Changes",
                            style: TextStyle(
                                color: AppThemeColors.primaryText(_b),
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                  ),
                ),
              ),
            )),
        const SizedBox(height: 16),
        if (!controller.isSocialLogin)
          TextButton(
            onPressed: () => Get.to(() => const ChangePasswordView()),
            child: Text(
              "Change Password",
              style: TextStyle(
                  color: AppThemeColors.primaryText(_b),
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  decorationColor: AppThemeColors.hintText(_b)),
            ),
          ),
      ],
    );
  }

  Widget _glassCard(
      {required String title,
      required IconData icon,
      required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(_b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppThemeColors.glassBorder(_b), width: 1.2),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF3730A3).withValues(alpha: 0.20),
              blurRadius: 30,
              offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF818CF8), size: 18),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      color: AppThemeColors.primaryText(_b),
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildGlassDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      isExpanded: true,
      icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppThemeColors.secondaryText(_b)),
      dropdownColor: _b == Brightness.light ? Colors.white : const Color(0xFF1E1B4B),
      style: TextStyle(color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.w500),
      decoration: _glassField(label, icon: icon),
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(item.toString(),
                    style: TextStyle(color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.w500)),
              ))
          .toList(),
    );
  }

  Future<void> _pickDate(ProfileController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final isDark = AppThemeColors.brightnessOf(context) == Brightness.dark;
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
          ),
          child: child!,
        );
      },
    );
    if (picked != null) controller.selectedDate.value = picked;
  }
}
