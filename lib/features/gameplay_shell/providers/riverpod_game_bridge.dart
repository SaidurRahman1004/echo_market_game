import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../game/engine/game_context_bridge.dart';
import '../../../game/models/run_end_summary.dart';
import '../../meta_progression/state/inventory_provider.dart';
import '../../meta_progression/state/run_result_processor.dart';
import '../../results/models/run_result.dart';

/// The concrete implementation of the bridge required by Flame.
/// This connects Flame runtime events safely back into Riverpod providers.
class RiverpodGameBridge implements GameContextBridge {
  final WidgetRef ref;
  final void Function(RunResult, CalculatedRewards)? onGameOver;
  bool _isProcessed = false;

  RiverpodGameBridge(this.ref, {this.onGameOver});

  @override
  void onCollectiblePickedUp(String collectibleId, int amount) {
    // Immediate feedback loops could dispatch sound callbacks here
    // or notify temporary run session providers tracking immediate HUD popups.
  }

  @override
  void onRunEnded(RunEndSummary runMetrics) {
    if (_isProcessed) return;
    _isProcessed = true;

    final processor = ref.read(runResultProcessorProvider);

    // Parse the typed Flame summary into the clean presentation model
    final result = RunResult(
      score: runMetrics.score,
      distance: runMetrics.distance,
      survivalTimeSeconds: runMetrics.survivalTimeSeconds,
      rawCoins: runMetrics.coins,
      rawShards: runMetrics.shards,
      relicsFound: 0,
      comboBonus: runMetrics.comboBonus,
    );

    final processed = processor.processFinalMetrics(result);
    if (onGameOver != null) {
      onGameOver!(result, processed);
    }
  }

  @override
  List<String> getEquippedGadgets() {
    // Flame queries the meta state strictly defensively avoiding direct linking.
    return ref.read(inventoryProvider).equippedGadgets;
  }

  @override
  void onPauseRequested() {}

  @override
  void onResumeRequested() {}
}
