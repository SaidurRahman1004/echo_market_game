import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../meta_progression/state/upgrade_provider.dart';
import '../../meta_progression/state/currency_provider.dart';
import '../data/upgrade_registry.dart';
import '../models/upgrade_config.dart';
import '../widgets/upgrade_card.dart';

class UpgradeScreen extends ConsumerStatefulWidget {
  const UpgradeScreen({super.key});

  @override
  ConsumerState<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends ConsumerState<UpgradeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyState = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: const Color(0xff111827),
      appBar: AppBar(
        title: const Text(
          'BIO-UPGRADE TERMINAL',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.amber),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${currencyState.echoCoins}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white54,
          indicatorColor: Colors.amberAccent,
          tabs: const [
            Tab(text: "SPEED", icon: Icon(Icons.bolt)),
            Tab(text: "COLLECTOR", icon: Icon(Icons.shopping_bag)),
            Tab(text: "SURVIVAL", icon: Icon(Icons.health_and_safety)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPathList(UpgradePath.speed),
          _buildPathList(UpgradePath.collector),
          _buildPathList(UpgradePath.survival),
        ],
      ),
    );
  }

  Widget _buildPathList(UpgradePath path) {
    final upgrades = UpgradeRegistry.getByPath(path);
    final upgradeNotifier = ref.watch(upgradeProvider.notifier);
    final upgradeState = ref.watch(upgradeProvider);
    final coins = ref.watch(currencyProvider).echoCoins;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: upgrades.length,
      itemBuilder: (context, index) {
        final config = upgrades[index];
        final level = upgradeState.levels[config.id] ?? 0;
        final nextCost = upgradeNotifier.getCostForNextLevel(config.id);
        final isMax = level >= config.maxLevel;
        final canAfford = coins >= nextCost && !isMax;

        return UpgradeCard(
          upgrade: config,
          currentLevel: level,
          nextCost: nextCost,
          isMaxLevel: isMax,
          canAfford: canAfford,
          onPurchase: () {
            final success = upgradeNotifier.purchaseUpgrade(config.id);
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Upgraded ${config.name} to Lvl ${level + 1}!'),
                  backgroundColor: Colors.green,
                  duration: const Duration(milliseconds: 500),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Insufficient Echo Coins or Max Level Reached.',
                  ),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(milliseconds: 500),
                ),
              );
            }
          },
        );
      },
    );
  }
}
