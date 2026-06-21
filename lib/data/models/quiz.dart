enum QuizLevel { pemula, menengah, tantanganWaktu, master }

class QuizLevelInfo {
  final QuizLevel level;
  final String title;
  final String subtitle;
  final int starScore; // 0-3
  final String bestScore;
  final bool locked;
  final int? timeLimitSeconds;

  const QuizLevelInfo({
    required this.level,
    required this.title,
    required this.subtitle,
    required this.starScore,
    required this.bestScore,
    this.locked = false,
    this.timeLimitSeconds,
  });
}

class QuizQuestion {
  final String id;
  final String aksara;
  final String prompt;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.aksara,
    required this.prompt,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}
