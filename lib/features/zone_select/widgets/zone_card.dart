import 'package:flutter/material.dart';
import '../models/zone_config.dart';

class ZoneCard extends StatelessWidget {
  final ZoneConfig config;
  final bool isUnlocked;
  final bool isSelected;
  final VoidCallback onTap;

  const ZoneCard({
    super.key,
    required this.config,
    required this.isUnlocked,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? config.themeColor
                : (isUnlocked ? Colors.white24 : Colors.transparent),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: config.themeColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.network(
                  config.imageUrl,
                  fit: BoxFit.cover,
                  color: isUnlocked ? null : Colors.grey,
                  colorBlendMode: isUnlocked ? null : BlendMode.saturation,
                  errorBuilder: (_, _, _) => ColoredBox(
                    color: config.themeColor.withValues(alpha: 0.2),
                  ),
                ),
              ),

              // Dark Gradient overlay for readability
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.black.withValues(alpha: 0.3),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),

              // Content Layer
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntrinsicWidth(
                      child: Row(
                        children: [
                          Icon(
                            isUnlocked ? Icons.location_on : Icons.lock,
                            color: isUnlocked ? config.themeColor : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isUnlocked ? config.name : '???',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isUnlocked
                                    ? Colors.white
                                    : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (isUnlocked) ...[
                      Text(
                        config.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _StatPill(
                            label: 'RISK',
                            value: '${config.riskLevel}/5',
                            color: Colors.redAccent,
                          ),
                          const SizedBox(width: 12),
                          _StatPill(
                            label: 'REWARD MULT',
                            value: 'x${config.rewardMultiplier}',
                            color: Colors.amberAccent,
                          ),
                        ],
                      ),
                    ] else ...[
                      const Text(
                        'Unlock specific prerequisites to access this sector.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Selected Indicator
              if (isSelected)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: config.themeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'ACTIVE ROUTE',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
