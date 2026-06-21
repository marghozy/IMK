import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/step_dots.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/user.dart';
import '../../shared/state/user_providers.dart';
import '../state/goal_selection_state.dart';

class ChooseGoalPage extends ConsumerWidget {
  const ChooseGoalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedGoalProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  onTap: () =>
                      context.canPop() ? context.pop() : context.go('/onboarding'),
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(Icons.chevron_left, color: AppColors.ink),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Pilih tujuan harianmu', style: AppTextStyles.display),
              const SizedBox(height: AppSpacing.sm),
              Text('Kami akan menyesuaikan rekomendasi pelajaran.',
                  style: AppTextStyles.bodyMuted),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: ListView.separated(
                  itemCount: MockData.dailyGoals.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, i) {
                    final goal = MockData.dailyGoals[i];
                    return _GoalCard(
                      goal: goal,
                      selected: goal.id == selected,
                      onTap: () => ref
                          .read(selectedGoalProvider.notifier)
                          .select(goal.id),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const StepDots(count: 3, activeIndex: 2),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'MULAI BELAJAR',
                onPressed: selected.isEmpty
                    ? null
                    : () {
                        ref.read(userProvider.notifier).setDailyGoal(selected);
                        context.go('/register');
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final DailyGoal goal;
  final bool selected;
  final VoidCallback onTap;

  const _GoalCard(
      {required this.goal, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            _RadioCircle(selected: selected),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goal.label,
                      style: AppTextStyles.h2.copyWith(color: AppColors.ink)),
                  const SizedBox(height: 2),
                  Text(goal.subtitle, style: AppTextStyles.bodyMuted),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _XpPill(xp: goal.xpTarget),
          ],
        ),
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  final bool selected;
  const _RadioCircle({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.locked,
          width: 2,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 18, color: Colors.white)
          : null,
    );
  }
}

class _XpPill extends StatelessWidget {
  final int xp;
  const _XpPill({required this.xp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.border),
      ),
      child: Text('$xp XP',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.accentOrange,
            fontWeight: FontWeight.w800,
          )),
    );
  }
}
