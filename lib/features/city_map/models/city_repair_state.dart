import 'package:equatable/equatable.dart';

class CityRepairState extends Equatable {
  final Map<String, int> nodeLevels;
  final int totalReputation;

  const CityRepairState({this.nodeLevels = const {}, this.totalReputation = 0});

  Map<String, dynamic> toJson() => {
    'nodeLevels': nodeLevels,
    'totalReputation': totalReputation,
  };

  factory CityRepairState.fromJson(Map<String, dynamic> json) =>
      CityRepairState(
        nodeLevels:
            (json['nodeLevels'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, v as int),
            ) ??
            {},
        totalReputation: json['totalReputation'] as int? ?? 0,
      );

  CityRepairState copyWith({
    Map<String, int>? nodeLevels,
    int? totalReputation,
  }) {
    return CityRepairState(
      nodeLevels: nodeLevels ?? this.nodeLevels,
      totalReputation: totalReputation ?? this.totalReputation,
    );
  }

  @override
  List<Object?> get props => [nodeLevels, totalReputation];
}
