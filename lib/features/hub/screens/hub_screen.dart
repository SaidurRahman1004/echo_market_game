import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../city_repair/screens/city_repair_screen.dart';
import '../../events/state/active_events_provider.dart';
import '../../gameplay_shell/gameplay_shell_screen.dart';
import '../../loadout/screens/loadout_screen.dart';
import '../../market/screens/market_screen.dart';
import '../../meta_progression/ui/profile_screen.dart';
import '../../missions/mission_progress_provider.dart';
import '../../missions/screens/mission_screen.dart';
import '../../npc_contracts/ui/contracts_screen.dart';
import '../../settings/ui/settings_screen.dart';
import '../../story_archive/ui/story_archive_screen.dart';
import '../../upgrades/screens/upgrade_screen.dart';
import '../../zone_select/data/zone_registry.dart';
import '../../zone_select/screens/zone_select_screen.dart';
import '../../zone_select/zone_unlock_provider.dart';
import '../widgets/hub_action_button.dart';
import '../widgets/resource_header.dart';

class HubScreen extends ConsumerWidget {
  const HubScreen({super.key});

  void _showPlaceholder(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Navigating to  Module...')));
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
          // Background (Stylized Gradient Cityscape Base)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A1A24), Color(0xFF2C2C3E), Color(0xFF1A1A24)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Main UI Layer
          SafeArea(
            child: Column(
              children: [
                // Top Resource Header
                const ResourceHeader(),

                const Spacer(), // Pushes central elements to the middle
                // Central Dashboard Focus (Ready to Run)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Objective Panel
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: currentZone.themeColor.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'CURRENT OBJECTIVE',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Survive and gather Time Shards',
                              style: TextStyle(
                                color: currentZone.themeColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.of(
                            context,
                          ).push(MaterialPageRoute(builder: (_) => const ZoneSelectScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.map, color: currentZone.themeColor, size: 20),
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
                              const Icon(Icons.arrow_drop_down, color: Colors.white54),
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
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                          elevation: 10,
                          shadowColor: currentZone.themeColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  const GameplayShellScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                              transitionDuration: const Duration(milliseconds: 600),
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
                      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.pinkAccent, width: 2),
                        color: Colors.pink.shade900.withValues(alpha: 0.8),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.celebration, color: Colors.pinkAccent, size: 32),
                        title: Text(
                          prominentEvent.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        subtitle: Text(
                          prominentEvent.summary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Colors.white),
                        onTap: () =>
                            _showPlaceholder(context, 'Event Details: ${prominentEvent.title}'),
                      ),
                    );
                  },
                ),

                // Bottom Actions Grid (Reorganized for responsive scaling)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: BoxDecoration(gradient: linearFromTopToBottomGradient()),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildHubTile(
                        context,
                        icon: Icons.person,
                        label: 'LOADOUT',
                        color: Colors.blueAccent,
                        onTap: () => Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (_) => const LoadoutScreen())),
                      ),
                      _buildHubTile(
                        context,
                        icon: Icons.upgrade,
                        label: 'UPGRADES',
                        color: Colors.greenAccent,
                        onTap: () => Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (_) => const UpgradeScreen())),
                      ),
                      _buildHubTile(
                        context,
                        icon: Icons.shopping_cart,
                        label: 'MARKET',
                        color: Colors.amberAccent,
                        onTap: () => Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (_) => const MarketScreen())),
                      ),
                      _buildHubTile(
                        context,
                        icon: Icons.assignment,
                        label: 'MISSIONS',
                        color: Colors.purpleAccent,
                        badgeCount: activeMissionCount > 0 ? activeMissionCount.toString() : null,
                        onTap: () => Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (_) => const MissionScreen())),
                      ),
                      _buildHubTile(
                        context,
                        icon: Icons.handshake,
                        label: 'CONTRACTS',
                        color: Colors.orangeAccent,
                        onTap: () => Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (_) => const ContractsScreen())),
                      ),
                      _buildHubTile(
                        context,
                        icon: Icons.map,
                        label: 'CITY REPAIR',
                        color: Colors.deepOrangeAccent,
                        onTap: () => Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (_) => const CityRepairScreen())),
                      ),
                      _buildHubTile(
                        context,
                        icon: Icons.insert_chart,
                        label: 'PROFILE',
                        color: Colors.tealAccent,
                        onTap: () => Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
                      ),
                      _buildHubTile(
                        context,
                        icon: Icons.book,
                        label: 'ARCHIVE',
                        color: Colors.blueGrey,
                        onTap: () => Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (_) => const StoryArchiveScreen())),
                      ),
                      _buildHubTile(
                        context,
                        icon: Icons.settings,
                        label: 'SETTINGS',
                        color: Colors.grey,
                        onTap: () => Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ), // End SafeArea
        ],
      ),
    );
  }

  Widget _buildHubTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    String? badgeCount,
  }) {
    // Allows robust fitting across typical mobile widths
    final double screenWidth = MediaQuery.of(context).size.width;
    final double maxTileWidth = (screenWidth - 32 - 24) / 3;
    final double tileWidth = maxTileWidth < 85 ? 85 : maxTileWidth;

    return SizedBox(
      width: tileWidth,
      child: HubActionButton(
        icon: icon,
        label: label,
        color: color,
        onTap: onTap,
        badgeCount: badgeCount,
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
