import 'package:flutter/material.dart';
import '../models/shop_item_config.dart';

class ShopItemCard extends StatelessWidget {
  final ShopItemConfig item;
  final bool canAfford;
  final bool isSoldOut;
  final int currentPurchases;
  final VoidCallback onPurchase;

  const ShopItemCard({
    super.key,
    required this.item,
    required this.canAfford,
    required this.isSoldOut,
    required this.currentPurchases,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    // Styling depending on currency type
    final isPremium = item.currency == MarketCurrency.timeShards;
    final currencyColor = isPremium ? Colors.lightBlueAccent : Colors.amber;
    final currencyIcon = isPremium ? Icons.diamond_outlined : Icons.stars;

    // Border states based on availability
    final borderColor = isSoldOut
        ? Colors.white24
        : (canAfford
              ? currencyColor.withValues(alpha: 0.5)
              : Colors.redAccent.withValues(alpha: 0.4));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Box Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSoldOut
                  ? Colors.white10
                  : currencyColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                _getSectionIcon(item.section),
                color: isSoldOut ? Colors.white30 : currencyColor,
                size: 32,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Data
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.displayName.toUpperCase() +
                      (item.bundleQuantity > 1
                          ? ' (x${item.bundleQuantity})'
                          : ''),
                  style: TextStyle(
                    color: isSoldOut ? Colors.white30 : Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.displayDescription,
                  style: TextStyle(
                    color: isSoldOut ? Colors.white24 : Colors.white54,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Purchase Limitation info (if not infinite)
                if (item.maxPurchases != -1) ...[
                  const SizedBox(height: 6),
                  Text(
                    'STOCK: $currentPurchases / ${item.maxPurchases}',
                    style: TextStyle(
                      color: isSoldOut ? Colors.redAccent : Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Interaction Button
          if (isSoldOut)
            _buildStatusBadge('SOLD OUT', Colors.grey.shade900, Colors.white54)
          else
            ElevatedButton(
              onPressed: canAfford ? onPurchase : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canAfford
                    ? currencyColor
                    : Colors.grey.shade900,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${item.cost}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: canAfford ? Colors.black : Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    currencyIcon,
                    color: canAfford ? Colors.black : Colors.amber,
                    size: 16,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  IconData _getSectionIcon(MarketSection section) {
    switch (section) {
      case MarketSection.gear:
        return Icons.memory;
      case MarketSection.supplies:
        return Icons.inventory_2;
      case MarketSection.cosmetics:
        return Icons.color_lens;
      case MarketSection.special:
        return Icons.star;
    }
  }
}
