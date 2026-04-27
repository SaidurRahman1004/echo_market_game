import 'package:flutter/material.dart';
import '../models/contract_config.dart';

class ContractCard extends StatelessWidget {
  final ContractConfig contract;
  final bool isCompleted;
  final bool canComplete;
  final VoidCallback onComplete;

  const ContractCard({
    super.key,
    required this.contract,
    required this.isCompleted,
    required this.canComplete,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLocked = !isCompleted && !canComplete;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: isCompleted
          ? Colors.green.shade900
          : (isLocked ? Colors.grey.shade900 : Colors.blueGrey.shade900),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    contract.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.green.shade100 : Colors.white,
                    ),
                  ),
                ),
                if (isCompleted)
                  const Icon(Icons.check_circle, color: Colors.green)
                else if (isLocked)
                  const Icon(Icons.lock, color: Colors.grey)
                else
                  const Icon(Icons.star, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${contract.npcName} - ${contract.npcRole.name.toUpperCase()}',
              style: TextStyle(
                color: Colors.amber.shade200,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              contract.dialogText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isCompleted
                    ? Colors.green.shade200
                    : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Requirements:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            ...contract.requirements.map((req) {
              String reqText = '';
              switch (req.type) {
                case ContractObjectiveType.handInItem:
                  reqText = 'Deliver ${req.requiredAmount}x ${req.targetId}';
                  break;
                case ContractObjectiveType.repairCityNode:
                  reqText = 'Repair node: ${req.targetId}';
                  break;
                case ContractObjectiveType.completeMission:
                  reqText = 'Complete mission: ${req.targetId}';
                  break;
                case ContractObjectiveType.unlockZone:
                  reqText = 'Unlock zone: ${req.targetId}';
                  break;
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_right, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      reqText,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
            const Text(
              'Rewards:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            ...contract.rewards.map((rew) {
              String rewText = '';
              switch (rew.type) {
                case ContractRewardType.echoCoins:
                  rewText = '${rew.amount} Echo Coins';
                  break;
                case ContractRewardType.timeShards:
                  rewText = '${rew.amount} Time Shards';
                  break;
                case ContractRewardType.item:
                  rewText = '${rew.amount}x ${rew.itemId}';
                  break;
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.card_giftcard,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rewText,
                      style: const TextStyle(color: Colors.amberAccent),
                    ),
                  ],
                ),
              );
            }),
            if (!isCompleted && canComplete) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: onComplete,
                  child: const Text('Complete Contract'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
