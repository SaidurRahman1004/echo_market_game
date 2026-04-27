import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mission_registry.dart';
import '../mission_progress_provider.dart';
import '../widgets/mission_card.dart';

class MissionScreen extends ConsumerWidget {
  const MissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionState = ref.watch(missionProgressProvider);

    // Filter into tabs/sections: Active / To Claim / Claimed
    final activeIds = missionState.activeMissions.keys.toList();
    final toClaimIds = missionState.completedMissions;
    final claimedIds = missionState.claimedMissions;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A24),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'MISSIONS BOARD',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              indicatorColor: Colors.amberAccent,
              labelColor: Colors.amberAccent,
              unselectedLabelColor: Colors.white54,
              tabs: [
                Tab(text: 'ACTIVE'),
                Tab(text: 'REWARDS'),
                Tab(text: 'LOG'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: ACTIVE
                  _buildList(
                    context,
                    ref,
                    activeIds,
                    missionState.activeMissions,
                    false,
                    false,
                  ),

                  // Tab 2: REWARDS (To Claim)
                  _buildList(context, ref, toClaimIds, null, true, false),

                  // Tab 3: LOG (Claimed)
                  _buildList(context, ref, claimedIds, null, true, true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    List<String> ids,
    Map<String, int>? progressMap,
    bool isCompleted,
    bool isClaimed,
  ) {
    if (ids.isEmpty) {
      return const Center(
        child: Text(
          'No records found.',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: ids.length,
      itemBuilder: (context, index) {
        final id = ids[index];
        final config = MissionRegistry.getById(id);

        int currentProgress = 0;
        if (isCompleted || isClaimed) {
          currentProgress = config.targetGoal;
        } else if (progressMap != null) {
          currentProgress = progressMap[id] ?? 0;
        }

        return MissionCard(
          config: config,
          currentProgress: currentProgress,
          isCompleted: isCompleted,
          isClaimed: isClaimed,
          onClaim: (isCompleted && !isClaimed)
              ? () => ref.read(missionProgressProvider.notifier).claimReward(id)
              : null,
        );
      },
    );
  }
}
