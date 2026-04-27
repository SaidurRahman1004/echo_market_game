import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import '../../../core/configs/game_config.dart';
import '../../engine/echo_market_game.dart';
import '../obstacles/base_obstacle.dart';
import '../collectibles/base_collectible.dart';

import '../../managers/combo_manager.dart';

class EchoRunner extends PositionComponent
    with HasGameReference<EchoMarketGame>, CollisionCallbacks {
  bool isGrounded = true;
  bool isSliding = false;
  bool isInvulnerable = false; // Post-hit or dash invulnerability
  late RectangleHitbox hitbox;

  double velocityY = 0.0;
  double _jumpBufferTimer = 0.0;
  double _slideTimer = 0.0;
  bool _isFastFalling = false;

  double get gravity => GameConfig.playerGravity;
  double get jumpForce => GameConfig.playerJumpForce;

  EchoRunner()
    : super(size: Vector2(GameConfig.playerWidth, GameConfig.playerHeight)) {
    anchor = Anchor.bottomCenter;
  }

  @override
  Future<void> onLoad() async {
    position = Vector2(100.0, GameConfig.groundLevel);

    // Add tighter hitbox for fairness, avoiding edge-cases causing cheap deaths
    hitbox = RectangleHitbox(
      position: Vector2(10, 12), // Shrink left/right slightly more for fairness
      size: Vector2(size.x - 20, size.y - 15),
    );
    add(hitbox);
  }

  @override
  void update(double dt) {
    if (!game.session.isPlaying) return;

    if (_jumpBufferTimer > 0) {
      _jumpBufferTimer -= dt;
    }

    if (isSliding) {
      _slideTimer -= dt;
      if (_slideTimer <= 0) {
        returnToRunning();
      }
    }

    if (!isGrounded) {
      // 1. Apex Float: Lowers gravity at the very top of the jump for better control & hang time
      // 2. Fast Fall: If we trigger a slide input while airborne
      double currentGravity = gravity;
      if (_isFastFalling) {
        currentGravity *= GameConfig.fastFallMultiplier;
      } else if (velocityY.abs() < 150) {
        currentGravity *= GameConfig.apexGravityMultiplier;
      }

      velocityY += currentGravity * dt;
      position.y += velocityY * dt;

      if (position.y >= GameConfig.groundLevel) {
        position.y = GameConfig.groundLevel;
        isGrounded = true;
        _isFastFalling = false;
        velocityY = 0.0;
        
        // Auto-consume jump buffer if we pressed jump right before landing
        if (_jumpBufferTimer > 0) {
          _jumpBufferTimer = 0;
          _performJump();
        }
      }
    }
  }

  void jump() {
    if (!game.session.isPlaying) return;

    if (isGrounded || (isSliding && _slideTimer > 0)) {
      _performJump();
    } else {
      // Airborne? Buffer the input slightly so pressing early doesn't "eat" the jump
      _jumpBufferTimer = GameConfig.jumpBufferDuration;
    }
  }

  void _performJump() {
    // Check for perfect jump
    final obstacles = game.children.whereType<BaseObstacle>();
    for (final obs in obstacles) {
      if (obs.position.x > position.x && obs.position.x - position.x < 120) {
        game.comboManager.triggerAction(ComboAction.perfectJump);
        break;
      }
    }

    isGrounded = false;
    velocityY = jumpForce;
    if (isSliding) {
      returnToRunning(); // Jump cancels slide immediately
    }
    _adjustHitboxForRun();

    // Simple jump stretch feedback
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2(0.8, 1.2), EffectController(duration: 0.1)),
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.1)),
      ]),
    );
  }

  void slide() {
    if (!game.session.isPlaying) return;
    
    if (!isGrounded) {
      // Fast fall maneuver if already in the air!
      _isFastFalling = true;
      return;
    }

    if (!isSliding) {
      isSliding = true;
      _slideTimer = GameConfig.playerSlideDuration;
      _adjustHitboxForSlide();

      // Visual slide squish
      add(ScaleEffect.to(Vector2(1.2, 0.5), EffectController(duration: 0.1)));
    } else {
      // Just refresh the slide timer if sliding again
      _slideTimer = GameConfig.playerSlideDuration;
    }
  }

  void returnToRunning() {
    isSliding = false;
    _adjustHitboxForRun();
    add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.1)));
  }

  void _adjustHitboxForRun() {
    hitbox.size = Vector2(size.x - 20, size.y - 15);
  }

  void _adjustHitboxForSlide() {
    hitbox.size = Vector2(size.x - 20, GameConfig.playerSlideHeight - 15);
    position.y = GameConfig.groundLevel;
    velocityY = 0.0;
    isGrounded = true;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is BaseObstacle && !isInvulnerable) {
      onHitObstacle();
    } else if (other is BaseCollectible && !isInvulnerable) {
      other.onCollect();
    }
  }

  void onHitObstacle() {
    isInvulnerable = true;
    game.comboManager.dropCombo();

    // Intense visual feedback of hit
    add(
      SequenceEffect(
        [
          ScaleEffect.to(Vector2(1.5, 0.5), EffectController(duration: 0.1)),
          MoveEffect.by(Vector2(-30, 0), EffectController(duration: 0.15)),
          OpacityEffect.fadeOut(EffectController(duration: 0.2)),
        ],
        onComplete: () {
          game.triggerGameOver();
        },
      ),
    );
  }
}
