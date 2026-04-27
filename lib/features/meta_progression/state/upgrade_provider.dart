import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/save_repository.dart';
import '../../upgrades/data/upgrade_registry.dart';
import '../../upgrades/models/upgrade_config.dart';
import '../models/upgrade_state.dart';
import 'currency_provider.dart';

class UpgradeNotifier extends Notifier<UpgradeState> {
  static const _saveKey = 'save_upgrades';

  @override
  UpgradeState build() {
    final repo = ref.read(saveRepositoryProvider);
    final data = repo.load(_saveKey);
    return data != null ? UpgradeState.fromJson(data) : const UpgradeState();
  }

  int getLevel(String upgradeId) {
    return state.levels[upgradeId] ?? 0;
  }

  int getCostForNextLevel(String upgradeId) {
    final config = UpgradeRegistry.getById(upgradeId);
    final currentLvl = getLevel(upgradeId);
    if (currentLvl >= config.maxLevel) return -1; // Maxed out

    // Exponential cost curve
    return (config.baseCost * pow(config.costMultiplier, currentLvl)).round();
  }

  /// Called from the UI when a player taps "Upgrade".
  bool purchaseUpgrade(String upgradeId) {
    final config = UpgradeRegistry.getById(upgradeId);
    final currentLvl = getLevel(upgradeId);

    // Prevent exceeding max level
    if (currentLvl >= config.maxLevel) return false;

    final cost = getCostForNextLevel(upgradeId);

    // Attempt standard transaction (Echo Coins used as default baseline resource for upgrades)
    final success = ref.read(currencyProvider.notifier).trySpendCoins(cost);

    if (success) {
      final newLevels = Map<String, int>.from(state.levels);
      newLevels[upgradeId] = currentLvl + 1;

      final newState = state.copyWith(levels: newLevels);
      state = newState;
      ref.read(saveRepositoryProvider).save(_saveKey, newState.toJson());

      return true;
    }

    return false; // Not enough coins
  }

  /// Main interface for Flame Gameplay Engine to query the finalized multiplier/value of a stat.
  /// Iterates over all upgrades touching the queried stat, adding the effective bonuses together.
  double getEffectiveStat(UpgradeStat targetStat) {
    double totalBonus = 0.0;

    for (final upgrade in UpgradeRegistry.all) {
      if (upgrade.stat == targetStat) {
        final currentLvl = getLevel(upgrade.id);
        if (currentLvl == 0) continue; // Not purchased

        // Sum of all linearly scaled benefits per level.
        final floatBonus = upgrade.valuePerLevel * currentLvl;
        totalBonus += floatBonus;
      }
    }

    // Most base stat variables start at `baseValue` of the first matching config,
    // though realistically this allows you to provide a multiplier or raw additive value.
    try {
      final originConfig = UpgradeRegistry.all.firstWhere(
        (u) => u.stat == targetStat,
      );
      return originConfig.baseValue + totalBonus;
    } catch (_) {
      // In case we query a stat that has no upgrades listed yet
      return 1.0;
    }
  }
}

// Injects the provider so UI and Gameplay Bridge can watch or read the upgrade logic.
final upgradeProvider = NotifierProvider<UpgradeNotifier, UpgradeState>(
  () => UpgradeNotifier(),
);
