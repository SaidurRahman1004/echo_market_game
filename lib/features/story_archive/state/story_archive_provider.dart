import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/save_repository.dart';
import '../models/story_archive_state.dart';

class StoryArchiveNotifier extends Notifier<StoryArchiveState> {
  static const _saveKey = 'save_story_archive';

  @override
  StoryArchiveState build() {
    final data = ref.read(saveRepositoryProvider).load(_saveKey);
    return data != null
        ? StoryArchiveState.fromJson(data)
        : const StoryArchiveState();
  }

  void unlockLog(String logId) {
    if (state.unlockedLogs.contains(logId)) return;

    final newList = List<String>.from(state.unlockedLogs)..add(logId);
    final newState = state.copyWith(unlockedLogs: newList);

    state = newState;
    ref.read(saveRepositoryProvider).save(_saveKey, newState.toJson());
  }

  bool isUnlocked(String logId) {
    return state.unlockedLogs.contains(logId);
  }
}

final storyArchiveProvider =
    NotifierProvider<StoryArchiveNotifier, StoryArchiveState>(
      () => StoryArchiveNotifier(),
    );
