import '../models/seasonal_event.dart';

class EventRegistry {
  // We can eventually replace this with a backend fetch,
  // but keeping it hardcoded protects the app from being overbuilt.
  static final List<SeasonalEvent> _events = [
    SeasonalEvent(
      id: 'event_cyberspring_01',
      title: 'Cyberspring Festival',
      summary: 'Find double time-shards in starter street zones! Speak to Jax.',
      // In a real app we'd load an Image.asset, but we'll use a network placeholder or native icon
      bannerAssetPath: 'https://picsum.photos/400/200?blur=2',
      startDate: DateTime.now().subtract(const Duration(days: 1)), // active now
      endDate: DateTime.now().add(const Duration(days: 7)),
      actionRoute: '/contracts',
    ),
    SeasonalEvent(
      id: 'event_halloween_01',
      title: 'Neon Nightmares',
      summary: 'Evade spooky corrupted drones on sector 4.',
      bannerAssetPath: 'https://picsum.photos/400/200',
      startDate: DateTime(2027, 10, 20),
      endDate: DateTime(2027, 11, 2),
      actionRoute: '/upgrades',
    ),
  ];

  /// Returns all currently active events checking their date/time boundary
  static List<SeasonalEvent> getActiveEvents() {
    return _events.where((e) => e.isActive).toList();
  }
}
