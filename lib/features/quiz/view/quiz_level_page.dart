import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/xp_badge.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/quiz.dart';
import '../../shared/state/user_providers.dart';

class QuizLevelPage extends ConsumerWidget {
  const QuizLevelPage({super.key});

  String _levelPath(QuizLevel level) => level.name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [const Icon(Icons.bolt_rounded), const SizedBox(width: AppSpacing.sm), Text('Quiz', style: AppTextStyles.h1)]),
                StreakPill(days: user.streakDays),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(AppRadius.sm)),
                      alignment: Alignment.center,
                      child: const Icon(Icons.gps_fixed_rounded, size: 24, color: AppColors.primaryDark),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('QUIZ HARIAN', style: AppTextStyles.labelUppercase.copyWith(color: AppColors.primaryDark)),
                          Text('5 soal · +100 XP bonus', style: AppTextStyles.body),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.push('/quiz/pemula/start'),
                      style: ElevatedButton.styleFrom(minimumSize: const Size(90, 44)),
                      child: const Text('MULAI'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionLabel(icon: Icons.menu_book_rounded, text: 'PILIH LEVEL'),
            const SizedBox(height: AppSpacing.md),
            ...MockData.quizLevelInfos.map((info) => _LevelCard(
                  info: info,
                  onTap: info.locked ? null : () => context.push('/quiz/${_levelPath(info.level)}/start'),
                )),
          ],
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final QuizLevelInfo info;
  final VoidCallback? onTap;

  const _LevelCard({required this.info, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final icon = switch (info.level) {
      QuizLevel.pemula => Icons.eco_rounded,
      QuizLevel.menengah => Icons.energy_savings_leaf_rounded,
      QuizLevel.tantanganWaktu => Icons.bolt_rounded,
      QuizLevel.master => Icons.workspace_premium_rounded,
    };
    final color = switch (info.level) {
      QuizLevel.pemula => AppColors.primary,
      QuizLevel.menengah => AppColors.accentBlue,
      QuizLevel.tantanganWaktu => AppColors.accentOrange,
      QuizLevel.master => AppColors.accentPurple,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Opacity(
        opacity: info.locked ? 0.6 : 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: onTap,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(AppRadius.sm)),
                    alignment: Alignment.center,
                    child: info.locked ? const Icon(Icons.lock_rounded, color: AppColors.inkMuted) : Icon(icon, size: 24, color: color),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(info.title, style: AppTextStyles.h2),
                        Text(info.subtitle, style: AppTextStyles.caption),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            ...List.generate(3, (i) => Icon(i < info.starScore ? Icons.star_rounded : Icons.star_outline_rounded, size: 16, color: AppColors.accentOrange)),
                            const SizedBox(width: AppSpacing.sm),
                            Text('Terbaik: ${info.bestScore}', style: AppTextStyles.caption),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!info.locked) const Icon(Icons.chevron_right_rounded, color: AppColors.inkMuted),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
