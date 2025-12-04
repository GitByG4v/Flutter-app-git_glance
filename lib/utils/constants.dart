import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Palette
  static const Color primaryBlue = Color(0xFF2563EB); // Vibrant Royal Blue
  static const Color primaryLight = Color(0xFF60A5FA); // Soft Blue
  static const Color backgroundWhite = Color(0xFFF8FAFC); // Cool White
  static const Color surfaceWhite = Color(0xFFFFFFFF); // Pure White
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B); // Slate 800
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  
  // Accents
  static const Color accentTeal = Color(0xFF2DD4BF);
  static const Color error = Color(0xFFEF4444);
  
  // Gradients
  static const LinearGradient liquidGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEFF6FF), // Blue 50
      Color(0xFFDBEAFE), // Blue 100
    ],
  );
}

class AppTextStyles {
  static TextStyle get header => GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      );

  static TextStyle get subHeader => GoogleFonts.outfit(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      );

  static TextStyle get body => GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 14,
      );
      
  static TextStyle get caption => GoogleFonts.inter(
        color: AppColors.textSecondary,
        fontSize: 12,
      );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundWhite,
      primaryColor: AppColors.primaryBlue,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.primaryLight,
        surface: AppColors.surfaceWhite,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.header.copyWith(fontSize: 32),
        titleLarge: AppTextStyles.header,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
        labelSmall: AppTextStyles.caption,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
    );
  }
}
