import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/save_repository.dart';
import '../../inventory/models/item_config.dart';
import '../../inventory/data/item_registry.dart';
import '../models/inventory_state.dart';

class InventoryNotifier extends Notifier<InventoryState> {
  static const _saveKey = 'save_inventory';

  @override
  InventoryState build() {
    final data = ref.read(saveRepositoryProvider).load(_saveKey);
    return data != null
        ? InventoryState.fromJson(data)
        : const InventoryState();
  }

  void _save() {
    ref.read(saveRepositoryProvider).save(_saveKey, state.toJson());
  }

  /// Master function for adding generic items to the inventory map.
  void addItem(String itemId, int quantity) {
    if (quantity <= 0) return;

    final newItems = Map<String, int>.from(state.ownedItems);
    newItems[itemId] = (newItems[itemId] ?? 0) + quantity;

    // Check if it's a gadget and update legacy lists for backward compatibility
    List<String> newGadgets = List.from(state.ownedGadgets);
    try {
      final config = ItemRegistry.getById(itemId);
      if (config.category == ItemCategory.gadget &&
          !newGadgets.contains(itemId)) {
        newGadgets.add(itemId);
      }
    } catch (_) {
      // Configuration might not exist yet, proceed safely.
    }

    state = state.copyWith(ownedItems: newItems, ownedGadgets: newGadgets);
    _save();
  }

  /// Master function for spending or removing generic items.
  bool removeOrConsumeItem(String itemId, int quantity) {
    if (quantity <= 0) return true;

    final currentAmount = state.ownedItems[itemId] ?? 0;
    if (currentAmount < quantity) return false;

    final newItems = Map<String, int>.from(state.ownedItems);
    newItems[itemId] = currentAmount - quantity;
    if (newItems[itemId]! <= 0) {
      newItems.remove(itemId);
    }

    state = state.copyWith(ownedItems: newItems);
    _save();
    return true;
  }

  /// Checks if inventory holds at least [quantity] of [itemId]
  bool hasItem(String itemId, {int quantity = 1}) {
    return (state.ownedItems[itemId] ?? 0) >= quantity;
  }

  void equipGadget(String gadgetId) {
    // Look closely at both generic list and legacy list to be safe
    final hasGadget =
        state.ownedGadgets.contains(gadgetId) || hasItem(gadgetId);
    if (!hasGadget) return;

    final newEquipped = List<String>.from(state.equippedGadgets);
    if (!newEquipped.contains(gadgetId)) {
      if (newEquipped.length >= 2) newEquipped.removeAt(0);
      newEquipped.add(gadgetId);

      state = state.copyWith(equippedGadgets: newEquipped);
      _save();
    }
  }
}

final inventoryProvider = NotifierProvider<InventoryNotifier, InventoryState>(
  () => InventoryNotifier(),
);
