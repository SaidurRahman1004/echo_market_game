import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart' hide Image;
import '../../core/configs/game_config.dart';
import '../engine/echo_market_game.dart';

enum ComboAction {
  pickup('Pickup', 1, 2.0),
  nearMiss('Near Miss!', 3, 3.0),
  perfectJump('Perfect Jump!', 2, 2.5),
  chainMulti('Chain Action!', 5, 4.0),
  hitlessSegment('Hitless Segment!', 10, 5.0);

  final String displayName;
  final int points; // Base points added to combo count per action
  final double timerAdd; // Time added to the combo duration

  const ComboAction(this.displayName, this.points, this.timerAdd);
}

class ComboManager extends Component with HasGameReference<EchoMarketGame> {
  int currentCombo = 0;
  int maxCombo = 0;
  double comboTimer = 0.0;
  double segmentTimer = 0.0; // Tracks hitless segments

  static const double maxComboDuration = GameConfig.comboMaxDuration;
  static const double hitlessThreshold = GameConfig.comboHitlessSegmentTime;

  bool get hasActiveCombo => currentCombo > 0;

  double get currentMultiplier => 1.0 + (currentCombo * 0.05);

  @override
  void update(double dt) {
    if (!game.session.isPlaying) return;

    if (comboTimer > 0) {
      comboTimer -= dt;
      if (comboTimer <= 0) {
        dropCombo();
      }
    }

    // Hitless segment tracking
    segmentTimer += dt;
    if (segmentTimer >= hitlessThreshold) {
      segmentTimer = 0.0;
      triggerAction(ComboAction.hitlessSegment);
    }
  }

  void triggerAction(ComboAction action) {
    if (!game.session.isPlaying) return;

    currentCombo += action.points;
    if (currentCombo > maxCombo) {
      maxCombo = currentCombo;
    }

    comboTimer += action.timerAdd;
    if (comboTimer > maxComboDuration) {
      comboTimer = maxComboDuration;
    }

    // Display visual feedback
    _spawnFeedbackText(action.displayName, currentCombo);
  }

  void resetHitlessTimer() {
    segmentTimer = 0.0;
  }

  void dropCombo() {
    currentCombo = 0;
    comboTimer = 0.0;
  }

  void _spawnFeedbackText(String text, int activeCombo) {
    if (activeCombo < 3) {
      return; // Don't spam text for just 1 or 2 small pickups
    }

    final textComp = TextComponent(
      text: '$text (x$activeCombo)',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 24,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Color(0xFF000000),
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
      position: Vector2(game.runner.position.x, game.runner.position.y - 120),
      anchor: Anchor.center,
    );

    game.add(textComp);

    textComp.add(
      MoveEffect.by(
        Vector2(0, -60),
        EffectController(duration: 1.0, curve: Curves.easeOut),
      ),
    );
    textComp.add(
      SequenceEffect([
        ScaleEffect.to(Vector2.all(1.2), EffectController(duration: 0.15)),
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.15)),
      ]),
    );
    textComp.add(OpacityEffect.fadeOut(EffectController(startDelay: 0.6, duration: 0.4)));
    textComp.add(RemoveEffect(delay: 1.0));
  }

  void reset() {
    currentCombo = 0;
    maxCombo = 0;
    comboTimer = 0.0;
    segmentTimer = 0.0;
  }
}
