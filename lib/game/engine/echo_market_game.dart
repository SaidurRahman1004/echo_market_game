import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Image;

import '../../core/configs/game_config.dart';
import '../components/collectibles/base_collectible.dart';
import '../components/environment/ground.dart';
import '../components/obstacles/base_obstacle.dart';
import '../components/player/echo_runner.dart';
import '../managers/combo_manager.dart';
import '../managers/spawn_manager.dart';
import '../models/run_session.dart';
import '../models/run_end_summary.dart';
import 'game_context_bridge.dart';

class EchoMarketGame extends FlameGame with HasCollisionDetection {
  final GameContextBridge bridge;
  late final RunSession session;
  late EchoRunner runner; // Removed final so it can reset cleanly on restart
  late ComboManager comboManager;

  late TextComponent _scoreHud;
  late TextComponent _comboHud;

  double currentSpeed = GameConfig.basePlayerSpeed;
  double _elapsedSeconds = 0.0;

  EchoMarketGame({required this.bridge}) : super() {
    session = RunSession(status: GameStatus.menu);
  }

  @override
  Future<void> onLoad() async {
    add(GroundComponent());
    runner = EchoRunner();
    add(runner);
    comboManager = ComboManager();
    add(comboManager);
    add(SpawnManager());

    // In-Game HUD for Live Feed
    _scoreHud = TextComponent(
      text: 'Distance: 0m   Shards: 0',
      position: Vector2(20, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(blurRadius: 4, color: Colors.black, offset: Offset(2, 2))],
        ),
      ),
    );
    _comboHud = TextComponent(
      text: 'x1.0',
      position: Vector2(size.x - 20, 20),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.amberAccent,
          fontSize: 28,
          fontWeight: FontWeight.w900,
          shadows: [Shadow(blurRadius: 6, color: Colors.black, offset: Offset(2, 2))],
        ),
      ),
    );
    add(_scoreHud);
    add(_comboHud);

    startRun(); // Start cleanly only after resources are fully loaded and components attached
  }

  @override
  void update(double dt) {
    if (session.status == GameStatus.playing) {
      currentSpeed += GameConfig.speedMultiplier * dt;
      if (currentSpeed > GameConfig.maxPlayerSpeed) {
        currentSpeed = GameConfig.maxPlayerSpeed;
      }

      _elapsedSeconds += dt;
      session.distance += currentSpeed * dt;

      // Update live HUD
      _scoreHud.text = 'Dist: ${session.distance.toInt()}m   Shards: ${session.shards}';
      _comboHud.text = comboManager.currentMultiplier > 1.0
          ? 'x${comboManager.currentMultiplier.toStringAsFixed(1)}'
          : '';
    }

    super.update(dt);
  }

  void startRun() {
    currentSpeed = GameConfig.basePlayerSpeed;
    _elapsedSeconds = 0.0;
    session.reset();
    comboManager.reset();
    _comboHud.text = 'x1.0';
  }

  void triggerGameOver() {
    session.status = GameStatus.gameOver;

    // Screenshake Effect on camera for impact feedback
    camera.viewfinder.add(
      SequenceEffect([
        MoveEffect.by(
          Vector2(5, 5),
          EffectController(duration: 0.05, alternate: true, repeatCount: 3),
        ),
      ]),
    );

    add(
      TimerComponent(
        period: 0.5,
        removeOnFinish: true,
        onTick: () {
          bridge.onRunEnded(
            RunEndSummary(
              score: session.score,
              distance: session.distance.toInt(),
              survivalTimeSeconds: _elapsedSeconds.toInt(),
              coins: session.coins,
              shards: session.shards,
              comboBonus:
                  comboManager.maxCombo /
                  10.0, // Convert combo points to a double multiplier bonus, eg 20 -> 2.0x bonus
            ),
          );
        },
      ),
    );
  }

  // Method requested by Collectible
  void onCollectibleGrabbed(int amount) {
    comboManager.triggerAction(ComboAction.pickup);
    session.shards += amount;
    session.score += (GameConfig.collectibleBaseValue * comboManager.currentMultiplier).toInt();
    bridge.onCollectiblePickedUp("time_shard", amount);
  }

  void togglePause() {
    if (session.status == GameStatus.playing) {
      session.status = GameStatus.paused;
      bridge.onPauseRequested();
      pauseEngine(); // Actually freeze flame loop cleanly
    } else if (session.status == GameStatus.paused) {
      session.status = GameStatus.playing;
      bridge.onResumeRequested();
      resumeEngine();
    }
  }

  void restartRun() {
    // Reset spawn timers
    children.whereType<SpawnManager>().forEach((element) => element.spawnTimer = 0.0);

    // Purge old entities
    children.whereType<BaseObstacle>().forEach((e) => e.removeFromParent());
    children.whereType<BaseCollectible>().forEach((e) => e.removeFromParent());
    children.whereType<TextComponent>().forEach((e) => e.removeFromParent());
    children.whereType<TimerComponent>().forEach((e) => e.removeFromParent());

    // Restore Player properly
    runner.removeFromParent();
    runner = EchoRunner();
    add(runner);

    // Reset camera just in case
    camera.viewfinder.children.whereType<Effect>().forEach((e) => e.removeFromParent());
    camera.viewfinder.position = Vector2.zero();

    resumeEngine(); // In case game was restarted from pause/gameover
    startRun();
  }
}
