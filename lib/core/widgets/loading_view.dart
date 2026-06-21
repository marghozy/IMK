import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Shared full-screen loading/transition state, modeled on the Figma
/// "Bersiap..." reference screen, reusable for any countdown/fetch delay.
class LoadingView extends StatelessWidget {
  final String title;
  final Widget centerContent;
  final String message;
  final List<Widget> infoPills;

  const LoadingView({
    super.key,
    required this.title,
    required this.centerContent,
    required this.message,
    this.infoPills = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppTextStyles.labelUppercase.copyWith(color: Colors.white, letterSpacing: 1.4),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: centerContent,
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                if (infoPills.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxl),
                  Wrap(spacing: AppSpacing.sm, alignment: WrapAlignment.center, children: infoPills),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingInfoPill extends StatelessWidget {
  final String label;
  final IconData? icon;

  const LoadingInfoPill({super.key, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: Colors.white),
            const SizedBox(width: 6),
          ],
          Text(label, style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
