import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors - Gradient vibrant
  static const Color primaryBlue = Color(0xFF4A90D9);
  static const Color primaryPurple = Color(0xFF7B68EE);
  static const Color primaryPink = Color(0xFFFF6B9D);
  static const Color primaryOrange = Color(0xFFFF8C42);
  static const Color primaryYellow = Color(0xFFFFD93D);
  static const Color primaryGreen = Color(0xFF6BCB77);
  static const Color primaryRed = Color(0xFFFF6B6B);
  static const Color primaryTeal = Color(0xFF4ECDC4);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8F9FF);
  static const Color backgroundDark = Color(0xFF1A1B3D);
  static const Color backgroundCard = Color(0xFFFFFFFF);
  static const Color backgroundCardDark = Color(0xFF252750);

  // Surface Colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF2D2F5E);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textHint = Color(0xFFB2BEC3);

  // Game Category Colors
  static const Color categoryFlashcard = Color(0xFF6C5CE7);
  static const Color categoryQuiz = Color(0xFFFF7675);
  static const Color categoryMatching = Color(0xFF00B894);
  static const Color categoryListening = Color(0xFF0984E3);
  static const Color categorySpelling = Color(0xFFFDAA5E);

  // Status Colors
  static const Color success = Color(0xFF00B894);
  static const Color error = Color(0xFFE17055);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color info = Color(0xFF74B9FF);

  // Star/Badge Colors
  static const Color starGold = Color(0xFFFFD700);
  static const Color starSilver = Color(0xFFC0C0C0);
  static const Color starBronze = Color(0xFFCD7F32);

  // Gradient Collections
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [primaryOrange, primaryPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coolGradient = LinearGradient(
    colors: [primaryTeal, primaryGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFA709A), Color(0xFFFEE140)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient skyGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient forestGradient = LinearGradient(
    colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [
      Color(0xFF667EEA),
      Color(0xFF764BA2),
      Color(0xFFFC5C7D),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Age group colors
  static const Color ageGroup3to5 = Color(0xFFFF6B9D);
  static const Color ageGroup6to7 = Color(0xFF4ECDC4);
  static const Color ageGroup8to10 = Color(0xFF7B68EE);
}
