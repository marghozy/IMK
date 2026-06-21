import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class XpBadge extends StatelessWidget {
  final int xp;
  final bool light;

  const XpBadge({super.key, required this.xp, this.light = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: light ? Colors.white.withValues(alpha: 0.25) : AppColors.danger,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 15, color: Colors.white),
          const SizedBox(width: AppSpacing.xs),
          Text('$xp XP', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class StreakPill extends StatelessWidget {
  final int days;

  const StreakPill({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.accentYellow,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department_rounded, size: 15, color: AppColors.ink),
          const SizedBox(width: AppSpacing.xs),
          Text('$days', style: AppTextStyles.caption.copyWith(color: AppColors.ink, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
