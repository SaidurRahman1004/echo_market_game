import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'currency_provider.dart';
import 'profile_provider.dart';
import '../../missions/mission_progress_provider.dart';
import '../../results/models/run_result.dart';

/// Centralized bus decoupling Flame's result payload from individual providers.
/// Takes cleanly-typed RunResult, applies combos and streaks, and distributes them safely.
class RunResultProcessor {
  final Ref ref;
  RunResultProcessor(this.ref);

  /// Process the raw RunResult, apply combo multipliers, update persistent meta-state,
  /// and return a CalculatedRewards object for UI consumption.
  CalculatedRewards processFinalMetrics(RunResult runData) {
    // 1) Apply multipliers
    final combo = runData.comboBonus > 0 ? runData.comboBonus : 1.0;

    // Convert to integers after multiplying
    final finalCoins = (runData.rawCoins * combo).round();
    final finalShards = (runData.rawShards * combo).round();
    final finalScore = (runData.score * combo).round();
    final xpEarned = (runData.survivalTimeSeconds + finalScore) ~/ 10;

    // 2) Allocate meta-resources safely without knowing how the state scales
    ref
        .read(currencyProvider.notifier)
        .addRunRewards(shards: finalShards, coins: finalCoins);

    final profileNotifier = ref.read(profileProvider.notifier);
    profileNotifier.addXp(xpEarned);
    profileNotifier.recordRunStats(finalScore, finalCoins, finalShards);

    // 3) Update relevant missions
    // e.g., 'daily_survive_seconds', 'lifetime_coins_collected'
    try {
      final missionNotifier = ref.read(missionProgressProvider.notifier);
      if (runData.survivalTimeSeconds > 0) {
        missionNotifier.updateProgress(
          'daily_survive_seconds',
          runData.survivalTimeSeconds,
        );
      }
      if (runData.distance > 0) {
        missionNotifier.updateProgress(
          'story_distance_reached',
          runData.distance,
        );
      }
      if (finalCoins > 0) {
        missionNotifier.updateProgress('weekly_collect_coins', finalCoins);
      }
    } catch (e) {
      // Graceful fail if mission provider not fully ready/configured in a bare mock run.
    }

    // (Future) Extension points: Ad Multipliers, Streak Bonus handling, Event Multipliers
    // Can inject additional classes here before creating CalculatedRewards

    return CalculatedRewards(
      finalScore: finalScore,
      finalCoins: finalCoins,
      finalShards: finalShards,
      finalXp: xpEarned,
      comboMultiplier: combo,
    );
  }
}

// Injects the processor
final runResultProcessorProvider = Provider<RunResultProcessor>((ref) {
  return RunResultProcessor(ref);
});
