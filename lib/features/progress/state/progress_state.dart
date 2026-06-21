import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/module.dart';
import '../../../data/models/progress_data.dart';
import '../../../data/models/progress_entry.dart';
import '../../../data/repositories/firebase_progress_repository.dart';
import '../../../data/repositories/local_progress_repository.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../auth/state/auth_session_state.dart';
import '../../shared/state/user_providers.dart';

/// Scoped to the signed-in user's uid so each account's progress is stored
/// separately in Firestore. Falls back to [LocalProgressRepository] only
/// while there's no authenticated user yet (e.g. session still restoring),
/// so the UI never crashes on a null uid.
final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final authState = ref.watch(authSessionProvider);
  final uid = authState.valueOrNull?.id;
  if (uid == null) return LocalProgressRepository();
  return FirebaseProgressRepository(uid: uid);
});

/// Centralized, persisted learning progress (lesson completions + quiz
/// history), shared by Home/Belajar/Quiz/Progress so they all read the same
/// real data instead of independent mock stats.
class ProgressNotifier extends AsyncNotifier<ProgressSnapshot> {
  @override
  Future<ProgressSnapshot> build() => ref.watch(progressRepositoryProvider).load();

  Future<void> completeCard(String moduleId, String cardId) async {
    await ref.read(progressRepositoryProvider).markCardCompleted(moduleId, cardId);
    await _refresh();
  }

  Future<void> recordQuiz(QuizHistoryEntry entry) async {
    await ref.read(progressRepositoryProvider).recordQuiz(entry);
    await _refresh();
  }

  Future<void> _refresh() async {
    final snapshot = await ref.read(progressRepositoryProvider).load();
    state = AsyncValue.data(snapshot);
    ref.read(userProvider.notifier).setStreakDays(computeStreakDays(snapshot));
  }
}

final progressProvider = AsyncNotifierProvider<ProgressNotifier, ProgressSnapshot>(ProgressNotifier.new);

/// A module is unlocked if it isn't flagged locked in the design, or once the
/// preceding module's cards are all completed.
bool isModuleUnlocked(ProgressSnapshot snapshot, LearningModule module) {
  if (!module.locked) return true;
  final index = MockData.modules.indexWhere((m) => m.id == module.id);
  if (index <= 0) return true;
  final previous = MockData.modules[index - 1];
  if (previous.cards.isEmpty) return true;
  return snapshot.completedCardCount(previous.id) >= previous.cards.length;
}

double moduleProgress(ProgressSnapshot snapshot, LearningModule module) {
  if (module.cards.isEmpty) return 0;
  return (snapshot.completedCardCount(module.id) / module.cards.length).clamp(0, 1).toDouble();
}

int totalLessonsCompleted(ProgressSnapshot snapshot) =>
    snapshot.completedCardsByModule.values.fold(0, (sum, cards) => sum + cards.length);

int totalQuizzesCompleted(ProgressSnapshot snapshot) => snapshot.quizHistory.length;

double overallAccuracy(ProgressSnapshot snapshot) {
  if (snapshot.quizHistory.isEmpty) return 0;
  final sum = snapshot.quizHistory.fold<double>(0, (s, e) => s + e.accuracy);
  return sum / snapshot.quizHistory.length;
}

List<ProgressEntry> last7DaysAccuracy(ProgressSnapshot snapshot) {
  final now = DateTime.now();
  return List.generate(7, (i) {
    final date = now.subtract(Duration(days: 6 - i));
    final key = dateKey(date);
    final dayEntries = snapshot.quizHistory.where((e) => dateKey(e.completedAt) == key).toList();
    final accuracy = dayEntries.isEmpty ? 0.0 : dayEntries.fold<double>(0, (s, e) => s + e.accuracy) / dayEntries.length;
    return ProgressEntry(date: date, accuracy: accuracy, active: snapshot.activeDays.contains(key));
  });
}

Set<int> activeDaysInMonth(ProgressSnapshot snapshot, DateTime month) {
  return snapshot.activeDays
      .where((key) {
        final parts = key.split('-');
        return int.parse(parts[0]) == month.year && int.parse(parts[1]) == month.month;
      })
      .map((key) => int.parse(key.split('-')[2]))
      .toSet();
}

int computeStreakDays(ProgressSnapshot snapshot) {
  var streak = 0;
  var day = DateTime.now();
  while (snapshot.activeDays.contains(dateKey(day))) {
    streak++;
    day = day.subtract(const Duration(days: 1));
  }
  return streak;
}

/// Today's XP earned from quizzes, used to drive Home's daily progress bar
/// against the user's selected [DailyGoal.xpTarget].
int todayXpEarned(ProgressSnapshot snapshot) {
  final today = dateKey(DateTime.now());
  return snapshot.quizHistory.where((e) => dateKey(e.completedAt) == today).fold(0, (sum, e) => sum + e.xpEarned);
}
