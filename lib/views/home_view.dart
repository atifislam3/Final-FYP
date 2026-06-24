import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'profile_view.dart';
import 'medicine_list_view.dart';
import 'tabs/dashboard_view.dart';
import 'tabs/health_hub_view.dart';
import '../utils/app_theme_colors.dart';
import '../data/services/notification_service.dart';
import 'medicine_action_dialog.dart';

// ─────────────────────────────────────────────────────────────
// MedCare Home — Glassmorphism nav bar with animated pill indicator
// ─────────────────────────────────────────────────────────────

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final RxInt selectedIndex = 0.obs;
  final RxInt previousIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    // After the first frame, check if a notification tap parked a payload
    // during the splash screen (cold-start) and show the action dialog.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pending = NotificationService.consumePendingNotification();
      if (pending != null) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            Get.to(
              () => MedicineActionDialog(
                medicineId: pending.medicineId,
                scheduledTime: pending.scheduledTime,
              ),
              fullscreenDialog: true,
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 300),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardView(),
      HealthHubView(),
      MedicineListView(),
      ProfileView(),
    ];

    return Scaffold(
      extendBody: true,
      body: Obx(() {
        final current = selectedIndex.value;
        final previous = previousIndex.value;
        final slideRight = current > previous;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            final begin =
                slideRight ? const Offset(0.05, 0) : const Offset(-0.05, 0);
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position:
                    Tween<Offset>(begin: begin, end: Offset.zero).animate(curved),
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(current),
            child: pages[current],
          ),
        );
      }),
      bottomNavigationBar: _PremiumNavBar(
        selectedIndex: selectedIndex,
        previousIndex: previousIndex,
      ),
    );
  }
}

// ── Premium Glassmorphism Nav Bar ────────────────────────────
class _PremiumNavBar extends StatelessWidget {
  final RxInt selectedIndex;
  final RxInt previousIndex;

  const _PremiumNavBar({
    required this.selectedIndex,
    required this.previousIndex,
  });

  static const _items = [
    (icon: Icons.home_outlined, selectedIcon: Icons.home_rounded, label: 'Today'),
    (icon: Icons.hub_outlined, selectedIcon: Icons.hub_rounded, label: 'Hub'),
    (icon: Icons.medication_outlined, selectedIcon: Icons.medication_rounded, label: 'Medicines'),
    (icon: Icons.person_outline_rounded, selectedIcon: Icons.person_rounded, label: 'Profile'),
  ];

  void _onTap(int index) {
    if (selectedIndex.value == index) return;
    HapticFeedback.lightImpact();
    previousIndex.value = selectedIndex.value;
    selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.navBarBg(b),
        border: Border(
          top: BorderSide(
            color: AppThemeColors.navBarBorder(b),
            width: 1.2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Obx(() => Row(
              children: List.generate(_items.length, (i) {
                final item = _items[i];
                return _NavItem(
                  index: i,
                  selectedIndex: selectedIndex.value,
                  icon: item.icon,
                  selectedIcon: item.selectedIcon,
                  label: item.label,
                  onTap: () => _onTap(i),
                );
              }),
            )),
      ),
    );
  }
}

// ── Nav Item ─────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    final b = AppThemeColors.brightnessOf(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gradient pill indicator for selected, transparent for unselected
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppThemeColors.navBarPillGradientStart(b),
                            AppThemeColors.navBarPillGradientEnd(b),
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? selectedIcon : icon,
                    key: ValueKey(isSelected),
                    size: 24,
                    color: isSelected
                        ? AppThemeColors.navBarSelectedIcon(b)
                        : AppThemeColors.navBarUnselectedIcon(b),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppThemeColors.navBarSelectedLabel(b)
                      : AppThemeColors.navBarUnselectedLabel(b),
                  letterSpacing: isSelected ? 0.2 : 0,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
