import 'package:flutter/material.dart';

class AppColors {
  // 60% - Dominant Color (Background/Netral)
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF1A1A1A);

  // 30% - Primary Color (Brand Identity)
  static const Color primaryBlue = Color(0xFF0066B1);
  static const Color darkBlue = Color(0xFF003865);
  static const Color navyBlue = Color(0xFF1E3A5F);

  // 10% - Accent Color (Highlight)
  static const Color accentGold = Color(0xFFE6B220);
  static const Color accentRed = Color(0xFFCC0000);
  static const Color accentGreen = Color(0xFF4CAF50);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Gradients
  static LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, darkBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient cardGradient = LinearGradient(
    colors: [white, grey100],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient goldGradient = LinearGradient(
    colors: [accentGold, Color(0xFFD4A017)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
