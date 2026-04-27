import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/gadget_registry.dart';
import '../loadout_provider.dart';
import '../widgets/gadget_card.dart';

class LoadoutScreen extends ConsumerWidget {
  const LoadoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadout = ref.watch(loadoutProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A24),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'RUNNER LOADOUT',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Equipped Slots Section
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.black26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'EQUIPPED MODULES',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${loadout.equippedGadgetIds.length}/${LoadoutNotifier.maxSlots}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: List.generate(LoadoutNotifier.maxSlots, (index) {
                    final isFilled = index < loadout.equippedGadgetIds.length;
                    final gadget = isFilled
                        ? GadgetRegistry.getById(
                            loadout.equippedGadgetIds[index],
                          )
                        : null;

                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          right: index == 0 ? 12 : 0,
                          left: index == 1 ? 12 : 0,
                        ),
                        height: 80,
                        decoration: BoxDecoration(
                          color: isFilled
                              ? gadget!.rarityColor.withValues(alpha: 0.1)
                              : Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isFilled
                                ? gadget!.rarityColor
                                : Colors.white24,
                            width: isFilled ? 2 : 1,
                            style: isFilled
                                ? BorderStyle.solid
                                : BorderStyle.solid,
                          ),
                        ),
                        child: isFilled
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(gadget!.icon, color: gadget.rarityColor),
                                  const SizedBox(height: 4),
                                  Text(
                                    gadget.name,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            : const Center(
                                child: Icon(Icons.add, color: Colors.white24),
                              ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          // Inventory Header
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Text(
              'AVAILABLE HARDWARE',
              style: TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Scrollable Inventory
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: GadgetRegistry.allGadgets.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final gadget = GadgetRegistry.allGadgets[index];
                final isUnlocked = loadout.unlockedGadgetIds.contains(
                  gadget.id,
                );
                final isEquipped = loadout.equippedGadgetIds.contains(
                  gadget.id,
                );

                return GadgetCard(
                  config: gadget,
                  isUnlocked: isUnlocked,
                  isEquipped: isEquipped,
                  onTap: () {
                    ref.read(loadoutProvider.notifier).toggleEquip(gadget.id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
