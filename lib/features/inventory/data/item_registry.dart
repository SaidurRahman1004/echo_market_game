import '../models/item_config.dart';

/// Central database of all non-procedural items capable of being owned.
class ItemRegistry {
  static const List<ItemConfig> _items = [
    // --- CURRENCIES (Mapped dynamically with CurrencyProvider) ---
    ItemConfig(
      id: 'echo_coins',
      name: 'Echo Coins',
      description: 'Universal currency across all timelines.',
      category: ItemCategory.currency,
      rarity: ItemRarity.common,
    ),
    ItemConfig(
      id: 'time_shards',
      name: 'Time Shards',
      description:
          'High-energy crystalline splinters. Best used for meta-upgrades.',
      category: ItemCategory.currency,
      rarity: ItemRarity.epic,
    ),

    // --- GADGETS ---
    ItemConfig(
      id: 'magnet_drone',
      name: 'Magnet Drone',
      description: 'Automatically gathers distant coins.',
      category: ItemCategory.gadget,
      rarity: ItemRarity.rare,
    ),
    ItemConfig(
      id: 'shield_matrix',
      name: 'Shield Matrix',
      description: 'Absorbs one fatal impact per run.',
      category: ItemCategory.gadget,
      rarity: ItemRarity.epic,
    ),
    ItemConfig(
      id: 'time_slower',
      name: 'Chronos Ward',
      description: 'Reduces passive obstacle speed by 10%.',
      category: ItemCategory.gadget,
      rarity: ItemRarity.legendary,
    ),

    // --- RELICS ---
    ItemConfig(
      id: 'relic_hourglass',
      name: 'Shattered Hourglass',
      description: 'A relic from the prime timeline. Seems useful.',
      category: ItemCategory.relic,
      rarity: ItemRarity.legendary,
    ),

    // --- MATERIALS (For crafting/upgrades later) ---
    ItemConfig(
      id: 'mat_copper',
      name: 'Scrap Copper',
      description: 'Basic upgrade material for gadgets.',
      category: ItemCategory.material,
      rarity: ItemRarity.common,
    ),
    ItemConfig(
      id: 'mat_flux',
      name: 'Flux Core',
      description: 'Required for deep-time jumps.',
      category: ItemCategory.material,
      rarity: ItemRarity.rare,
    ),

    // --- COSMETICS (Placeholders) ---
    ItemConfig(
      id: 'cos_neon_trail',
      name: 'Neon Trail',
      description: 'Leaves a bright blue cyan wake behind the runner.',
      category: ItemCategory.cosmetic,
      rarity: ItemRarity.epic,
    ),

    // --- SPECIAL (Mission triggers/keys) ---
    ItemConfig(
      id: 'keycard_alpha',
      name: 'Sector Alpha Keycard',
      description: 'Grants access to the restricted upper levels.',
      category: ItemCategory.special,
      rarity: ItemRarity.rare,
    ),
  ];

  static List<ItemConfig> get all => _items;

  static ItemConfig getById(String id) {
    return _items.firstWhere(
      (i) => i.id == id,
      orElse: () => throw Exception('Item Configuration $id not found!'),
    );
  }

  static List<ItemConfig> getByCategory(ItemCategory category) {
    return _items.where((i) => i.category == category).toList();
  }
}
