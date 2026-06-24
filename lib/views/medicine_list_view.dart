import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/medicine_controller.dart';
import '../data/models/medicine_model.dart';
import 'add_medicine_view.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class MedicineListView extends StatefulWidget {
  const MedicineListView({super.key});

  @override
  State<MedicineListView> createState() => _MedicineListViewState();
}

class _MedicineListViewState extends State<MedicineListView>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final AnimationController _entryCtrl;
  late final Animation<double> _bgAnim;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4000))
      ..repeat(reverse: true);
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    _bgAnim = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }



  // type accent colours
  static const _typeColors = {
    'Tablet': Color(0xFF60A5FA),
    'Capsule': Color(0xFFC084FC),
    'Syrup': Color(0xFFFB923C),
    'Injection': Color(0xFFF87171),
  };

  Color _colorForType(String type) =>
      _typeColors[type] ?? const Color(0xFF818CF8);

  IconData _iconForType(String type) {
    switch (type) {
      case 'Tablet':
        return Icons.circle_outlined;
      case 'Capsule':
        return Icons.medication_rounded;
      case 'Syrup':
        return Icons.water_drop_outlined;
      case 'Injection':
        return Icons.vaccines_outlined;
      default:
        return Icons.medical_services_outlined;
    }
  }

  String _unitForType(String type) {
    switch (type) {
      case 'Tablet':
        return 'tablets';
      case 'Capsule':
        return 'capsules';
      case 'Syrup':
        return 'ml';
      case 'Injection':
        return 'vials';
      default:
        return 'units';
    }
  }

  Widget _staggeredItem(int index, Widget child) {
    final start = (index * 0.08).clamp(0.0, 0.6);
    return AnimatedBuilder(
      animation: _entryCtrl,
      builder: (_, __) {
        final t = Curves.easeOutCubic
            .transform((((_entryCtrl.value - start) / (1.0 - start)).clamp(0.0, 1.0)));
        return Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, 36 * (1 - t)), child: child),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final MedicineController controller = Get.put(MedicineController());
    final b = AppThemeColors.brightnessOf(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppThemeColors.scaffoldBg(b),
      floatingActionButton: _buildFAB(controller),
      body: Stack(
        children: [
          // background gradient
          Container(decoration: AppThemeColors.backgroundDecoration(b)),
          // animated orbs
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(
                t: _bgAnim.value,
                alphaMultiplier: AppThemeColors.orbAlpha(b),
              ),
              size: Size.infinite,
            ),
          ),
          // content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── App Bar ──────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                floating: false,
                expandedHeight: 120,
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      const EdgeInsets.only(left: 24, bottom: 16),
                  title: Text(
                    "My Medicines",
                    style: TextStyle(
                        color: AppThemeColors.primaryText(b),
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppThemeColors.scaffoldBg(b).withValues(alpha: 0.85),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16, top: 8),
                    child: GestureDetector(
                      onTap: () => Get.to(() => AddMedicineView()),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color(0xFF818CF8),
                            Color(0xFF4F46E5),
                          ]),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFF4F46E5)
                                    .withValues(alpha: 0.40),
                                blurRadius: 10,
                                offset: const Offset(0, 4)),
                          ],
                        ),
                        child: const Icon(Icons.add_rounded,
                            color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                ],
              ),

              // ── Low-stock alert ───────────────────────────────────────
              SliverToBoxAdapter(
                child: Obx(() {
                  final lowStock = controller.medicines
                      .where((m) => m.isActive && m.stock <= 5)
                      .toList();
                  if (lowStock.isEmpty) return const SizedBox.shrink();

                  return _staggeredItem(
                    0,
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFF97316)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFEF4444).withValues(alpha: 0.30),
                                blurRadius: 16,
                                offset: const Offset(0, 6)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.inventory_2_rounded,
                                  color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${lowStock.length} Medicine${lowStock.length > 1 ? 's' : ''} Low on Stock",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    "Tap a card to update stock",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withValues(alpha: 0.85)),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.warning_amber_rounded,
                                color: Colors.white, size: 24),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),

              // ── Medicine list with Low Stock section ─────────────────
              Obx(() {
                final meds = controller.sortedMedicines;
                if (meds.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(b),
                  );
                }

                final lowStockMeds =
                    meds.where((m) => m.stock <= 5).toList();
                final normalMeds =
                    meds.where((m) => m.stock > 5).toList();

                // Build items list: section headers + medicine cards
                final List<dynamic> items = [];
                if (lowStockMeds.isNotEmpty) {
                  items.add('_header_low');
                  items.addAll(lowStockMeds);
                }
                if (normalMeds.isNotEmpty) {
                  items.add('_header_all');
                  items.addAll(normalMeds);
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = items[index];
                        final hb = AppThemeColors.brightnessOf(context);

                        // Section header
                        if (item is String) {
                          final isLow = item == '_header_low';
                          return Padding(
                            padding: EdgeInsets.only(
                                top: isLow ? 0 : 8, bottom: 10),
                            child: Row(
                              children: [
                                Icon(
                                  isLow
                                      ? Icons.inventory_2_outlined
                                      : Icons.medication_outlined,
                                  size: 14,
                                  color: isLow
                                      ? const Color(0xFFF87171)
                                      : AppThemeColors.hintText(hb),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isLow
                                      ? '⚠  LOW STOCK'
                                      : 'ALL MEDICINES',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                    color: isLow
                                        ? const Color(0xFFF87171)
                                        : AppThemeColors.hintText(hb),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Medicine card
                        final med = item;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _staggeredItem(
                            index + 1,
                            Dismissible(
                              key: Key(med.medicineId),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 24),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444)
                                      .withValues(alpha: 0.85),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Icon(Icons.delete_rounded,
                                    color: Colors.white, size: 28),
                              ),
                              confirmDismiss: (direction) async {
                                return await Get.dialog<bool>(
                                  _buildDeleteDialog(med.name, hb),
                                );
                              },
                              onDismissed: (_) =>
                                  controller.deleteMedicine(med),
                              child: _buildMedicineCard(
                                  context, med, controller),
                            ),
                          ),
                        );
                      },
                      childCount: items.length,
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineCard(
      BuildContext context, dynamic med, MedicineController controller) {
    final b = AppThemeColors.brightnessOf(context);
    final color = _colorForType(med.type);
    final stockFrac = med.stock <= 0
        ? 0.0
        : med.stock <= 10
            ? 0.33
            : med.stock <= 50
                ? 0.66
                : 1.0;
    final barColor = med.stock > 50
        ? const Color(0xFF4ADE80)
        : med.stock > 10
            ? const Color(0xFFFBBF24)
            : const Color(0xFFF87171);

    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppThemeColors.glassBorder(b), width: 1.2),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.10),
              blurRadius: 18,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          splashColor: AppThemeColors.glassBorder(b),
          onTap: () => _showMedicineOptions(context, med, controller),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // type icon
                    Hero(
                      tag: 'med_${med.medicineId}',
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(
                              color: color.withValues(alpha: 0.30), width: 1),
                        ),
                        child: Icon(_iconForType(med.type),
                            color: color, size: 26),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            med.name,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppThemeColors.primaryText(b)),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              // type badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(med.type,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: color,
                                        fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.scale_outlined,
                                  size: 12,
                                  color: AppThemeColors.secondaryText(b)),
                              const SizedBox(width: 4),
                              Text(med.dosage,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppThemeColors.secondaryText(b))),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // stock count
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${med.stock}",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: barColor),
                        ),
                        Text(
                          _unitForType(med.type),
                          style: TextStyle(
                              fontSize: 10,
                              color: AppThemeColors.hintText(b)),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // stock bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Stock Level",
                            style: TextStyle(
                                fontSize: 11,
                                color: AppThemeColors.hintText(b),
                                fontWeight: FontWeight.w500)),
                        Text(
                          med.stock <= 5
                              ? "⚠ Low stock"
                              : med.stock <= 10
                                  ? "Running low"
                                  : "Good",
                          style: TextStyle(
                              fontSize: 11,
                              color: barColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: stockFrac,
                        backgroundColor: AppThemeColors.glassBorder(b),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(barColor),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAB(MedicineController controller) {
    return GestureDetector(
      onTap: () => Get.to(() => AddMedicineView()),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color(0xFF818CF8),
            Color(0xFF6366F1),
            Color(0xFF4F46E5),
          ]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF4F46E5).withValues(alpha: 0.45),
                blurRadius: 18,
                offset: const Offset(0, 6)),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: Colors.white, size: 22),
            SizedBox(width: 8),
            Text("Add Medicine",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Brightness b) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppThemeColors.glassBg(b),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppThemeColors.glassBorder(b), width: 1.2),
            ),
            child: Icon(Icons.medical_information_outlined,
                size: 48, color: AppThemeColors.secondaryText(b)),
          ),
          const SizedBox(height: 20),
          Text("No Medicines Yet",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColors.primaryText(b))),
          const SizedBox(height: 8),
          Text("Add medicines to track stock & reminders",
              style: TextStyle(
                  color: AppThemeColors.secondaryText(b), fontSize: 14)),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () => Get.to(() => AddMedicineView()),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color(0xFF818CF8),
                  Color(0xFF4F46E5),
                ]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.40),
                      blurRadius: 14,
                      offset: const Offset(0, 5)),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Add First Medicine",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteDialog(String name, Brightness b) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: b == Brightness.light ? Colors.white : const Color(0xFF1E1B4B),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: AppThemeColors.glassBorder(b), width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFF87171).withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  color: Color(0xFFF87171), size: 26),
            ),
            const SizedBox(height: 16),
            Text("Delete Medicine",
                style: TextStyle(
                    color: AppThemeColors.primaryText(b),
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              "Are you sure you want to delete '$name'?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppThemeColors.secondaryText(b), fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(result: false),
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppThemeColors.glassBg(b),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppThemeColors.glassBorder(b)),
                      ),
                      child: Text("Cancel",
                          style: TextStyle(color: AppThemeColors.primaryText(b))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(result: true),
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text("Delete",
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
    );
  }

  void _showMedicineOptions(BuildContext context, dynamic med, MedicineController controller) {
    final b = AppThemeColors.brightnessOf(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 24, bottom: 32, left: 24, right: 24),
          decoration: BoxDecoration(
            color: b == Brightness.light ? Colors.white : const Color(0xFF1E1B4B),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppThemeColors.hintText(b).withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              Text(med.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppThemeColors.primaryText(b))),
              const SizedBox(height: 24),
              _buildOptionButton(
                icon: Icons.edit_outlined,
                title: "Update Medicine",
                color: const Color(0xFF818CF8),
                onTap: () {
                  Get.back();
                  Get.to(() => AddMedicineView(editMedicine: med));
                },
              ),
              const SizedBox(height: 12),
              _buildOptionButton(
                icon: Icons.inventory_2_outlined,
                title: "Update Stock",
                color: const Color(0xFFF59E0B),
                onTap: () {
                  Get.back();
                  _showUpdateStockDialog(context, med, controller);
                },
              ),
              const SizedBox(height: 12),
              _buildOptionButton(
                icon: Icons.check_circle_outline,
                title: "Complete Medication",
                color: const Color(0xFF10B981),
                onTap: () {
                  Get.back();
                  controller.completeMedicine(med);
                  Get.snackbar("Completed", "${med.name} marked as complete", backgroundColor: Colors.green, colorText: Colors.white);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionButton({required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  void _showUpdateStockDialog(BuildContext context, dynamic med, MedicineController controller) {
    final b = AppThemeColors.brightnessOf(context);
    final TextEditingController stockCtrl = TextEditingController(text: med.stock.toString());
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: b == Brightness.light ? Colors.white : const Color(0xFF1E1B4B),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppThemeColors.glassBorder(b), width: 1.2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.inventory_2_outlined, color: Color(0xFFF59E0B), size: 32),
                const SizedBox(height: 16),
                Text("Update Stock", style: TextStyle(color: AppThemeColors.primaryText(b), fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: stockCtrl,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: AppThemeColors.primaryText(b)),
                  decoration: InputDecoration(
                    labelText: "New Quantity",
                    labelStyle: TextStyle(color: AppThemeColors.secondaryText(b)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppThemeColors.glassBorder(b)), borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: const Color(0xFF818CF8)), borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppThemeColors.glassBg(b),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppThemeColors.glassBorder(b)),
                          ),
                          child: Text("Cancel", style: TextStyle(color: AppThemeColors.primaryText(b))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          final newQty = int.tryParse(stockCtrl.text) ?? med.stock;
                          controller.updateStock(med, newQty);
                          Get.back();
                        },
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text("Update", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
