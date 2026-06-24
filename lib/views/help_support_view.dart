import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class HelpSupportView extends StatefulWidget {
  const HelpSupportView({super.key});

  @override
  State<HelpSupportView> createState() => _HelpSupportViewState();
}

class _HelpSupportViewState extends State<HelpSupportView>
    with TickerProviderStateMixin {
  Brightness _b = Brightness.dark;

  late final AnimationController _bgCtrl;
  late final AnimationController _entryCtrl;

  late final Animation<double> _badgeAnim;
  late final Animation<double> _guideAnim;
  late final Animation<double> _contactAnim;
  late final Animation<double> _aboutAnim;

  Future<void> _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@medcare.com',
      queryParameters: {
        'subject': 'Feedback for Personal Medicine Reminder',
        'body': 'Hello Support Team, \n\n',
      },
    );
    if (!await launchUrl(emailLaunchUri)) {
      Get.snackbar(
        "Error",
        "Could not launch email client",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _badgeAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
    );
    _guideAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.15, 0.70, curve: Curves.easeOutCubic),
    );
    _contactAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.35, 0.85, curve: Curves.easeOutCubic),
    );
    _aboutAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.50, 1.0, curve: Curves.easeOutCubic),
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
          "Help & Support",
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
              painter: OrbPainter(t: _bgCtrl.value),
              child: const SizedBox.expand(),
            ),
          ),
          // Content
          SafeArea(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 48),
              children: [
                // Icon badge header
                _buildAnimatedSection(
                  animation: _badgeAnim,
                  child: _buildHelpBadge(),
                ),
                const SizedBox(height: 32),

                // User Guide section
                _buildAnimatedSection(
                  animation: _guideAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("User Guide"),
                      const SizedBox(height: 12),
                      _buildGuideCard(
                        icon: Icons.medication_rounded,
                        title: "Managing Medicines",
                        content:
                            "Add your prescriptions, set reminders, and track your inventory. Usage history is saved automatically.",
                        accentColor: const Color(0xFF818CF8),
                      ),
                      _buildGuideCard(
                        icon: Icons.calendar_month_rounded,
                        title: "Appointments",
                        content:
                            "Schedule doctor visits and get notified. You can categorize visits (Checkup, Lab, Surgery).",
                        accentColor: const Color(0xFF60A5FA),
                      ),
                      _buildGuideCard(
                        icon: Icons.smart_toy_rounded,
                        title: "AI Assistant",
                        content:
                            "Chat with the AI to get quick health tips or guidance on using the app.",
                        accentColor: const Color(0xFFA78BFA),
                      ),
                      _buildGuideCard(
                        icon: Icons.analytics_rounded,
                        title: "Reports & Analytics",
                        content:
                            "View visual charts of your adherence and inventory status. Upload medical PDFs for safe keeping.",
                        accentColor: const Color(0xFF34D399),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Contact & Feedback section
                _buildAnimatedSection(
                  animation: _contactAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("Contact & Feedback"),
                      const SizedBox(height: 12),
                      _buildContactCard(),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // About section
                _buildAnimatedSection(
                  animation: _aboutAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("About App"),
                      const SizedBox(height: 12),
                      _buildAboutCard(),
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

  Widget _buildHelpBadge() {
    return Center(
      child: AnimatedBuilder(
        animation: _bgCtrl,
        builder: (_, __) {
          final dy = math.sin(_bgCtrl.value * math.pi) * 5.0;
          return Transform.translate(
            offset: Offset(0, dy),
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF818CF8),
                        Color(0xFF6366F1),
                        Color(0xFF4F46E5)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.50),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.help_center_rounded,
                      color: Colors.white, size: 42),
                ),
                const SizedBox(height: 16),
                Text(
                  "How can we help?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppThemeColors.primaryText(_b),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Browse guides or reach out to our team",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppThemeColors.secondaryText(_b),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedSection({
    required Animation<double> animation,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => Opacity(
        opacity: animation.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, 28 * (1 - animation.value.clamp(0.0, 1.0))),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.0,
        color: AppThemeColors.secondaryText(_b),
      ),
    );
  }

  Widget _buildGuideCard({
    required IconData icon,
    required String title,
    required String content,
    required Color accentColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(_b),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppThemeColors.glassBorder(_b), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3730A3).withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding:
              const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppThemeColors.primaryText(_b),
            ),
          ),
          iconColor: AppThemeColors.secondaryText(_b),
          collapsedIconColor: AppThemeColors.hintText(_b),
          children: [
            Text(
              content,
              style: TextStyle(
                height: 1.6,
                fontSize: 13,
                color: AppThemeColors.secondaryText(_b),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4338CA), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: AppThemeColors.glassBorder(_b), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.40),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppThemeColors.glassBorder(_b),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mark_email_unread_rounded,
                size: 36, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            "Have Questions or Suggestions?",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppThemeColors.primaryText(_b),
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "We'd love to hear from you. Send us a message and we'll get back to you.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppThemeColors.secondaryText(_b),
                fontSize: 13,
                height: 1.5),
          ),
          const SizedBox(height: 22),
          GestureDetector(
            onTap: _sendEmail,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                "Contact Support",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF4338CA),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(_b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppThemeColors.glassBorder(_b), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3730A3).withValues(alpha: 0.20),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF818CF8), Color(0xFF4F46E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.40),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.local_hospital_rounded,
                    size: 30, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MedCare",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppThemeColors.primaryText(_b),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF818CF8).withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: const Color(0xFF818CF8).withValues(alpha: 0.40),
                          width: 1),
                    ),
                    child: const Text(
                      "v1.0.0",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF818CF8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          Divider(color: AppThemeColors.glassDivider(_b)),
          const SizedBox(height: 14),
          _buildInfoRow("Developers", "Atif Islam & Muhammad Awais Ali"),
          const SizedBox(height: 10),
          _buildInfoRow("Contact", "support@medcare.com"),
          const SizedBox(height: 10),
          _buildInfoRow("Copyright", "© 2026 MedCare"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: AppThemeColors.secondaryText(_b), fontSize: 13)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppThemeColors.primaryText(_b)),
          ),
        ),
      ],
    );
  }
}
