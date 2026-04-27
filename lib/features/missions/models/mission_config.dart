import 'package:flutter/material.dart';

enum MissionCategory { daily, weekly, story, zone, contract }

enum RewardType { echoCoins, timeShards, xp, gadget }

class MissionReward {
  final RewardType type;
  final int amount;
  final String? gadgetId; // Only used if type == RewardType.gadget

  const MissionReward({
    required this.type,
    required this.amount,
    this.gadgetId,
  });
}

class MissionConfig {
  final String id;
  final String title;
  final String description;
  final MissionCategory category;
  final int targetGoal;
  final MissionReward reward;
  final IconData icon;

  const MissionConfig({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.targetGoal,
    required this.reward,
    required this.icon,
  });

  Color get categoryColor {
    switch (category) {
      case MissionCategory.daily:
        return Colors.greenAccent;
      case MissionCategory.weekly:
        return Colors.blueAccent;
      case MissionCategory.story:
        return Colors.amber;
      case MissionCategory.zone:
        return Colors.purpleAccent;
      case MissionCategory.contract:
        return Colors.deepOrangeAccent;
    }
  }

  String get categoryIdentifier {
    switch (category) {
      case MissionCategory.daily:
        return 'DAILY';
      case MissionCategory.weekly:
        return 'WEEKLY';
      case MissionCategory.story:
        return 'STORY';
      case MissionCategory.zone:
        return 'ZONE OP';
      case MissionCategory.contract:
        return 'CONTRACT';
    }
  }
}
