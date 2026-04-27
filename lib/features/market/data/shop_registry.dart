import '../models/shop_item_config.dart';

/// Database mapping shop IDs to inventory targets and costs.
/// This acts as the structural point allowing us to create dynamic/rotating stock later.
class ShopRegistry {
  static const List<ShopItemConfig> _items = [
    // --- GEAR & TECH ---
    ShopItemConfig(
      id: 'shop_magnet_drone',
      targetItemId: 'magnet_drone',
      displayName: 'Magnet Drone MK-I',
      displayDescription:
          'Auto-collects nearby coins. Essential entry-level tech.',
      section: MarketSection.gear,
      currency: MarketCurrency.echoCoins,
      cost: 1500,
      maxPurchases: 1, // Unlock once
    ),
    ShopItemConfig(
      id: 'shop_shield_matrix',
      targetItemId: 'shield_matrix',
      displayName: 'Shield Prototype',
      displayDescription:
          'Absorbs one fatal impact per run. Highly experimental.',
      section: MarketSection.gear,
      currency: MarketCurrency.timeShards, // Premium
      cost: 200,
      maxPurchases: 1,
    ),

    // --- SUPPLIES / CONSUMABLES ---
    ShopItemConfig(
      id: 'shop_mat_copper_bundle',
      targetItemId: 'mat_copper',
      displayName: 'Scrap Copper Bundle',
      displayDescription: '5x pieces of basic upgrade materials for gadgets.',
      section: MarketSection.supplies,
      currency: MarketCurrency.echoCoins,
      cost: 500,
      maxPurchases: -1, // Infinite uses
      bundleQuantity: 5,
    ),
    ShopItemConfig(
      id: 'shop_mat_flux',
      targetItemId: 'mat_flux',
      displayName: 'Flux Core',
      displayDescription:
          'Highly radioactive. Required for deep-time upgrades.',
      section: MarketSection.supplies,
      currency: MarketCurrency.timeShards,
      cost: 100,
      maxPurchases: 5, // Simulated limited weekly stock
      bundleQuantity: 1,
    ),

    // --- COSMETICS ---
    ShopItemConfig(
      id: 'shop_cos_neon_trail',
      targetItemId: 'cos_neon_trail',
      displayName: 'Neon Trail FX',
      displayDescription: 'Leave a bright cyan wake. Look good running fast.',
      section: MarketSection.cosmetics,
      currency: MarketCurrency.timeShards,
      cost: 500,
      maxPurchases: 1,
    ),
    ShopItemConfig(
      id: 'shop_cos_crimson_suit',
      targetItemId: 'cos_crimson_suit',
      displayName: 'Crimson Ops Suit',
      displayDescription: 'A stark red variant of the Prime Timeline armor.',
      section: MarketSection.cosmetics,
      currency: MarketCurrency.timeShards,
      cost: 1000,
      maxPurchases: 1,
    ),
  ];

  static List<ShopItemConfig> get all => _items;

  static List<ShopItemConfig> getBySection(MarketSection section) {
    return _items.where((i) => i.section == section).toList();
  }

  static ShopItemConfig getById(String id) {
    return _items.firstWhere(
      (i) => i.id == id,
      orElse: () => throw Exception('Shop item $id not found in registry!'),
    );
  }
}
