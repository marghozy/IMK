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
import '../../shared/state/user_providers.dart';

class LearnListPage extends ConsumerWidget {
  const LearnListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final activeModule = MockData.modules.firstWhere((m) => !m.locked && m.completedCards < m.cards.length,
        orElse: () => MockData.modules.first);

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
                          Text('Kartu ${activeModule.completedCards} dari ${activeModule.cards.length}',
                              style: AppTextStyles.body.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                          const SizedBox(height: AppSpacing.md),
                          AppProgressBar(value: activeModule.progress, color: Colors.white, height: 6),
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
            ...MockData.modules.map((m) => _ModuleCard(module: m)),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final LearningModule module;
  const _ModuleCard({required this.module});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Opacity(
        opacity: module.locked ? 0.6 : 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: module.locked ? null : () => context.push('/learn/${module.id}'),
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
                    child: module.locked
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
                        if (!module.locked && module.cards.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          AppProgressBar(value: module.progress, color: module.color, height: 5),
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
