import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/hub_action_button.dart';
import '../widgets/resource_header.dart';
import '../../missions/mission_progress_provider.dart';
import '../../zone_select/zone_unlock_provider.dart';
import '../../zone_select/data/zone_registry.dart';
import '../../zone_select/screens/zone_select_screen.dart';
import '../../loadout/screens/loadout_screen.dart';
import '../../missions/screens/mission_screen.dart';
import '../../upgrades/screens/upgrade_screen.dart';
import '../../market/screens/market_screen.dart';
import '../../city_repair/screens/city_repair_screen.dart';
import '../../npc_contracts/ui/contracts_screen.dart';
import '../../meta_progression/ui/profile_screen.dart';
import '../../settings/ui/settings_screen.dart';
import '../../story_archive/ui/story_archive_screen.dart';
import '../../events/state/active_events_provider.dart';
import '../../gameplay_shell/gameplay_shell_screen.dart';

class HubScreen extends ConsumerWidget {
  const HubScreen({super.key});

  void _showPlaceholder(BuildContext context, String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Navigating to  Module...')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missions = ref.watch(missionProgressProvider);
    final zoneState = ref.watch(zoneUnlockProvider);
    final activeMissionCount = missions.activeMissions.length;
    final currentZone = ZoneRegistry.getById(zoneState.currentRoute);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A24), // Dark stylized background
      body: Stack(
        children: [
          // Background Placeholder (Stylized Cityscape)
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.network(
                'https://picsum.photos/800/1200?blur=2', // Safe placeholder background
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const ColoredBox(color: Colors.blueGrey),
              ),
            ),
          ),

          // Main UI Layer
          Column(
            children: [
              // Top Resource Header
              const ResourceHeader(),

              const Spacer(), // Pushes central elements to the middle
              // Central Dashboard Focus (Ready to Run)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ZoneSelectScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.map,
                              color: currentZone.themeColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              currentZone.name.toUpperCase(),
                              style: TextStyle(
                                color: currentZone.themeColor,
                                letterSpacing: 2,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white54,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Core Start Run Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentZone.themeColor,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 20,
                        ),
                        elevation: 10,
                        shadowColor: currentZone.themeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const GameplayShellScreen(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                            transitionDuration: const Duration(
                              milliseconds: 600,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'START RUN',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Seasonal / Limited Time Active Event Banners Pipeline
              Builder(
                builder: (ctx) {
                  final activeEvents = ref.watch(activeEventsProvider);
                  if (activeEvents.isEmpty) return const SizedBox.shrink();

                  // Just take the most prominent event (the first one) to avoid clutter
                  final prominentEvent = activeEvents.first;

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.pinkAccent, width: 2),
                      color: Colors.pink.shade900.withValues(alpha: 0.8),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.celebration,
                        color: Colors.pinkAccent,
                        size: 32,
                      ),
                      title: Text(
                        prominentEvent.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        prominentEvent.summary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                      onTap: () => _showPlaceholder(
                        context,
                        'Event Details: ${prominentEvent.title}',
                      ),
                    ),
                  );
                },
              ),

              // Bottom Actions Grid
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient:
                      linearFromTopToBottomGradient(), // Handled differently via BoxDecoration
                ),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    HubActionButton(
                      icon: Icons.person,
                      label: 'LOADOUT',
                      color: Colors.blueAccent,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LoadoutScreen(),
                          ),
                        );
                      },
                    ),
                    HubActionButton(
                      icon: Icons.upgrade,
                      label: 'UPGRADES',
                      color: Colors.greenAccent,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const UpgradeScreen(),
                          ),
                        );
                      },
                    ),
                    HubActionButton(
                      icon: Icons.shopping_cart,
                      label: 'MARKET',
                      color: Colors.amberAccent,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const MarketScreen(),
                          ),
                        );
                      },
                    ),
                    HubActionButton(
                      icon: Icons.assignment,
                      label: 'MISSIONS',
                      color: Colors.purpleAccent,
                      badgeCount: activeMissionCount > 0
                          ? activeMissionCount.toString()
                          : null,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const MissionScreen(),
                          ),
                        );
                      },
                    ),
                    HubActionButton(
                      icon: Icons.handshake,
                      label: 'CONTRACTS',
                      color: Colors.orangeAccent,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ContractsScreen(),
                          ),
                        );
                      },
                    ),
                    HubActionButton(
                      icon: Icons.map,
                      label: 'CITY REPAIR',
                      color: Colors.deepOrangeAccent,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CityRepairScreen(),
                          ),
                        );
                      },
                    ),
                    HubActionButton(
                      icon: Icons.insert_chart,
                      label: 'PROFILE',
                      color: Colors.tealAccent,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },
                    ),
                    HubActionButton(
                      icon: Icons.book,
                      label: 'ARCHIVE',
                      color: Colors.blueGrey,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const StoryArchiveScreen(),
                          ),
                        );
                      },
                    ),
                    HubActionButton(
                      icon: Icons.settings,
                      label: 'SETTINGS',
                      color: Colors.grey,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}

LinearGradient linearFromTopToBottomGradient() {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Colors.black.withValues(alpha: 0.6),
      Colors.black.withValues(alpha: 0.9),
    ],
  );
}
