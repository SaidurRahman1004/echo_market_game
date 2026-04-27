import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/zone_registry.dart';
import '../zone_unlock_provider.dart';
import '../widgets/zone_card.dart';

class ZoneSelectScreen extends ConsumerWidget {
  const ZoneSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zoneState = ref.watch(zoneUnlockProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A24),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'SELECT SECTOR',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: ZoneRegistry.allZones.length,
        itemBuilder: (context, index) {
          final zone = ZoneRegistry.allZones[index];
          final isUnlocked = zoneState.unlockedZones.contains(zone.id);
          final isSelected = zoneState.currentRoute == zone.id;

          return ZoneCard(
            config: zone,
            isUnlocked: isUnlocked,
            isSelected: isSelected,
            onTap: () {
              ref.read(zoneUnlockProvider.notifier).setCurrentRoute(zone.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${zone.name} is now the active route!'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
