import '../models/progress_data.dart';

abstract class ProgressRepository {
  Future<ProgressSnapshot> load();
  Future<void> markCardCompleted(String moduleId, String cardId);
  Future<void> recordQuiz(QuizHistoryEntry entry);
}
