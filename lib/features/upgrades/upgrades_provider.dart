import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/save_repository.dart';
import 'models/upgrade_state.dart';

final upgradesProvider = NotifierProvider<UpgradesNotifier, UpgradeState>(
  UpgradesNotifier.new,
);

class UpgradesNotifier extends Notifier<UpgradeState> {
  static const _saveKey = 'upgrades';
  late SaveRepository _saveRepo;

  @override
  UpgradeState build() {
    _saveRepo = ref.read(saveRepositoryProvider);
    return _loadState();
  }

  UpgradeState _loadState() {
    final data = _saveRepo.load(_saveKey);
    if (data != null) {
      try {
        return UpgradeState.fromJson(data);
      } catch (e) {
        // Fallback to fresh state
      }
    }
    return const UpgradeState();
  }

  void _saveState() {
    _saveRepo.save(_saveKey, state.toJson());
  }

  void purchaseUpgrade(String upgradeId, int levelIncrease) {
    final newUpgrades = Map<String, int>.from(state.currentUpgrades);
    newUpgrades[upgradeId] = (newUpgrades[upgradeId] ?? 0) + levelIncrease;

    state = state.copyWith(currentUpgrades: newUpgrades);
    _saveState();
  }
}
