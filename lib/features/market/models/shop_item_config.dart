import 'package:equatable/equatable.dart';

enum MarketSection {
  gear, // Permanent unlocks like gadgets
  supplies, // Repeatable purchases like materials
  cosmetics, // Visual upgrades
  special, // Event or rotation stock
}

enum MarketCurrency { echoCoins, timeShards }

/// Architecture blueprint mapping Shop items to internal systems securely.
class ShopItemConfig extends Equatable {
  final String id;
  final String targetItemId; // Links directly to ItemRegistry.id or Gadget.id
  final String displayName;
  final String displayDescription;
  final MarketSection section;
  final MarketCurrency currency;
  final int cost;
  final int maxPurchases; // -1 denotes infinite stock
  final int bundleQuantity; // How many items you receive per click

  const ShopItemConfig({
    required this.id,
    required this.targetItemId,
    required this.displayName,
    required this.displayDescription,
    required this.section,
    required this.currency,
    required this.cost,
    this.maxPurchases = 1,
    this.bundleQuantity = 1,
  });

  @override
  List<Object?> get props => [
    id,
    targetItemId,
    displayName,
    displayDescription,
    section,
    currency,
    cost,
    maxPurchases,
    bundleQuantity,
  ];
}
