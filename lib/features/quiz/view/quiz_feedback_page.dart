import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../shared/state/user_providers.dart';
import '../state/quiz_session_state.dart';

class QuizFeedbackPage extends ConsumerWidget {
  final String levelId;
  final String questionId;

  const QuizFeedbackPage({super.key, required this.levelId, required this.questionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizSessionProvider);
    if (session == null || session.answers.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final result = session.answers.last;
    final isCorrect = result.isCorrect;
    final outOfLives = session.lives <= 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCorrect ? AppColors.primaryGradient : AppColors.dangerGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Icon(isCorrect ? Icons.check_rounded : Icons.close_rounded, color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(isCorrect ? 'Benar!' : 'Belum Tepat', style: AppTextStyles.h1.copyWith(color: Colors.white)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      isCorrect ? 'Pertahankan terus!' : 'Jangan menyerah, coba lagi!',
                      style: AppTextStyles.body.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (isCorrect)
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Text('+50', style: AppTextStyles.h1.copyWith(color: AppColors.primary)),
                        Text('XP', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('JAWABANMU', style: AppTextStyles.labelUppercase),
                          const SizedBox(height: AppSpacing.xs),
                          Text(result.selectedAnswer, style: AppTextStyles.h1.copyWith(color: AppColors.danger)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('JAWABAN BENAR', style: AppTextStyles.labelUppercase),
                          const SizedBox(height: AppSpacing.xs),
                          Text(result.question.correctAnswer, style: AppTextStyles.h1.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('💡 PENJELASAN', style: AppTextStyles.labelUppercase),
                    const SizedBox(height: AppSpacing.sm),
                    Text(result.question.explanation, style: AppTextStyles.body),
                  ],
                ),
              ),
              if (isCorrect && session.correctStreak >= 2) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(color: AppColors.accentYellow.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(AppRadius.md)),
                  child: Text('🔥 Benar ${session.correctStreak}x berturut-turut', style: AppTextStyles.bodyMuted.copyWith(fontWeight: FontWeight.w700)),
                ),
              ],
              if (!isCorrect) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(color: AppColors.accentYellow.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(AppRadius.md)),
                  child: Text('❤️ Sisa nyawa: ${session.lives} dari 3', style: AppTextStyles.bodyMuted.copyWith(fontWeight: FontWeight.w700)),
                ),
              ],
              const Spacer(),
              if (isCorrect)
                AppButton(
                  label: session.isLastQuestion ? 'Lihat Hasil' : 'Lanjut ke Soal Berikutnya',
                  onPressed: () => _goNext(context, ref, session),
                )
              else ...[
                AppButton(
                  label: 'Coba Lagi',
                  variant: AppButtonVariant.danger,
                  onPressed: outOfLives
                      ? null
                      : () {
                          ref.read(quizSessionProvider.notifier).retryCurrentQuestion();
                          context.pop();
                        },
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Lewati Soal',
                  variant: AppButtonVariant.outline,
                  onPressed: () => _goNext(context, ref, session),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _goNext(BuildContext context, WidgetRef ref, QuizSessionState session) {
    if (session.isLastQuestion || session.lives <= 0) {
      ref.read(userProvider.notifier).addXp(session.xpEarned);
      context.go('/quiz/$levelId/result');
    } else {
      ref.read(quizSessionProvider.notifier).nextQuestion();
      final next = ref.read(quizSessionProvider)!.currentQuestion;
      context.go('/quiz/$levelId/question/${next.id}');
    }
  }
}
