import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Shared animated radial-gradient orb background painter.
/// Driven by an animation value [t] in the range 0→1 (repeat/reverse).
/// [alphaMultiplier] scales all orb alphas — use < 1.0 for light-mode
/// backgrounds where full-opacity orbs would be too dominant.
class OrbPainter extends CustomPainter {
  final double t;
  final double alphaMultiplier;
  const OrbPainter({required this.t, this.alphaMultiplier = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    void orb(double cx, double cy, double r, Color c, double a) {
      final p = Paint()
        ..shader = RadialGradient(
          colors: [c.withValues(alpha: a), c.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
      canvas.drawCircle(Offset(cx, cy), r, p);
    }

    final dy = math.sin(t * math.pi) * 24;
    orb(size.width * 0.1, size.height * 0.15 + dy, 140,
        const Color(0xFF818CF8), 0.30 * alphaMultiplier);
    orb(size.width * 0.9, size.height * 0.30 - dy, 120,
        const Color(0xFFA78BFA), 0.24 * alphaMultiplier);
    orb(size.width * 0.5, size.height * 0.88 + dy * 0.5, 160,
        const Color(0xFF6366F1), 0.22 * alphaMultiplier);
  }

  @override
  bool shouldRepaint(OrbPainter old) =>
      old.t != t || old.alphaMultiplier != alphaMultiplier;
}
