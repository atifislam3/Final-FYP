import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../view_models/appointment_controller.dart';
import '../data/models/appointment_model.dart';
import 'add_appointment_view.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

// Amber/yellow used for reminder and recurring badges throughout this view
const Color _kReminderColor = Color(0xFFFBBF24);

class AppointmentsView extends StatefulWidget {
  const AppointmentsView({super.key});

  @override
  State<AppointmentsView> createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<AppointmentsView>
    with TickerProviderStateMixin {
  late AnimationController _bgCtrl;
  late AnimationController _entryCtrl;
  late Animation<double> _headerAnim;
  late Animation<double> _tabAnim;
  late Animation<double> _listAnim;
  final RxInt _selectedTab = 0.obs;
  Brightness _b = Brightness.dark;

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

    _headerAnim = _buildAnim(0.00, 0.50);
    _tabAnim = _buildAnim(0.25, 0.70);
    _listAnim = _buildAnim(0.45, 1.00);
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
    final controller = Get.find<AppointmentController>();

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
              painter: OrbPainter(t: _bgCtrl.value, alphaMultiplier: AppThemeColors.orbAlpha(b)),
              child: const SizedBox.expand(),
            ),
            // Main content
            SafeArea(
              child: Column(
                children: [
                  _AnimFade(anim: _headerAnim, child: _buildHeader(controller, b)),
                  _AnimFade(anim: _tabAnim, child: _buildTabBar()),
                  const SizedBox(height: 12),
                  _AnimFade(anim: _listAnim, child: _buildFilterBar(controller)),
                  Expanded(
                    child: _AnimFade(
                      anim: _listAnim,
                      child: _buildList(controller),
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

  Widget _buildHeader(AppointmentController controller, Brightness b) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          // Back button area (if pushed) or icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppThemeColors.glassBg(b),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppThemeColors.glassBorder(b), width: 1),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded,
                  color: AppThemeColors.primaryText(b), size: 18),
              onPressed: () => Get.back(),
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 14),
          // Title area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SCHEDULE",
                  style: TextStyle(
                    color: AppThemeColors.hintText(b),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                  ),
                ),
                Text(
                  "Appointments",
                  style: TextStyle(
                    color: AppThemeColors.primaryText(b),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          // Add button
          GestureDetector(
            onTap: () {
              controller.clearForm();
              Get.to(() => AddAppointmentView());
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF4F46E5)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.40),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppThemeColors.glassBg(_b),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppThemeColors.glassBorder(_b), width: 1),
        ),
        child: Obx(() => Row(
              children: [
                _buildTab("Upcoming", 0),
                _buildTab("History", 1),
              ],
            )),
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = _selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectedTab.value = index,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isSelected
                ? AppThemeColors.glassBorder(_b)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(
                    color: AppThemeColors.hintText(_b), width: 1)
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : AppThemeColors.secondaryText(_b),
              fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar(AppointmentController controller) {
    return Obx(() {
      final selectedDate = controller.filterDate.value;
      final selectedCategory = controller.filterCategory.value;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppThemeColors.glassBg(_b),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppThemeColors.glassBorder(_b), width: 1.2),
              ),
              child: TextField(
                onChanged: controller.updateSearch,
                style: TextStyle(color: AppThemeColors.primaryText(_b)),
                decoration: InputDecoration(
                  hintText: 'Search by doctor, category or date...',
                  hintStyle: TextStyle(
                      color: AppThemeColors.secondaryText(_b), fontSize: 14),
                  prefixIcon: Icon(Icons.search_rounded,
                      color: AppThemeColors.secondaryText(_b)),
                  suffixIcon: controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear_rounded,
                              color: AppThemeColors.secondaryText(_b)),
                          onPressed: () => controller.updateSearch(''),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppThemeColors.glassBg(_b),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppThemeColors.glassBorder(_b), width: 1.2),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.category_rounded, size: 18, color: AppThemeColors.secondaryText(_b)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCategory,
                              isExpanded: true,
                              icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppThemeColors.secondaryText(_b)),
                              dropdownColor: AppThemeColors.scaffoldBg(_b),
                              items: ['All', ...controller.categories]
                                  .map((category) => DropdownMenuItem(
                                        value: category,
                                        child: Text(category,
                                            style: TextStyle(
                                                color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.w500)),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  controller.setFilterCategory(value);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    controller.setFilterDate(picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppThemeColors.glassBg(_b),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppThemeColors.glassBorder(_b), width: 1.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_month_rounded,
                            size: 18,
                            color: AppThemeColors.secondaryText(_b)),
                        const SizedBox(width: 8),
                        Text(
                          selectedDate == null
                              ? 'Filter date'
                              : '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: TextStyle(
                              color: selectedDate == null
                                  ? AppThemeColors.secondaryText(_b)
                                  : AppThemeColors.primaryText(_b)),
                        ),
                      ],
                    ),
                  ),
                ),
                if (selectedCategory != 'All' || selectedDate != null)
                  IconButton(
                    icon: Icon(Icons.clear_rounded,
                        color: AppThemeColors.secondaryText(_b)),
                    onPressed: controller.clearFilters,
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildList(AppointmentController controller) {
    return Obx(() {
      final appointments = _selectedTab.value == 0
          ? controller.upcomingAppointments
          : controller.historyAppointments;

      if (appointments.isEmpty) {
        return _buildEmptyState(_selectedTab.value == 0);
      }

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final apt = appointments[index];
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 350 + index * 60),
            curve: Curves.easeOutCubic,
            builder: (_, v, child) => Opacity(
              opacity: v,
              child: Transform.translate(
                  offset: Offset(0, (1 - v) * 20), child: child),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildAppointmentCard(apt, controller),
            ),
          );
        },
      );
    });
  }

  Widget _buildAppointmentCard(
      AppointmentModel apt, AppointmentController controller) {
    const categoryColors = {
      'General': Color(0xFF60A5FA),
      'Dentist': Color(0xFF34D399),
      'Cardiology': Color(0xFFF87171),
      'Dermatology': Color(0xFFFBBF24),
      'Therapy': Color(0xFFA78BFA),
    };
    final color = categoryColors[apt.category] ?? const Color(0xFF818CF8);

    return Dismissible(
      key: Key(apt.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF87171).withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: const Color(0xFFF87171).withValues(alpha: 0.30), width: 1),
        ),
        child: const Icon(Icons.delete_rounded,
            color: Color(0xFFF87171), size: 26),
      ),
      onDismissed: (_) => controller.deleteAppointment(apt.id),
      child: GestureDetector(
        onTap: () {
          controller.prepareEdit(apt);
          Get.to(() => AddAppointmentView(existingApt: apt));
        },
        child: Container(
          decoration: BoxDecoration(
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
          ),
          child: Row(
            children: [
              // Date strip
              Container(
                width: 76,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                  border: Border(
                    right: BorderSide(
                        color: color.withValues(alpha: 0.20), width: 1),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('d').format(apt.dateTime),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: color,
                        height: 1,
                      ),
                    ),
                    Text(
                      DateFormat('MMM').format(apt.dateTime).toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: color,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time_rounded,
                                  size: 13,
                                  color:
                                      AppThemeColors.secondaryText(_b)),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('h:mm a').format(apt.dateTime),
                                style: TextStyle(
                                  color: AppThemeColors.primaryText(_b),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              // UC-31 step 9: Bell icon when reminder is set
                              if (apt.reminderMinutes != null) ...[
                                const SizedBox(width: 6),
                                Icon(
                                  apt.isRecurring
                                      ? Icons.notifications_active_rounded
                                      : Icons.notifications_rounded,
                                  size: 13,
                                  color: _kReminderColor
                                      .withValues(alpha: 0.85),
                                ),
                              ],
                            ],
                          ),
                          // Badge row: recurring + category
                          Row(
                            children: [
                              // SRS-113: Recurring badge
                              if (apt.isRecurring) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _kReminderColor
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: _kReminderColor
                                            .withValues(alpha: 0.30),
                                        width: 1),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.repeat_rounded,
                                          size: 9,
                                          color: _kReminderColor),
                                      const SizedBox(width: 3),
                                      Text(
                                        apt.recurringFrequency ?? 'Recurring',
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: _kReminderColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                              // Category badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: color.withValues(alpha: 0.30),
                                      width: 1),
                                ),
                                child: Text(
                                  apt.category,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: color,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        apt.doctorName,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppThemeColors.primaryText(_b),
                        ),
                      ),
                      if (apt.visitNotes != null &&
                          apt.visitNotes!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          apt.visitNotes!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: AppThemeColors.secondaryText(_b),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Icon(Icons.chevron_right_rounded,
                    color: AppThemeColors.hintText(_b), size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isUpcoming) {
    final icon = isUpcoming ? Icons.event_available_rounded : Icons.history_rounded;
    final title = isUpcoming ? "No Upcoming Appointments" : "No History Found";
    final subtitle = isUpcoming
        ? "Tap + to schedule your next visit"
        : "Your past appointments will appear here";

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppThemeColors.glassBg(_b),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppThemeColors.glassBorder(_b), width: 1.2),
            ),
            child: Icon(icon,
                size: 48, color: AppThemeColors.hintText(_b)),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              color: AppThemeColors.primaryText(_b),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: AppThemeColors.secondaryText(_b),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
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
          offset: Offset(0, (1 - anim.value) * 20),
          child: child,
        ),
      ),
    );
  }
}
