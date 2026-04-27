import 'package:equatable/equatable.dart';

/// Classification of items to allow modular sorting, filtering, and logic.
enum ItemCategory {
  currency, // Handled separately in state, but displayed together
  relic,
  material,
  gadget,
  cosmetic,
  special,
}

enum ItemRarity { common, rare, epic, legendary }

/// The structural blueprint of any item existing in the game.
class ItemConfig extends Equatable {
  final String id;
  final String name;
  final String description;
  final ItemCategory category;
  final ItemRarity rarity;
  // Use icon placeholder for now
  final String iconPath;

  const ItemConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.rarity = ItemRarity.common,
    this.iconPath = 'assets/icons/default_item.png',
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    category,
    rarity,
    iconPath,
  ];
}
