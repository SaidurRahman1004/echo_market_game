import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../core/configs/game_config.dart';
import '../../engine/echo_market_game.dart';

class GroundComponent extends PositionComponent with HasGameReference<EchoMarketGame> {
  GroundComponent() {
    position = Vector2(0, GameConfig.groundLevel);
  }

  @override
  Future<void> onLoad() async {
    size = Vector2(game.size.x, game.size.y - GameConfig.groundLevel);

    // Make ground visible
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = const Color(0xFF2C3E50), // Slate grey ground
      ),
    );

    // Decorative top line of the ground
    add(
      RectangleComponent(size: Vector2(size.x, 4), paint: Paint()..color = const Color(0xFF34495E)),
    );
  }
}
