import 'package:flutter/material.dart';

/// Cal AI Aesthetic - Dark Theme
/// Pure black background with subtle gray accents
class AppTheme {
  // Colors
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF111111);
  static const Color surfaceLight = Color(0xFF1A1A1A);
  static const Color surfaceLighter = Color(0xFF222222);
  static const Color border = Color(0xFF333333);
  static const Color borderLight = Color(0xFF444444);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);
  
  // Accent Colors
  static const Color accent = Color(0xFF6366F1); // Indigo
  static const Color accentLight = Color(0xFF818CF8);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  
  // Wine-specific accents
  static const Color wineRed = Color(0xFF722F37);
  static const Color wineBurgundy = Color(0xFF800020);
  static const Color wineGold = Color(0xFFD4AF37);
  
  // Border Radius
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 32.0;
  
  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;
  
  // Typography
  static const String fontFamily = 'Inter';
  
  static TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: textPrimary,
      letterSpacing: -1.5,
    ),
    displayMedium: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: textPrimary,
      letterSpacing: -1,
    ),
    displaySmall: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: textPrimary,
      letterSpacing: -0.5,
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: textSecondary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: textSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: textTertiary,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textPrimary,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: textSecondary,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: textTertiary,
      letterSpacing: 0.5,
    ),
  );
  
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      background: background,
      surface: surface,
      primary: accent,
      secondary: wineGold,
      error: error,
      onBackground: textPrimary,
      onSurface: textPrimary,
      onPrimary: textPrimary,
      onSecondary: background,
    ),
    textTheme: textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: accent,
      unselectedItemColor: textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: accent),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingMd,
        vertical: spacingMd,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: textPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLg,
          vertical: spacingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimary,
        side: const BorderSide(color: border),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLg,
          vertical: spacingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceLight,
      selectedColor: accent.withOpacity(0.2),
      labelStyle: const TextStyle(color: textSecondary),
      secondaryLabelStyle: const TextStyle(color: accent),
      padding: const EdgeInsets.symmetric(
        horizontal: spacingMd,
        vertical: spacingSm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
        side: const BorderSide(color: border),
      ),
    ),
  );
}
