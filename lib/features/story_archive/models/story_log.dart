import 'package:equatable/equatable.dart';

enum LogType { datalog, cutscene, audioTranscript }

/// Represents a piece of narrative lore or story beat the player can unlock.
/// Future-proofed for cutscenes, text logs, or audio transcripts.
class StoryLog extends Equatable {
  final String id;
  final String title;
  final String content;
  final LogType type;
  final String unlockConditionHint; // Displayed when locked

  const StoryLog({
    required this.id,
    required this.title,
    required this.content,
    this.type = LogType.datalog,
    required this.unlockConditionHint,
  });

  @override
  List<Object?> get props => [id, title, content, type, unlockConditionHint];
}
