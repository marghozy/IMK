import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/mock/mock_data.dart';
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
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.chevron_left),
                style: IconButton.styleFrom(backgroundColor: AppColors.surface),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Pilih Tujuan Harian', style: AppTextStyles.h1),
              const SizedBox(height: AppSpacing.sm),
              Text('Berapa banyak yang ingin kamu pelajari setiap hari?', style: AppTextStyles.bodyMuted),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: ListView.separated(
                  itemCount: MockData.dailyGoals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, i) {
                    final goal = MockData.dailyGoals[i];
                    final isSelected = goal.id == selected;
                    return InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      onTap: () => ref.read(selectedGoalProvider.notifier).select(goal.id),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: isSelected ? AppColors.primary : AppColors.inkMuted,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(child: Text(goal.label, style: AppTextStyles.h2)),
                            Text('+${goal.xpTarget} XP',
                                style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              AppButton(
                label: 'MULAI BELAJAR',
                onPressed: () {
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
