import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/event_registry.dart';
import '../models/seasonal_event.dart';

/// Provides the active events asynchronously if we decide to fetch from a backend later.
/// Right now, it safely maps the static temporal logic to a Notifier.
class ActiveEventsNotifier extends Notifier<List<SeasonalEvent>> {
  @override
  List<SeasonalEvent> build() {
    return EventRegistry.getActiveEvents();
  }

  // Future backend fetch logic hook could live here:
  // Future<void> refreshEventsFromServer() async { ... }
}

final activeEventsProvider =
    NotifierProvider<ActiveEventsNotifier, List<SeasonalEvent>>(
      () => ActiveEventsNotifier(),
    );
