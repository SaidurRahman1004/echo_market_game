import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../meta_progression/state/shop_provider.dart';
import '../../meta_progression/state/currency_provider.dart';
import '../data/shop_registry.dart';
import '../models/shop_item_config.dart';
import '../widgets/shop_item_card.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen>
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
          'BLACK MARKET',
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
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.diamond_outlined,
                    color: Colors.lightBlueAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${currencyState.timeShards}',
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
            Tab(text: "GEAR & TECH", icon: Icon(Icons.memory)),
            Tab(text: "SUPPLIES", icon: Icon(Icons.inventory_2)),
            Tab(text: "COSMETICS", icon: Icon(Icons.color_lens)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPathList(MarketSection.gear),
          _buildPathList(MarketSection.supplies),
          _buildPathList(MarketSection.cosmetics),
        ],
      ),
    );
  }

  Widget _buildPathList(MarketSection section) {
    final items = ShopRegistry.getBySection(section);
    final shopNotifier = ref.watch(shopProvider.notifier);
    final shopState = ref.watch(shopProvider);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final config = items[index];
        final currentPurchases = shopState.purchaseCounts[config.id] ?? 0;
        final isSoldOut =
            config.maxPurchases != -1 &&
            currentPurchases >= config.maxPurchases;

        // Ensure UI doesn't allow clicks without checking the provider
        final canAffordUI = !isSoldOut && shopNotifier.canAfford(config.id);

        return ShopItemCard(
          item: config,
          canAfford: canAffordUI,
          isSoldOut: isSoldOut,
          currentPurchases: currentPurchases,
          onPurchase: () {
            final success = shopNotifier.purchaseItem(config.id);
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Purchased ${config.displayName}!'),
                  backgroundColor: Colors.green,
                  duration: const Duration(milliseconds: 500),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Transaction Failed. Insufficient Currency or Out of Stock.',
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
