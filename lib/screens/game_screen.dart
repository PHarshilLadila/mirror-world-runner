// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirror_world_runner/widgets/custom_loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mirror_world_runner/game/mirror_world_game.dart';
import 'package:mirror_world_runner/providers/game_state.dart';
import 'package:mirror_world_runner/screens/game_over.dart';
import 'package:mirror_world_runner/screens/pause_menu.dart';
import 'package:mirror_world_runner/screens/setting_screen.dart';
import 'package:mirror_world_runner/service/auth_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  MirrorWorldGame? game;
  late FocusNode focusNode;

  final Map<LogicalKeyboardKey, bool> keyStates = {};
  double moveSpeed = 400.0;

  Offset? dragStartPosition;
  bool isDragging = false;

  Timer? timer;
  int elapsedSeconds = 0;
  int currentGameTime = 0;

  int starPowerUpsCollected = 0;
  int heartPowerUpsCollected = 0;
  int starActivations = 0;
  bool reachedMaxLives = false;
  int consecutivePowerUps = 0;
  int maxConsecutivePowerUps = 0;
  bool lastCollectionWasPowerUp = false;
  Timer? consecutiveTimer;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    loadSpeedSetting();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  Future<void> loadSpeedSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final settingValue = prefs.getDouble('movementSpeed') ?? 5.0;
      moveSpeed = convertSettingToGameSpeed(settingValue);

      final gameState = Provider.of<GameState>(context, listen: false);
      game = MirrorWorldGame(
        gameState: gameState,
        initialSpeed: moveSpeed,
        onPowerUpCollected: handlePowerUpCollected,
      );

      startTimer(gameState);
    });
  }

  void handlePowerUpCollected(String type) {
    setState(() {
      if (type == 'star') {
        starPowerUpsCollected++;
        starActivations++;
        consecutivePowerUps++;
        lastCollectionWasPowerUp = true;

        debugPrint(
          '[Game Screen] Star collected! Total stars: $starPowerUpsCollected',
        );
        debugPrint('[Game Screen] Star activations: $starActivations');
        debugPrint('[Game Screen] Consecutive power-ups: $consecutivePowerUps');
      } else if (type == 'heart') {
        heartPowerUpsCollected++;
        consecutivePowerUps++;
        lastCollectionWasPowerUp = true;

        debugPrint(
          '[Game Screen] Heart collected! Total hearts: $heartPowerUpsCollected',
        );
        debugPrint('[Game Screen] Consecutive power-ups: $consecutivePowerUps');
      }

      if (consecutivePowerUps > maxConsecutivePowerUps) {
        maxConsecutivePowerUps = consecutivePowerUps;
        debugPrint(
          '[Game Screen] New max consecutive: $maxConsecutivePowerUps',
        );
      }

      final gameState = Provider.of<GameState>(context, listen: false);
      if (gameState.lives >= 5) {
        reachedMaxLives = true;
        debugPrint('[Game Screen] Max lives reached!');
      }

      consecutiveTimer?.cancel();
      consecutiveTimer = Timer(const Duration(seconds: 3), () {
        setState(() {
          consecutivePowerUps = 0;
          lastCollectionWasPowerUp = false;
          debugPrint('[Game Screen] Consecutive counter reset');
        });
      });
    });
  }

  void startTimer(GameState gameState) {
    elapsedSeconds = 0;
    currentGameTime = 0;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!gameState.isPaused && !gameState.isGameOver) {
        setState(() {
          elapsedSeconds++;
          currentGameTime = elapsedSeconds;
        });
      }

      if (gameState.isGameOver) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('lastGameTimeSeconds', currentGameTime);

        await saveGameDataWithAchievements(gameState);

        timer.cancel();
      }
    });
  }

  Future<void> saveGameDataWithAchievements(GameState gameState) async {
    try {
      final authService = AuthService();

      debugPrint('[Game Screen] === SAVING GAME DATA ===');
      debugPrint('[Game Screen] Score: ${gameState.score}');
      debugPrint('[Game Screen] Time: $currentGameTime seconds');
      debugPrint('[Game Screen] Lives left: ${gameState.lives}');
      debugPrint('[Game Screen] Star power-ups: $starPowerUpsCollected');
      debugPrint('[Game Screen] Heart power-ups: $heartPowerUpsCollected');
      debugPrint('[Game Screen] Star activations: $starActivations');
      debugPrint('[Game Screen] Reached max lives: $reachedMaxLives');
      debugPrint(
        '[Game Screen] Max consecutive power-ups: $maxConsecutivePowerUps',
      );

      await authService.saveGameData(
        score: gameState.score,
        timeTaken: currentGameTime,
        livesLeft: gameState.lives,
        difficultyLevel: gameState.difficultyLevel,
        starPowerUpsCollected: starPowerUpsCollected,
        heartPowerUpsCollected: heartPowerUpsCollected,
        starActivations: starActivations,
        reachedMaxLives: reachedMaxLives,
        consecutivePowerUps: maxConsecutivePowerUps,
      );

      await authService.updateMaxSurvivalTime(currentGameTime);

      await authService.updateAddictedRunnerAchievements();

      debugPrint('[Game Screen] === GAME DATA SAVED SUCCESSFULLY ===');
    } catch (e) {
      debugPrint('[Game Screen] Error saving game data: $e');
    }
  }

  double convertSettingToGameSpeed(double settingValue) {
    return settingValue * 80.0;
  }

  void handleSpeedChanged(double newSpeed) {
    setState(() {
      moveSpeed = convertSettingToGameSpeed(newSpeed);
      if (game != null) {
        game!.setMovement(0, 0, moveSpeed);
      }
    });
  }

  void showSettings() {
    showDialog(
      context: context,
      builder: (context) => SettingScreen(onSpeedChanged: handleSpeedChanged),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    timer?.cancel();
    consecutiveTimer?.cancel();
    super.dispose();
  }

  void handleDragStart(DragStartDetails details) {
    dragStartPosition = details.localPosition;
    isDragging = true;
  }

  void handleDragUpdate(DragUpdateDetails details) {
    if (!isDragging || dragStartPosition == null) return;

    final currentPosition = details.localPosition;
    final dragVector = currentPosition - dragStartPosition!;
    final dragDistance = dragVector.distance;

    if (dragDistance < 10) {
      game!.setMovement(0, 0, 0);
      return;
    }

    double dx = dragVector.dx / math.max(dragDistance, 1);
    double dy = dragVector.dy / math.max(dragDistance, 1);

    game!.setMovement(dx, dy, moveSpeed);
  }

  void handleDragEnd(DragEndDetails details) {
    isDragging = false;
    dragStartPosition = null;
    game!.setMovement(0, 0, 0);
  }

  void handleDragCancel() {
    isDragging = false;
    dragStartPosition = null;
    game!.setMovement(0, 0, 0);
  }

  void handleKeyEvent(RawKeyEvent event) {
    final key = event.logicalKey;
    final isKeyDown = event is RawKeyDownEvent;

    if (isKeyDown != keyStates[key]) {
      keyStates[key] = isKeyDown;

      double dx = 0;
      double dy = 0;

      if (keyStates[LogicalKeyboardKey.arrowUp] == true) dy -= 1;
      if (keyStates[LogicalKeyboardKey.arrowDown] == true) dy += 1;
      if (keyStates[LogicalKeyboardKey.arrowLeft] == true) dx -= 1;
      if (keyStates[LogicalKeyboardKey.arrowRight] == true) dx += 1;

      if (dx != 0 && dy != 0) {
        final length = math.sqrt(dx * dx + dy * dy);
        dx /= length;
        dy /= length;
      }

      if (dx != 0 || dy != 0) {
        game!.setMovement(dx, dy, moveSpeed);
      } else {
        game!.setMovement(0, 0, 0);
      }

      if ((key == LogicalKeyboardKey.escape ||
              key == LogicalKeyboardKey.space) &&
          isKeyDown) {
        final gameState = Provider.of<GameState>(context, listen: false);
        if (!gameState.isGameOver) {
          gameState.togglePause();
          if (gameState.isPaused) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const PauseMenu(),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        if (game == null) {
          return Scaffold(
            body: Center(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: GameLoadingWidget(width: 100, height: 100),
                ),
              ),
            ),
          );
        }

        if (gameState.isGameOver) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('lastGameTimeSeconds', currentGameTime);

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const GameOverScreen(),
            );
          });
        }

        return Scaffold(
          body: RawKeyboardListener(
            focusNode: focusNode,
            onKey: handleKeyEvent,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: handleDragStart,
              onPanUpdate: handleDragUpdate,
              onPanEnd: handleDragEnd,
              onPanCancel: handleDragCancel,
              child: Stack(
                children: [
                  GameWidget(
                    game: game ?? MirrorWorldGame(gameState: gameState),
                  ),
                  Hud(
                    gameState: gameState,
                    showSettings: showSettings,
                    currentGameTime: (currentGameTime.toString()),
                  ),
                  controlButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget controlButtons() {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        if (gameState.isGameOver || gameState.isPaused) {
          return const SizedBox();
        }

        return Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTapDown: (_) => game!.setMovement(0, -1, moveSpeed),
                onTapUp: (_) => game!.setMovement(0, 0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTapDown: (_) => game!.setMovement(0, 1, moveSpeed),
                onTapUp: (_) => game!.setMovement(0, 0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Icon(
                    Icons.arrow_downward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 40),
              GestureDetector(
                onTapDown: (_) => game!.setMovement(-1, 0, moveSpeed),
                onTapUp: (_) => game!.setMovement(0, 0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTapDown: (_) => game!.setMovement(1, 0, moveSpeed),
                onTapUp: (_) => game!.setMovement(0, 0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String takenTimeFormate(int totalSeconds) {
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

class Hud extends StatelessWidget {
  final GameState gameState;
  final VoidCallback showSettings;
  final String currentGameTime;

  const Hud({
    super.key,
    required this.gameState,
    required this.showSettings,
    required this.currentGameTime,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Score: ${gameState.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Time: ${takenTimeFormate(int.parse(currentGameTime))}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.favorite,
                color: index < gameState.lives ? Colors.red : Colors.grey,
                size: 26,
              ),
            ),
          ),
          if (!gameState.isGameOver)
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: showSettings,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
