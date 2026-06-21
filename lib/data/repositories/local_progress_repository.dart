import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/progress_data.dart';
import 'progress_repository.dart';

String dateKey(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Local-storage backed [ProgressRepository], standing in for a real backend
/// until a Firebase/Firestore project is configured. Tracks real lesson card
/// completions and quiz session history so Home/Belajar/Quiz/Progress can all
/// read from one source of truth instead of static mock stats.
class LocalProgressRepository implements ProgressRepository {
  static const _completedCardsKey = 'progress_completed_cards_v1';
  static const _quizHistoryKey = 'progress_quiz_history_v1';
  static const _activeDaysKey = 'progress_active_days_v1';

  @override
  Future<ProgressSnapshot> load() async {
    final prefs = await SharedPreferences.getInstance();

    final completedRaw = prefs.getString(_completedCardsKey);
    final completedCardsByModule = <String, Set<String>>{};
    if (completedRaw != null) {
      final decoded = Map<String, dynamic>.from(jsonDecode(completedRaw) as Map);
      decoded.forEach((moduleId, cardIds) {
        completedCardsByModule[moduleId] = Set<String>.from(cardIds as List);
      });
    }

    final historyRaw = prefs.getStringList(_quizHistoryKey) ?? const [];
    final quizHistory = historyRaw
        .map((raw) => QuizHistoryEntry.fromJson(Map<String, dynamic>.from(jsonDecode(raw) as Map)))
        .toList();

    final activeDays = (prefs.getStringList(_activeDaysKey) ?? const []).toSet();

    return ProgressSnapshot(completedCardsByModule: completedCardsByModule, quizHistory: quizHistory, activeDays: activeDays);
  }

  @override
  Future<void> markCardCompleted(String moduleId, String cardId) async {
    final prefs = await SharedPreferences.getInstance();
    final snapshot = await load();
    final updated = Map<String, Set<String>>.from(snapshot.completedCardsByModule);
    updated[moduleId] = {...?updated[moduleId], cardId};
    await prefs.setString(_completedCardsKey, jsonEncode(updated.map((k, v) => MapEntry(k, v.toList()))));
    await _markActiveToday(prefs, snapshot.activeDays);
  }

  @override
  Future<void> recordQuiz(QuizHistoryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final snapshot = await load();
    final updated = [...snapshot.quizHistory, entry];
    await prefs.setStringList(_quizHistoryKey, updated.map((e) => jsonEncode(e.toJson())).toList());
    await _markActiveToday(prefs, snapshot.activeDays);
  }

  Future<void> _markActiveToday(SharedPreferences prefs, Set<String> existingActiveDays) async {
    final today = dateKey(DateTime.now());
    if (existingActiveDays.contains(today)) return;
    await prefs.setStringList(_activeDaysKey, {...existingActiveDays, today}.toList());
  }
}
