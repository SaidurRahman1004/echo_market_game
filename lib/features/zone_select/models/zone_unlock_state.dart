import 'package:equatable/equatable.dart';

class ZoneUnlockState extends Equatable {
  final List<String> unlockedZones;
  final String currentRoute;

  const ZoneUnlockState({
    this.unlockedZones = const ['starter_street'], // Default starting zone
    this.currentRoute = 'starter_street',
  });

  Map<String, dynamic> toJson() => {
    'unlockedZones': unlockedZones,
    'currentRoute': currentRoute,
  };

  factory ZoneUnlockState.fromJson(Map<String, dynamic> json) =>
      ZoneUnlockState(
        unlockedZones:
            (json['unlockedZones'] as List<dynamic>?)?.cast<String>() ??
            ['starter_street'],
        currentRoute: json['currentRoute'] as String? ?? 'starter_street',
      );

  ZoneUnlockState copyWith({
    List<String>? unlockedZones,
    String? currentRoute,
  }) {
    return ZoneUnlockState(
      unlockedZones: unlockedZones ?? this.unlockedZones,
      currentRoute: currentRoute ?? this.currentRoute,
    );
  }

  @override
  List<Object?> get props => [unlockedZones, currentRoute];
}
