import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        children: [
          const _SectionHeader(title: 'AUDIO'),
          SwitchListTile(
            title: const Text('Music'),
            subtitle: const Text('Enable background music'),
            value: state.isMusicEnabled,
            onChanged: (val) => notifier.toggleMusic(),
            secondary: const Icon(Icons.music_note),
          ),
          SwitchListTile(
            title: const Text('Sound Effects'),
            subtitle: const Text('Enable UI and gameplay sounds'),
            value: state.isSfxEnabled,
            onChanged: (val) => notifier.toggleSfx(),
            secondary: const Icon(Icons.volume_up),
          ),
          const Divider(height: 32),

          const _SectionHeader(title: 'PREFERENCES'),
          SwitchListTile(
            title: const Text('Vibration / Haptics'),
            subtitle: const Text('Enable physical feedback'),
            value: state.isHapticsEnabled,
            onChanged: (val) => notifier.toggleHaptics(),
            secondary: const Icon(Icons.vibration),
          ),
          const Divider(height: 32),

          const _SectionHeader(title: 'GRAPHICS & ACCESSIBILITY'),
          SwitchListTile(
            title: const Text('High Performance Mode'),
            subtitle: const Text('Lowers visuals to boost frame rates'),
            value: state.isHighPerformanceMode,
            onChanged: (val) => notifier.toggleHighPerformance(),
            secondary: const Icon(Icons.speed),
          ),
          SwitchListTile(
            title: const Text('Reduce Motion'),
            subtitle: const Text('Disables screen shake and rapid flashes'),
            value: state.reduceMotion,
            onChanged: (val) => notifier.toggleReduceMotion(),
            secondary: const Icon(Icons.accessibility_new),
          ),
          const Divider(height: 32),

          const _SectionHeader(title: 'DATA'),
          ListTile(
            title: const Text(
              'Reset All Progress',
              style: TextStyle(color: Colors.redAccent),
            ),
            subtitle: const Text(
              'Permanently deletes your save file. This cannot be undone.',
              style: TextStyle(color: Colors.redAccent),
            ),
            leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
            onTap: () {
              _showResetConfirmation(context, notifier);
            },
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, dynamic notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Reset'),
        content: const Text(
          'Are you sure you want to completely erase all progress?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            onPressed: () {
              notifier.resetProgress();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Save data cleared. Restart app fully to apply.',
                  ),
                ),
              );
            },
            child: const Text('RESET'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Colors.grey.shade400,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
