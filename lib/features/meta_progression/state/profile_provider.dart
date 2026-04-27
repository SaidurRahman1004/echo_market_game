import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/save_repository.dart';
import '../models/profile_state.dart';

class ProfileNotifier extends Notifier<ProfileState> {
  static const _saveKey = 'save_profile';

  @override
  ProfileState build() {
    final data = ref.read(saveRepositoryProvider).load(_saveKey);
    return data != null ? ProfileState.fromJson(data) : const ProfileState();
  }

  void addXp(int xpEarned) {
    if (xpEarned <= 0) return;
    int newXp = state.currentXp + xpEarned;
    int newLevel = state.currentLevel;

    int xpToNextLevel = newLevel * 100;
    while (newXp >= xpToNextLevel) {
      newXp -= xpToNextLevel;
      newLevel++;
      xpToNextLevel = newLevel * 100;
    }

    final newState = state.copyWith(currentLevel: newLevel, currentXp: newXp);
    state = newState;
    ref.read(saveRepositoryProvider).save(_saveKey, newState.toJson());
  }

  void recordRunStats(int score, int coins, int shards) {
    final newBest = score > state.bestScore ? score : state.bestScore;

    final newState = state.copyWith(
      totalRuns: state.totalRuns + 1,
      bestScore: newBest,
      lifetimeCoins: state.lifetimeCoins + coins,
      lifetimeShards: state.lifetimeShards + shards,
    );

    state = newState;
    ref.read(saveRepositoryProvider).save(_saveKey, newState.toJson());
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  () => ProfileNotifier(),
);
