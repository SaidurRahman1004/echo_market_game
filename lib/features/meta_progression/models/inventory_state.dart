import 'package:equatable/equatable.dart';

class InventoryState extends Equatable {
  // Legacy fields (kept for backward compatibility during runtime logic if needed)
  final List<String> ownedGadgets;
  final List<String> equippedGadgets;

  // Future-proof, fully structural generic items map (id -> quantity)
  final Map<String, int> ownedItems;

  const InventoryState({
    this.ownedGadgets = const [],
    this.equippedGadgets = const [],
    this.ownedItems = const {},
  });

  Map<String, dynamic> toJson() => {
    'ownedGadgets': ownedGadgets,
    'equippedGadgets': equippedGadgets,
    'ownedItems': ownedItems,
  };

  factory InventoryState.fromJson(Map<String, dynamic> json) {
    return InventoryState(
      ownedGadgets:
          (json['ownedGadgets'] as List<dynamic>?)?.cast<String>() ?? [],
      equippedGadgets:
          (json['equippedGadgets'] as List<dynamic>?)?.cast<String>() ?? [],
      ownedItems:
          (json['ownedItems'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          {},
    );
  }

  InventoryState copyWith({
    List<String>? ownedGadgets,
    List<String>? equippedGadgets,
    Map<String, int>? ownedItems,
  }) {
    return InventoryState(
      ownedGadgets: ownedGadgets ?? this.ownedGadgets,
      equippedGadgets: equippedGadgets ?? this.equippedGadgets,
      ownedItems: ownedItems ?? this.ownedItems,
    );
  }

  @override
  List<Object?> get props => [ownedGadgets, equippedGadgets, ownedItems];
}
