import 'package:flutter/material.dart';

class AppColors {
  // Primary Forest Clinical Brand (Stitch PulseCare Shifts)
  static const Color primary = Color(0xFF316342);
  static const Color primaryContainer = Color(0xFF4A7C59);
  static const Color primaryDark = Color(0xFF1E5031);
  static const Color primaryLight = Color(0xFFB9EFC5);
  static const Color primaryFixed = Color(0xFFB9EFC5);
  static const Color primaryTint = Color(0xFFE1FFE5);

  // Secondary Warm Sand / Earth Accents
  static const Color secondary = Color(0xFF655D52);
  static const Color secondaryContainer = Color(0xFFE9DED0);
  static const Color secondaryLight = Color(0xFFECE1D3);

  // Tertiary Muted Warm Gold
  static const Color tertiary = Color(0xFF6D5622);
  static const Color tertiaryContainer = Color(0xFF886E38);
  static const Color tertiaryFixed = Color(0xFFFFDEA0);

  // Surfaces & Backgrounds
  static const Color background = Color(0xFFF7FAF4);
  static const Color surface = Colors.white;
  static const Color surfaceLow = Color(0xFFF1F5EF);
  static const Color surfaceContainer = Color(0xFFECEFE9);
  static const Color surfaceHigh = Color(0xFFE6E9E3);
  static const Color surfaceHighest = Color(0xFFE0E3DE);
  static const Color inputBackground = Color(0xFFF1F5EF);
  static const Color cardBorder = Color(0xFFE0E3DE);

  // Typography
  static const Color textPrimary = Color(0xFF191D19);
  static const Color textSecondary = Color(0xFF414942);
  static const Color textMuted = Color(0xFF717971);
  static const Color outline = Color(0xFF717971);
  static const Color outlineVariant = Color(0xFFC1C9BF);

  // Semantic Status & Types
  static const Color dayAccentBg = Color(0xFFFFF6ED);
  static const Color dayIcon = Color(0xFFD97706);

  static const Color eveningAccentBg = Color(0xFFE9DED0);
  static const Color eveningIcon = Color(0xFF655D52);

  static const Color nightAccentBg = Color(0xFFB9EFC5);
  static const Color nightIcon = Color(0xFF316342);

  static const Color offDutyAccentBg = Color(0xFFECEFE9);
  static const Color offDutyIcon = Color(0xFF655D52);

  static const Color pdfRed = Color(0xFFBA1A1A);
  static const Color csvGreen = Color(0xFF316342);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);

  // Primary Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF316342),
      Color(0xFF4A7C59),
    ],
  );

  // Subtle ambient shadows matching Stitch elevation system
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF2E3230).withOpacity(0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: const Color(0xFF2E3230).withOpacity(0.02),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get buttonGlow => [
        BoxShadow(
          color: primary.withOpacity(0.24),
          blurRadius: 14,
          offset: const Offset(0, 6),
          spreadRadius: 0,
        ),
      ];
}
