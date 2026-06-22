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

class LessonXpEntry {
  final String moduleId;
  final String cardId;
  final int xpEarned;
  final DateTime completedAt;

  const LessonXpEntry({
    required this.moduleId,
    required this.cardId,
    required this.xpEarned,
    required this.completedAt,
  });

  Map<String, dynamic> toJson() => {
        'moduleId': moduleId,
        'cardId': cardId,
        'xpEarned': xpEarned,
        'completedAt': completedAt.toIso8601String(),
      };

  factory LessonXpEntry.fromJson(Map<String, dynamic> json) => LessonXpEntry(
        moduleId: json['moduleId'] as String,
        cardId: json['cardId'] as String,
        xpEarned: json['xpEarned'] as int,
        completedAt: DateTime.parse(json['completedAt'] as String),
      );
}

/// Single source of truth for everything Home/Belajar/Quiz/Progress need to
/// render real (not mocked) learning progress.
class ProgressSnapshot {
  final Map<String, Set<String>> completedCardsByModule;
  final List<QuizHistoryEntry> quizHistory;
  final List<LessonXpEntry> lessonXpHistory;
  final Set<String> activeDays; // "yyyy-MM-dd" keys with any learning activity

  const ProgressSnapshot({
    required this.completedCardsByModule,
    required this.quizHistory,
    this.lessonXpHistory = const [],
    required this.activeDays,
  });

  factory ProgressSnapshot.empty() =>
      const ProgressSnapshot(completedCardsByModule: {}, quizHistory: [], lessonXpHistory: [], activeDays: {});

  int completedCardCount(String moduleId) => completedCardsByModule[moduleId]?.length ?? 0;

  bool isCardCompleted(String moduleId, String cardId) =>
      completedCardsByModule[moduleId]?.contains(cardId) ?? false;
}
