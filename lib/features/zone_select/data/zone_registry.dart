import 'package:flutter/material.dart';
import '../models/zone_config.dart';

class ZoneRegistry {
  static const List<ZoneConfig> allZones = [
    ZoneConfig(
      id: 'starter_street',
      name: 'Starter Street',
      description:
          'The lowest level. A relatively safe district perfect for learning the ropes.',
      riskLevel: 1,
      rewardMultiplier: 1.0,
      themeColor: Colors.blueGrey,
      imageUrl: 'https://picsum.photos/400/200?blur=1&random=1',
    ),
    ZoneConfig(
      id: 'clock_alley',
      name: 'Clock Alley',
      description:
          'Cramped quarters and ticking machinery. The hazards are starting to wind up.',
      riskLevel: 2,
      rewardMultiplier: 1.2,
      themeColor: Colors.amber,
      imageUrl: 'https://picsum.photos/400/200?blur=1&random=2',
    ),
    ZoneConfig(
      id: 'neon_bazaar',
      name: 'Neon Bazaar',
      description:
          'Bright lights and dark alleys. High commerce means high security.',
      riskLevel: 3,
      rewardMultiplier: 1.5,
      themeColor: Colors.cyanAccent,
      imageUrl: 'https://picsum.photos/400/200?blur=1&random=3',
    ),
    ZoneConfig(
      id: 'dust_warehouse',
      name: 'Dust Warehouse',
      description:
          'An abandoned industrial sector filled with precarious jumps and rust.',
      riskLevel: 3,
      rewardMultiplier: 1.8,
      themeColor: Colors.brown,
      imageUrl: 'https://picsum.photos/400/200?blur=1&random=4',
    ),
    ZoneConfig(
      id: 'sky_bridge',
      name: 'Sky Bridge',
      description:
          'Suspended highways above the city. One misstep is a long way down.',
      riskLevel: 4,
      rewardMultiplier: 2.2,
      themeColor: Colors.lightBlueAccent,
      imageUrl: 'https://picsum.photos/400/200?blur=1&random=5',
    ),
    ZoneConfig(
      id: 'forgotten_market',
      name: 'Forgotten Market',
      description:
          'An underground unregulated zone where the highest bounties are paid.',
      riskLevel: 5,
      rewardMultiplier: 3.0,
      themeColor: Colors.purpleAccent,
      imageUrl: 'https://picsum.photos/400/200?blur=1&random=6',
    ),
    ZoneConfig(
      id: 'echo_core',
      name: 'Echo Core',
      description:
          'The pulsing heart of the city grid. Absolute danger. Absolute reward.',
      riskLevel: 5,
      rewardMultiplier: 5.0,
      themeColor: Colors.redAccent,
      imageUrl: 'https://picsum.photos/400/200?blur=1&random=7',
    ),
    ZoneConfig(
      id: 'shattered_grid',
      name: 'Shattered Grid',
      description:
          'A corrupted data realm where time physics glitch out unpredictably.',
      riskLevel: 6,
      rewardMultiplier: 7.5,
      themeColor: Colors.deepPurple,
      imageUrl: 'https://picsum.photos/400/200?blur=1&random=8',
    ),
  ];

  static ZoneConfig getById(String id) {
    return allZones.firstWhere(
      (zone) => zone.id == id,
      orElse: () => allZones.first,
    );
  }
}
