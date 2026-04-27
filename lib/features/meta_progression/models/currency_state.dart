import 'package:equatable/equatable.dart';

class CurrencyState extends Equatable {
  final int timeShards;
  final int echoCoins;
  final int memoryCrates;

  const CurrencyState({
    this.timeShards = 0,
    this.echoCoins = 0,
    this.memoryCrates = 0,
  });

  Map<String, dynamic> toJson() => {
    'timeShards': timeShards,
    'echoCoins': echoCoins,
    'memoryCrates': memoryCrates,
  };

  factory CurrencyState.fromJson(Map<String, dynamic> json) => CurrencyState(
    timeShards: json['timeShards'] as int? ?? 0,
    echoCoins: json['echoCoins'] as int? ?? 0,
    memoryCrates: json['memoryCrates'] as int? ?? 0,
  );

  CurrencyState copyWith({int? timeShards, int? echoCoins, int? memoryCrates}) {
    return CurrencyState(
      timeShards: timeShards ?? this.timeShards,
      echoCoins: echoCoins ?? this.echoCoins,
      memoryCrates: memoryCrates ?? this.memoryCrates,
    );
  }

  @override
  List<Object?> get props => [timeShards, echoCoins, memoryCrates];
}
