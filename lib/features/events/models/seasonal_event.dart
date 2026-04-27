import 'package:equatable/equatable.dart';

/// Models a limited-time or seasonal event in the game.
/// Used to dynamically inject new content, rewards, or visual banners.
class SeasonalEvent extends Equatable {
  final String id;
  final String title;
  final String summary;

  /// The image or icon representing the event
  final String bannerAssetPath;

  /// If null, the event is permanently active unless feature flipped.
  final DateTime? startDate;
  final DateTime? endDate;

  /// External link or internal deep-link route (e.g., 'route:/npc_contracts/jax')
  final String? actionRoute;

  const SeasonalEvent({
    required this.id,
    required this.title,
    required this.summary,
    required this.bannerAssetPath,
    this.startDate,
    this.endDate,
    this.actionRoute,
  });

  bool get isActive {
    final now = DateTime.now();
    if (startDate != null && now.isBefore(startDate!)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;
    return true; // Unbounded or currently within window
  }

  @override
  List<Object?> get props => [
    id,
    title,
    summary,
    bannerAssetPath,
    startDate,
    endDate,
    actionRoute,
  ];
}
