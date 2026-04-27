import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/save_repository.dart';
import 'models/zone_unlock_state.dart';

final zoneUnlockProvider =
    NotifierProvider<ZoneUnlockNotifier, ZoneUnlockState>(
      ZoneUnlockNotifier.new,
    );

class ZoneUnlockNotifier extends Notifier<ZoneUnlockState> {
  static const _saveKey = 'zone_unlock';
  late SaveRepository _saveRepo;

  @override
  ZoneUnlockState build() {
    _saveRepo = ref.read(saveRepositoryProvider);
    return _loadState();
  }

  ZoneUnlockState _loadState() {
    final data = _saveRepo.load(_saveKey);
    if (data != null) {
      try {
        return ZoneUnlockState.fromJson(data);
      } catch (e) {
        // Fallback to fresh state
      }
    }
    return const ZoneUnlockState();
  }

  void _saveState() {
    _saveRepo.save(_saveKey, state.toJson());
  }

  void unlockZone(String zoneId) {
    if (!state.unlockedZones.contains(zoneId)) {
      state = state.copyWith(unlockedZones: [...state.unlockedZones, zoneId]);
      _saveState();
    }
  }

  void setCurrentRoute(String zoneId) {
    if (state.unlockedZones.contains(zoneId)) {
      state = state.copyWith(currentRoute: zoneId);
      _saveState();
    }
  }
}
