import '../models/city_node_config.dart';

class CityRegistry {
  static const List<CityNodeConfig> _nodes = [
    CityNodeConfig(
      id: 'city_hub_power',
      name: 'Hub Generator Phase 1',
      description: 'Restoring power opens up the basic Smuggler Market.',
      effectType: RepairEffectType.unlockShopStock,
      costs: [RepairCost(itemId: 'echo_coins', amount: 500)],
      mapX: 0.5,
      mapY: 0.8,
    ),
    CityNodeConfig(
      id: 'city_scavenger_den',
      name: 'Scavenger\'s Outpost',
      description:
          'Creates a shortcut through Sector 2, skipping hazard areas.',
      effectType: RepairEffectType.unlockShortcut,
      prerequisites: ['city_hub_power'],
      costs: [
        RepairCost(itemId: 'echo_coins', amount: 1500),
        RepairCost(itemId: 'mat_copper', amount: 3),
      ],
      mapX: 0.3,
      mapY: 0.6,
    ),
    CityNodeConfig(
      id: 'city_purifier_vent',
      name: 'Atmospheric Purifier',
      description: 'Clears the smog in District 3. Reduces hazard intensity.',
      effectType: RepairEffectType.reduceHazard,
      prerequisites: ['city_hub_power'],
      costs: [
        RepairCost(itemId: 'time_shards', amount: 300),
        RepairCost(itemId: 'mat_flux', amount: 1),
      ],
      mapX: 0.7,
      mapY: 0.6,
    ),
    CityNodeConfig(
      id: 'city_echo_terminal',
      name: 'Prime Echo Terminal',
      description: 'Decodes a lost memory fragment from the first runner.',
      effectType: RepairEffectType.unlockStoryMemory,
      prerequisites: ['city_purifier_vent', 'city_scavenger_den'],
      costs: [RepairCost(itemId: 'time_shards', amount: 1000)],
      mapX: 0.5,
      mapY: 0.3,
    ),
  ];

  static List<CityNodeConfig> get all => _nodes;

  static CityNodeConfig getById(String id) {
    return _nodes.firstWhere(
      (n) => n.id == id,
      orElse: () => throw Exception('City Node Configuration $id not found!'),
    );
  }
}
