import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/save_repository.dart';
import '../models/settings_state.dart';

class SettingsNotifier extends Notifier<SettingsState> {
  static const _saveKey = 'save_settings';

  @override
  SettingsState build() {
    final data = ref.read(saveRepositoryProvider).load(_saveKey);
    return data != null ? SettingsState.fromJson(data) : const SettingsState();
  }

  void toggleMusic() {
    _updateState(state.copyWith(isMusicEnabled: !state.isMusicEnabled));
  }

  void toggleSfx() {
    _updateState(state.copyWith(isSfxEnabled: !state.isSfxEnabled));
  }

  void toggleHaptics() {
    _updateState(state.copyWith(isHapticsEnabled: !state.isHapticsEnabled));
  }

  void toggleHighPerformance() {
    _updateState(
      state.copyWith(isHighPerformanceMode: !state.isHighPerformanceMode),
    );
  }

  void toggleReduceMotion() {
    _updateState(state.copyWith(reduceMotion: !state.reduceMotion));
  }

  void resetProgress() {
    // We would reset save data here if needed, but for now just clear settings
    // or trigger full generic reset depending on domain architecture.
    // In a real app we'd dispatch an event to clear the SaveRepository keys.
    ref.read(saveRepositoryProvider).clearAll(); // clears EVERYTHING
    // Note: To see the UI reflect immediately all providers would need a reset mechanism,
    // which usually means restarting the app or invalidating all providers.
  }

  void _updateState(SettingsState newState) {
    state = newState;
    ref.read(saveRepositoryProvider).save(_saveKey, newState.toJson());
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  () => SettingsNotifier(),
);
