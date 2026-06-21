import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/progress_bar.dart';
import '../state/quiz_session_state.dart';

class QuizQuestionPage extends ConsumerStatefulWidget {
  final String levelId;
  final String questionId;

  const QuizQuestionPage({super.key, required this.levelId, required this.questionId});

  @override
  ConsumerState<QuizQuestionPage> createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends ConsumerState<QuizQuestionPage> {
  static const _duration = 45;
  int _secondsLeft = _duration;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = _duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void didUpdateWidget(covariant QuizQuestionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionId != widget.questionId) _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showExitConfirm() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari kuis?'),
        content: const Text('Progres kuis saat ini akan hilang.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(quizSessionProvider.notifier).reset();
              context.go('/quiz');
            },
            child: Text('Keluar', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  void _selectAnswer(String option) {
    ref.read(quizSessionProvider.notifier).answer(option);
    context.push('/quiz/${widget.levelId}/question/${widget.questionId}/feedback');
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(quizSessionProvider);
    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final question = session.currentQuestion;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: _showExitConfirm),
                  Expanded(
                    child: Text('Soal ${session.currentIndex + 1} dari ${session.questions.length}',
                        textAlign: TextAlign.center, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.danger.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.full)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite_rounded, size: 14, color: AppColors.danger),
                        const SizedBox(width: 4),
                        Text('${session.lives}/3', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              AppProgressBar(value: (session.currentIndex + 1) / session.questions.length),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: Text('${(_secondsLeft ~/ 60)}:${(_secondsLeft % 60).toString().padLeft(2, '0')}', style: AppTextStyles.caption),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(question.prompt, style: AppTextStyles.h2, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border)),
                  alignment: Alignment.center,
                  child: Text(question.aksara, style: AppTextStyles.aksara(size: 72)),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.8,
                  children: question.options
                      .map((opt) => OutlinedButton(
                            onPressed: () => _selectAnswer(opt),
                            style: OutlinedButton.styleFrom(minimumSize: Size.zero),
                            child: Text(opt, style: AppTextStyles.h2.copyWith(color: AppColors.ink)),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
