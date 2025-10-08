// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mirror_world_runner/screens/game_screen.dart';
import 'package:mirror_world_runner/service/auth_service.dart';
import 'package:mirror_world_runner/widgets/custom_loader.dart';
import 'package:mirror_world_runner/widgets/particle_painter.dart';
import 'package:mirror_world_runner/widgets/particles.dart';

enum GameHistorySort { highestScore, lowestScore, highestTime, lowestTime }

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

  final Map<int, bool> hoveredMap = {};

  GameHistorySort currentSort = GameHistorySort.highestScore;

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

  List<Map<String, dynamic>> getSortedGames(List<Map<String, dynamic>> games) {
    List<Map<String, dynamic>> sorted = List.from(games);

    switch (currentSort) {
      case GameHistorySort.highestScore:
        sorted.sort((a, b) => (b['score'] ?? 0).compareTo(a['score'] ?? 0));
        break;
      case GameHistorySort.lowestScore:
        sorted.sort((a, b) => (a['score'] ?? 0).compareTo(b['score'] ?? 0));
        break;
      case GameHistorySort.highestTime:
        sorted.sort(
          (a, b) => (b['timeTaken'] ?? 0).compareTo(a['timeTaken'] ?? 0),
        );
        break;
      case GameHistorySort.lowestTime:
        sorted.sort(
          (a, b) => (a['timeTaken'] ?? 0).compareTo(b['timeTaken'] ?? 0),
        );
        break;
    }

    return sorted;
  }

  Future<void> _loadGameHistory() async {
    try {
      final history = await authService.getUserGameHistory(false);

      debugPrint("Total games fetched: ${history.length}");

      final uniqueGames = getUniqueGames(history);
      debugPrint("Total unique games to display: ${uniqueGames.length}");

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
    final sortedGames = getSortedGames(uniqueGames);

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
          SafeArea(
            child:
                isLoading
                    ? Center(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: GameLoadingWidget(width: 100, height: 100),
                        ),
                      ),
                    )
                    : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const BackButton(color: Colors.white),
                                const Expanded(
                                  child: Center(
                                    child: Text(
                                      'GAME HISTORY',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                sortedGames.isEmpty
                                    ? SizedBox.shrink()
                                    : DropdownButton<GameHistorySort>(
                                      dropdownColor: Colors.black87,
                                      value: currentSort,
                                      icon: const Icon(
                                        Icons.filter_list,
                                        color: Colors.white,
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: GameHistorySort.highestScore,
                                          child: Text(
                                            'Highest Score',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: GameHistorySort.lowestScore,
                                          child: Text(
                                            'Lowest Score',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: GameHistorySort.highestTime,
                                          child: Text(
                                            'Highest Time',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: GameHistorySort.lowestTime,
                                          child: Text(
                                            'Lowest Time',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            currentSort = value;
                                          });
                                        }
                                      },
                                    ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            if (sortedGames.isEmpty)
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.4,
                                  ),
                                  child: const Text(
                                    "No game history found.",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Column(
                                children:
                                    sortedGames.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final game = entry.value;

                                      hoveredMap[index] =
                                          hoveredMap[index] ?? false;

                                      return MouseRegion(
                                        onEnter:
                                            (_) => setState(
                                              () => hoveredMap[index] = true,
                                            ),
                                        onExit:
                                            (_) => setState(
                                              () => hoveredMap[index] = false,
                                            ),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeOutBack,
                                          alignment: Alignment.center,
                                          transform:
                                              Matrix4.identity()
                                                ..translate(
                                                  0.0,
                                                  hoveredMap[index]!
                                                      ? -10
                                                      : 0.0,
                                                )
                                                ..scale(
                                                  hoveredMap[index]!
                                                      ? 1.001
                                                      : 1.0,
                                                ),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              top: hoveredMap[index]! ? 22 : 5,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 12,
                                                      ),
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white30,
                                                    child: Center(
                                                      child: Text(
                                                        '${index + 1}',
                                                        style: const TextStyle(
                                                          color: Colors.white70,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Score: ${game['score']}',
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 15,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Time: ${takenTimeFormate(game['timeTaken'] ?? 0)}',
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 15,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
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
