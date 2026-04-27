import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/save_repository.dart';
import '../../city_repair/data/city_registry.dart';
import '../models/city_state.dart';
import 'currency_provider.dart';
import 'inventory_provider.dart';

class CityNotifier extends Notifier<CityState> {
  static const _saveKey = 'save_city_state';

  @override
  CityState build() {
    final data = ref.read(saveRepositoryProvider).load(_saveKey);
    return data != null ? CityState.fromJson(data) : const CityState();
  }

  bool isNodeRepaired(String nodeId) {
    return state.repairedNodes.contains(nodeId);
  }

  bool canRepair(String nodeId) {
    if (isNodeRepaired(nodeId)) return false;

    final config = CityRegistry.getById(nodeId);

    // Check prerequisites
    for (final prereq in config.prerequisites) {
      if (!isNodeRepaired(prereq)) return false;
    }

    // Check specific resource affordabilities individually
    // This allows arbitrary complex costs (Coins + Shards + Multiple Materials)
    final currState = ref.read(currencyProvider);
    final invNotifier = ref.read(inventoryProvider.notifier);

    for (final cost in config.costs) {
      if (cost.itemId == 'echo_coins') {
        if (currState.echoCoins < cost.amount) return false;
      } else if (cost.itemId == 'time_shards') {
        if (currState.timeShards < cost.amount) return false;
      } else {
        // Assume it's a material item ID from inventory
        if (!invNotifier.hasItem(cost.itemId, quantity: cost.amount)) {
          return false;
        }
      }
    }

    return true;
  }

  /// Attempts to spend all required resources to repair/unlock the city node
  bool attemptRepair(String nodeId) {
    if (!canRepair(nodeId)) return false;

    final config = CityRegistry.getById(nodeId);
    final currencyNotifier = ref.read(currencyProvider.notifier);
    final inventoryNotifier = ref.read(inventoryProvider.notifier);

    // Because canRepair guaranteed we have all resources, we can boldly subtract them
    for (final cost in config.costs) {
      if (cost.itemId == 'echo_coins') {
        currencyNotifier.trySpendCoins(cost.amount);
      } else if (cost.itemId == 'time_shards') {
        currencyNotifier.trySpendShards(cost.amount);
      } else {
        inventoryNotifier.removeOrConsumeItem(cost.itemId, cost.amount);
      }
    }

    final newNodes = List<String>.from(state.repairedNodes)..add(nodeId);
    state = state.copyWith(repairedNodes: newNodes);
    ref.read(saveRepositoryProvider).save(_saveKey, state.toJson());

    // NOTE: Extension point for applying immediate effect unlocks globally
    // E.g., if (config.effectType == RepairEffectType.unlockShopStock)
    // we could ping the ShopProvider to recalculate static availability
    return true;
  }
}

final cityProvider = NotifierProvider<CityNotifier, CityState>(
  () => CityNotifier(),
);
