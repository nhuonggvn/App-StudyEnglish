import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunitoSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: const BorderSide(color: AppColors.outlineVariant, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceContainerLowest,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.outline,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.nunitoSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.02,
      ),
      displayMedium: GoogleFonts.nunitoSans(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.nunitoSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.nunitoSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.nunitoSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.nunitoSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.nunitoSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.nunitoSans(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textHint,
      ),
      labelLarge: GoogleFonts.nunitoSans(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
    );
  }
}
