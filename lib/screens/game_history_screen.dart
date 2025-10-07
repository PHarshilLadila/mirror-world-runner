import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mirror_world_runner/screens/game_screen.dart';
import 'package:mirror_world_runner/service/auth_service.dart';
import 'package:mirror_world_runner/widgets/particle_painter.dart';
import 'package:mirror_world_runner/widgets/particles.dart';

class GameHistoryScreen extends StatefulWidget {
  const GameHistoryScreen({super.key});

  @override
  State<GameHistoryScreen> createState() => _GameHistoryScreenState();
}

class _GameHistoryScreenState extends State<GameHistoryScreen>
    with SingleTickerProviderStateMixin {
  final List<Particles> particles = [];
  List<Map<String, dynamic>> gameHistory = [];
  final AuthService authService = AuthService();

  late Ticker ticker;
  bool isLoading = true;
  final ValueNotifier<int> particleNotifier = ValueNotifier<int>(0);
  final numberOfParticle = kIsWeb ? 50 : 40;
  Duration lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    setupParticles();
    _loadGameHistory();
  }

  void setupParticles() {
    for (int i = 0; i < numberOfParticle; i++) {
      particles.add(Particles());
    }

    ticker = createTicker((elapsed) {
      final dt = (elapsed - lastElapsed).inMicroseconds / 1e6;
      lastElapsed = elapsed;

      for (var p in particles) {
        p.update(dt);
      }

      particleNotifier.value++;
    });

    ticker.start();
  }

  List<Map<String, dynamic>> getUniqueGames(List<Map<String, dynamic>> games) {
    final seen = <String>{};
    final uniqueGames = <Map<String, dynamic>>[];

    for (var game in games) {
      final key = '${game['score']}_${game['timeTaken']}';
      if (!seen.contains(key)) {
        seen.add(key);
        uniqueGames.add(game);
      }
    }

    return uniqueGames;
  }

  Future<void> _loadGameHistory() async {
    try {
      final history = await authService.getUserGameHistory();
      if (mounted) {
        setState(() {
          gameHistory = history;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      debugPrint("Error loading game history: $e");
    }
  }

  @override
  void dispose() {
    ticker.dispose();
    particleNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uniqueGames = getUniqueGames(gameHistory);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade900,
                  Colors.indigo.shade900,
                  Colors.black87,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          RepaintBoundary(
            child: ValueListenableBuilder<int>(
              valueListenable: particleNotifier,
              builder: (context, _, __) {
                return CustomPaint(
                  painter: ParticlePainter(particles),
                  size: Size.infinite,
                );
              },
            ),
          ),

          // 📋 Foreground content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.greenAccent,
                        ),
                      )
                      : uniqueGames.isEmpty
                      ? const Center(
                        child: Text(
                          "No game history found.",
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      )
                      : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              children: const [
                                Icon(
                                  Icons.history,
                                  color: Colors.greenAccent,
                                  size: 22,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'GAME HISTORY',
                                  style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            ...uniqueGames.map(
                              (game) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.greenAccent.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Score: ${game['score']}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Time: ${takenTimeFormate(game['timeTaken'] ?? 0)}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
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
