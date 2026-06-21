import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Page indicator shared across the onboarding flow.
class StepDots extends StatelessWidget {
  final int count;
  final int activeIndex;

  const StepDots({super.key, required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == activeIndex ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: i == activeIndex ? AppColors.primary : AppColors.border,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
      ),
    );
  }
}
