import 'package:flame/game.dart';
import 'package:flame/effects.dart';
import 'package:flame/components.dart';
import '../../core/configs/game_config.dart';
import '../models/run_session.dart';
import 'game_context_bridge.dart';
import '../components/player/echo_runner.dart';
import '../components/environment/ground.dart';
import '../managers/spawn_manager.dart';
import '../components/obstacles/base_obstacle.dart';
import '../components/collectibles/base_collectible.dart';
import '../managers/combo_manager.dart';

class EchoMarketGame extends FlameGame with HasCollisionDetection {
  final GameContextBridge bridge;
  late final RunSession session;
  late EchoRunner runner; // Removed final so it can reset cleanly on restart
  late ComboManager comboManager;

  double currentSpeed = GameConfig.basePlayerSpeed;

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

    startRun(); // Start cleanly only after resources are fully loaded and components attached
  }

  @override
  void update(double dt) {
    if (session.status != GameStatus.playing) return;

    currentSpeed += GameConfig.speedMultiplier * dt;
    if (currentSpeed > GameConfig.maxPlayerSpeed) {
      currentSpeed = GameConfig.maxPlayerSpeed;
    }

    session.distance += currentSpeed * dt;
    super.update(dt);
  }

  void startRun() {
    currentSpeed = GameConfig.basePlayerSpeed;
    session.reset();
    comboManager.reset();
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
          bridge.onRunEnded({
            'score': session.score,
            'distance': session.distance,
            'coins': session.coins,
            'shards': session.shards,
            'combo':
                comboManager.maxCombo /
                10.0, // Convert combo points to a double multiplier bonus, eg 20 -> 2.0x bonus
          });
        },
      ),
    );
  }

  // Method requested by Collectible
  void onCollectibleGrabbed(int amount) {
    comboManager.triggerAction(ComboAction.pickup);
    session.shards += amount;
    session.score +=
        (GameConfig.collectibleBaseValue * comboManager.currentMultiplier)
            .toInt();
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
    children.whereType<SpawnManager>().forEach(
      (element) => element.spawnTimer = 0.0,
    );

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
    camera.viewfinder.children.whereType<Effect>().forEach(
      (e) => e.removeFromParent(),
    );
    camera.viewfinder.position = Vector2.zero();

    resumeEngine(); // In case game was restarted from pause/gameover
    startRun();
  }
}
