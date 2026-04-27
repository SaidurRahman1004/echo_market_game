import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/run_result.dart';
import '../widgets/reward_row.dart';

/// The End-of-Run screen that presents the results, handles score transfers,
/// and provides satisfying feedback before the player returns to the Hub.
class ResultsScreen extends ConsumerStatefulWidget {
  final RunResult rawResult;
  final CalculatedRewards finalRewards;

  const ResultsScreen({
    super.key,
    required this.rawResult,
    required this.finalRewards,
  });

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);

    // Fade in text nicely
    Future.microtask(() {
      if (mounted) {
        _animController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final multBonusStr = widget.rawResult.comboBonus > 1.0
        ? 'x${widget.rawResult.comboBonus.toStringAsFixed(1)}'
        : null;

    return Scaffold(
      backgroundColor: const Color(0xff111827),
      appBar: AppBar(
        title: const Text(
          'RUN COMPLETE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Force them to press "Return to Hub"
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                // Top score highlight
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.amberAccent, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amberAccent.withValues(alpha: 0.2),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'SCORE',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.finalRewards.finalScore}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Runtime metrics block
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'PERFORMANCE',
                    style: TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                RewardRow(
                  icon: Icons.speed,
                  iconColor: Colors.deepOrangeAccent,
                  title: 'Distance',
                  baseValue: '${widget.rawResult.distance}m',
                ),
                RewardRow(
                  icon: Icons.timer,
                  iconColor: Colors.lightGreenAccent,
                  title: 'Time Survived',
                  baseValue: '${widget.rawResult.survivalTimeSeconds}s',
                ),

                const SizedBox(height: 24),
                // Earned Rewards block
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'REWARDS',
                    style: TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                RewardRow(
                  icon: Icons.stars,
                  iconColor: Colors.amber,
                  title: 'Echo Coins',
                  baseValue: '+${widget.finalRewards.finalCoins}',
                  bonusValue: multBonusStr,
                ),
                RewardRow(
                  icon: Icons.diamond_outlined,
                  iconColor: Colors.lightBlueAccent,
                  title: 'Time Shards',
                  baseValue: '+${widget.finalRewards.finalShards}',
                  bonusValue: multBonusStr,
                ),
                RewardRow(
                  icon: Icons.insights,
                  iconColor: Colors.purpleAccent,
                  title: 'Account XP',
                  baseValue: '+${widget.finalRewards.finalXp}',
                ),

                const Spacer(),

                // Actions
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('RETURN TO HUB'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
