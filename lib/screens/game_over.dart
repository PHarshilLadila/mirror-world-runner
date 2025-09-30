// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mirror_world_runner/screens/leader_board_screen.dart';
import 'package:mirror_world_runner/service/auth_service.dart';
import 'package:mirror_world_runner/widgets/custom_loader.dart';
import 'package:mirror_world_runner/widgets/custom_toast.dart';
import 'package:mirror_world_runner/widgets/holographic_button.dart';
import 'package:mirror_world_runner/widgets/particle_painter.dart';
import 'package:mirror_world_runner/widgets/particles.dart';
import 'package:provider/provider.dart';
import 'package:mirror_world_runner/providers/game_state.dart';
import 'package:mirror_world_runner/screens/main_menu.dart';
import 'package:mirror_world_runner/screens/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with TickerProviderStateMixin {
  int timeTaken = 0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final List<Particles> _particles = [];
  late Ticker _ticker;
  final numberOfParticle = kIsWeb ? 60 : 50;
  Duration _lastElapsed = Duration.zero;
  final ValueNotifier<int> _particleNotifier = ValueNotifier<int>(0);

  final AuthService _authService = AuthService();
  bool _isSaving = false;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _gameHistory = [];
  Map<String, dynamic> _personalBests = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupAnimations();
    _setupParticles();
  }

  void _initializeData() async {
    await getTotalTakenTime();
    await _loadUserData();
    await _loadGameHistory();
    await _loadPersonalBests();
    await _saveGameDataToFirebase();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  void _setupParticles() {
    for (int i = 0; i < numberOfParticle; i++) {
      _particles.add(Particles());
    }

    _ticker = createTicker((elapsed) {
      final dt = (elapsed - _lastElapsed).inMicroseconds / 1e6;
      _lastElapsed = elapsed;

      for (var p in _particles) {
        p.update(dt);
      }

      _particleNotifier.value++;
    });
    _ticker.start();
  }

  Future<void> getTotalTakenTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = preferences.getInt("lastGameTimeSeconds");
    setState(() {
      timeTaken = data ?? 0;
    });
  }

  Future<void> _loadUserData() async {
    final userData = await _authService.getCurrentUserData();
    setState(() {
      _userData = userData;
    });
  }

  Future<void> _loadGameHistory() async {
    final history = await _authService.getUserGameHistory();
    setState(() {
      _gameHistory = history;
    });
  }

  Future<void> _loadPersonalBests() async {
    final personalBests = await _authService.getUserPersonalBests();
    setState(() {
      _personalBests = personalBests;
    });
  }

  Future<void> _saveGameDataToFirebase() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final gameState = Provider.of<GameState>(context, listen: false);

      await _authService.saveGameData(
        score: gameState.score,
        timeTaken: timeTaken,
        livesLeft: gameState.lives,
        difficultyLevel: gameState.difficultyLevel,
      );

      // Reload data after saving
      await _loadUserData();
      await _loadGameHistory();
      await _loadPersonalBests();

      if (mounted) {
        CustomToast.show(
          context,
          message: "Game data saved successfully!",
          type: GameToastType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomToast.show(
          context,
          message: "Failed to save game data: $e",
          type: GameToastType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
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

  @override
  void dispose() {
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  String takenTimeFormate(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  String formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final uniqueGames = getUniqueGames(_gameHistory);
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
            child: Stack(
              children: [
                Center(
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: kIsWeb ? 500 : 380,
                        height: kIsWeb ? 1000 : 1200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purple.shade800.withOpacity(0.9),
                                    Colors.deepPurple.shade900.withOpacity(0.8),
                                    Colors.black.withOpacity(0.9),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SlideTransition(
                                      position: _slideAnimation,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          ShaderMask(
                                            shaderCallback:
                                                (bounds) =>
                                                    const LinearGradient(
                                                      colors: [
                                                        Colors.red,
                                                        Colors.orange,
                                                        Colors.yellow,
                                                        Colors.green,
                                                        Colors.blue,
                                                        Colors.purple,
                                                      ],
                                                      stops: [
                                                        0.0,
                                                        0.2,
                                                        0.4,
                                                        0.6,
                                                        0.8,
                                                        1.0,
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ).createShader(bounds),
                                            child: const Text(
                                              'GAME OVER',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    if (_userData != null) ...[
                                      SlideTransition(
                                        position: _slideAnimation,
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Player:',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    '${_userData!['userName']}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Best:',
                                                    style: TextStyle(
                                                      color: Colors.yellow,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    '${_userData!['highestScore'] ?? 0}',
                                                    style: TextStyle(
                                                      color: Colors.yellow,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],

                                    SlideTransition(
                                      position: _slideAnimation,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black12,
                                              Colors.black12,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.2,
                                            ),
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildStatItem(
                                              Icons.emoji_events,
                                              'SCORE',
                                              gameState.score.toString(),
                                              Colors.yellowAccent,
                                            ),
                                            const SizedBox(height: 8),
                                            Divider(color: Colors.white38),
                                            const SizedBox(height: 8),

                                            // _buildStatItem(
                                            //   Icons.star,
                                            //   'HIGH SCORE',
                                            //   '${_userData!['highestScore'] ?? 0}',
                                            //   Colors.orangeAccent,
                                            // ),
                                            _buildStatItem(
                                              Icons.star,
                                              'HIGH SCORE',
                                              '${_userData?['highestScore'] ?? 0}',
                                              Colors.orangeAccent,
                                            ),
                                            const SizedBox(height: 8),
                                            Divider(color: Colors.white38),
                                            const SizedBox(height: 8),

                                            _buildStatItem(
                                              Icons.timer,
                                              'TIME TAKEN',
                                              takenTimeFormate(timeTaken),
                                              Colors.greenAccent,
                                            ),
                                            const SizedBox(height: 8),
                                            Divider(color: Colors.white38),
                                            const SizedBox(height: 8),

                                            const SizedBox(height: 8),

                                            _buildStatItem(
                                              Icons.speed,
                                              'DIFFICULTY',
                                              _getDifficultyText(
                                                gameState.difficultyLevel,
                                              ),
                                              _getDifficultyColor(
                                                gameState.difficultyLevel,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    if (_personalBests.isNotEmpty) ...[
                                      SlideTransition(
                                        position: _slideAnimation,
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color: Colors.blue.withOpacity(0.1),
                                            border: Border.all(
                                              color: Colors.blue.withOpacity(
                                                0.3,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.leaderboard,
                                                    color: Colors.blueAccent,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'PERSONAL BESTS',
                                                    style: TextStyle(
                                                      color: Colors.blueAccent,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Highest Score:',
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${_personalBests['highestScore'] ?? 0}',
                                                    style: TextStyle(
                                                      color: Colors.yellow,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Total Games:',
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${_personalBests['totalGamesPlayed'] ?? 0}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                    ],

                                    if (_gameHistory.isNotEmpty) ...[
                                      SlideTransition(
                                        position: _slideAnimation,
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color: Colors.green.withOpacity(
                                              0.1,
                                            ),
                                            border: Border.all(
                                              color: Colors.green.withOpacity(
                                                0.3,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.history,
                                                    color: Colors.greenAccent,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'RECENT GAMES',
                                                    style: TextStyle(
                                                      color: Colors.greenAccent,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),

                                              ...uniqueGames
                                                  .take(3)
                                                  .map(
                                                    (game) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            bottom: 8,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              'Score: ${game['score']}',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white70,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              'Time: ${takenTimeFormate(game['timeTaken'] ?? 0)}',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white70,
                                                              ),
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
                                      const SizedBox(height: 20),
                                    ],

                                    SlideTransition(
                                      position: _slideAnimation,
                                      child: Column(
                                        children: [
                                          HolographicButton(
                                            verticalPadding: 12,
                                            label: "PLAY AGAIN",
                                            fontSize: 13,
                                            colors: const [
                                              Colors.purple,
                                              Colors.pinkAccent,
                                            ],
                                            onTap: () {
                                              gameState.resetGame();
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          const GameScreen(),
                                                ),
                                                (route) => false,
                                              );
                                            },
                                          ),

                                          const SizedBox(height: 15),

                                          HolographicButton(
                                            verticalPadding: 12,
                                            label: "VIEW LEADERBOARD",
                                            fontSize: 13,
                                            colors: const [
                                              Colors.amber,
                                              Colors.yellowAccent,
                                            ],
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          LeaderboardScreen(),
                                                ),
                                              );
                                            },
                                          ),

                                          const SizedBox(height: 15),

                                          HolographicButton(
                                            verticalPadding: 12,
                                            label: "MAIN MENU",
                                            fontSize: 13,
                                            colors: [
                                              Colors.blue,
                                              Colors.cyanAccent,
                                            ],
                                            onTap: () {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          const MainMenuScreen(),
                                                ),
                                                (route) => false,
                                              );
                                            },
                                          ),
                                        ],
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
                ),
                if (_isSaving) ...[
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: GameLoadingWidget(width: 100, height: 100),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IgnorePointer(
            child: RepaintBoundary(
              child: ValueListenableBuilder<int>(
                valueListenable: _particleNotifier,
                builder: (context, _, __) {
                  return CustomPaint(
                    painter: ParticlePainter(_particles),
                    size: Size.infinite,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDifficultyText(int level) {
    switch (level) {
      case 1:
        return 'Easy';
      case 2:
        return 'Medium';
      case 3:
        return 'Hard';
      default:
        return 'Medium';
    }
  }

  Color _getDifficultyColor(int level) {
    switch (level) {
      case 1:
        return Colors.greenAccent;
      case 2:
        return Colors.orangeAccent;
      case 3:
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  Widget _buildStatItem(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(color: color.withOpacity(0.5), blurRadius: 10),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildAnimatedButton({
    required String label,
    required List<Color> colors,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(colors: colors),
            boxShadow: [
              BoxShadow(
                color: colors.first.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
