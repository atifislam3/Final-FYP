import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../view_models/report_controller.dart';
import '../data/models/report_model.dart';
import 'report_pdf_view.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView>
    with TickerProviderStateMixin {
  Brightness _b = Brightness.dark;

  late final AnimationController _bgCtrl;
  late final AnimationController _entryCtrl;

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
    final ReportController controller = Get.put(ReportController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Gradient background ──────────────────────────────────────
          Container(decoration: AppThemeColors.backgroundDecoration(b)),
          // ── Animated orbs ────────────────────────────────────────────
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(t: _bgCtrl.value, alphaMultiplier: AppThemeColors.orbAlpha(b)),
              size: Size.infinite,
            ),
          ),
          // ── Main content ─────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, controller),
                _buildHeader(),
                _buildSearchBar(controller),
                const SizedBox(height: 8),
                _buildFilterBar(controller),
                const SizedBox(height: 8),
                Expanded(child: _buildReportsList(controller)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context, ReportController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: AppThemeColors.primaryText(_b)),
            onPressed: () => Get.back(),
          ),
          const Spacer(),
          Text(
            'Medical Archive',
            style: TextStyle(
                color: AppThemeColors.primaryText(_b),
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          const Spacer(),
          _GlassButton(
            onTap: () => _showAddReportDialog(context, controller),
            child: const Icon(Icons.upload_file_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  // ── Gradient header ───────────────────────────────────────────────────
  Widget _buildHeader() {
    return FadeTransition(
      opacity: CurvedAnimation(
          parent: _entryCtrl,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.folder_special_rounded,
                  color: Colors.white, size: 26),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Records',
                    style: TextStyle(
                        color: AppThemeColors.primaryText(_b),
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                Text('Prescriptions & Lab Results',
                    style: TextStyle(
                        color: AppThemeColors.secondaryText(_b),
                        fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Glass search bar ──────────────────────────────────────────────────
  Widget _buildSearchBar(ReportController controller) {
    return SlideTransition(
      position: Tween<Offset>(
              begin: const Offset(0, 0.3), end: Offset.zero)
          .animate(CurvedAnimation(
              parent: _entryCtrl,
              curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Container(
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
              hintText: 'Search records by name, type or date...',
              hintStyle: TextStyle(
                  color: AppThemeColors.hintText(_b), fontSize: 14),
              prefixIcon: Icon(Icons.search_rounded,
                  color: AppThemeColors.secondaryText(_b)),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar(ReportController controller) {
    return Obx(() {
      final dateFilter = controller.selectedDate.value;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
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
                          value: controller.selectedCategory.value,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppThemeColors.secondaryText(_b)),
                          dropdownColor: AppThemeColors.scaffoldBg(_b),
                          items: controller.categories
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category,
                                        style: TextStyle(
                                            color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.w500)),
                                  ))
                              .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.setCategoryFilter(value);
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
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: dateFilter ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.fromSwatch(
                          primarySwatch: Colors.indigo,
                          brightness: _b,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  controller.setDateFilter(picked);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppThemeColors.glassBg(_b),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppThemeColors.glassBorder(_b), width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_rounded,
                          size: 18, color: AppThemeColors.secondaryText(_b)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          dateFilter == null
                              ? 'Filter by date'
                              : DateFormat('dd MMM yyyy').format(dateFilter),
                          style: TextStyle(
                              color: dateFilter == null
                                  ? AppThemeColors.secondaryText(_b)
                                  : AppThemeColors.primaryText(_b)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (dateFilter != null || controller.selectedCategory.value != 'All')
              IconButton(
                icon: Icon(Icons.clear_rounded,
                    color: AppThemeColors.secondaryText(_b)),
                onPressed: controller.clearFilters,
              ),
          ],
        ),
      );
    });
  }

  // ── Reports list ──────────────────────────────────────────────────────
  Widget _buildReportsList(ReportController controller) {
    return Obx(() {
      if (controller.filteredReports.isEmpty) {
        return _buildEmptyState(controller);
      }
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: controller.filteredReports.length,
        itemBuilder: (context, index) {
          final report = controller.filteredReports[index];
          final delay = (index * 0.06).clamp(0.0, 0.7);
          return AnimatedBuilder(
            animation: _entryCtrl,
            builder: (_, child) {
              final t = CurvedAnimation(
                parent: _entryCtrl,
                curve: Interval(delay, (delay + 0.4).clamp(0.0, 1.0),
                    curve: Curves.easeOutCubic),
              ).value;
              return Opacity(
                opacity: t,
                child: Transform.translate(
                    offset: Offset(0, 30 * (1 - t)), child: child),
              );
            },
            child: _buildReportCard(context, report, controller),
          );
        },
      );
    });
  }

  // ── Empty state ───────────────────────────────────────────────────────
  Widget _buildEmptyState(ReportController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppThemeColors.glassBg(_b),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppThemeColors.glassBorder(_b), width: 1.2),
            ),
            child: Icon(Icons.folder_off_outlined,
                size: 48, color: AppThemeColors.secondaryText(_b)),
          ),
          const SizedBox(height: 20),
          Text(
            controller.searchQuery.value.isNotEmpty
                ? 'No matching records found'
                : 'No medical records yet',
            style: TextStyle(
                color: AppThemeColors.primaryText(_b),
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
          if (controller.searchQuery.value.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Upload prescriptions or lab results here.',
                style: TextStyle(
                    color: AppThemeColors.secondaryText(_b), fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  // ── Glass report card ─────────────────────────────────────────────────
  Widget _buildReportCard(
      BuildContext context, ReportModel report, ReportController controller) {
    final (icon, badgeColor) = _categoryStyle(report.category);

    return Dismissible(
      key: Key(report.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: Colors.red.withValues(alpha: 0.35), width: 1.2),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        _confirmDelete(context, controller, report.id);
        return false;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppThemeColors.glassBg(_b),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: AppThemeColors.glassBorder(_b), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.20),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            if (report.filePath.toLowerCase().endsWith('.pdf')) {
              Get.to(() => ReportPdfView(filePath: report.filePath));
            } else {
              controller.openReport(report.filePath);
            }
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: badgeColor, size: 22),
                ),
                const SizedBox(width: 14),
                // Title + meta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(report.title,
                          style: TextStyle(
                              color: AppThemeColors.primaryText(_b),
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _CategoryBadge(
                              label: report.category, color: badgeColor),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MMM d, y')
                                .format(report.dateUploaded),
                            style: TextStyle(
                                color: AppThemeColors.secondaryText(_b),
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.open_in_new_rounded,
                    size: 18,
                    color: AppThemeColors.hintText(_b)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  (IconData, Color) _categoryStyle(String category) {
    switch (category) {
      case 'Prescription':
        return (Icons.medication_rounded, const Color(0xFF818CF8));
      case 'Lab Result':
        return (Icons.biotech_rounded, const Color(0xFF34D399));
      default:
        return (Icons.grid_view_rounded, const Color(0xFFA78BFA));
    }
  }

  // ── Upload dialog ─────────────────────────────────────────────────────
  void _showAddReportDialog(
      BuildContext context, ReportController controller) {
    final titleController = TextEditingController();
    String selectedType = 'Prescription';

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: _b == Brightness.light ? Colors.white : const Color(0xFF1E1B4B),
            gradient: null,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
                color: AppThemeColors.glassBorder(_b), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F46E5).withValues(alpha: 0.4),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: StatefulBuilder(builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Color(0xFF818CF8),
                          Color(0xFF6366F1)
                        ]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.upload_file_rounded,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text('Upload Document',
                        style: TextStyle(
                            color: AppThemeColors.primaryText(_b),
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 24),
                // Title field
                _GlassTextField(
                  controller: titleController,
                  label: 'Document Title',
                  hint: 'e.g., Blood Test Jan',
                  icon: Icons.text_fields_rounded,
                ),
                const SizedBox(height: 20),
                Text('Document Type',
                    style: TextStyle(
                        color: AppThemeColors.secondaryText(_b),
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: ['Prescription', 'Lab Result', 'Other'].map((t) {
                    final sel = selectedType == t;
                    return GestureDetector(
                      onTap: () =>
                          setDialogState(() => selectedType = t),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: sel
                              ? const LinearGradient(colors: [
                                  Color(0xFF818CF8),
                                  Color(0xFF6366F1)
                                ])
                              : null,
                          color: sel
                              ? null
                              : AppThemeColors.glassDivider(_b),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: sel
                                ? Colors.transparent
                                : AppThemeColors.glassBorder(_b),
                          ),
                        ),
                        child: Text(t,
                            style: TextStyle(
                                color: AppThemeColors.primaryText(_b),
                                fontWeight: sel
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),
                // Upload button
                GestureDetector(
                  onTap: () {
                    if (titleController.text.isEmpty) {
                      Get.snackbar('Error', 'Please enter a title');
                      return;
                    }
                    Navigator.pop(context);
                    controller.pickAndAddReport(
                      title: titleController.text,
                      category: selectedType,
                    );
                  },
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
                          color: const Color(0xFF4F46E5)
                              .withValues(alpha: 0.40),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file_rounded,
                            color: Colors.white, size: 18),
                        SizedBox(width: 10),
                        Text('Select File & Upload',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, ReportController controller, String id) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: _b == Brightness.light ? Colors.white : const Color(0xFF1E1B4B),
            gradient: null,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: AppThemeColors.glassBorder(_b), width: 1.2),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline,
                    color: Colors.redAccent, size: 28),
              ),
              const SizedBox(height: 16),
              Text('Delete Record?',
                  style: TextStyle(
                      color: AppThemeColors.primaryText(_b),
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              const SizedBox(height: 10),
              Text(
                'This action cannot be undone. The file reference will be removed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppThemeColors.secondaryText(_b),
                    fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppThemeColors.glassDivider(_b),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppThemeColors.glassBorder(_b)),
                        ),
                        alignment: Alignment.center,
                        child: Text('Cancel',
                            style: TextStyle(color: AppThemeColors.primaryText(_b))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.deleteReport(id);
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.red.withValues(alpha: 0.45)),
                        ),
                        alignment: Alignment.center,
                        child: const Text('Delete',
                            style: TextStyle(
                                color: Color(0xFFFCA5A5),
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

// ── Shared small widgets ───────────────────────────────────────────────────

class _GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _GlassButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final _b = AppThemeColors.brightnessOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppThemeColors.glassDivider(_b),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: AppThemeColors.glassBorder(_b), width: 1.2),
        ),
        child: child,
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _CategoryBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}

class _GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  const _GlassTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final _b = AppThemeColors.brightnessOf(context);
    return TextField(
      controller: controller,
      style: TextStyle(color: AppThemeColors.primaryText(_b)),
      autofocus: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            TextStyle(color: AppThemeColors.secondaryText(_b)),
        hintText: hint,
        hintStyle: TextStyle(color: AppThemeColors.hintText(_b)),
        prefixIcon: Icon(icon,
            color: AppThemeColors.secondaryText(_b)),
        filled: true,
        fillColor: AppThemeColors.glassDivider(_b),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: AppThemeColors.glassBorder(_b), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: Color(0xFFC7D2FE), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: Color(0xFFFCA5A5), width: 1.2),
        ),
      ),
    );
  }
}
