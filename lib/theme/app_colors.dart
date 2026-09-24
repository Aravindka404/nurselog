import 'package:flutter/material.dart';

class AppColors {
  // Primary Medical Blues
  static const Color primary = Color(0xFF1B68F8);
  static const Color primaryDark = Color(0xFF0B4FD9);
  static const Color primaryLight = Color(0xFFEBF3FF);
  static const Color primaryTint = Color(0xFFF0F5FF);

  // Light Backgrounds & Surfaces
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Colors.white;
  static const Color inputBackground = Color(0xFFF3F5F9);
  static const Color cardBorder = Color(0xFFEDF1F7);

  // Dark Mode Surfaces (Deep Charcoal & True Black Aesthetic)
  static const Color darkBackground = Color(0xFF0B1120);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCardBorder = Color(0xFF334155);
  static const Color darkInputBackground = Color(0xFF131D30);

  // Typography / Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF8E9AAB);
  static const Color textMuted = Color(0xFFB0B9C6);

  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Accents & Badges
  static const Color dayAccentBg = Color(0xFFFFF9E6);
  static const Color dayIcon = Color(0xFFD97706);

  static const Color eveningAccentBg = Color(0xFFF3E8FF);
  static const Color eveningIcon = Color(0xFF9333EA);

  static const Color nightAccentBg = Color(0xFFEEF2FF);
  static const Color nightIcon = Color(0xFF4F46E5);

  static const Color offDutyAccentBg = Color(0xFFECFDF5);
  static const Color offDutyIcon = Color(0xFF059669);

  static const Color pdfRed = Color(0xFFEF4444);
  static const Color csvGreen = Color(0xFF10B981);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF246CF9),
      Color(0xFF0B4FD9),
    ],
  );

  // Soft Shadows
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF1E293B).withOpacity(0.04),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: const Color(0xFF1E293B).withOpacity(0.02),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get darkCardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get buttonGlow => [
        BoxShadow(
          color: primary.withOpacity(0.38),
          blurRadius: 18,
          offset: const Offset(0, 8),
          spreadRadius: 1,
        ),
      ];
}
