import '../models/progress_data.dart';

abstract class ProgressRepository {
  Future<ProgressSnapshot> load();
  Future<void> markCardCompleted(String moduleId, String cardId, {int xpEarned = 0});
  Future<void> recordQuiz(QuizHistoryEntry entry);
}
