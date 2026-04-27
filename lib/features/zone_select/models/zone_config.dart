import 'package:flutter/material.dart';

class ZoneConfig {
  final String id;
  final String name;
  final String description;
  final int riskLevel;
  final double rewardMultiplier;
  final Color themeColor;
  final String imageUrl;

  const ZoneConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.riskLevel,
    required this.rewardMultiplier,
    required this.themeColor,
    required this.imageUrl,
  });
}
