import '../models/contract_config.dart';

class ContractRegistry {
  static const List<ContractConfig> _contracts = [
    // --- RELIC COLLECTOR ---
    ContractConfig(
      id: 'contract_relic_1',
      npcName: 'Aris',
      npcRole: NpcRole.relicCollector,
      title: 'Lost Timepiece',
      dialogText:
          'Runner! Did you find the Shattered Hourglass? Bring it to me and I\'ll compensate you handsomely.',
      requirements: [
        ContractRequirement(
          type: ContractObjectiveType.handInItem,
          targetId: 'relic_hourglass',
          requiredAmount: 1,
        ),
      ],
      rewards: [
        ContractReward(type: ContractRewardType.timeShards, amount: 500),
      ],
    ),

    // --- REPAIR ENGINEER ---
    ContractConfig(
      id: 'contract_fix_hub',
      npcName: 'Jax',
      npcRole: NpcRole.repairEngineer,
      title: 'Powering Up The Workshop',
      dialogText:
          'I can\'t work without power. Go out there and repair the Hub Generator Phase 1 node. Once it\'s online, I can start building tech for you.',
      requirements: [
        ContractRequirement(
          type: ContractObjectiveType.repairCityNode,
          targetId: 'city_hub_power',
        ),
      ],
      rewards: [
        ContractReward(
          type: ContractRewardType.item,
          itemId: 'shield_matrix',
          amount: 1,
        ),
      ],
    ),

    // --- GADGET SELLER / BLACK MARKET ---
    ContractConfig(
      id: 'contract_copper_run',
      npcName: 'Vera',
      npcRole: NpcRole.gadgetSeller,
      title: 'Scrap Run',
      dialogText:
          'I\'m running low on basic components. Gather 5 pieces of Scrap Copper from the lower levels. Don\'t ask why, just get them.',
      requirements: [
        ContractRequirement(
          type: ContractObjectiveType.handInItem,
          targetId: 'mat_copper',
          requiredAmount: 5,
        ),
      ],
      rewards: [
        ContractReward(type: ContractRewardType.echoCoins, amount: 1500),
      ],
    ),

    // --- SECONDARY ENGINEER QUEST ---
    ContractConfig(
      id: 'contract_fix_hub_2',
      npcName: 'Jax',
      npcRole: NpcRole.repairEngineer,
      title: 'Deeper Scavenging',
      dialogText:
          'Thanks for the power. Now, have you unlocked the Scavenger\'s Outpost? I need someone who can travel through Sector 2 without dying.',
      requirements: [
        ContractRequirement(
          type: ContractObjectiveType.repairCityNode,
          targetId: 'city_scavenger_den',
        ),
      ],
      rewards: [
        ContractReward(type: ContractRewardType.timeShards, amount: 100),
        ContractReward(
          type: ContractRewardType.item,
          itemId: 'mat_flux',
          amount: 1,
        ),
      ],
      prerequisiteContractId:
          'contract_fix_hub', // Requires first Jax contract to be finished natively
    ),
  ];

  static List<ContractConfig> get all => _contracts;

  static ContractConfig getById(String id) {
    return _contracts.firstWhere(
      (c) => c.id == id,
      orElse: () => throw Exception('Contract $id not found in registry!'),
    );
  }
}
