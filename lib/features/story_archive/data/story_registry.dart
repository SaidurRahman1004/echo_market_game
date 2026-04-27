import '../models/story_log.dart';

/// Centralized hardcoded definitions for story beats and lore logs.
/// Easy to expand as narrative writers add more content.
class StoryRegistry {
  static const List<StoryLog> _logs = [
    StoryLog(
      id: 'prelude_fall',
      title: 'The First Echo',
      content:
          'I don’t know when the sky broke, but I know what happened after. '
          'We started finding pieces of yesterday scattered in tomorrow’s ruins.',
      type: LogType.audioTranscript,
      unlockConditionHint: 'Complete your first run.',
    ),
    StoryLog(
      id: 'jax_blueprint',
      title: 'Jax\'s Master Plan',
      content:
          'If we can rewire the relay nodes across sector 4, we might just '
          'be able to spoof the security drones. Need to find more flux-capacitors.',
      type: LogType.datalog,
      unlockConditionHint: 'Repair the first city node with Jax.',
    ),
    StoryLog(
      id: 'unknown_signal',
      title: 'Signal 0xFF0A',
      content: '[ENCRYPTED DATA CORRUPTION] ...they are coming... [END]',
      type: LogType.cutscene,
      unlockConditionHint: 'Reach a distance of 10,000m in one run.',
    ),
  ];

  static List<StoryLog> get all => _logs;

  static StoryLog getById(String id) {
    return _logs.firstWhere(
      (log) => log.id == id,
      orElse: () => throw Exception('Story Log $id not found'),
    );
  }
}
