class AppUser {
  final String id;
  final String name;
  final String email;
  final int level;
  final int totalXp;
  final int streakDays;
  final String dailyGoalId;
  final List<String> badgeIds;
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final bool musicEnabled;
  final bool sfxEnabled;
  final double volume;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.level,
    required this.totalXp,
    required this.streakDays,
    required this.dailyGoalId,
    required this.badgeIds,
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
    this.musicEnabled = true,
    this.sfxEnabled = true,
    this.volume = 0.7,
  });

  String get initials =>
      name.trim().split(RegExp(r'\s+')).map((e) => e.isNotEmpty ? e[0] : '').take(2).join();

  AppUser copyWith({
    String? name,
    int? level,
    int? totalXp,
    int? streakDays,
    String? dailyGoalId,
    List<String>? badgeIds,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    bool? musicEnabled,
    bool? sfxEnabled,
    double? volume,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email,
      level: level ?? this.level,
      totalXp: totalXp ?? this.totalXp,
      streakDays: streakDays ?? this.streakDays,
      dailyGoalId: dailyGoalId ?? this.dailyGoalId,
      badgeIds: badgeIds ?? this.badgeIds,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      volume: volume ?? this.volume,
    );
  }
}

class DailyGoal {
  final String id;
  final String label;
  final int xpTarget;

  const DailyGoal({required this.id, required this.label, required this.xpTarget});
}

class AppBadge {
  final String id;
  final String title;
  final String emoji;
  final String earnedOn;
  final bool locked;

  const AppBadge({
    required this.id,
    required this.title,
    required this.emoji,
    required this.earnedOn,
    this.locked = false,
  });
}
