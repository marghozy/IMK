import 'package:flutter/material.dart';

/// Color tokens extracted from the JawaLingo Figma reference screenshots.
class AppColors {
  AppColors._();

  // Primary green (header gradients, primary buttons, active nav)
  static const Color primary = Color(0xFF58CC02);
  static const Color primaryDark = Color(0xFF3FA000);
  static const Color primaryLight = Color(0xFF8BDB3A);

  static const List<Color> primaryGradient = [primaryDark, primary];

  // Danger / incorrect feedback
  static const Color danger = Color(0xFFE14747);
  static const Color dangerDark = Color(0xFFC23636);
  static const List<Color> dangerGradient = [dangerDark, danger];

  // Accents
  static const Color accentOrange = Color(0xFFFFA726);
  static const Color accentYellow = Color(0xFFFFD15C);
  static const Color accentBlue = Color(0xFF4FC3F7);
  static const Color accentPurple = Color(0xFFB39DDB);
  static const Color accentCream = Color(0xFFF3E0B8);

  // Neutrals
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF1F2933);
  static const Color inkMuted = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color locked = Color(0xFFD1D5DB);
}
