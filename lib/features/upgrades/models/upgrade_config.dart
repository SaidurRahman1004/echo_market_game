import 'package:equatable/equatable.dart';

enum UpgradePath { speed, collector, survival }

enum UpgradeStat {
  runSpeed,
  jumpHeight,
  energy,
  shieldChance,
  relicBonus,
  magnetRange,
}

/// Strict blueprint for static upgrade balancing.
class UpgradeConfig extends Equatable {
  final String id;
  final String name;
  final String description;
  final UpgradePath path;
  final UpgradeStat stat;
  final int maxLevel;
  final int baseCost;
  final double costMultiplier;
  final double baseValue; // The starting amount
  final double valuePerLevel; // The increment per level
  final String iconPath;

  const UpgradeConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.path,
    required this.stat,
    required this.maxLevel,
    required this.baseCost,
    required this.costMultiplier,
    required this.baseValue,
    required this.valuePerLevel,
    this.iconPath = 'assets/icons/upgrade_default.png',
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    path,
    stat,
    maxLevel,
    baseCost,
    costMultiplier,
    baseValue,
    valuePerLevel,
    iconPath,
  ];
}
