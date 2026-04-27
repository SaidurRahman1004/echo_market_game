import 'package:flutter/material.dart';
import '../models/mission_config.dart';

class MissionRegistry {
  static const List<MissionConfig> allMissions = [
    // Daily Missions
    MissionConfig(
      id: 'daily_collect_coins',
      title: 'Scavenger Hunt',
      description: 'Collect 500 Echo Coins during runs.',
      category: MissionCategory.daily,
      targetGoal: 500,
      reward: MissionReward(type: RewardType.xp, amount: 250),
      icon: Icons.monetization_on,
    ),
    MissionConfig(
      id: 'daily_survive_seconds',
      title: 'Endurance Tester',
      description: 'Survive in any zone for 120 seconds total.',
      category: MissionCategory.daily,
      targetGoal: 120,
      reward: MissionReward(type: RewardType.timeShards, amount: 15),
      icon: Icons.timer,
    ),

    // Weekly Missions
    MissionConfig(
      id: 'weekly_use_gadgets',
      title: 'Tech Savvy',
      description: 'Use equipped gadgets 50 times across all runs.',
      category: MissionCategory.weekly,
      targetGoal: 50,
      reward: MissionReward(
        type: RewardType.gadget,
        amount: 1,
        gadgetId: 'phase_dash',
      ),
      icon: Icons.electrical_services,
    ),

    // Story Missions
    MissionConfig(
      id: 'story_complete_starter',
      title: 'Breaking Ground',
      description: 'Complete the Starter Street route safely.',
      category: MissionCategory.story,
      targetGoal: 1,
      reward: MissionReward(type: RewardType.timeShards, amount: 100),
      icon: Icons.map,
    ),

    // Zone specific
    MissionConfig(
      id: 'zone_neon_avoid_hits',
      title: 'Untouchable',
      description: 'Navigate the Neon Bazaar without taking a single hit.',
      category: MissionCategory.zone,
      targetGoal: 1,
      reward: MissionReward(type: RewardType.echoCoins, amount: 2000),
      icon: Icons.fast_forward,
    ),

    // Contract
    MissionConfig(
      id: 'contract_repair_node',
      title: 'Mechanic\'s Request',
      description: 'Repair 3 critical infrastructure nodes in the city map.',
      category: MissionCategory.contract,
      targetGoal: 3,
      reward: MissionReward(type: RewardType.xp, amount: 500),
      icon: Icons.build,
    ),
    MissionConfig(
      id: 'contract_gather_relics',
      title: 'Archaeologist\'s Bounty',
      description: 'Loot 5 ancient tech relics from Echo Core.',
      category: MissionCategory.contract,
      targetGoal: 5,
      reward: MissionReward(type: RewardType.timeShards, amount: 200),
      icon: Icons.diamond,
    ),
  ];

  static MissionConfig getById(String id) {
    return allMissions.firstWhere(
      (m) => m.id == id,
      orElse: () => allMissions.first,
    );
  }
}
