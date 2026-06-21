import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/progress_data.dart';
import 'progress_repository.dart';

/// Firebase-backed [ProgressRepository]. Persists each user's lesson-card
/// completions, quiz history, and active-day streak under
/// `users/{uid}/progress/summary` in Cloud Firestore, scoped to [uid] so
/// Home/Belajar/Quiz/Progress all read the same per-account source of truth.
///
/// This replaces [LocalProgressRepository] now that a Firebase project is
/// configured — see [progressRepositoryProvider] in `progress_state.dart`.
class FirebaseProgressRepository implements ProgressRepository {
  FirebaseProgressRepository({required this.uid, FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection('users').doc(uid).collection('progress').doc('summary');

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  Future<ProgressSnapshot> load() async {
    final snapshot = await _doc.get();
    final data = snapshot.data();
    if (data == null) return ProgressSnapshot.empty();

    final completedRaw = Map<String, dynamic>.from(data['completedCardsByModule'] as Map? ?? const {});
    final completedCardsByModule = <String, Set<String>>{
      for (final entry in completedRaw.entries) entry.key: Set<String>.from(entry.value as List),
    };

    final historyRaw = (data['quizHistory'] as List? ?? const [])
        .map((e) => QuizHistoryEntry.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    final activeDays = Set<String>.from(data['activeDays'] as List? ?? const []);

    return ProgressSnapshot(
      completedCardsByModule: completedCardsByModule,
      quizHistory: historyRaw,
      activeDays: activeDays,
    );
  }

  Future<void> _save(ProgressSnapshot snapshot) {
    return _doc.set({
      'completedCardsByModule': snapshot.completedCardsByModule.map((k, v) => MapEntry(k, v.toList())),
      'quizHistory': snapshot.quizHistory.map((e) => e.toJson()).toList(),
      'activeDays': snapshot.activeDays.toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> markCardCompleted(String moduleId, String cardId) async {
    final snapshot = await load();
    final updated = Map<String, Set<String>>.from(snapshot.completedCardsByModule);
    updated[moduleId] = {...?updated[moduleId], cardId};
    await _save(ProgressSnapshot(
      completedCardsByModule: updated,
      quizHistory: snapshot.quizHistory,
      activeDays: {...snapshot.activeDays, _todayKey()},
    ));
  }

  @override
  Future<void> recordQuiz(QuizHistoryEntry entry) async {
    final snapshot = await load();
    await _save(ProgressSnapshot(
      completedCardsByModule: snapshot.completedCardsByModule,
      quizHistory: [...snapshot.quizHistory, entry],
      activeDays: {...snapshot.activeDays, _todayKey()},
    ));
  }
}
