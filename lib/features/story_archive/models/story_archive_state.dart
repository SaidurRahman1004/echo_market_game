import 'package:equatable/equatable.dart';

class StoryArchiveState extends Equatable {
  final List<String> unlockedLogs;

  const StoryArchiveState({this.unlockedLogs = const []});

  Map<String, dynamic> toJson() => {'unlockedLogs': unlockedLogs};

  factory StoryArchiveState.fromJson(Map<String, dynamic> json) =>
      StoryArchiveState(
        unlockedLogs:
            (json['unlockedLogs'] as List<dynamic>?)?.cast<String>() ?? [],
      );

  StoryArchiveState copyWith({List<String>? unlockedLogs}) {
    return StoryArchiveState(unlockedLogs: unlockedLogs ?? this.unlockedLogs);
  }

  @override
  List<Object?> get props => [unlockedLogs];
}
