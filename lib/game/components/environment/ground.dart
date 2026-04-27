import 'package:flame/components.dart';
import '../../../core/configs/game_config.dart';
import '../../engine/echo_market_game.dart';

class GroundComponent extends PositionComponent
    with HasGameReference<EchoMarketGame> {
  GroundComponent() {
    position = Vector2(0, GameConfig.groundLevel);
  }

  @override
  Future<void> onLoad() async {
    size = Vector2(game.size.x, game.size.y - GameConfig.groundLevel);
  }
}
