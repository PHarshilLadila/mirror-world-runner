// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mirror_world_runner/screens/game_history_screen.dart';
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
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<Offset> offsetAnimation;

  final List<Particles> particles = [];
  late Ticker ticker;
  final numberOfParticle = kIsWeb ? 60 : 50;
  Duration lastElapsed = Duration.zero;
  final ValueNotifier<int> particleNotifier = ValueNotifier<int>(0);

  final AuthService authService = AuthService();
  bool isSaving = false;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> gameHistory = [];
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
    await saveGameDataToFirebase();
  }

  void _setupAnimations() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic),
    );

    animationController.forward();
  }

  void _setupParticles() {
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

  Future<void> getTotalTakenTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = preferences.getInt("lastGameTimeSeconds");
    if (mounted) {
      setState(() {
        timeTaken = data ?? 0;
      });
    }
  }

  Future<void> _loadUserData() async {
    final userData = await authService.getCurrentUserData();
    if (mounted) {
      setState(() {
        _userData = userData;
      });
    }
  }

  Future<void> _loadGameHistory() async {
    final history = await authService.getUserGameHistory(true);
    if (mounted) {
      setState(() {
        gameHistory = history;
      });
    }
  }

  Future<void> _loadPersonalBests() async {
    final personalBests = await authService.getUserPersonalBests();
    if (mounted) {
      setState(() {
        _personalBests = personalBests;
      });
    }
  }

  Future<void> saveGameDataToFirebase() async {
    if (isSaving) return;

    if (mounted) setState(() => isSaving = true);

    try {
      final gameState = Provider.of<GameState>(context, listen: false);

      await authService.saveGameData(
        score: gameState.score,
        timeTaken: timeTaken,
        livesLeft: gameState.lives,
        difficultyLevel: gameState.difficultyLevel,
      );

      await authService.updateMaxSurvivalTime(timeTaken);

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
          isSaving = false;
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

  int getTotalGamesCount(List<Map<String, dynamic>> games) {
    return games.length; // This includes ALL games (with duplicates)
  }

  @override
  void dispose() {
    ticker.dispose();
    animationController.dispose();
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

  Widget statItem(IconData icon, String title, String value, Color color) {
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

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final uniqueGames = getUniqueGames(gameHistory);
    final totalGamesCount = getTotalGamesCount(gameHistory);

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
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: FadeTransition(
                      opacity: fadeAnimation,
                      child: Container(
                        width: kIsWeb ? 500 : 380,
                        height: kIsWeb ? 1000 : 1200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SlideTransition(
                                  position: slideAnimation,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [BackButton()],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Center(
                                  child: ShaderMask(
                                    shaderCallback:
                                        (bounds) => const LinearGradient(
                                          colors: [
                                            Colors.red,
                                            Colors.orange,
                                            Colors.yellow,
                                            Colors.green,
                                            Colors.blue,
                                            Colors.purple,
                                          ],
                                          stops: [0, 0.2, 0.4, 0.6, 0.8, 1.0],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds),
                                    child: const Text(
                                      'GAME OVER',
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (_userData != null) ...[
                                  SlideTransition(
                                    position: slideAnimation,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SlideTransition(
                                            position: offsetAnimation,
                                            child: Center(
                                              child: Image.asset(
                                                'assets/images/png/winner.png',
                                                width: 100,
                                              ),
                                            ),
                                          ),
                                          Row(
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
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                                SlideTransition(
                                  position: slideAnimation,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black12,
                                          Colors.black12,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        statItem(
                                          Icons.emoji_events,
                                          'SCORE',
                                          gameState.score.toString(),
                                          Colors.yellowAccent,
                                        ),
                                        const SizedBox(height: 8),
                                        Divider(color: Colors.white38),
                                        const SizedBox(height: 8),
                                        statItem(
                                          Icons.star,
                                          'HIGH SCORE',
                                          '${_userData?['highestScore'] ?? 0}',
                                          Colors.orangeAccent,
                                        ),
                                        const SizedBox(height: 8),
                                        Divider(color: Colors.white38),
                                        const SizedBox(height: 8),
                                        statItem(
                                          Icons.timer,
                                          'TIME TAKEN',
                                          takenTimeFormate(timeTaken),
                                          Colors.greenAccent,
                                        ),
                                        const SizedBox(height: 8),
                                        Divider(color: Colors.white38),
                                        const SizedBox(height: 8),
                                        statItem(
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
                                const SizedBox(height: 10),
                                if (_personalBests.isNotEmpty) ...[
                                  SlideTransition(
                                    position: slideAnimation,
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.blue.withOpacity(0.1),
                                        border: Border.all(
                                          color: Colors.blue.withOpacity(0.3),
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
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total Games:',
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              Text(
                                                '${_personalBests['totalGamesPlayed'] ?? totalGamesCount}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                                if (gameHistory.isNotEmpty) ...[
                                  SlideTransition(
                                    position: slideAnimation,
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.green.withOpacity(0.1),
                                        border: Border.all(
                                          color: Colors.green.withOpacity(0.3),
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
                                                  fontWeight: FontWeight.bold,
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
                                                                Colors.white70,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'Time: ${takenTimeFormate(game['timeTaken'] ?? 0)}',
                                                          style: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          HolographicButton(
                                            width:
                                                kIsWeb ? null : double.infinity,
                                            verticalPadding: 6,
                                            label: "View All",
                                            fontSize: 12,
                                            colors: const [
                                              Colors.white24,
                                              Colors.white24,
                                            ],
                                            onTap: () {
                                              debugPrint(
                                                "[GAME OVER] VIEW ALL GAMES HISTORY",
                                              );
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          const GameHistoryScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                                SlideTransition(
                                  position: slideAnimation,
                                  child: Column(
                                    children: [
                                      HolographicButton(
                                        width: kIsWeb ? null : double.infinity,
                                        verticalPadding: 14,
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
                                        width: kIsWeb ? null : double.infinity,
                                        verticalPadding: 14,
                                        label: "VIEW LEADERBOARD",
                                        fontSize: 13,
                                        colors: const [
                                          Colors.amber,
                                          Colors.deepOrange,
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
                                        width: kIsWeb ? null : double.infinity,
                                        verticalPadding: 14,
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
                      ),
                    ),
                  ),
                ),
                if (isSaving) ...[
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
                valueListenable: particleNotifier,
                builder: (context, _, __) {
                  return CustomPaint(
                    painter: ParticlePainter(particles),
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
}
