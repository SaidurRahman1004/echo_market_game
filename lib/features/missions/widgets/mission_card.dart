import 'package:flutter/material.dart';
import '../models/mission_config.dart';

class MissionCard extends StatelessWidget {
  final MissionConfig config;
  final int currentProgress;
  final bool isCompleted;
  final bool isClaimed;
  final VoidCallback? onClaim;

  const MissionCard({
    super.key,
    required this.config,
    required this.currentProgress,
    this.isCompleted = false,
    this.isClaimed = false,
    this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final double progressPercent = (currentProgress / config.targetGoal).clamp(
      0.0,
      1.0,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isClaimed
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted && !isClaimed
              ? Colors.greenAccent
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon Badge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isClaimed
                    ? Colors.grey.withValues(alpha: 0.3)
                    : config.categoryColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isClaimed ? Icons.check : config.icon,
                color: isClaimed ? Colors.grey : config.categoryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Middle Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.categoryIdentifier,
                    style: TextStyle(
                      color: isClaimed ? Colors.grey : config.categoryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    config.title,
                    style: TextStyle(
                      color: isClaimed ? Colors.grey : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: isClaimed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    config.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 12),

                  // Progress Bar
                  if (!isClaimed) ...[
                    Stack(
                      children: [
                        Container(
                          height: 6,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: progressPercent,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? Colors.greenAccent
                                  : config.categoryColor,
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (isCompleted
                                              ? Colors.greenAccent
                                              : config.categoryColor)
                                          .withValues(alpha: 0.5),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isCompleted ? 'READY TO CLAIM' : '/',
                          style: TextStyle(
                            color: isCompleted
                                ? Colors.greenAccent
                                : Colors.white54,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _RewardPreview(reward: config.reward),
                      ],
                    ),
                  ] else ...[
                    const Text(
                      'COMPLETED',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Claim Button
            if (isCompleted && !isClaimed) ...[
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade400,
                  foregroundColor: Colors.black87,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                ),
                onPressed: onClaim,
                child: const Icon(Icons.download, size: 24),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RewardPreview extends StatelessWidget {
  final MissionReward reward;

  const _RewardPreview({required this.reward});

  @override
  Widget build(BuildContext context) {
    Color actColor;
    String symbol;

    switch (reward.type) {
      case RewardType.echoCoins:
        actColor = Colors.amber;
        symbol = 'C';
        break;
      case RewardType.timeShards:
        actColor = Colors.purpleAccent;
        symbol = 'S';
        break;
      case RewardType.xp:
        actColor = Colors.blueAccent;
        symbol = 'XP';
        break;
      case RewardType.gadget:
        actColor = Colors.cyanAccent;
        symbol = 'G';
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.stars, size: 12, color: actColor),
        const SizedBox(width: 4),
        Text(
          '+${reward.amount} $symbol',
          style: TextStyle(
            color: actColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
