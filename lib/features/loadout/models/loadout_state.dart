import 'package:equatable/equatable.dart';

class LoadoutState extends Equatable {
  final List<String> equippedGadgetIds; // Max 2 gadgets
  final List<String> unlockedGadgetIds;

  const LoadoutState({
    this.equippedGadgetIds = const ['time_brake'],
    this.unlockedGadgetIds = const ['time_brake', 'pulse_magnet'],
  });

  Map<String, dynamic> toJson() => {
    'equippedGadgetIds': equippedGadgetIds,
    'unlockedGadgetIds': unlockedGadgetIds,
  };

  factory LoadoutState.fromJson(Map<String, dynamic> json) => LoadoutState(
    equippedGadgetIds:
        (json['equippedGadgetIds'] as List<dynamic>?)?.cast<String>() ??
        ['time_brake'],
    unlockedGadgetIds:
        (json['unlockedGadgetIds'] as List<dynamic>?)?.cast<String>() ??
        ['time_brake', 'pulse_magnet'],
  );

  LoadoutState copyWith({
    List<String>? equippedGadgetIds,
    List<String>? unlockedGadgetIds,
  }) {
    return LoadoutState(
      equippedGadgetIds: equippedGadgetIds ?? this.equippedGadgetIds,
      unlockedGadgetIds: unlockedGadgetIds ?? this.unlockedGadgetIds,
    );
  }

  @override
  List<Object?> get props => [equippedGadgetIds, unlockedGadgetIds];
}
