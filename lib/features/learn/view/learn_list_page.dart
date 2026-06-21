import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/xp_badge.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/module.dart';
import '../../../data/models/progress_data.dart';
import '../../progress/state/progress_state.dart';
import '../../shared/state/user_providers.dart';

class LearnListPage extends ConsumerWidget {
  const LearnListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final snapshot = ref.watch(progressProvider).valueOrNull ?? ProgressSnapshot.empty();
    final activeModule = MockData.modules.firstWhere(
        (m) => isModuleUnlocked(snapshot, m) && snapshot.completedCardCount(m.id) < m.cards.length,
        orElse: () => MockData.modules.first);
    final activeModuleCompleted = snapshot.completedCardCount(activeModule.id);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [const Icon(Icons.menu_book_rounded), const SizedBox(width: AppSpacing.sm), Text('Belajar', style: AppTextStyles.h1)]),
                StreakPill(days: user.streakDays),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            InkWell(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              onTap: () => context.push('/learn/${activeModule.id}'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.primaryGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LANJUTKAN', style: AppTextStyles.labelUppercase.copyWith(color: Colors.white70)),
                          const SizedBox(height: AppSpacing.xs),
                          Text(activeModule.title, style: AppTextStyles.h1.copyWith(color: Colors.white)),
                          Text('Kartu $activeModuleCompleted dari ${activeModule.cards.length}',
                              style: AppTextStyles.body.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                          const SizedBox(height: AppSpacing.md),
                          AppProgressBar(value: moduleProgress(snapshot, activeModule), color: Colors.white, height: 6),
                        ],
                      ),
                    ),
                    Text(activeModule.previewAksara, style: AppTextStyles.aksara(size: 48, color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionLabel(icon: Icons.menu_book_rounded, text: 'SEMUA MATERI'),
            const SizedBox(height: AppSpacing.md),
            ...MockData.modules.map((m) => _ModuleCard(module: m, snapshot: snapshot)),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final LearningModule module;
  final ProgressSnapshot snapshot;
  const _ModuleCard({required this.module, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final unlocked = isModuleUnlocked(snapshot, module);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Opacity(
        opacity: unlocked ? 1 : 0.6,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: unlocked ? () => context.push('/learn/${module.id}') : null,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(color: module.color, borderRadius: BorderRadius.circular(AppRadius.sm)),
                    alignment: Alignment.center,
                    child: !unlocked
                        ? const Icon(Icons.lock_rounded, color: AppColors.inkMuted)
                        : Text(module.previewAksara, style: AppTextStyles.aksara(size: 22)),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(module.title, style: AppTextStyles.h2),
                        Text(module.subtitle, style: AppTextStyles.caption),
                        if (unlocked && module.cards.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          AppProgressBar(value: moduleProgress(snapshot, module), color: module.color, height: 5),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                    decoration: BoxDecoration(
                      color: module.color.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text('+${module.xpReward} XP', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
