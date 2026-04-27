import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/save_repository.dart';
import '../../npc_contracts/data/contract_registry.dart';
import '../../npc_contracts/models/contract_config.dart';
import '../models/contract_state.dart';
import 'inventory_provider.dart';
import 'city_provider.dart';
import 'currency_provider.dart';
import '../../missions/mission_progress_provider.dart';
import '../../zone_select/zone_unlock_provider.dart';

class ContractNotifier extends Notifier<ContractState> {
  static const _saveKey = 'save_npc_contracts';

  @override
  ContractState build() {
    final data = ref.read(saveRepositoryProvider).load(_saveKey);
    return data != null ? ContractState.fromJson(data) : const ContractState();
  }

  bool isCompleted(String contractId) {
    return state.completedContracts.contains(contractId);
  }

  /// Determines if the player's internal states meet all the needs of the contract.
  bool canComplete(String contractId) {
    if (isCompleted(contractId)) return false;

    final config = ContractRegistry.getById(contractId);

    // Is there a prequel story quest they missed?
    if (config.prerequisiteContractId != null &&
        !isCompleted(config.prerequisiteContractId!)) {
      return false; // Still locked contextually
    }

    final invState = ref.read(inventoryProvider);
    final cityState = ref.read(cityProvider);
    final missionState = ref.read(missionProgressProvider);
    final zoneState = ref.read(zoneUnlockProvider);

    for (var req in config.requirements) {
      if (req.type == ContractObjectiveType.handInItem) {
        final genericCount = invState.ownedItems[req.targetId] ?? 0;
        final legacyCount = invState.ownedGadgets.contains(req.targetId)
            ? 1
            : 0;
        if (genericCount < req.requiredAmount &&
            legacyCount < req.requiredAmount) {
          return false;
        }
      } else if (req.type == ContractObjectiveType.repairCityNode) {
        if (!cityState.repairedNodes.contains(req.targetId)) return false;
      } else if (req.type == ContractObjectiveType.completeMission) {
        final isDone =
            missionState.completedMissions.contains(req.targetId) ||
            missionState.claimedMissions.contains(req.targetId);
        if (!isDone) return false;
      } else if (req.type == ContractObjectiveType.unlockZone) {
        if (!zoneState.unlockedZones.contains(req.targetId)) return false;
      }
    }

    return true; // Passed every single condition natively!
  }

  /// Triggers the transaction internally, removing resources and awarding currencies.
  bool completeContract(String contractId) {
    if (!canComplete(contractId)) return false;

    final config = ContractRegistry.getById(contractId);

    // 1) Take Required Items from Inventory (For item-based collection quests only)
    final invNotifier = ref.read(inventoryProvider.notifier);
    final currNotifier = ref.read(currencyProvider.notifier);

    for (var req in config.requirements) {
      if (req.type == ContractObjectiveType.handInItem) {
        invNotifier.removeOrConsumeItem(req.targetId, req.requiredAmount);
      }
    }

    // 2) Issue Rewards
    for (var rew in config.rewards) {
      if (rew.type == ContractRewardType.echoCoins) {
        currNotifier.addRunRewards(coins: rew.amount);
      } else if (rew.type == ContractRewardType.timeShards) {
        currNotifier.addRunRewards(shards: rew.amount);
      } else if (rew.type == ContractRewardType.item && rew.itemId != null) {
        invNotifier.addItem(rew.itemId!, rew.amount);
      }
    }

    // 3) Push to Persistence
    final newCompleted = List<String>.from(state.completedContracts)
      ..add(contractId);
    state = state.copyWith(completedContracts: newCompleted);
    ref.read(saveRepositoryProvider).save(_saveKey, state.toJson());

    return true;
  }
}

// Centralized DI for reading world-contract states
final contractProvider = NotifierProvider<ContractNotifier, ContractState>(
  () => ContractNotifier(),
);
