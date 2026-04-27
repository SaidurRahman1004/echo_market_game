import 'package:flutter/material.dart';
import '../models/gadget_config.dart';

class GadgetCard extends StatelessWidget {
  final GadgetConfig config;
  final bool isUnlocked;
  final bool isEquipped;
  final VoidCallback onTap;

  const GadgetCard({
    super.key,
    required this.config,
    required this.isUnlocked,
    required this.isEquipped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isUnlocked
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black54,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEquipped
                ? config.rarityColor
                : (isUnlocked ? Colors.white24 : Colors.transparent),
            width: isEquipped ? 2.5 : 1,
          ),
          boxShadow: isEquipped
              ? [
                  BoxShadow(
                    color: config.rarityColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              if (!isUnlocked)
                const Positioned.fill(child: ColoredBox(color: Colors.black45)),
              Row(
                children: [
                  // Icon Area
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Image.network(
                          config.imageUrl,
                          fit: BoxFit.cover,
                          color: isUnlocked ? null : Colors.grey,
                          colorBlendMode: isUnlocked
                              ? null
                              : BlendMode.saturation,
                          errorBuilder: (_, _, _) =>
                              const ColoredBox(color: Colors.white10),
                        ),
                        Center(
                          child: Icon(
                            isUnlocked ? config.icon : Icons.lock,
                            size: 32,
                            color: isUnlocked
                                ? config.rarityColor
                                : Colors.grey,
                            shadows: const [
                              BoxShadow(color: Colors.black, blurRadius: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Detail Area
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  isUnlocked ? config.name : 'Unknown Gadget',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isUnlocked
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isUnlocked)
                                Text(
                                  config.rarityName,
                                  style: TextStyle(
                                    color: config.rarityColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isUnlocked
                                ? config.description
                                : 'Unlock criteria not met.',
                            style: TextStyle(
                              color: isUnlocked
                                  ? Colors.white70
                                  : Colors.grey.shade700,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Equip Checkmark
                  if (isEquipped)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: config.rarityColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
