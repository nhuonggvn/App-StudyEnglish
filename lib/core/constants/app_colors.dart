import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Bảng màu thiết kế Bento Minimalist cao cấp (Tím chủ đạo & Xanh lá thẫm nhấn)
  static const Color primary = Color(0xFF6B38D4);
  static const Color primaryContainer = Color(0xFF8455EF);
  static const Color primaryFixed = Color(0xFFE9DDFF);
  static const Color primaryFixedDim = Color(0xFFD0BCFF);
  
  static const Color secondary = Color(0xFF006C49);
  static const Color secondaryContainer = Color(0xFF6CF8BB);
  static const Color onSecondaryContainer = Color(0xFF00714D);
  static const Color onSecondaryFixedVariant = Color(0xFF005236);

  static const Color onSurface = Color(0xFF1D1A23);
  static const Color onSurfaceVariant = Color(0xFF494454);
  static const Color outlineVariant = Color(0xFFCBC3D7);
  static const Color outline = Color(0xFF7B7486);

  static const Color surfaceContainerHighest = Color(0xFFE7E0ED);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF8F1FE);
  static const Color surfaceContainerHigh = Color(0xFFEDE5F3);
  static const Color surfaceContainer = Color(0xFFF3EBF8);

  static const Color tertiary = Color(0xFF825100);
  static const Color tertiaryFixed = Color(0xFFFFDDB8);
  static const Color onTertiaryFixedVariant = Color(0xFF653E00);

  static const Color error = Color(0xFFBA1A1A);

  // Tương thích ngược với các file hiện tại (mapping màu cũ sang màu bento mới)
  static const Color primaryBlue = Color(0xFF6B38D4);
  static const Color primaryPurple = Color(0xFF8455EF);
  static const Color primaryPink = Color(0xFF006C49);
  static const Color primaryOrange = Color(0xFF825100);
  static const Color primaryYellow = Color(0xFF825100);
  static const Color primaryGreen = Color(0xFF006C49);
  static const Color primaryRed = Color(0xFFBA1A1A);
  static const Color primaryTeal = Color(0xFF006C49);

  // Background & Surface
  static const Color backgroundLight = Color(0xFFFEF7FF);
  static const Color backgroundDark = Color(0xFF1D1A23);
  static const Color backgroundCard = Color(0xFFFFFFFF);
  static const Color backgroundCardDark = Color(0xFF322F39);

  static const Color surfaceLight = Color(0xFFFEF7FF);
  static const Color surfaceDark = Color(0xFF322F39);

  // Text Colors
  static const Color textPrimary = Color(0xFF1D1A23);
  static const Color textSecondary = Color(0xFF494454);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textHint = Color(0xFF7B7486);

  // Game Category Colors
  static const Color categoryFlashcard = Color(0xFF6B38D4);
  static const Color categoryQuiz = Color(0xFF006C49);
  static const Color categoryMatching = Color(0xFF825100);
  static const Color categoryListening = Color(0xFF8455EF);
  static const Color categorySpelling = Color(0xFF006C49);

  // Status Colors
  static const Color success = Color(0xFF006C49);
  static const Color warning = Color(0xFF825100);
  static const Color info = Color(0xFF6B38D4);

  // Star/Badge Colors
  static const Color starGold = Color(0xFF825100);
  static const Color starSilver = Color(0xFF7B7486);
  static const Color starBronze = Color(0xFF653E00);

  // Soft Tint Colors
  static const Color softGreenTint = Color(0xFF6CF8BB);
  static const Color softGreenCard = Color(0xFF6CF8BB);

  // Gradient Collections
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6B38D4), Color(0xFF8455EF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFF825100), Color(0xFFFFDDB8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coolGradient = LinearGradient(
    colors: [Color(0xFF006C49), Color(0xFF6CF8BB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFF8455EF), Color(0xFFE9DDFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient skyGradient = LinearGradient(
    colors: [Color(0xFFE9DDFF), Color(0xFFFEF7FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient forestGradient = LinearGradient(
    colors: [Color(0xFF006C49), Color(0xFF005236)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [
      Color(0xFF6B38D4),
      Color(0xFF8455EF),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Age group colors
  static const Color ageGroup3to5 = Color(0xFF6B38D4);
  static const Color ageGroup6to7 = Color(0xFF006C49);
  static const Color ageGroup8to10 = Color(0xFF825100);
}
