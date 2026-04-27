import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../meta_progression/state/contract_provider.dart';
import '../data/contract_registry.dart';
import 'contract_card.dart';

class ContractsScreen extends ConsumerWidget {
  const ContractsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contracts = ContractRegistry.all;
    final contractNotifier = ref.watch(contractProvider.notifier);

    // Using ref.watch just to ensure UI rebuilds when state changes
    ref.watch(contractProvider);

    // Categorize
    final activeContracts = <Widget>[];
    final completedContracts = <Widget>[];

    for (final contract in contracts) {
      final isCompleted = contractNotifier.isCompleted(contract.id);
      final canComplete = contractNotifier.canComplete(contract.id);

      final card = ContractCard(
        contract: contract,
        isCompleted: isCompleted,
        canComplete: canComplete,
        onComplete: () {
          final success = contractNotifier.completeContract(contract.id);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Contract "${contract.title}" Completed!'),
              ),
            );
          }
        },
      );

      if (isCompleted) {
        completedContracts.add(card);
      } else {
        // Only show if prerequisites are met (simplistic logic: canComplete covers item checks,
        // but let's just show it if it's the next logical step. For now, active gets all non-completed).
        // Ideally, you'd filter out contracts whose prequel isn't completed.
        if (contract.prerequisiteContractId == null ||
            contractNotifier.isCompleted(contract.prerequisiteContractId!)) {
          activeContracts.add(card);
        }
      }
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('NPC Contracts'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            activeContracts.isEmpty
                ? const Center(child: Text('No active contracts available.'))
                : ListView(children: activeContracts),
            completedContracts.isEmpty
                ? const Center(child: Text('No completed contracts yet.'))
                : ListView(children: completedContracts),
          ],
        ),
      ),
    );
  }
}
