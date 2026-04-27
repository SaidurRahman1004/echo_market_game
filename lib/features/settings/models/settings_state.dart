import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool isMusicEnabled;
  final bool isSfxEnabled;
  final bool isHapticsEnabled;
  final bool isHighPerformanceMode;
  final bool reduceMotion;

  const SettingsState({
    this.isMusicEnabled = true,
    this.isSfxEnabled = true,
    this.isHapticsEnabled = true,
    this.isHighPerformanceMode = false,
    this.reduceMotion = false,
  });

  Map<String, dynamic> toJson() => {
    'isMusicEnabled': isMusicEnabled,
    'isSfxEnabled': isSfxEnabled,
    'isHapticsEnabled': isHapticsEnabled,
    'isHighPerformanceMode': isHighPerformanceMode,
    'reduceMotion': reduceMotion,
  };

  factory SettingsState.fromJson(Map<String, dynamic> json) => SettingsState(
    isMusicEnabled: json['isMusicEnabled'] as bool? ?? true,
    isSfxEnabled: json['isSfxEnabled'] as bool? ?? true,
    isHapticsEnabled: json['isHapticsEnabled'] as bool? ?? true,
    isHighPerformanceMode: json['isHighPerformanceMode'] as bool? ?? false,
    reduceMotion: json['reduceMotion'] as bool? ?? false,
  );

  SettingsState copyWith({
    bool? isMusicEnabled,
    bool? isSfxEnabled,
    bool? isHapticsEnabled,
    bool? isHighPerformanceMode,
    bool? reduceMotion,
  }) {
    return SettingsState(
      isMusicEnabled: isMusicEnabled ?? this.isMusicEnabled,
      isSfxEnabled: isSfxEnabled ?? this.isSfxEnabled,
      isHapticsEnabled: isHapticsEnabled ?? this.isHapticsEnabled,
      isHighPerformanceMode:
          isHighPerformanceMode ?? this.isHighPerformanceMode,
      reduceMotion: reduceMotion ?? this.reduceMotion,
    );
  }

  @override
  List<Object?> get props => [
    isMusicEnabled,
    isSfxEnabled,
    isHapticsEnabled,
    isHighPerformanceMode,
    reduceMotion,
  ];
}
