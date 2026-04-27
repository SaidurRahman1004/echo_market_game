import 'package:flame/components.dart';
import '../../core/configs/game_config.dart';
import '../engine/echo_market_game.dart';
import '../models/run_session.dart';
import '../components/obstacles/base_obstacle.dart';
import '../components/collectibles/base_collectible.dart';
import 'dart:math';

class SpawnManager extends Component with HasGameReference<EchoMarketGame> {
  double spawnTimer = 0.0;
  final Random _rnd = Random();

  @override
  void update(double dt) {
    if (game.session.status != GameStatus.playing) return;

    spawnTimer += dt;

    double currentInterval =
        (GameConfig.basePlayerSpeed / game.currentSpeed) *
        GameConfig.initialSpawnInterval;
    currentInterval = currentInterval.clamp(
      GameConfig.minSpawnInterval,
      GameConfig.initialSpawnInterval,
    );

    if (spawnTimer >= currentInterval) {
      spawnEntity();
      spawnTimer = 0.0;
    }
  }

  void spawnEntity() {
    bool spawnCollectible = _rnd.nextDouble() < 0.2;

    if (spawnCollectible) {
      game.add(TimeShard());
    } else {
      game.add(BoxObstacle());
    }
  }
}
