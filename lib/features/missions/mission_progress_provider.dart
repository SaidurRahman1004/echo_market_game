import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/save_repository.dart';
import '../meta_progression/state/currency_provider.dart';
import '../meta_progression/state/profile_provider.dart';
import '../loadout/loadout_provider.dart';
import 'models/mission_progress_state.dart';
import 'models/mission_config.dart';
import 'data/mission_registry.dart';

final missionProgressProvider =
    NotifierProvider<MissionProgressNotifier, MissionProgressState>(
      MissionProgressNotifier.new,
    );

class MissionProgressNotifier extends Notifier<MissionProgressState> {
  static const _saveKey = 'mission_progress';
  late SaveRepository _saveRepo;

  @override
  MissionProgressState build() {
    _saveRepo = ref.read(saveRepositoryProvider);
    final loaded = _loadState();

    // Auto-initialize standard missions if empty (For demo/onboarding)
    if (loaded.activeMissions.isEmpty &&
        loaded.completedMissions.isEmpty &&
        loaded.claimedMissions.isEmpty) {
      return const MissionProgressState(
        activeMissions: {
          'daily_collect_coins': 0,
          'daily_survive_seconds': 0,
          'weekly_use_gadgets': 0,
          'story_complete_starter': 0,
          'contract_repair_node': 0,
        },
      );
    }
    return loaded;
  }

  MissionProgressState _loadState() {
    final data = _saveRepo.load(_saveKey);
    if (data != null) {
      try {
        return MissionProgressState.fromJson(data);
      } catch (e) {
        // Fallback
      }
    }
    return const MissionProgressState();
  }

  void _saveState() {
    _saveRepo.save(_saveKey, state.toJson());
  }

  // Called from Gameplay or Meta systems during actions
  void updateProgress(String missionId, int amountAdded) {
    if (state.completedMissions.contains(missionId) ||
        state.claimedMissions.contains(missionId)) {
      return;
    }
    if (!state.activeMissions.containsKey(missionId)) return;

    final config = MissionRegistry.getById(missionId);
    final currentProgress = state.activeMissions[missionId] ?? 0;
    final newProgress = currentProgress + amountAdded;

    final newActive = Map<String, int>.from(state.activeMissions);

    if (newProgress >= config.targetGoal) {
      // Mission Finished
      newActive.remove(missionId);
      state = state.copyWith(
        activeMissions: newActive,
        completedMissions: [...state.completedMissions, missionId],
      );
    } else {
      newActive[missionId] = newProgress;
      state = state.copyWith(activeMissions: newActive);
    }
    _saveState();
  }

  void claimReward(String missionId) {
    if (!state.completedMissions.contains(missionId)) return;

    // Distribute Reward
    final config = MissionRegistry.getById(missionId);
    switch (config.reward.type) {
      case RewardType.echoCoins:
        ref
            .read(currencyProvider.notifier)
            .addRunRewards(coins: config.reward.amount);
        break;
      case RewardType.timeShards:
        ref
            .read(currencyProvider.notifier)
            .addRunRewards(shards: config.reward.amount);
        break;
      case RewardType.xp:
        ref.read(profileProvider.notifier).addXp(config.reward.amount);
        break;
      case RewardType.gadget:
        if (config.reward.gadgetId != null) {
          ref
              .read(loadoutProvider.notifier)
              .unlockGadget(config.reward.gadgetId!);
        }
        break;
    }

    // Move to Claimed
    final newCompleted = List<String>.from(state.completedMissions)
      ..remove(missionId);
    state = state.copyWith(
      completedMissions: newCompleted,
      claimedMissions: [...state.claimedMissions, missionId],
    );
    _saveState();
  }
}
