import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _base => GoogleFonts.baloo2(color: AppColors.ink);

  static TextStyle get display => _base.copyWith(fontSize: 28, fontWeight: FontWeight.w700);
  static TextStyle get h1 => _base.copyWith(fontSize: 24, fontWeight: FontWeight.w700);
  static TextStyle get h2 => _base.copyWith(fontSize: 18, fontWeight: FontWeight.w700);
  static TextStyle get body => GoogleFonts.nunito(fontSize: 15, color: AppColors.ink);
  static TextStyle get bodyMuted =>
      GoogleFonts.nunito(fontSize: 14, color: AppColors.inkMuted);
  static TextStyle get caption =>
      GoogleFonts.nunito(fontSize: 12, color: AppColors.inkMuted);
  static TextStyle get labelUppercase => GoogleFonts.nunito(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.inkMuted,
        letterSpacing: 0.8,
      );
  static TextStyle get button =>
      GoogleFonts.baloo2(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white);

  /// Used for rendering real Javanese script glyphs.
  static TextStyle aksara({double size = 40, Color? color}) =>
      GoogleFonts.notoSansJavanese(fontSize: size, color: color ?? AppColors.ink);
}
