import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../meta_progression/state/inventory_provider.dart';
import '../../meta_progression/state/currency_provider.dart';
import '../data/item_registry.dart';
import '../models/item_config.dart';
import '../widgets/inventory_item_card.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // E.g. Resources, Gear, Specials
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111827),
      appBar: AppBar(
        title: const Text(
          'VAULT & CARGO',
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white54,
          indicatorColor: Colors.amberAccent,
          tabs: const [
            Tab(text: "RESOURCES", icon: Icon(Icons.my_library_books)),
            Tab(text: "GEAR & RELICS", icon: Icon(Icons.handyman)),
            Tab(text: "SPECIALS", icon: Icon(Icons.star)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildResourcesTab(context, ref),
          _buildGearTab(context, ref),
          _buildSpecialsTab(context, ref),
        ],
      ),
    );
  }

  /// Groups Currencies and Materials
  Widget _buildResourcesTab(BuildContext context, WidgetRef ref) {
    final currencyState = ref.watch(currencyProvider);
    final invState = ref.watch(inventoryProvider);

    final List<MapEntry<ItemConfig, int>> resources = [];

    // Inject currencies dynamically mapped to registry info
    try {
      final coinsConfig = ItemRegistry.getById('echo_coins');
      resources.add(MapEntry(coinsConfig, currencyState.echoCoins));
    } catch (_) {}

    try {
      final shardsConfig = ItemRegistry.getById('time_shards');
      resources.add(MapEntry(shardsConfig, currencyState.timeShards));
    } catch (_) {}

    // Pull non-currency materials directly from inventory
    final materials = ItemRegistry.getByCategory(ItemCategory.material);
    for (var m in materials) {
      final count = invState.ownedItems[m.id] ?? 0;
      if (count > 0) {
        resources.add(MapEntry(m, count));
      }
    }

    return _buildStaggeredGrid(resources, "No resources stored in cargo.");
  }

  /// Groups Gadgets & Relics
  Widget _buildGearTab(BuildContext context, WidgetRef ref) {
    final invState = ref.watch(inventoryProvider);
    final List<MapEntry<ItemConfig, int>> gear = [];

    // Pull Relics
    final relics = ItemRegistry.getByCategory(ItemCategory.relic);
    for (var r in relics) {
      if ((invState.ownedItems[r.id] ?? 0) > 0) {
        gear.add(MapEntry(r, invState.ownedItems[r.id]!));
      }
    }

    // Pull Gadgets (from both modern ownedItems or legacy ownedGadgets)
    final gadgets = ItemRegistry.getByCategory(ItemCategory.gadget);
    for (var g in gadgets) {
      int count = invState.ownedItems[g.id] ?? 0;
      if (invState.ownedGadgets.contains(g.id) && count == 0) {
        // Fallback for legacy owned gadgets array showing at least 1
        count = 1;
      }
      if (count > 0) {
        gear.add(MapEntry(g, count));
      }
    }

    return _buildStaggeredGrid(gear, "Cargo hold empty. Go find some tech!");
  }

  /// Groups Event items, Cosmetics, Mission Triggers
  Widget _buildSpecialsTab(BuildContext context, WidgetRef ref) {
    final invState = ref.watch(inventoryProvider);
    final List<MapEntry<ItemConfig, int>> specials = [];

    final categories = [ItemCategory.special, ItemCategory.cosmetic];
    for (var c in categories) {
      final itemsConfig = ItemRegistry.getByCategory(c);
      for (var item in itemsConfig) {
        if ((invState.ownedItems[item.id] ?? 0) > 0) {
          specials.add(MapEntry(item, invState.ownedItems[item.id]!));
        }
      }
    }

    return _buildStaggeredGrid(
      specials,
      "No special items or cosmetics in cargo.",
    );
  }

  Widget _buildStaggeredGrid(
    List<MapEntry<ItemConfig, int>> items,
    String emptyMessage,
  ) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final data = items[index];
        return InventoryItemCard(
          item: data.key,
          count: data.value,
          onTap: () {
            // Future: Show detailed modal pop-out regarding item usage logic
          },
        );
      },
    );
  }
}
