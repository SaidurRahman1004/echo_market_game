import 'package:equatable/equatable.dart';

class UpgradeState extends Equatable {
  final Map<String, int> currentUpgrades;

  const UpgradeState({this.currentUpgrades = const {}});

  Map<String, dynamic> toJson() => {'currentUpgrades': currentUpgrades};

  factory UpgradeState.fromJson(Map<String, dynamic> json) => UpgradeState(
    currentUpgrades:
        (json['currentUpgrades'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k, v as int),
        ) ??
        {},
  );

  UpgradeState copyWith({Map<String, int>? currentUpgrades}) {
    return UpgradeState(
      currentUpgrades: currentUpgrades ?? this.currentUpgrades,
    );
  }

  @override
  List<Object?> get props => [currentUpgrades];
}
