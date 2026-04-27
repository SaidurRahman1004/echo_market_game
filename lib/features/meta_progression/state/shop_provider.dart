import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/save_repository.dart';
import '../../market/data/shop_registry.dart';
import '../../market/models/shop_item_config.dart';
import '../models/shop_state.dart';
import 'currency_provider.dart';
import 'inventory_provider.dart';

class ShopNotifier extends Notifier<ShopState> {
  static const _saveKey = 'save_market';

  @override
  ShopState build() {
    final data = ref.read(saveRepositoryProvider).load(_saveKey);
    return data != null ? ShopState.fromJson(data) : const ShopState();
  }

  /// Fetches how many times an item was bought globally.
  int getPurchaseCount(String shopId) {
    return state.purchaseCounts[shopId] ?? 0;
  }

  /// Determines if the stock is depleted according to registry limits.
  bool isSoldOut(String shopId) {
    final config = ShopRegistry.getById(shopId);
    if (config.maxPurchases == -1) return false; // Infinite uses allowed

    return getPurchaseCount(shopId) >= config.maxPurchases;
  }

  /// Single source of truth determining UI button color and transaction capability
  bool canAfford(String shopId) {
    if (isSoldOut(shopId)) return false;

    final config = ShopRegistry.getById(shopId);
    final currencyState = ref.read(currencyProvider);

    if (config.currency == MarketCurrency.echoCoins) {
      return currencyState.echoCoins >= config.cost;
    } else {
      return currencyState.timeShards >= config.cost;
    }
  }

  /// Triggered by UI Button. Orchestrates cross-provider transaction.
  bool purchaseItem(String shopId) {
    // 1. Initial State Protection
    if (!canAfford(shopId)) return false;

    final config = ShopRegistry.getById(shopId);
    final currencyNotifier = ref.read(currencyProvider.notifier);

    bool spentSuccessfully = false;

    // 2. Perform Transaction logic
    if (config.currency == MarketCurrency.echoCoins) {
      spentSuccessfully = currencyNotifier.trySpendCoins(config.cost);
    } else {
      spentSuccessfully = currencyNotifier.trySpendShards(config.cost);
    }

    // 3. Dispatch Product safely
    if (spentSuccessfully) {
      ref
          .read(inventoryProvider.notifier)
          .addItem(config.targetItemId, config.bundleQuantity);

      // 4. Record the specific shop purchase for stock limits
      final currentCount = getPurchaseCount(shopId);
      final newCounts = Map<String, int>.from(state.purchaseCounts);
      newCounts[shopId] = currentCount + 1;

      state = state.copyWith(purchaseCounts: newCounts);
      ref.read(saveRepositoryProvider).save(_saveKey, state.toJson());

      return true;
    }

    return false; // Edgecase fallback (e.g. state mutated rapidly during tap)
  }
}

// Injects the centralized Market service safely to all screens
final shopProvider = NotifierProvider<ShopNotifier, ShopState>(
  () => ShopNotifier(),
);
