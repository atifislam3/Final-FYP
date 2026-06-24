import 'package:flutter/material.dart';

class AnimatedListItem extends StatelessWidget {
  final int index;
  final Widget child;

  const AnimatedListItem({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Interval(
        (index * 0.1).clamp(0.0, 0.5),
        1.0,
        curve: Curves.easeOutCubic,
      ),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)), // Slide up
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// Improved version with proper stagger using Interval
class StaggeredListItem extends StatelessWidget {
  final int index;
  final Widget child;
  final AnimationController? controller; // Optional if we want manual control

  const StaggeredListItem({
    super.key,
    required this.index,
    required this.child,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      // Delay start by modifying the curve interval
      curve: Interval(
        (index * 0.1).clamp(0.0, 0.8), // Start time
        1.0, // End time
        curve: Curves.easeOutQuart,
      ),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
