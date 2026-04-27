import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/story_registry.dart';
import '../state/story_archive_provider.dart';
import '../models/story_log.dart';

class StoryArchiveScreen extends ConsumerWidget {
  const StoryArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archiveState = ref.watch(storyArchiveProvider);
    final logs = StoryRegistry.all;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Archives', style: TextStyle(letterSpacing: 2)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 24, color: Colors.white24),
        itemBuilder: (context, index) {
          final log = logs[index];
          final isUnlocked = archiveState.unlockedLogs.contains(log.id);

          if (!isUnlocked) {
            return ListTile(
              leading: const Icon(Icons.lock, color: Colors.grey, size: 36),
              title: Text('???', style: TextStyle(color: Colors.grey.shade600)),
              subtitle: Text(
                'Unlock Condition: ${log.unlockConditionHint}',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }

          return Card(
            elevation: 4,
            color: const Color(0xFF2B2E3A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        log.type == LogType.audioTranscript
                            ? Icons.mic
                            : log.type == LogType.cutscene
                            ? Icons.movie
                            : Icons.library_books,
                        color: Colors.lightBlueAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          log.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    log.content,
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.4, // nice readable line height
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
