import 'package:equatable/equatable.dart';

/// Clean model representing the raw outcome of a run before external multipliers.
class RunResult extends Equatable {
  final int score;
  final int distance;
  final int survivalTimeSeconds;
  final int rawCoins;
  final int rawShards;
  final int relicsFound;
  final double comboBonus;

  const RunResult({
    this.score = 0,
    this.distance = 0,
    this.survivalTimeSeconds = 0,
    this.rawCoins = 0,
    this.rawShards = 0,
    this.relicsFound = 0,
    this.comboBonus = 1.0,
  });

  @override
  List<Object?> get props => [
    score,
    distance,
    survivalTimeSeconds,
    rawCoins,
    rawShards,
    relicsFound,
    comboBonus,
  ];
}

/// The expanded outcome after processor calculates combo multipliers and streaks.
class CalculatedRewards extends Equatable {
  final int finalScore;
  final int finalCoins;
  final int finalShards;
  final int finalXp;
  final double comboMultiplier;

  const CalculatedRewards({
    required this.finalScore,
    required this.finalCoins,
    required this.finalShards,
    required this.finalXp,
    required this.comboMultiplier,
  });

  @override
  List<Object?> get props => [
    finalScore,
    finalCoins,
    finalShards,
    finalXp,
    comboMultiplier,
  ];
}
