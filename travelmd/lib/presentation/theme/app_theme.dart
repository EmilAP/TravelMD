import 'package:flutter/material.dart';

class AppColors {
  static const Color brand = Color(0xFF0D5E63);
  static const Color brandSoft = Color(0xFFE8F4F4);
  static const Color accent = Color(0xFF2C8C7A);
  static const Color urgent = Color(0xFFB93A32);
  static const Color important = Color(0xFFCD7B1B);
  static const Color routine = Color(0xFF2E7D4A);
  static const Color background = Color(0xFFF5F7F8);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1E2A2B);
  static const Color textSecondary = Color(0xFF4E6264);
}

class AppSpacing {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      brightness: Brightness.light,
      primary: AppColors.brand,
      secondary: AppColors.accent,
      surface: AppColors.surface,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8E9)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD4DCDE)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD4DCDE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.brand, width: 1.4),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.brand,
        side: const BorderSide(color: Color(0xFFBCD0D2)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      side: const BorderSide(color: Color(0xFFD4DCDE)),
      backgroundColor: Colors.white,
      selectedColor: AppColors.brandSoft,
    ),
    textTheme: base.textTheme.copyWith(
      headlineSmall: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: const TextStyle(color: AppColors.textPrimary),
      bodyMedium: const TextStyle(color: AppColors.textSecondary),
    ),
  );
}