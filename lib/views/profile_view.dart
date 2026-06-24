import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../view_models/profile_controller.dart';
import 'edit_profile_view.dart';
import 'settings_view.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  final ProfileController controller = Get.put(ProfileController());

  Brightness _b = Brightness.dark;

  late AnimationController _bgCtrl;
  late AnimationController _entryCtrl;
  late Animation<double> _avatarAnim;
  late Animation<double> _vitalsAnim;
  late Animation<double> _infoAnim;
  late Animation<double> _btnAnim;

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

    _avatarAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );
    _vitalsAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    );
    _infoAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
    );
    _btnAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );
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
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Profile',
            style: TextStyle(
                color: AppThemeColors.primaryText(b), fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: AppThemeColors.primaryText(b)),
            onPressed: () => Get.to(() => const SettingsView()),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _bgCtrl,
        builder: (context, child) {
          return Stack(
            children: [
              Container(decoration: AppThemeColors.backgroundDecoration(b)),
              CustomPaint(
                painter: OrbPainter(
                  t: _bgCtrl.value,
                  alphaMultiplier: AppThemeColors.orbAlpha(b),
                ),
                child: const SizedBox.expand(),
              ),
              child!,
            ],
          );
        },
        child: Obx(() {
          final user = controller.currentUser.value;
          if (controller.isLoading.value && user == null) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF818CF8)));
          }
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off_outlined,
                      size: 60, color: AppThemeColors.secondaryText(b)),
                  const SizedBox(height: 16),
                  Text("No Profile Found",
                      style: TextStyle(
                          color: AppThemeColors.secondaryText(b))),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
                20, 24, 20, MediaQuery.of(context).padding.bottom + 80),
            child: Column(
              children: [
                // Avatar section
                FadeTransition(
                  opacity: _avatarAnim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, -0.3), end: Offset.zero)
                        .animate(_avatarAnim),
                    child: _buildAvatarSection(user),
                  ),
                ),
                const SizedBox(height: 24),

                // BMI card
                FadeTransition(
                  opacity: _vitalsAnim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, 0.2), end: Offset.zero)
                        .animate(_vitalsAnim),
                    child: _buildBMICard(user),
                  ),
                ),
                const SizedBox(height: 16),

                // Vitals row
                FadeTransition(
                  opacity: _vitalsAnim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, 0.2), end: Offset.zero)
                        .animate(_vitalsAnim),
                    child: Row(
                      children: [
                        Expanded(
                            child: _buildVitalCard("Blood",
                                user.bloodGroup ?? "-", Icons.bloodtype,
                                const Color(0xFFFF6B6B))),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildVitalCard("Height",
                                "${user.height ?? '-'} cm", Icons.height,
                                const Color(0xFF60A5FA))),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildVitalCard("Weight",
                                "${user.weight ?? '-'} kg",
                                Icons.monitor_weight,
                                const Color(0xFFFBBF24))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Personal info card
                FadeTransition(
                  opacity: _infoAnim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, 0.2), end: Offset.zero)
                        .animate(_infoAnim),
                    child: _buildPersonalInfoCard(user),
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                FadeTransition(
                  opacity: _btnAnim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, 0.2), end: Offset.zero)
                        .animate(_btnAnim),
                    child: Column(
                      children: [
                        _buildEditButton(user),
                        const SizedBox(height: 12),
                        _buildLogoutButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAvatarSection(dynamic user) {
    final b = _b;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF4F46E5)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.5),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppThemeColors.scaffoldBg(b),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: b == Brightness.dark
                  ? const Color(0xFF312E81)
                  : const Color(0xFFEEF2FF),
              backgroundImage: (user.photoUrl != null &&
                      user.photoUrl!.isNotEmpty)
                  ? (user.photoUrl!.startsWith('http')
                      ? NetworkImage(user.photoUrl!) as ImageProvider
                      : FileImage(File(user.photoUrl!)))
                  : null,
              child: (user.photoUrl == null || user.photoUrl!.isEmpty)
                  ? const Icon(Icons.person, size: 50, color: Color(0xFF818CF8))
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.fullName,
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppThemeColors.primaryText(b)),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: TextStyle(
              fontSize: 14, color: AppThemeColors.secondaryText(b)),
        ),
      ],
    );
  }

  Widget _buildBMICard(dynamic user) {
    final b = _b;
    final double bmi = user.bmiValue;
    final String category = _getBMICategory(bmi);
    final Color statusColor = _getBMIColor(bmi);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppThemeColors.glassBorder(b), width: 1.2),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF3730A3).withValues(alpha: 0.10),
              blurRadius: 30,
              offset: const Offset(0, 12)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("BMI Score",
                    style: TextStyle(
                        color: AppThemeColors.secondaryText(b),
                        fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  bmi > 0 ? bmi.toStringAsFixed(1) : "--",
                  style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      color: AppThemeColors.primaryText(b),
                      height: 1),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(category,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                          fontSize: 12)),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: _ArcPainter(
                    value: (bmi / 40).clamp(0.0, 1.0),
                    color: statusColor,
                  ),
                ),
                Center(
                  child: Icon(Icons.health_and_safety_outlined,
                      size: 36, color: statusColor.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalCard(
      String label, String value, IconData icon, Color color) {
    final b = _b;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppThemeColors.glassBorder(b), width: 1.2),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF3730A3).withValues(alpha: 0.10),
              blurRadius: 30,
              offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppThemeColors.primaryText(b))),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: AppThemeColors.secondaryText(b))),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(dynamic user) {
    final b = _b;
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppThemeColors.glassBorder(b), width: 1.2),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF3730A3).withValues(alpha: 0.10),
              blurRadius: 30,
              offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        children: [
          _buildInfoTile("Gender", user.gender ?? "Not Set", Icons.wc),
          Divider(
              height: 1,
              color: AppThemeColors.glassDivider(b),
              indent: 56),
          _buildInfoTile(
            "Birthday",
            user.dateOfBirth != null
                ? DateFormat('dd MMM yyyy').format(user.dateOfBirth!)
                : "Not Set",
            Icons.cake,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    final b = _b;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: AppThemeColors.glassBg(b),
            borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 20, color: AppThemeColors.secondaryText(b)),
      ),
      title: Text(title,
          style: TextStyle(
              fontSize: 12, color: AppThemeColors.secondaryText(b))),
      subtitle: Text(value,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppThemeColors.primaryText(b))),
    );
  }

  Widget _buildEditButton(dynamic user) {
    return GestureDetector(
      onTap: () {
        controller.prepareEditData();
        Get.to(() => EditProfileView());
      },
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
              colors: [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF4F46E5)]),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.40),
                blurRadius: 16,
                offset: const Offset(0, 6)),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_outlined, color: Colors.white),
            SizedBox(width: 10),
            Text("Edit Profile",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () => controller.logout(),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppThemeColors.glassBg(_b),
          border: Border.all(
              color: Colors.red.withValues(alpha: 0.45), width: 1.3),
          boxShadow: [
            BoxShadow(
                color: Colors.red.withValues(alpha: 0.10),
                blurRadius: 16,
                offset: const Offset(0, 6)),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.redAccent),
            SizedBox(width: 10),
            Text("Logout",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    fontSize: 15)),
          ],
        ),
      ),
    );
  }

  String _getBMICategory(double bmi) {
    if (bmi <= 0) return "Add Data";
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  Color _getBMIColor(double bmi) {
    if (bmi <= 0) return const Color(0xFF818CF8);
    if (bmi < 18.5) return const Color(0xFF60A5FA);
    if (bmi < 25) return const Color(0xFF34D399);
    if (bmi < 30) return const Color(0xFFFBBF24);
    return const Color(0xFFFF6B6B);
  }
}

class _ArcPainter extends CustomPainter {
  final double value;
  final Color color;
  const _ArcPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fgPaint = Paint()
      ..color = color
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -math.pi * 0.75, math.pi * 1.5, false, bgPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -math.pi * 0.75, math.pi * 1.5 * value, false, fgPaint);
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.value != value || old.color != color;
}
