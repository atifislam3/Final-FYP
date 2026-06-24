import 'package:flutter/material.dart';

/// Centralised theme-aware colour helpers used across every screen.
/// Dark mode keeps the existing deep-purple glassmorphism palette.
/// Light mode uses a soft lavender-purple gradient so the theme toggle
/// produces a clearly visible, professional difference.
class AppThemeColors {
  AppThemeColors._();

  // ── Dark gradient (existing) ─────────────────────────────────────
  static const List<Color> _darkGradientColors = [
    Color(0xFF1E0A3C),
    Color(0xFF312E81),
    Color(0xFF4C1D95),
    Color(0xFF1E1B4B),
  ];

  // ── Light gradient: soft lavender → periwinkle → lilac → blush ──
  // These tones are clearly "light purple / lavender" while remaining
  // professional and easy on the eye.
  static const List<Color> _lightGradientColors = [
    Color(0xFFEDE9FE), // violet-100  – warm lavender
    Color(0xFFE0E7FF), // indigo-100  – periwinkle
    Color(0xFFEDE9FE), // violet-100  – lavender again for smooth flow
    Color(0xFFF5F3FF), // violet-50   – very light lilac fade-out
  ];

  static const List<double> _gradientStops = [0.0, 0.4, 0.7, 1.0];

  // ── Scaffold ─────────────────────────────────────────────────────

  static Color scaffoldBg(Brightness b) =>
      b == Brightness.dark ? const Color(0xFF1E0A3C) : const Color(0xFFEDE9FE);

  // ── Background gradient ──────────────────────────────────────────

  static List<Color> gradientColors(Brightness b) =>
      b == Brightness.dark ? _darkGradientColors : _lightGradientColors;

  static BoxDecoration backgroundDecoration(Brightness b) => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors(b),
          stops: _gradientStops,
        ),
      );

  // ── Navigation bar ───────────────────────────────────────────────

  static Color navBarBg(Brightness b) =>
      b == Brightness.dark
          ? const Color(0xFF1E0A3C).withValues(alpha: 0.95)
          : const Color(0xFFEDE9FE).withValues(alpha: 0.97);

  static Color navBarBorder(Brightness b) =>
      b == Brightness.dark
          ? Colors.white.withValues(alpha: 0.15)
          : const Color(0xFFC4B5FD).withValues(alpha: 0.50);

  static Color navBarSelectedIcon(Brightness b) =>
      b == Brightness.dark ? Colors.white : const Color(0xFF6D28D9);

  static Color navBarUnselectedIcon(Brightness b) =>
      b == Brightness.dark
          ? Colors.white.withValues(alpha: 0.50)
          : const Color(0xFF7C3AED).withValues(alpha: 0.45);

  static Color navBarSelectedLabel(Brightness b) =>
      b == Brightness.dark ? Colors.white : const Color(0xFF6D28D9);

  static Color navBarUnselectedLabel(Brightness b) =>
      b == Brightness.dark
          ? Colors.white.withValues(alpha: 0.50)
          : const Color(0xFF7C3AED).withValues(alpha: 0.45);

  static Color navBarPillGradientStart(Brightness b) =>
      b == Brightness.dark
          ? const Color(0xFF818CF8)
          : const Color(0xFF7C3AED).withValues(alpha: 0.18);

  static Color navBarPillGradientEnd(Brightness b) =>
      b == Brightness.dark
          ? const Color(0xFF4F46E5)
          : const Color(0xFF6D28D9).withValues(alpha: 0.18);

  // ── Text ─────────────────────────────────────────────────────────

  /// High-emphasis text (headings, tile titles)
  static Color primaryText(Brightness b) =>
      b == Brightness.dark ? Colors.white : const Color(0xFF1E1B4B);

  /// Medium-emphasis text (subtitles, descriptions)
  static Color secondaryText(Brightness b) =>
      b == Brightness.dark
          ? Colors.white.withValues(alpha: 0.65)
          : const Color(0xFF4C1D95).withValues(alpha: 0.75);

  /// Low-emphasis text (hints, timestamps, section headers)
  static Color hintText(Brightness b) =>
      b == Brightness.dark
          ? Colors.white.withValues(alpha: 0.45)
          : const Color(0xFF7C3AED).withValues(alpha: 0.55);

  // ── Glass card ───────────────────────────────────────────────────

  static Color glassBg(Brightness b) =>
      b == Brightness.dark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.white.withValues(alpha: 0.70);

  static Color glassBorder(Brightness b) =>
      b == Brightness.dark
          ? Colors.white.withValues(alpha: 0.15)
          : const Color(0xFFC4B5FD).withValues(alpha: 0.50);

  static Color glassDivider(Brightness b) =>
      b == Brightness.dark
          ? Colors.white.withValues(alpha: 0.10)
          : const Color(0xFFC4B5FD).withValues(alpha: 0.35);

  // ── Orb painter alpha multiplier ────────────────────────────────
  /// Orbs are visible on dark; very muted on the light lavender bg.
  static double orbAlpha(Brightness b) => b == Brightness.dark ? 1.0 : 0.35;

  // ── Convenience from context ─────────────────────────────────────
  static Brightness brightnessOf(BuildContext context) =>
      Theme.of(context).brightness;
}
