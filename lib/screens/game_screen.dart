// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final Map<LogicalKeyboardKey, bool> _keyStates = {};
  double _moveSpeed = 400.0;

  Offset? _dragStartPosition;
  bool _isDragging = false;

  Timer? _timer;
  int _elapsedSeconds = 0;
  int _currentGameTime = 0;

  // Power-up tracking for Power Collector achievements
  int _starPowerUpsCollected = 0;
  int _heartPowerUpsCollected = 0;
  int _starActivations = 0;
  bool _reachedMaxLives = false;
  int _consecutivePowerUps = 0;
  int _maxConsecutivePowerUps = 0;
  bool lastCollectionWasPowerUp = false;
  Timer? _consecutiveTimer;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    _loadSpeedSetting();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  Future<void> _loadSpeedSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final settingValue = prefs.getDouble('movementSpeed') ?? 5.0;
      _moveSpeed = _convertSettingToGameSpeed(settingValue);

      final gameState = Provider.of<GameState>(context, listen: false);
      game = MirrorWorldGame(
        gameState: gameState,
        initialSpeed: _moveSpeed,
        onPowerUpCollected: _handlePowerUpCollected,
      );

      _startTimer(gameState);
    });
  }

  void _handlePowerUpCollected(String type) {
    setState(() {
      if (type == 'star') {
        _starPowerUpsCollected++;
        _starActivations++;
        _consecutivePowerUps++;
        lastCollectionWasPowerUp = true;

        debugPrint('Star collected! Total stars: $_starPowerUpsCollected');
        debugPrint('Star activations: $_starActivations');
        debugPrint('Consecutive power-ups: $_consecutivePowerUps');
      } else if (type == 'heart') {
        _heartPowerUpsCollected++;
        _consecutivePowerUps++;
        lastCollectionWasPowerUp = true;

        debugPrint('Heart collected! Total hearts: $_heartPowerUpsCollected');
        debugPrint('Consecutive power-ups: $_consecutivePowerUps');
      }

      // Update max consecutive power-ups
      if (_consecutivePowerUps > _maxConsecutivePowerUps) {
        _maxConsecutivePowerUps = _consecutivePowerUps;
        debugPrint('New max consecutive: $_maxConsecutivePowerUps');
      }

      // Check if max lives reached
      final gameState = Provider.of<GameState>(context, listen: false);
      if (gameState.lives >= 5) {
        _reachedMaxLives = true;
        debugPrint('Max lives reached!');
      }

      // Reset the consecutive timer
      _consecutiveTimer?.cancel();
      _consecutiveTimer = Timer(const Duration(seconds: 3), () {
        setState(() {
          _consecutivePowerUps = 0;
          lastCollectionWasPowerUp = false;
          debugPrint('Consecutive counter reset');
        });
      });
    });
  }

  void _startTimer(GameState gameState) {
    _elapsedSeconds = 0;
    _currentGameTime = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!gameState.isPaused && !gameState.isGameOver) {
        setState(() {
          _elapsedSeconds++;
          _currentGameTime = _elapsedSeconds;
        });
      }

      if (gameState.isGameOver) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('lastGameTimeSeconds', _currentGameTime);

        // Save all game data with achievement tracking
        await _saveGameDataWithAchievements(gameState);

        timer.cancel();
      }
    });
  }

  Future<void> _saveGameDataWithAchievements(GameState gameState) async {
    try {
      final authService = AuthService();

      debugPrint('=== SAVING GAME DATA ===');
      debugPrint('Score: ${gameState.score}');
      debugPrint('Time: $_currentGameTime seconds');
      debugPrint('Lives left: ${gameState.lives}');
      debugPrint('Star power-ups: $_starPowerUpsCollected');
      debugPrint('Heart power-ups: $_heartPowerUpsCollected');
      debugPrint('Star activations: $_starActivations');
      debugPrint('Reached max lives: $_reachedMaxLives');
      debugPrint('Max consecutive power-ups: $_maxConsecutivePowerUps');

      // Save game data with Power Collector tracking
      await authService.saveGameData(
        score: gameState.score,
        timeTaken: _currentGameTime,
        livesLeft: gameState.lives,
        difficultyLevel: gameState.difficultyLevel,
        starPowerUpsCollected: _starPowerUpsCollected,
        heartPowerUpsCollected: _heartPowerUpsCollected,
        starActivations: _starActivations,
        reachedMaxLives: _reachedMaxLives,
        consecutivePowerUps: _maxConsecutivePowerUps,
      );

      // Update max survival time for Survival Master achievements
      await authService.updateMaxSurvivalTime(_currentGameTime);

      // Update Addicted Runner achievements based on current time
      await authService.updateAddictedRunnerAchievements();

      debugPrint('=== GAME DATA SAVED SUCCESSFULLY ===');
    } catch (e) {
      debugPrint('Error saving game data: $e');
    }
  }

  double _convertSettingToGameSpeed(double settingValue) {
    return settingValue * 80.0;
  }

  void _handleSpeedChanged(double newSpeed) {
    setState(() {
      _moveSpeed = _convertSettingToGameSpeed(newSpeed);
      if (game != null) {
        game!.setMovement(0, 0, _moveSpeed);
      }
    });
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => SettingScreen(onSpeedChanged: _handleSpeedChanged),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    _timer?.cancel();
    _consecutiveTimer?.cancel();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _dragStartPosition = details.localPosition;
    _isDragging = true;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging || _dragStartPosition == null) return;

    final currentPosition = details.localPosition;
    final dragVector = currentPosition - _dragStartPosition!;
    final dragDistance = dragVector.distance;

    if (dragDistance < 10) {
      game!.setMovement(0, 0, 0);
      return;
    }

    double dx = dragVector.dx / math.max(dragDistance, 1);
    double dy = dragVector.dy / math.max(dragDistance, 1);

    game!.setMovement(dx, dy, _moveSpeed);
  }

  void _handleDragEnd(DragEndDetails details) {
    _isDragging = false;
    _dragStartPosition = null;
    game!.setMovement(0, 0, 0);
  }

  void _handleDragCancel() {
    _isDragging = false;
    _dragStartPosition = null;
    game!.setMovement(0, 0, 0);
  }

  void _handleKeyEvent(RawKeyEvent event) {
    final key = event.logicalKey;
    final isKeyDown = event is RawKeyDownEvent;

    if (isKeyDown != _keyStates[key]) {
      _keyStates[key] = isKeyDown;

      double dx = 0;
      double dy = 0;

      if (_keyStates[LogicalKeyboardKey.arrowUp] == true) dy -= 1;
      if (_keyStates[LogicalKeyboardKey.arrowDown] == true) dy += 1;
      if (_keyStates[LogicalKeyboardKey.arrowLeft] == true) dx -= 1;
      if (_keyStates[LogicalKeyboardKey.arrowRight] == true) dx += 1;

      if (dx != 0 && dy != 0) {
        final length = math.sqrt(dx * dx + dy * dy);
        dx /= length;
        dy /= length;
      }

      if (dx != 0 || dy != 0) {
        game!.setMovement(dx, dy, _moveSpeed);
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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (gameState.isGameOver) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('lastGameTimeSeconds', _currentGameTime);

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
            onKey: _handleKeyEvent,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: _handleDragStart,
              onPanUpdate: _handleDragUpdate,
              onPanEnd: _handleDragEnd,
              onPanCancel: _handleDragCancel,
              child: Stack(
                children: [
                  GameWidget(
                    game: game ?? MirrorWorldGame(gameState: gameState),
                  ),
                  _buildHUD(context, gameState),
                  _buildControlButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHUD(BuildContext context, GameState gameState) {
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
              SizedBox(height: 8),
              Text(
                'Time: ${takenTimeFormate(_currentGameTime)}',
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
                  onPressed: _showSettings,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
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
                onTapDown: (_) => game!.setMovement(0, -1, _moveSpeed),
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
                onTapDown: (_) => game!.setMovement(0, 1, _moveSpeed),
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
                onTapDown: (_) => game!.setMovement(-1, 0, _moveSpeed),
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
                onTapDown: (_) => game!.setMovement(1, 0, _moveSpeed),
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
