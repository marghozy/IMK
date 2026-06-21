import 'package:flutter/material.dart';

class LessonCard {
  final String id;
  final String aksara;
  final String title;
  final String pronunciation;
  final String description;
  final String example;
  final String exampleMeaning;
  final List<String> attributes;
  final String? tip;
  final String? warning;

  const LessonCard({
    required this.id,
    required this.aksara,
    required this.title,
    required this.pronunciation,
    required this.description,
    required this.example,
    required this.exampleMeaning,
    this.attributes = const [],
    this.tip,
    this.warning,
  });
}

class LearningModule {
  final String id;
  final String title;
  final String subtitle;
  final String previewAksara;
  final Color color;
  final int xpReward;
  final bool locked;
  final List<LessonCard> cards;
  final int completedCards;

  const LearningModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.previewAksara,
    required this.color,
    required this.xpReward,
    required this.cards,
    this.locked = false,
    this.completedCards = 0,
  });

  double get progress => cards.isEmpty ? 0 : completedCards / cards.length;
}
