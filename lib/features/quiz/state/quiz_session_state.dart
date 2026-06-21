import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/quiz.dart';
import '../../../data/mock/mock_data.dart';

class QuestionResult {
  final QuizQuestion question;
  final String selectedAnswer;
  final bool isCorrect;

  const QuestionResult({required this.question, required this.selectedAnswer, required this.isCorrect});
}

class QuizSessionState {
  final QuizLevel level;
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int lives;
  final List<QuestionResult> answers;
  final int correctStreak;
  final DateTime startedAt;
  final String? lastSelectedAnswer;

  const QuizSessionState({
    required this.level,
    required this.questions,
    required this.currentIndex,
    required this.lives,
    required this.answers,
    required this.correctStreak,
    required this.startedAt,
    this.lastSelectedAnswer,
  });

  QuizQuestion get currentQuestion => questions[currentIndex];
  bool get isLastQuestion => currentIndex == questions.length - 1;
  int get correctCount => answers.where((a) => a.isCorrect).length;
  int get xpEarned => answers.where((a) => a.isCorrect).length * 50;

  QuizSessionState copyWith({
    int? currentIndex,
    int? lives,
    List<QuestionResult>? answers,
    int? correctStreak,
    String? lastSelectedAnswer,
    bool clearSelectedAnswer = false,
  }) {
    return QuizSessionState(
      level: level,
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      lives: lives ?? this.lives,
      answers: answers ?? this.answers,
      correctStreak: correctStreak ?? this.correctStreak,
      startedAt: startedAt,
      lastSelectedAnswer: clearSelectedAnswer ? null : (lastSelectedAnswer ?? this.lastSelectedAnswer),
    );
  }
}

class QuizSessionNotifier extends Notifier<QuizSessionState?> {
  @override
  QuizSessionState? build() => null;

  void start(QuizLevel level) {
    state = QuizSessionState(
      level: level,
      questions: MockData.quizBank[level] ?? const [],
      currentIndex: 0,
      lives: 3,
      answers: const [],
      correctStreak: 0,
      startedAt: DateTime.now(),
    );
  }

  void answer(String selected) {
    final s = state;
    if (s == null) return;
    final correct = selected == s.currentQuestion.correctAnswer;
    state = s.copyWith(
      lastSelectedAnswer: selected,
      lives: correct ? s.lives : s.lives - 1,
      correctStreak: correct ? s.correctStreak + 1 : 0,
      answers: [...s.answers, QuestionResult(question: s.currentQuestion, selectedAnswer: selected, isCorrect: correct)],
    );
  }

  void retryCurrentQuestion() {
    final s = state;
    if (s == null) return;
    state = s.copyWith(clearSelectedAnswer: true, answers: s.answers.sublist(0, s.answers.length - 1));
  }

  void nextQuestion() {
    final s = state;
    if (s == null) return;
    state = s.copyWith(currentIndex: s.currentIndex + 1, clearSelectedAnswer: true);
  }

  void reset() {
    state = null;
  }

  /// Restarts the session with only the questions answered incorrectly,
  /// per FR: "Coba Lagi" must re-run wrong questions, not just re-show the score.
  void retryWrongQuestions() {
    final s = state;
    if (s == null) return;
    final wrongQuestions = s.answers.where((a) => !a.isCorrect).map((a) => a.question).toList();
    if (wrongQuestions.isEmpty) return;
    state = QuizSessionState(
      level: s.level,
      questions: wrongQuestions,
      currentIndex: 0,
      lives: 3,
      answers: const [],
      correctStreak: 0,
      startedAt: DateTime.now(),
    );
  }
}

final quizSessionProvider = NotifierProvider<QuizSessionNotifier, QuizSessionState?>(QuizSessionNotifier.new);
