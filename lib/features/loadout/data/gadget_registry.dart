import 'package:flutter/material.dart';
import '../models/gadget_config.dart';

class GadgetRegistry {
  static const List<GadgetConfig> allGadgets = [
    GadgetConfig(
      id: 'time_brake',
      name: 'Time Brake',
      description:
          'Slows down oncoming obstacles briefly, increasing reaction window.',
      rarity: GadgetRarity.common,
      statModifiers: {'time_dilation': 0.8},
      icon: Icons.timer,
      imageUrl: 'https://picsum.photos/200/200?blur=2&random=10',
    ),
    GadgetConfig(
      id: 'pulse_magnet',
      name: 'Pulse Magnet',
      description: 'Automatically pulls in Echo Coins from a wider radius.',
      rarity: GadgetRarity.rare,
      statModifiers: {'magnet_radius': 2.0},
      icon: Icons.wifi_tethering,
      imageUrl: 'https://picsum.photos/200/200?blur=2&random=11',
    ),
    GadgetConfig(
      id: 'phase_dash',
      name: 'Phase Dash',
      description:
          'Allows phasing right through a single obstacle without taking damage. Recharges slowly.',
      rarity: GadgetRarity.epic,
      statModifiers: {'invincibility_charges': 1.0, 'cooldown': 30.0},
      icon: Icons.double_arrow,
      imageUrl: 'https://picsum.photos/200/200?blur=2&random=12',
    ),
    GadgetConfig(
      id: 'echo_shield',
      name: 'Echo Shield',
      description:
          'Provides a permanent shield layer that ablates one lethal hit per run.',
      rarity: GadgetRarity.legendary,
      statModifiers: {'max_shields': 1.0},
      icon: Icons.shield,
      imageUrl: 'https://picsum.photos/200/200?blur=2&random=13',
    ),
    GadgetConfig(
      id: 'route_scanner',
      name: 'Route Scanner',
      description:
          'Reveals upcoming hazards earlier on the HUD, increasing far-sight.',
      rarity: GadgetRarity.rare,
      statModifiers: {'sight_range': 1.5},
      icon: Icons.radar,
      imageUrl: 'https://picsum.photos/200/200?blur=2&random=14',
    ),
    GadgetConfig(
      id: 'repair_drone',
      name: 'Repair Drone',
      description: 'Passively heals damage over time during long endless runs.',
      rarity: GadgetRarity.epic,
      statModifiers: {'hp_regen_per_second': 0.5},
      icon: Icons.medical_services,
      imageUrl: 'https://picsum.photos/200/200?blur=2&random=15',
    ),
    GadgetConfig(
      id: 'quantum_hook',
      name: 'Quantum Hook',
      description:
          'Grapples onto high platforms, extending jump hang-time immensely.',
      rarity: GadgetRarity.epic,
      statModifiers: {'hang_time': 2.0, 'jump_force': 1.2},
      icon: Icons.link,
      imageUrl: 'https://picsum.photos/200/200?blur=2&random=16',
    ),
  ];

  static GadgetConfig getById(String id) {
    return allGadgets.firstWhere(
      (g) => g.id == id,
      orElse: () => allGadgets.first,
    );
  }
}
