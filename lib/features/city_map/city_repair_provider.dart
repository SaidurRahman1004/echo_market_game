import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/save_repository.dart';
import 'models/city_repair_state.dart';

final cityRepairProvider =
    NotifierProvider<CityRepairNotifier, CityRepairState>(
      CityRepairNotifier.new,
    );

class CityRepairNotifier extends Notifier<CityRepairState> {
  static const _saveKey = 'city_repair';
  late SaveRepository _saveRepo;

  @override
  CityRepairState build() {
    _saveRepo = ref.read(saveRepositoryProvider);
    return _loadState();
  }

  CityRepairState _loadState() {
    final data = _saveRepo.load(_saveKey);
    if (data != null) {
      try {
        return CityRepairState.fromJson(data);
      } catch (e) {
        // Fallback to fresh state
      }
    }
    return const CityRepairState();
  }

  void _saveState() {
    _saveRepo.save(_saveKey, state.toJson());
  }

  void repairNode(String nodeId, int levelIncrease, int reputationReward) {
    final newLevels = Map<String, int>.from(state.nodeLevels);
    newLevels[nodeId] = (newLevels[nodeId] ?? 0) + levelIncrease;

    state = state.copyWith(
      nodeLevels: newLevels,
      totalReputation: state.totalReputation + reputationReward,
    );
    _saveState();
  }
}
