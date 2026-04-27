import 'package:flutter/material.dart';

enum GadgetRarity { common, rare, epic, legendary }

class GadgetConfig {
  final String id;
  final String name;
  final String description;
  final GadgetRarity rarity;
  final Map<String, double> statModifiers; // e.g. {'speed': 1.1, 'shield': 1.0}
  final String imageUrl;
  final IconData icon;

  const GadgetConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.rarity,
    this.statModifiers = const {},
    required this.imageUrl,
    required this.icon,
  });

  Color get rarityColor {
    switch (rarity) {
      case GadgetRarity.common:
        return Colors.white70;
      case GadgetRarity.rare:
        return Colors.blueAccent;
      case GadgetRarity.epic:
        return Colors.purpleAccent;
      case GadgetRarity.legendary:
        return Colors.amberAccent;
    }
  }

  String get rarityName {
    switch (rarity) {
      case GadgetRarity.common:
        return 'COMMON';
      case GadgetRarity.rare:
        return 'RARE';
      case GadgetRarity.epic:
        return 'EPIC';
      case GadgetRarity.legendary:
        return 'LEGENDARY';
    }
  }
}
