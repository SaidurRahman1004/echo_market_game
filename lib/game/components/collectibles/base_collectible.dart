import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart' hide Image;

import '../../../core/configs/game_config.dart';
import '../../engine/echo_market_game.dart';
import '../../models/run_session.dart';

abstract class BaseCollectible extends PositionComponent
    with HasGameReference<EchoMarketGame>, CollisionCallbacks {
  bool isCollected = false;

  BaseCollectible() {
    size = Vector2.all(GameConfig.collectibleSize);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    // Add visual representation (Amber Diamond)
    final visual = RectangleComponent(
      size: size,
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
      paint: Paint()..color = Colors.amber,
      angle: 0.785398, // 45 degrees in radians
    );
    add(visual);

    // Outline for punchiness
    add(
      RectangleComponent(
        size: size,
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2),
        angle: 0.785398,
        paint: Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      ),
    );

    // Hitbox slightly larger than sprite for generous pickups
    add(RectangleHitbox(size: Vector2(size.x + 10, size.y + 10), position: Vector2(-5, -5)));
  }

  @override
  void update(double dt) {
    if (game.session.status != GameStatus.playing) return;

    // Apply sine wave hover effect for visual polish, can be moved to an Effect
    // But simple manual calculation avoids spawning too many transient objects
    position.x -= game.currentSpeed * dt;
    if (position.x + size.x < 0 && !isCollected) {
      removeFromParent();
    }
  }

  void onCollect() {
    if (isCollected) return;
    isCollected = true;

    // Visual feedback: rapid scale up, pop up slightly, and fade before removal
    add(ScaleEffect.to(Vector2.all(1.5), EffectController(duration: 0.15)));
    add(MoveEffect.by(Vector2(0, -30), EffectController(duration: 0.2, curve: Curves.easeOut)));
    add(RemoveEffect(delay: 0.2));

    game.onCollectibleGrabbed(1);
  }
}

class TimeShard extends BaseCollectible {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = Vector2(game.size.x + size.x, GameConfig.groundLevel - 60);
  }
}
