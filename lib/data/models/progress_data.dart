class QuizHistoryEntry {
  final String level;
  final int correctCount;
  final int totalCount;
  final int xpEarned;
  final DateTime completedAt;

  const QuizHistoryEntry({
    required this.level,
    required this.correctCount,
    required this.totalCount,
    required this.xpEarned,
    required this.completedAt,
  });

  double get accuracy => totalCount == 0 ? 0 : correctCount / totalCount;

  Map<String, dynamic> toJson() => {
        'level': level,
        'correctCount': correctCount,
        'totalCount': totalCount,
        'xpEarned': xpEarned,
        'completedAt': completedAt.toIso8601String(),
      };

  factory QuizHistoryEntry.fromJson(Map<String, dynamic> json) => QuizHistoryEntry(
        level: json['level'] as String,
        correctCount: json['correctCount'] as int,
        totalCount: json['totalCount'] as int,
        xpEarned: json['xpEarned'] as int,
        completedAt: DateTime.parse(json['completedAt'] as String),
      );
}

/// Single source of truth for everything Home/Belajar/Quiz/Progress need to
/// render real (not mocked) learning progress.
class ProgressSnapshot {
  final Map<String, Set<String>> completedCardsByModule;
  final List<QuizHistoryEntry> quizHistory;
  final Set<String> activeDays; // "yyyy-MM-dd" keys with any learning activity

  const ProgressSnapshot({
    required this.completedCardsByModule,
    required this.quizHistory,
    required this.activeDays,
  });

  factory ProgressSnapshot.empty() =>
      const ProgressSnapshot(completedCardsByModule: {}, quizHistory: [], activeDays: {});

  int completedCardCount(String moduleId) => completedCardsByModule[moduleId]?.length ?? 0;
}
