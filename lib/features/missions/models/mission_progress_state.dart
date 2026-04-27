import 'package:equatable/equatable.dart';

class MissionProgressState extends Equatable {
  final Map<String, int> activeMissions;
  final List<String> completedMissions; // Ready to claim
  final List<String> claimedMissions; // Claimed recently

  const MissionProgressState({
    this.activeMissions = const {},
    this.completedMissions = const [],
    this.claimedMissions = const [],
  });

  Map<String, dynamic> toJson() => {
    'activeMissions': activeMissions,
    'completedMissions': completedMissions,
    'claimedMissions': claimedMissions,
  };

  factory MissionProgressState.fromJson(Map<String, dynamic> json) =>
      MissionProgressState(
        activeMissions:
            (json['activeMissions'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, v as int),
            ) ??
            {},
        completedMissions:
            (json['completedMissions'] as List<dynamic>?)?.cast<String>() ?? [],
        claimedMissions:
            (json['claimedMissions'] as List<dynamic>?)?.cast<String>() ?? [],
      );

  MissionProgressState copyWith({
    Map<String, int>? activeMissions,
    List<String>? completedMissions,
    List<String>? claimedMissions,
  }) {
    return MissionProgressState(
      activeMissions: activeMissions ?? this.activeMissions,
      completedMissions: completedMissions ?? this.completedMissions,
      claimedMissions: claimedMissions ?? this.claimedMissions,
    );
  }

  @override
  List<Object?> get props => [
    activeMissions,
    completedMissions,
    claimedMissions,
  ];
}
