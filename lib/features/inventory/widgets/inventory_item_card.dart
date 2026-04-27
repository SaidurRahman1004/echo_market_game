import 'package:flutter/material.dart';
import '../models/item_config.dart';

class InventoryItemCard extends StatelessWidget {
  final ItemConfig item;
  final int count;
  final VoidCallback? onTap;

  const InventoryItemCard({
    super.key,
    required this.item,
    required this.count,
    this.onTap,
  });

  Color _getRarityColor(ItemRarity rarity) {
    switch (rarity) {
      case ItemRarity.common:
        return Colors.blueGrey;
      case ItemRarity.rare:
        return Colors.lightBlueAccent;
      case ItemRarity.epic:
        return Colors.purpleAccent;
      case ItemRarity.legendary:
        return Colors.amberAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rarityColor = _getRarityColor(item.rarity);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: rarityColor.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            // Internal content
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        item.category == ItemCategory.gadget
                            ? Icons.memory
                            : item.category == ItemCategory.currency
                            ? Icons.monetization_on
                            : item.category == ItemCategory.relic
                            ? Icons.diamond
                            : Icons.category,
                        color: rarityColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(
                            color: rarityColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Expanded(
                    child: Text(
                      item.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Badge (if strictly applicable and not a structural unlock)
            if (count > 0 ||
                item.category == ItemCategory.currency ||
                item.category == ItemCategory.material)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: rarityColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'x$count',
                    style: TextStyle(
                      color: rarityColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
