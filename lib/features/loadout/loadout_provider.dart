import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/save_repository.dart';
import 'models/loadout_state.dart';

final loadoutProvider = NotifierProvider<LoadoutNotifier, LoadoutState>(
  LoadoutNotifier.new,
);

class LoadoutNotifier extends Notifier<LoadoutState> {
  static const _saveKey = 'loadout';
  late SaveRepository _saveRepo;
  static const int maxSlots = 2; // Fixed number of equip slots

  @override
  LoadoutState build() {
    _saveRepo = ref.read(saveRepositoryProvider);
    return _loadState();
  }

  LoadoutState _loadState() {
    final data = _saveRepo.load(_saveKey);
    if (data != null) {
      try {
        return LoadoutState.fromJson(data);
      } catch (_) {}
    }
    return const LoadoutState();
  }

  void _saveState() {
    _saveRepo.save(_saveKey, state.toJson());
  }

  void toggleEquip(String gadgetId) {
    if (!state.unlockedGadgetIds.contains(gadgetId)) return; // Security check

    final List<String> current = List.from(state.equippedGadgetIds);
    if (current.contains(gadgetId)) {
      current.remove(gadgetId);
    } else {
      if (current.length >= maxSlots) {
        current.removeAt(0); // Pop oldest equip
      }
      current.add(gadgetId);
    }

    state = state.copyWith(equippedGadgetIds: current);
    _saveState();
  }

  void unlockGadget(String gadgetId) {
    if (!state.unlockedGadgetIds.contains(gadgetId)) {
      state = state.copyWith(
        unlockedGadgetIds: [...state.unlockedGadgetIds, gadgetId],
      );
      _saveState();
    }
  }
}
