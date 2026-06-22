import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/xp_badge.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/progress_data.dart';
import '../../progress/state/progress_state.dart';
import '../../shared/state/user_providers.dart';

String _timeGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 10) return 'Selamat pagi';
  if (hour < 15) return 'Selamat siang';
  if (hour < 18) return 'Selamat sore';
  return 'Selamat malam';
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final lastLesson = ref.watch(lastLessonProvider);
    final snapshot = ref.watch(progressProvider).valueOrNull ?? ProgressSnapshot.empty();
    final goal = MockData.dailyGoals.firstWhere((g) => g.id == user.dailyGoalId, orElse: () => MockData.dailyGoals.first);
    final dailyProgress = goal.xpTarget == 0 ? 0.0 : (todayXpEarned(snapshot) / goal.xpTarget).clamp(0, 1).toDouble();

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xl),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppRadius.lg)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            child: Text(user.initials,
                                style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
                          ),
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(color: AppColors.accentOrange, shape: BoxShape.circle),
                              child: Text('${user.level}',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      XpBadge(xp: user.totalXp, light: false),
                      const SizedBox(width: AppSpacing.sm),
                      StreakPill(days: user.streakDays),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.h1.copyWith(color: Colors.white),
                      children: [
                        TextSpan(text: '${_timeGreeting()}, '),
                        TextSpan(text: '${user.name.split(' ').first}!', style: const TextStyle(color: AppColors.accentYellow)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Jangan putus streak-mu hari ini',
                      style: AppTextStyles.body.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (i) {
                      final active = i < user.streakDays.clamp(0, 7);
                      return Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: active ? AppColors.accentOrange : AppColors.border,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: active
                            ? const Icon(Icons.local_fire_department_rounded,
                                size: 20, color: Colors.white)
                            : null,
                      );
                    }),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('PROGRESS HARI INI', style: AppTextStyles.labelUppercase),
                              Text('${(dailyProgress * 100).round()}%', style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          AppProgressBar(value: dailyProgress),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: 'Lanjutkan Belajar',
                    icon: Icons.play_arrow_rounded,
                    onPressed: () => context.push('/learn/${lastLesson.moduleId}/${lastLesson.cardId}'),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const SectionLabel(icon: Icons.menu_book_rounded, text: 'RECOMMENDED'),
                  const SizedBox(height: AppSpacing.md),
                  ...MockData.modules.take(3).map(
                        (m) {
                          final unlocked = isModuleUnlocked(snapshot, m);
                          return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: Opacity(
                            opacity: unlocked ? 1 : 0.6,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              onTap: unlocked ? () => context.push('/learn/${m.id}') : null,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(color: m.color, borderRadius: BorderRadius.circular(AppRadius.sm)),
                                        alignment: Alignment.center,
                                        child: !unlocked
                                            ? const Icon(Icons.lock_rounded, color: AppColors.inkMuted)
                                            : Text(m.previewAksara, style: AppTextStyles.aksara(size: 22)),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(m.title, style: AppTextStyles.h2),
                                            Text(m.subtitle, style: AppTextStyles.caption),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                                        decoration: BoxDecoration(
                                            color: AppColors.accentYellow.withValues(alpha: 0.4),
                                            borderRadius: BorderRadius.circular(AppRadius.full)),
                                        child: Text('+${m.xpReward} XP', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                        },
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
