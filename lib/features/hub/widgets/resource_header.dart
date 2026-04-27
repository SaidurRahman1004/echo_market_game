import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../meta_progression/state/currency_provider.dart';
import '../../meta_progression/state/profile_provider.dart';

class ResourceHeader extends ConsumerWidget {
  const ResourceHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final profile = ref.watch(profileProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 360;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      radius: 20,
                      child: Text(
                        profile.currentLevel.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Runner',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            'XP: ${profile.currentXp}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (isCompact)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _CurrencyPill(
                          icon: Icons.monetization_on,
                          iconColor: Colors.amber,
                          amount: currency.echoCoins,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _CurrencyPill(
                          icon: Icons.diamond,
                          iconColor: Colors.purpleAccent,
                          amount: currency.timeShards,
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _CurrencyPill(
                        icon: Icons.monetization_on,
                        iconColor: Colors.amber,
                        amount: currency.echoCoins,
                      ),
                      const SizedBox(width: 12),
                      _CurrencyPill(
                        icon: Icons.diamond,
                        iconColor: Colors.purpleAccent,
                        amount: currency.timeShards,
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CurrencyPill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final int amount;

  const _CurrencyPill({required this.icon, required this.iconColor, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            amount.toString(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
