import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final int currentLevel;
  final int currentXp;

  // Lifetime Stats
  final int totalRuns;
  final int bestScore;
  final int lifetimeCoins;
  final int lifetimeShards;

  const ProfileState({
    this.currentLevel = 1,
    this.currentXp = 0,
    this.totalRuns = 0,
    this.bestScore = 0,
    this.lifetimeCoins = 0,
    this.lifetimeShards = 0,
  });

  Map<String, dynamic> toJson() => {
    'currentLevel': currentLevel,
    'currentXp': currentXp,
    'totalRuns': totalRuns,
    'bestScore': bestScore,
    'lifetimeCoins': lifetimeCoins,
    'lifetimeShards': lifetimeShards,
  };

  factory ProfileState.fromJson(Map<String, dynamic> json) => ProfileState(
    currentLevel: json['currentLevel'] as int? ?? 1,
    currentXp: json['currentXp'] as int? ?? 0,
    totalRuns: json['totalRuns'] as int? ?? 0,
    bestScore: json['bestScore'] as int? ?? 0,
    lifetimeCoins: json['lifetimeCoins'] as int? ?? 0,
    lifetimeShards: json['lifetimeShards'] as int? ?? 0,
  );

  ProfileState copyWith({
    int? currentLevel,
    int? currentXp,
    int? totalRuns,
    int? bestScore,
    int? lifetimeCoins,
    int? lifetimeShards,
  }) {
    return ProfileState(
      currentLevel: currentLevel ?? this.currentLevel,
      currentXp: currentXp ?? this.currentXp,
      totalRuns: totalRuns ?? this.totalRuns,
      bestScore: bestScore ?? this.bestScore,
      lifetimeCoins: lifetimeCoins ?? this.lifetimeCoins,
      lifetimeShards: lifetimeShards ?? this.lifetimeShards,
    );
  }

  @override
  List<Object?> get props => [
    currentLevel,
    currentXp,
    totalRuns,
    bestScore,
    lifetimeCoins,
    lifetimeShards,
  ];
}
