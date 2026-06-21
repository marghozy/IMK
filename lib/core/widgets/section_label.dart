import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A small uppercase section heading prefixed with a leading icon, e.g.
/// "🏆 PENCAPAIAN" rendered as an icon + text instead of an emoji.
class SectionLabel extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const SectionLabel({super.key, required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.inkMuted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: c),
        const SizedBox(width: 6),
        Text(text, style: AppTextStyles.labelUppercase.copyWith(color: c)),
      ],
    );
  }
}
