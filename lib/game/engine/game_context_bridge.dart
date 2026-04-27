/// A strict bridge interface that the Flame engine uses to communicate
/// with the persistent app state (Flutter/Riverpod) without depending on it directly.
///
/// The `EchoMarketGame` receives this interface via constructor injection. This prevents
/// tight coupling between the Flame game loop and the app UI/Meta-progression logic.
library;

import '../models/run_end_summary.dart';

abstract class GameContextBridge {
  /// Notifies the app shell that a specific collectible was picked up.
  void onCollectiblePickedUp(String collectibleId, int amount);

  /// Notifies the app shell that the player's run has completely ended (e.g., due to death).
  void onRunEnded(RunEndSummary runMetrics);

  /// Allows Flame to query starting loadout or unlocked gadget logic at boot.
  List<String> getEquippedGadgets();

  /// Pause/Resume requests originating from either game (e.g., player hit pause zone)
  /// or system events.
  void onPauseRequested();

  void onResumeRequested();
}
