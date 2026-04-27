import 'package:flutter/material.dart';
import '../models/upgrade_config.dart';

class UpgradeCard extends StatelessWidget {
  final UpgradeConfig upgrade;
  final int currentLevel;
  final int nextCost;
  final bool isMaxLevel;
  final bool canAfford;
  final VoidCallback onPurchase;

  const UpgradeCard({
    super.key,
    required this.upgrade,
    required this.currentLevel,
    required this.nextCost,
    required this.isMaxLevel,
    required this.canAfford,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = _getPathColor(upgrade.path);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeColor.withValues(alpha: isMaxLevel ? 0.8 : 0.2),
          width: isMaxLevel ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getPathIcon(upgrade.path),
              color: themeColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          // Info Col
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  upgrade.name.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  upgrade.description,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Progress Bar or Level Text
                if (!isMaxLevel)
                  Row(
                    children: [
                      Text(
                        'LVL $currentLevel/',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${upgrade.maxLevel}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      // Stat Prediction
                      Text(
                        '+ ${(upgrade.valuePerLevel * (currentLevel + 1)).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: themeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    'MAX LEVEL ACHIEVED',
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Purchase Action
          if (!isMaxLevel)
            ElevatedButton(
              onPressed: canAfford ? onPurchase : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canAfford ? themeColor : Colors.grey.shade900,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.upgrade, size: 18),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$nextCost',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: canAfford ? Colors.white : Colors.redAccent,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.stars, color: Colors.amber, size: 12),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getPathColor(UpgradePath path) {
    switch (path) {
      case UpgradePath.speed:
        return Colors.blueAccent;
      case UpgradePath.collector:
        return Colors.amberAccent;
      case UpgradePath.survival:
        return Colors.greenAccent;
    }
  }

  IconData _getPathIcon(UpgradePath path) {
    switch (path) {
      case UpgradePath.speed:
        return Icons.bolt;
      case UpgradePath.collector:
        return Icons.monetization_on;
      case UpgradePath.survival:
        return Icons.shield;
    }
  }
}
