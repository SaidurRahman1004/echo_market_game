import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../core/configs/game_config.dart';
import '../../engine/echo_market_game.dart';
import '../../managers/combo_manager.dart';

abstract class BaseObstacle extends PositionComponent
    with HasGameReference<EchoMarketGame>, CollisionCallbacks {
  late final RectangleHitbox hitbox;
  bool _passedPlayer = false;

  BaseObstacle() {
    size = Vector2.all(GameConfig.obstacleSize);
    anchor = Anchor.bottomCenter;
  }

  @override
  Future<void> onLoad() async {
    // Make danger boxes visible
    final rectVisual = RectangleComponent(size: size, paint: Paint()..color = Colors.redAccent);
    add(rectVisual);

    // Border
    add(
      RectangleComponent(
        size: size,
        paint: Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      ),
    );

    // Add a hitbox slightly smaller than visual bounds for fairness
    hitbox = RectangleHitbox(
      size: Vector2(size.x - GameConfig.hitboxPaddingX * 2, size.y - GameConfig.hitboxPaddingY * 2),
      position: Vector2(GameConfig.hitboxPaddingX, GameConfig.hitboxPaddingY * 2),
      // Focus bottom, pad top for fair overhead jumping
    );
    add(hitbox);
  }

  @override
  void update(double dt) {
    if (!game.session.isPlaying) return;
    position.x -= game.currentSpeed * dt;

    // Check if player passed this obstacle successfully
    if (!_passedPlayer && position.x + size.x < game.runner.position.x) {
      _passedPlayer = true;
      // Close distance = near miss
      final distanceY = (game.runner.position.y - position.y).abs();
      if (distanceY > 0 && distanceY < 150) {
        game.comboManager.triggerAction(ComboAction.nearMiss);
      }
    }

    if (position.x + size.x < 0) {
      removeFromParent();
    }
  }

  void onHit() {
    // Modular effect hook: visual hit response before removal/death
    removeFromParent();
  }
}

class BoxObstacle extends BaseObstacle {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = Vector2(game.size.x + size.x, GameConfig.groundLevel);
  }
}
