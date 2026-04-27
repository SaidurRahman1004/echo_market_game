import 'package:equatable/equatable.dart';

class CityState extends Equatable {
  // IDs of the city nodes that have been fully repaired/unlocked
  final List<String> repairedNodes;

  const CityState({this.repairedNodes = const []});

  Map<String, dynamic> toJson() => {'repairedNodes': repairedNodes};

  factory CityState.fromJson(Map<String, dynamic> json) {
    return CityState(
      repairedNodes:
          (json['repairedNodes'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  CityState copyWith({List<String>? repairedNodes}) {
    return CityState(repairedNodes: repairedNodes ?? this.repairedNodes);
  }

  @override
  List<Object?> get props => [repairedNodes];
}
