import 'package:equatable/equatable.dart';

/// Defines the outcome type of a city repair node.
enum RepairEffectType {
  unlockShortcut,
  reduceHazard,
  unlockShopStock,
  unlockRoute,
  revealHiddenReward,
  unlockStoryMemory,
  statsBoost,
}

class RepairCost {
  final String
  itemId; // 'echo_coins', 'time_shards', or material id like 'mat_copper'
  final int amount;

  const RepairCost({required this.itemId, required this.amount});
}

class CityNodeConfig extends Equatable {
  final String id;
  final String name;
  final String description;
  final RepairEffectType effectType;
  final List<String>
  prerequisites; // IDs of other nodes that must be repaired first
  final List<RepairCost> costs;
  final double mapX; // For plotting on a 2D UI map (0.0 to 1.0)
  final double mapY; // For plotting on a 2D UI map (0.0 to 1.0)

  const CityNodeConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.effectType,
    this.prerequisites = const [],
    required this.costs,
    required this.mapX,
    required this.mapY,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    effectType,
    prerequisites,
    costs,
    mapX,
    mapY,
  ];
}
