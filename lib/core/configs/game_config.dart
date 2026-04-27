class GameConfig {
  GameConfig._();

  // -------------------------
  // 1. ENGINE & SCALING
  // -------------------------
  static const double basePlayerSpeed = 250.0;
  static const double maxPlayerSpeed = 800.0;
  static const double speedMultiplier = 8.0;

  // -------------------------
  // 2. PLAYER PHYSICS (Tuned for feel)
  // -------------------------
  static const double playerGravity = 1800.0; // Snappier fall
  static const double playerJumpForce = -650.0; // Higher, tighter jump
  static const double playerSlideDuration = 0.6; // Quicker slide recovery

  static const double jumpBufferDuration =
      0.15; // Seconds to remember a jump input before landing
  static const double fastFallMultiplier =
      3.5; // Gravity multiplier when sliding mid-air
  static const double apexGravityMultiplier =
      0.5; // Floaty feel at the peak of the jump

  static const double groundLevel = 300.0;

  // -------------------------
  // 3. SIZES & HITBOX FAIRNESS
  // -------------------------
  static const double playerWidth = 40.0;
  static const double playerHeight = 80.0;
  static const double playerSlideHeight = 40.0;

  // Collision fairness modifiers (inner hitboxes are smaller than visuals)
  static const double hitboxPaddingX = 8.0;
  static const double hitboxPaddingY = 8.0;

  static const double obstacleSize = 40.0;
  static const double collectibleSize = 25.0;

  // -------------------------
  // 4. SPAWNING & MODIFIERS
  // -------------------------
  static const double initialSpawnInterval = 1.2;
  static const double minSpawnInterval = 0.6;
  static const double collectibleSpawnChance = 0.3; // 30% chance for items

  // -------------------------
  // 5. META / REWARDS & COMBO
  // -------------------------
  static const double collectibleBaseValue = 10.0;
  static const double comboMaxDuration = 3.5; // Max time before combo drops
  static const double comboHitlessSegmentTime =
      15.0; // Seconds to get hitless reward
}
