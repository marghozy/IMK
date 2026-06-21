import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedGoalNotifier extends Notifier<String> {
  @override
  String build() => 'reguler';

  void select(String goalId) => state = goalId;
}

final selectedGoalProvider = NotifierProvider<SelectedGoalNotifier, String>(SelectedGoalNotifier.new);
