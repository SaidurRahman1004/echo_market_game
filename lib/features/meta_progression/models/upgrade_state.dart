import 'package:equatable/equatable.dart';

class UpgradeState extends Equatable {
  // Key: upgradeId, Value: currentLevel (0 if not in map)
  final Map<String, int> levels;

  const UpgradeState({this.levels = const {}});

  Map<String, dynamic> toJson() => {'levels': levels};

  factory UpgradeState.fromJson(Map<String, dynamic> json) {
    return UpgradeState(
      levels:
          (json['levels'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          {},
    );
  }

  UpgradeState copyWith({Map<String, int>? levels}) {
    return UpgradeState(levels: levels ?? this.levels);
  }

  @override
  List<Object?> get props => [levels];
}
