import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/quiz.dart';
import '../../../data/mock/mock_data.dart';

/// Maps which attempt (1-based) a question was answered correctly on to the
/// XP awarded: 1st try = 50 XP, 2nd = 30 XP, 3rd = 10 XP.
int xpForAttempt(int attemptNumber) {
  if (attemptNumber <= 1) return 50;
  if (attemptNumber == 2) return 30;
  return 10;
}

class QuestionResult {
  final QuizQuestion question;
  final String selectedAnswer;
  final bool isCorrect;
  final int attemptNumber;

  const QuestionResult({
    required this.question,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.attemptNumber,
  });
}

class QuizSessionState {
  final QuizLevel level;
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int lives; // lives remaining for the current question (resets each question)
  final int currentAttempt; // 1-based attempt count for the current question
  final List<QuestionResult> answers;
  final int correctStreak;
  final DateTime startedAt;
  final String? lastSelectedAnswer;
  final bool forcedAdvance; // true if the last answer exhausted lives on this question

  const QuizSessionState({
    required this.level,
    required this.questions,
    required this.currentIndex,
    required this.lives,
    required this.currentAttempt,
    required this.answers,
    required this.correctStreak,
    required this.startedAt,
    this.lastSelectedAnswer,
    this.forcedAdvance = false,
  });

  QuizQuestion get currentQuestion => questions[currentIndex];
  bool get isLastQuestion => currentIndex == questions.length - 1;
  int get correctCount => answers.where((a) => a.isCorrect).length;
  int get xpEarned => answers.where((a) => a.isCorrect).fold(0, (sum, a) => sum + xpForAttempt(a.attemptNumber));

  QuizSessionState copyWith({
    int? currentIndex,
    int? lives,
    int? currentAttempt,
    List<QuestionResult>? answers,
    int? correctStreak,
    String? lastSelectedAnswer,
    bool clearSelectedAnswer = false,
    bool? forcedAdvance,
  }) {
    return QuizSessionState(
      level: level,
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      lives: lives ?? this.lives,
      currentAttempt: currentAttempt ?? this.currentAttempt,
      answers: answers ?? this.answers,
      correctStreak: correctStreak ?? this.correctStreak,
      startedAt: startedAt,
      lastSelectedAnswer: clearSelectedAnswer ? null : (lastSelectedAnswer ?? this.lastSelectedAnswer),
      forcedAdvance: forcedAdvance ?? this.forcedAdvance,
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
      currentAttempt: 1,
      answers: const [],
      correctStreak: 0,
      startedAt: DateTime.now(),
    );
  }

  void answer(String selected) {
    final s = state;
    if (s == null) return;
    final correct = selected == s.currentQuestion.correctAnswer;
    final result = QuestionResult(
      question: s.currentQuestion,
      selectedAnswer: selected,
      isCorrect: correct,
      attemptNumber: s.currentAttempt,
    );
    if (correct) {
      state = s.copyWith(
        lastSelectedAnswer: selected,
        correctStreak: s.correctStreak + 1,
        answers: [...s.answers, result],
        forcedAdvance: false,
      );
      return;
    }
    final remainingLives = s.lives - 1;
    state = s.copyWith(
      lastSelectedAnswer: selected,
      lives: remainingLives,
      correctStreak: 0,
      answers: [...s.answers, result],
      forcedAdvance: remainingLives <= 0,
    );
  }

  /// Retries the current question after a wrong (but not life-exhausting)
  /// attempt: discards that attempt's result and bumps the attempt counter.
  void retryCurrentQuestion() {
    final s = state;
    if (s == null || s.lives <= 0) return;
    state = s.copyWith(
      clearSelectedAnswer: true,
      currentAttempt: s.currentAttempt + 1,
      answers: s.answers.sublist(0, s.answers.length - 1),
    );
  }

  void nextQuestion() {
    final s = state;
    if (s == null) return;
    state = s.copyWith(
      currentIndex: s.currentIndex + 1,
      clearSelectedAnswer: true,
      lives: 3,
      currentAttempt: 1,
      forcedAdvance: false,
    );
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
      currentAttempt: 1,
      answers: const [],
      correctStreak: 0,
      startedAt: DateTime.now(),
    );
  }
}

final quizSessionProvider = NotifierProvider<QuizSessionNotifier, QuizSessionState?>(QuizSessionNotifier.new);
