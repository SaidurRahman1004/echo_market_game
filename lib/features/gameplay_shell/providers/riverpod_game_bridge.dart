import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../game/engine/game_context_bridge.dart';
import '../../meta_progression/state/run_result_processor.dart';
import '../../meta_progression/state/inventory_provider.dart';
import '../../results/models/run_result.dart';

/// The concrete implementation of the bridge required by Flame.
/// This connects Flame runtime events safely back into Riverpod providers.
class RiverpodGameBridge implements GameContextBridge {
  final WidgetRef ref;
  final void Function(RunResult, CalculatedRewards)? onGameOver;

  RiverpodGameBridge(this.ref, {this.onGameOver});

  @override
  void onCollectiblePickedUp(String collectibleId, int amount) {
    // Immediate feedback loops could dispatch sound callbacks here
    // or notify temporary run session providers tracking immediate HUD popups.
  }

  bool _isProcessed = false;

  @override
  void onRunEnded(Map<String, dynamic> runMetrics) {
    if (_isProcessed) return;
    _isProcessed = true;

    final processor = ref.read(runResultProcessorProvider);

    // Parse the primitive map from Flame into the clean presentation model
    final result = RunResult(
      score: runMetrics['score'] as int? ?? 0,
      distance: runMetrics['distance'] as int? ?? 0,
      survivalTimeSeconds: runMetrics['survivalTimeSeconds'] as int? ?? 0,
      rawCoins: runMetrics['coins'] as int? ?? 0,
      rawShards: runMetrics['shards'] as int? ?? 0,
      relicsFound: runMetrics['relics'] as int? ?? 0,
      comboBonus: (runMetrics['combo'] as double?) ?? 1.0,
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
