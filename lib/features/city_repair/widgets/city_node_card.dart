import 'package:flutter/material.dart';
import '../models/city_node_config.dart';

class CityNodeCard extends StatelessWidget {
  final CityNodeConfig node;
  final bool isRepaired;
  final bool isLocked;
  final bool canAfford;
  final VoidCallback onRepair;

  const CityNodeCard({
    super.key,
    required this.node,
    required this.isRepaired,
    required this.isLocked,
    required this.canAfford,
    required this.onRepair,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = isRepaired
        ? Colors.greenAccent
        : (isLocked
              ? Colors.redAccent.withValues(alpha: 0.5)
              : Colors.amberAccent);

    // Calculate dynamic border
    final borderColor = isRepaired
        ? Colors.greenAccent
        : (canAfford && !isLocked)
        ? Colors.amberAccent
        : Colors.grey.shade800;

    return Container(
      width: 280,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLocked ? Colors.black38 : Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isRepaired ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                isRepaired
                    ? Icons.check_circle
                    : (isLocked ? Icons.lock : Icons.build),
                color: themeColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  node.name.toUpperCase(),
                  style: TextStyle(
                    color: isLocked ? Colors.white54 : Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              if (isRepaired)
                const Text(
                  'ONLINE',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            node.description,
            style: TextStyle(
              color: isLocked ? Colors.white24 : Colors.white70,
              fontSize: 12,
            ),
          ),

          if (!isRepaired) ...[
            const SizedBox(height: 16),
            const Text(
              'REPAIR COMPONENTS',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...node.costs.map((c) => _buildCostRow(c.itemId, c.amount)),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (canAfford && !isLocked) ? onRepair : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: Colors.grey.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isLocked ? 'MISSING PREREQUISITES' : 'COMMENCE REPAIRS',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCostRow(String id, int amount) {
    Color c = Colors.white;
    String tag = id;
    IconData i = Icons.category;

    if (id == 'echo_coins') {
      c = Colors.amber;
      tag = 'Echo Coins';
      i = Icons.stars;
    } else if (id == 'time_shards') {
      c = Colors.lightBlueAccent;
      tag = 'Time Shards';
      i = Icons.diamond_outlined;
    } else if (id.startsWith('mat_')) {
      c = Colors.purpleAccent;
      tag = 'Material ($id)';
      i = Icons.settings;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Icon(i, size: 14, color: c),
          const SizedBox(width: 6),
          Text(tag, style: TextStyle(color: c, fontSize: 12)),
          const Spacer(),
          Text(
            '$amount',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
