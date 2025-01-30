import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFF81C784);
  static const Color darkGreen = Color(0xFF1B5E20);

  // Accent Colors
  static const Color leafAccent = Color(0xFF66BB6A);
  static const Color earthBrown = Color(0xFF795548);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F8F5);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textDark = Color(0xFF212121);
  static const Color textMedium = Color(0xFF666666);
  static const Color textLight = Color(0xFF9E9E9E);

  // Custom Text Styles
  static TextStyle get headlineLarge => GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textDark,
  );

  static TextStyle get headlineMedium => GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textDark,
  );

  static TextStyle get bodyLarge => GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textDark,
  );

  static TextStyle get bodyMedium => GoogleFonts.lato(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textMedium,
  );

  // Navigation Bar Colors
  static const navigationBarBackground = backgroundLight;

  // Bottom Tab Bar Theme
  static CupertinoTabBar defaultTabBar({
    required List<BottomNavigationBarItem> items,
  }) => CupertinoTabBar(
    items: items,
    backgroundColor: backgroundLight,
    activeColor: primaryGreen,
    inactiveColor: textLight,
  );

  // Standard Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 400);

  // Shadow
  static List<BoxShadow> get defaultShadow => [
    BoxShadow(
      color: primaryGreen.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  // Card Decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(borderRadiusMedium),
    boxShadow: defaultShadow,
  );
}