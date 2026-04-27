import '../models/upgrade_config.dart';

/// Central database making upgrades data-driven instead of hardcoded.
class UpgradeRegistry {
  static const List<UpgradeConfig> _upgrades = [
    // --- SPEED BUILD ---
    UpgradeConfig(
      id: 'upg_speed_base',
      name: 'Kinetic Thrusters',
      description: 'Increases base running speed slightly.',
      path: UpgradePath.speed,
      stat: UpgradeStat.runSpeed,
      maxLevel: 10,
      baseCost: 100,
      costMultiplier: 1.5,
      baseValue: 1.0, // baseline multiplier 1x
      valuePerLevel: 0.05, // +5% speed per level
    ),
    UpgradeConfig(
      id: 'upg_jump_boost',
      name: 'Grav-Boots',
      description: 'Increases vertical jump thrust.',
      path: UpgradePath.speed,
      stat: UpgradeStat.jumpHeight,
      maxLevel: 5,
      baseCost: 250,
      costMultiplier: 1.8,
      baseValue: 1.0,
      valuePerLevel: 0.1, // +10% jump height
    ),

    // --- SURVIVAL BUILD ---
    UpgradeConfig(
      id: 'upg_energy_cap',
      name: 'Core Battery',
      description: 'Expands maximum stamina/energy.',
      path: UpgradePath.survival,
      stat: UpgradeStat.energy,
      maxLevel: 20,
      baseCost: 50,
      costMultiplier: 1.2,
      baseValue: 100.0, // Absolute value
      valuePerLevel: 10.0, // +10 energy per level
    ),
    UpgradeConfig(
      id: 'upg_shield_chance',
      name: 'Deflection Matrix',
      description: 'Small chance to ignore a minor hit.',
      path: UpgradePath.survival,
      stat: UpgradeStat.shieldChance,
      maxLevel: 5,
      baseCost: 500,
      costMultiplier: 2.0,
      baseValue: 0.0, // 0% chance base
      valuePerLevel: 0.05, // +5% chance per level
    ),

    // --- COLLECTOR BUILD ---
    UpgradeConfig(
      id: 'upg_magnet_range',
      name: 'Attraction Field',
      description: 'Increases distance coins are pulled towards you.',
      path: UpgradePath.collector,
      stat: UpgradeStat.magnetRange,
      maxLevel: 10,
      baseCost: 150,
      costMultiplier: 1.4,
      baseValue: 1.0, // 100% of standard radius
      valuePerLevel: 0.25, // +25% radius per level
    ),
    UpgradeConfig(
      id: 'upg_relic_bonus',
      name: 'Resonance Scanner',
      description: 'Increases yield when finding dimensional relics.',
      path: UpgradePath.collector,
      stat: UpgradeStat.relicBonus,
      maxLevel: 3,
      baseCost: 1000,
      costMultiplier: 3.0,
      baseValue: 1.0, // 1x payout
      valuePerLevel: 0.5, // 0.5x extra bonus payout
    ),
  ];

  static List<UpgradeConfig> get all => _upgrades;

  static List<UpgradeConfig> getByPath(UpgradePath path) {
    return _upgrades.where((u) => u.path == path).toList();
  }

  static UpgradeConfig getById(String id) {
    return _upgrades.firstWhere(
      (u) => u.id == id,
      orElse: () => throw Exception('Upgrade config $id not found!'),
    );
  }
}
