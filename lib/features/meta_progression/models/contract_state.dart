import 'package:equatable/equatable.dart';

class ContractState extends Equatable {
  // Simple immutable map of which Contract IDs have been fully cashed in
  final List<String> completedContracts;

  const ContractState({this.completedContracts = const []});

  Map<String, dynamic> toJson() => {'completedContracts': completedContracts};

  factory ContractState.fromJson(Map<String, dynamic> json) {
    return ContractState(
      completedContracts:
          (json['completedContracts'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  ContractState copyWith({List<String>? completedContracts}) {
    return ContractState(
      completedContracts: completedContracts ?? this.completedContracts,
    );
  }

  @override
  List<Object?> get props => [completedContracts];
}
