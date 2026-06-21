import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/user.dart';

class UserNotifier extends Notifier<AppUser> {
  @override
  AppUser build() => MockData.user;

  void setDailyGoal(String goalId) {
    state = state.copyWith(dailyGoalId: goalId);
  }

  void addXp(int amount) {
    state = state.copyWith(totalXp: state.totalXp + amount);
  }

  void toggleNotifications(bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }

  void toggleDarkMode(bool value) {
    state = state.copyWith(darkModeEnabled: value);
  }

  void toggleMusic(bool value) {
    state = state.copyWith(musicEnabled: value);
  }

  void toggleSfx(bool value) {
    state = state.copyWith(sfxEnabled: value);
  }

  void setVolume(double value) {
    state = state.copyWith(volume: value);
  }
}

final userProvider = NotifierProvider<UserNotifier, AppUser>(UserNotifier.new);

/// Tracks the last lesson card visited, used by Home's "Lanjutkan Belajar".
class LastLessonNotifier extends Notifier<({String moduleId, String cardId})> {
  @override
  ({String moduleId, String cardId}) build() => (moduleId: 'nglegena', cardId: 'ng-1');

  void update(String moduleId, String cardId) {
    state = (moduleId: moduleId, cardId: cardId);
  }
}

final lastLessonProvider =
    NotifierProvider<LastLessonNotifier, ({String moduleId, String cardId})>(LastLessonNotifier.new);
