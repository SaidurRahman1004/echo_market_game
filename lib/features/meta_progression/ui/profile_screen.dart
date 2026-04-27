import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/profile_provider.dart';
import '../../zone_select/zone_unlock_provider.dart';
import '../../missions/mission_progress_provider.dart';
import '../../city_map/city_repair_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final zones = ref.watch(zoneUnlockProvider);
    final missions = ref.watch(missionProgressProvider);
    final city = ref.watch(cityRepairProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Player Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Level and XP Header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.blueAccent.shade700,
                      child: Icon(
                        Icons.person,
                        size: 64,
                        color: Colors.blue.shade100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'LEVEL ${profile.currentLevel}',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                    ),
                    Text(
                      '${profile.currentXp} XP / ${profile.currentLevel * 100} XP',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'LIFETIME STATS',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.grey.shade400,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),

              Card(
                elevation: 4,
                color: const Color(0xFF262630),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _StatRow('Total Runs', profile.totalRuns.toString()),
                      const Divider(height: 24, color: Colors.white12),
                      _StatRow(
                        'Best Score',
                        profile.bestScore.toString(),
                        isHighlight: true,
                      ),
                      const Divider(height: 24, color: Colors.white12),
                      _StatRow(
                        'Coins Collected',
                        profile.lifetimeCoins.toString(),
                        icon: Icons.monetization_on,
                        color: Colors.amber,
                      ),
                      const Divider(height: 24, color: Colors.white12),
                      _StatRow(
                        'Shards Collected',
                        profile.lifetimeShards.toString(),
                        icon: Icons.diamond,
                        color: Colors.lightBlueAccent,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'WORLD PROGRESS',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.grey.shade400,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),

              Card(
                elevation: 4,
                color: const Color(0xFF262630),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _StatRow(
                        'Zones Unlocked',
                        zones.unlockedZones.length.toString(),
                        icon: Icons.map,
                        color: Colors.greenAccent,
                      ),
                      const Divider(height: 24, color: Colors.white12),
                      _StatRow(
                        'City Nodes Repaired',
                        city.nodeLevels.length.toString(),
                        icon: Icons.build,
                        color: Colors.orangeAccent,
                      ),
                      const Divider(height: 24, color: Colors.white12),
                      _StatRow(
                        'Missions Completed',
                        missions.claimedMissions.length.toString(),
                        icon: Icons.check_circle,
                        color: Colors.purpleAccent,
                      ),
                    ],
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

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;
  final bool isHighlight;

  const _StatRow(
    this.label,
    this.value, {
    this.icon,
    this.color,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isHighlight ? Colors.amberAccent : Colors.white,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isHighlight ? Colors.amberAccent : Colors.white70,
          ),
        ),
      ],
    );
  }
}
