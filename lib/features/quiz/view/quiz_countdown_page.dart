import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../data/models/quiz.dart';
import '../state/quiz_session_state.dart';

QuizLevel parseQuizLevel(String raw) =>
    QuizLevel.values.firstWhere((l) => l.name == raw, orElse: () => QuizLevel.pemula);

class QuizCountdownPage extends ConsumerStatefulWidget {
  final String levelId;

  const QuizCountdownPage({super.key, required this.levelId});

  @override
  ConsumerState<QuizCountdownPage> createState() => _QuizCountdownPageState();
}

class _QuizCountdownPageState extends ConsumerState<QuizCountdownPage> {
  int _count = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final level = parseQuizLevel(widget.levelId);
    ref.read(quizSessionProvider.notifier).start(level);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_count == 1) {
        t.cancel();
        if (mounted) {
          final firstId = ref.read(quizSessionProvider)?.currentQuestion.id ?? 'q1';
          context.go('/quiz/${widget.levelId}/question/$firstId');
        }
      } else {
        setState(() => _count--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final level = parseQuizLevel(widget.levelId);
    final isTimeChallenge = level == QuizLevel.tantanganWaktu;

    return LoadingView(
      title: isTimeChallenge ? 'Tantangan Waktu' : 'Bersiap',
      centerContent: Text('$_count', style: AppTextStyles.display.copyWith(fontSize: 56, color: const Color(0xFF58CC02))),
      message: isTimeChallenge
          ? 'Kamu punya 60 detik untuk menjawab 10 soal. Tetap fokus!'
          : 'Bersiap menjawab soal-soal level ${level.name}.',
      infoPills: isTimeChallenge
          ? const [
              LoadingInfoPill(icon: Icons.timer_rounded, label: '60s'),
              LoadingInfoPill(icon: Icons.favorite_rounded, label: '3 nyawa'),
              LoadingInfoPill(icon: Icons.bolt_rounded, label: '2x XP'),
            ]
          : const [LoadingInfoPill(icon: Icons.favorite_rounded, label: '3 nyawa')],
    );
  }
}
