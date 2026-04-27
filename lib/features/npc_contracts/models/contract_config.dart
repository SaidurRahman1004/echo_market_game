import 'package:equatable/equatable.dart';

enum NpcRole {
  gadgetSeller,
  relicCollector,
  repairEngineer,
  missionBroker,
  memoryArchivist,
  blackMarketTrader,
}

enum ContractObjectiveType {
  handInItem, // NPC takes the item from the player's inventory
  repairCityNode, // NPC checks if a specific city node is repaired
  completeMission, // NPC checks if a specific mission has been completed
  unlockZone, // NPC checks if a specific zone map is unlocked
}

class ContractRequirement {
  final ContractObjectiveType type;
  final String targetId; // Item ID, City Node ID, Mission ID, or Zone ID
  final int requiredAmount;

  const ContractRequirement({
    required this.type,
    required this.targetId,
    this.requiredAmount = 1,
  });
}

enum ContractRewardType { echoCoins, timeShards, item }

class ContractReward {
  final ContractRewardType type;
  final String? itemId;
  final int amount;

  const ContractReward({required this.type, this.itemId, required this.amount});
}

class ContractConfig extends Equatable {
  final String id;
  final String npcName;
  final NpcRole npcRole;
  final String title;
  final String dialogText;
  final List<ContractRequirement> requirements;
  final List<ContractReward> rewards;
  final String? prerequisiteContractId; // For creating chained narratives

  const ContractConfig({
    required this.id,
    required this.npcName,
    required this.npcRole,
    required this.title,
    required this.dialogText,
    required this.requirements,
    required this.rewards,
    this.prerequisiteContractId,
  });

  @override
  List<Object?> get props => [
    id,
    npcName,
    npcRole,
    title,
    dialogText,
    requirements,
    rewards,
    prerequisiteContractId,
  ];
}
