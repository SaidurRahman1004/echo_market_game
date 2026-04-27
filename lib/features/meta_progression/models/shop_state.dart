import 'package:equatable/equatable.dart';

class ShopState extends Equatable {
  // Keeps track of how many times a user bought a specific shop item ID.
  // Crucial for limited stock / single-unlock tracking.
  final Map<String, int> purchaseCounts;

  const ShopState({this.purchaseCounts = const {}});

  Map<String, dynamic> toJson() => {'purchaseCounts': purchaseCounts};

  factory ShopState.fromJson(Map<String, dynamic> json) {
    return ShopState(
      purchaseCounts:
          (json['purchaseCounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          {},
    );
  }

  ShopState copyWith({Map<String, int>? purchaseCounts}) {
    return ShopState(purchaseCounts: purchaseCounts ?? this.purchaseCounts);
  }

  @override
  List<Object?> get props => [purchaseCounts];
}
