import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../meta_progression/state/city_provider.dart';
import '../data/city_registry.dart';
import '../models/city_node_config.dart';
import '../widgets/city_node_card.dart';

class CityRepairScreen extends ConsumerStatefulWidget {
  const CityRepairScreen({super.key});

  @override
  ConsumerState<CityRepairScreen> createState() => _CityRepairScreenState();
}

class _CityRepairScreenState extends ConsumerState<CityRepairScreen> {
  bool _showMapMode = false;

  void _toggleView() => setState(() => _showMapMode = !_showMapMode);

  @override
  Widget build(BuildContext context) {
    final cityNotifier = ref.watch(cityProvider.notifier);
    final allNodes = CityRegistry.all;

    return Scaffold(
      backgroundColor: const Color(0xff090c14),
      appBar: AppBar(
        title: const Text(
          'CITY REPAIR & RECLAMATION',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.amber),
        actions: [
          IconButton(
            icon: Icon(_showMapMode ? Icons.list : Icons.map),
            onPressed: _toggleView,
            tooltip: 'Toggle View',
          ),
        ],
      ),
      body: _showMapMode
          ? _buildMapLayer(allNodes, cityNotifier)
          : _buildListLayer(allNodes, cityNotifier),
    );
  }

  Widget _buildListLayer(
    List<CityNodeConfig> nodes,
    CityNotifier cityNotifier,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        final node = nodes[index];
        final isRepaired = cityNotifier.isNodeRepaired(node.id);

        // Locked if prerequisites are not met
        bool isLocked = false;
        for (var p in node.prerequisites) {
          if (!cityNotifier.isNodeRepaired(p)) isLocked = true;
        }

        final canAfford = cityNotifier.canRepair(node.id);

        return Center(
          child: CityNodeCard(
            node: node,
            isRepaired: isRepaired,
            isLocked: isLocked,
            canAfford: canAfford,
            onRepair: () => _handleRepairTap(node, cityNotifier),
          ),
        );
      },
    );
  }

  Widget _buildMapLayer(List<CityNodeConfig> nodes, CityNotifier cityNotifier) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          children: [
            // Safe Background
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Image.network(
                  'https://picsum.photos/1000/1000?grayscale',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const ColoredBox(color: Colors.blueGrey),
                ),
              ),
            ),

            // Map Nodes Scattered
            ...nodes.map((node) {
              final x = node.mapX * w;
              final y = node.mapY * h;
              final isRepaired = cityNotifier.isNodeRepaired(node.id);

              bool isLocked = false;
              for (var p in node.prerequisites) {
                if (!cityNotifier.isNodeRepaired(p)) isLocked = true;
              }

              return Positioned(
                left: x - 24, // Shift center
                top: y - 24,
                child: GestureDetector(
                  onTap: () {
                    _showNodeDetailsDialog(
                      context,
                      node,
                      cityNotifier,
                      isRepaired,
                      isLocked,
                    );
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isRepaired
                          ? Colors.greenAccent
                          : (isLocked
                                ? Colors.redAccent.withValues(alpha: 0.5)
                                : Colors.amberAccent),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: isRepaired
                              ? Colors.greenAccent.withValues(alpha: 0.4)
                              : Colors.transparent,
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Icon(
                      isRepaired
                          ? Icons.check
                          : (isLocked ? Icons.lock : Icons.build),
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  void _showNodeDetailsDialog(
    BuildContext context,
    CityNodeConfig node,
    CityNotifier cityNotifier,
    bool isRepaired,
    bool isLocked,
  ) {
    final canAfford = cityNotifier.canRepair(node.id);

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: CityNodeCard(
            node: node,
            isRepaired: isRepaired,
            isLocked: isLocked,
            canAfford: canAfford,
            onRepair: () {
              Navigator.of(ctx).pop(); // Close dialog
              _handleRepairTap(node, cityNotifier);
            },
          ),
        );
      },
    );
  }

  void _handleRepairTap(CityNodeConfig node, CityNotifier cityNotifier) {
    final success = cityNotifier.attemptRepair(node.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('District Repaired: ${node.name}! Effect Applied.'),
          backgroundColor: Colors.green,
          duration: const Duration(milliseconds: 1000),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insufficient Components to complete repair.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }
}
