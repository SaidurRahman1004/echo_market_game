import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/game.dart';
import '../../game/engine/echo_market_game.dart';
import '../results/screens/results_screen.dart';
import 'providers/riverpod_game_bridge.dart';

class GameplayShellScreen extends ConsumerStatefulWidget {
  const GameplayShellScreen({super.key});

  @override
  ConsumerState<GameplayShellScreen> createState() =>
      _GameplayShellScreenState();
}

class _GameplayShellScreenState extends ConsumerState<GameplayShellScreen> {
  late final EchoMarketGame game;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    // Initialize the Flame engine and inject the Riverpod bridge
    game = EchoMarketGame(
      bridge: RiverpodGameBridge(
        ref,
        onGameOver: (result, finalRewards) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ResultsScreen(rawResult: result, finalRewards: finalRewards),
            ),
          );
        },
      ),
    );
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
    game.togglePause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Base layer for the flame game board
      body: Stack(
        children: [
          // 1. The Flame widget securely rendering the game
          GameWidget(game: game),

          // 2. Gameplay Input Overlays (Gestures) - Disabled if paused
          if (!_isPaused)
            GestureDetector(
              onTap: () {
                if (game.isLoaded && game.runner.isLoaded) game.runner.jump();
              },
              onVerticalDragEnd: (details) {
                if (!game.isLoaded || !game.runner.isLoaded) return;
                if (details.primaryVelocity != null &&
                    details.primaryVelocity! > 0) {
                  // Downward swipe -> Slide
                  game.runner.slide();
                } else if (details.primaryVelocity != null &&
                    details.primaryVelocity! < 0) {
                  // Upward swipe -> Jump overlap
                  game.runner.jump();
                }
              },
              behavior: HitTestBehavior.translucent,
            ),

          // 3. UI overlays (HUD)
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(
                 _isPaused ? Icons.play_arrow : Icons.pause, 
                 color: Colors.white,
                 size: 32,
              ),
              onPressed: _togglePause,
            ),
          ),

          // 4. Pause Menu Overlay
          if (_isPaused)
            Positioned.fill(
              child: Container(
                color: Colors.black87,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'PAUSED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: _togglePause,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyanAccent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('RESUME'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 250,
                        child: OutlinedButton(
                          onPressed: () {
                            // Safe abort sequence bypassing Game Over rewards
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(color: Colors.redAccent),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('ABORT RUN'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
