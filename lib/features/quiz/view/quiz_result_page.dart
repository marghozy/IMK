import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../shared/state/user_providers.dart';
import '../state/quiz_session_state.dart';

class QuizResultPage extends ConsumerStatefulWidget {
  final String levelId;

  const QuizResultPage({super.key, required this.levelId});

  @override
  ConsumerState<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends ConsumerState<QuizResultPage> {
  bool _reviewing = false;

  @override
  Widget build(BuildContext context) {
    final levelId = widget.levelId;
    final session = ref.watch(quizSessionProvider);
    final user = ref.watch(userProvider);

    if (session == null) {
      // Defensive fallback for direct navigation without an active session.
      return Scaffold(
        appBar: AppBar(title: const Text('Hasil Kuis')),
        body: const Center(child: Text('Belum ada sesi kuis aktif.')),
      );
    }

    final total = session.answers.length;
    final correct = session.correctCount;
    final wrong = total - correct;
    final accuracy = total == 0 ? 0 : (correct / total * 100).round();
    final elapsed = DateTime.now().difference(session.startedAt);
    final minutes = elapsed.inMinutes;
    final seconds = elapsed.inSeconds % 60;
    final wrongAnswers = session.answers.where((a) => !a.isCorrect).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.primaryGradient, begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.emoji_events_rounded, size: 52, color: Colors.white),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Bagus Sekali!', style: AppTextStyles.h1.copyWith(color: Colors.white)),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Pill(label: '$correct/$total Benar'),
                        const SizedBox(width: AppSpacing.sm),
                        _Pill(label: '$minutes:${seconds.toString().padLeft(2, '0')} Waktu'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 1.6,
                      children: [
                        _StatCard(icon: Icons.gps_fixed_rounded, color: AppColors.primary, value: '$accuracy%', label: 'AKURASI'),
                        _StatCard(icon: Icons.bolt_rounded, color: AppColors.accentYellow, value: '+${session.xpEarned}', label: 'XP DIDAPAT'),
                        _StatCard(icon: Icons.timer_rounded, color: AppColors.accentBlue, value: '$minutes:${seconds.toString().padLeft(2, '0')}', label: 'WAKTU TEMPUH'),
                        _StatCard(icon: Icons.local_fire_department_rounded, color: AppColors.accentOrange, value: '${user.streakDays}', label: 'STREAK AKTIF'),
                      ],
                    ),
                    if (wrong > 0) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.cancel_rounded, size: 18, color: AppColors.danger),
                                const SizedBox(width: 6),
                                Text('$wrong Jawaban Salah', style: AppTextStyles.h2.copyWith(color: AppColors.danger)),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            ...wrongAnswers.asMap().entries.map((e) {
                              final i = e.key + 1;
                              final a = e.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.sm)),
                                  child: Text(
                                    'Soal $i: Aksara ${a.question.aksara} dibaca "${a.question.correctAnswer}" bukan "${a.selectedAnswer}"',
                                    style: AppTextStyles.bodyMuted,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'Coba Lagi Soal yang Salah',
                        variant: AppButtonVariant.danger,
                        onPressed: () {
                          ref.read(quizSessionProvider.notifier).retryWrongQuestions();
                          final next = ref.read(quizSessionProvider)!.currentQuestion;
                          context.go('/quiz/$levelId/question/${next.id}');
                        },
                      ),
                    ],
                    if (_reviewing) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text('ULASAN JAWABAN', style: AppTextStyles.labelUppercase),
                      const SizedBox(height: AppSpacing.sm),
                      ...session.answers.asMap().entries.map((e) {
                        final i = e.key + 1;
                        final a = e.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: a.isCorrect
                                  ? AppColors.primary.withValues(alpha: 0.06)
                                  : AppColors.danger.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              border: Border.all(
                                color: a.isCorrect
                                    ? AppColors.primary.withValues(alpha: 0.3)
                                    : AppColors.danger.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      a.isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                      size: 18,
                                      color: a.isCorrect ? AppColors.primary : AppColors.danger,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text('Soal $i: ${a.question.prompt}',
                                          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text('Jawabanmu: ${a.selectedAnswer}', style: AppTextStyles.bodyMuted),
                                if (!a.isCorrect)
                                  Text('Jawaban benar: ${a.question.correctAnswer}', style: AppTextStyles.bodyMuted),
                                const SizedBox(height: AppSpacing.xs),
                                Text(a.question.explanation, style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: 'Kembali',
                            icon: Icons.home_rounded,
                            variant: AppButtonVariant.outline,
                            onPressed: () {
                              ref.read(quizSessionProvider.notifier).reset();
                              context.go('/quiz');
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AppButton(
                            label: _reviewing ? 'Sembunyikan' : 'Tinjau',
                            icon: Icons.menu_book_rounded,
                            onPressed: () => setState(() => _reviewing = !_reviewing),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(AppRadius.full)),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatCard({required this.icon, required this.color, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            Text(value, style: AppTextStyles.h2),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
