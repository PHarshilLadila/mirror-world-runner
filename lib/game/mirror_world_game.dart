// // ignore_for_file: deprecated_member_use

// import 'package:flame/components.dart';
// import 'package:flame/game.dart';
// import 'package:flame/input.dart';
// import 'package:flutter/material.dart';
// import 'package:vibration/vibration.dart';
// import 'dart:math';
// import 'package:mirror_world_runner/providers/game_state.dart';
// import 'package:mirror_world_runner/game/components/player.dart';
// import 'package:mirror_world_runner/game/components/obstacle.dart';
// import 'package:mirror_world_runner/game/components/powerup.dart';
// import 'package:mirror_world_runner/game/components/boom_animation.dart';
// import 'package:mirror_world_runner/game/managers/game_manager.dart';
// import 'package:mirror_world_runner/game/game_world.dart';
// import 'package:flame_audio/flame_audio.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

// class MirrorWorldGame extends FlameGame
//     with HasCollisionDetection, TapDetector {
//   final GameState gameState;
//   late GameWorld gameWorld;
//   late Player normalPlayer;
//   late Player mirroredPlayer;
//   late GameManager gameManager;
//   final Random random = Random();

//   late Vector2 gameSize;

//   double _scoreTimer = 0;
//   final double _scoreInterval = 0.1;
//   double _targetDx = 0;
//   double _targetDy = 0;
//   double _moveSpeed = 400.0;

//   MirrorWorldGame({required this.gameState, double initialSpeed = 400.0}) {
//     _moveSpeed = initialSpeed;
//     // pauseWhenBackgrounded = false;
//   }

//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();

//     await FlameAudio.audioCache.loadAll(['bomb.mp3']);

//     gameWorld = GameWorld();
//     add(gameWorld);

//     gameSize = size;

//     normalPlayer = Player(
//       isMirrored: false,
//       gameSize: gameSize,
//       position: Vector2(100, gameSize.y / 2),
//       size: Vector2(50, 50),
//     );
//     gameWorld.add(normalPlayer);

//     mirroredPlayer = Player(
//       isMirrored: true,
//       gameSize: gameSize,
//       position: Vector2(gameSize.x - 150, gameSize.y / 2),
//       size: Vector2(50, 50),
//     );
//     gameWorld.add(mirroredPlayer);

//     gameManager = GameManager(
//       world: gameWorld,
//       gameSize: gameSize,
//       onPlayerHit: () {
//         gameState.decreaseLife();
//       },
//       onPowerUpCollected: (PowerUpType type) {
//         if (type == PowerUpType.extraLife) {
//           if (gameState.lives < 5) {
//             gameState.increaseLife();
//           }
//         } else if (type == PowerUpType.timeSlowdown) {
//           gameManager.activateTimeSlowdown();
//         } else {
//           normalPlayer.activatePowerUp();
//           mirroredPlayer.activatePowerUp();
//         }
//       },
//     );
//     add(gameManager);
//   }

//   void setMovement(double dx, double dy, [double? speed]) {
//     _targetDx = dx;
//     _targetDy = dy;
//     if (speed != null) {
//       _moveSpeed = speed;
//     }
//   }

//   @override
//   void onTap() {
//     if (gameState.isPaused) {
//       gameState.togglePause();
//     }
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);

//     if (!gameState.isPaused && !gameState.isGameOver) {
//       _scoreTimer += dt;
//       if (_scoreTimer >= _scoreInterval) {
//         gameState.incrementScore(1);
//         _scoreTimer = 0;
//       }

//       _applySmoothMovement(dt);

//       normalPlayer.updatePowerUp(dt);
//       mirroredPlayer.updatePowerUp(dt);

//       _checkCollisions();
//     }
//   }

//   void _applySmoothMovement(double dt) {
//     if (_targetDx != 0 || _targetDy != 0) {
//       final moveDistance = _moveSpeed * dt;
//       final moveX = _targetDx * moveDistance;
//       final moveY = _targetDy * moveDistance;

//       _movePlayer(normalPlayer, moveX, moveY);
//       _movePlayer(mirroredPlayer, moveX, moveY);
//     }
//   }

//   void _movePlayer(Player player, double dx, double dy) {
//     double newX = player.position.x + dx;
//     double newY = player.position.y + dy;

//     if (player.isMirrored) {
//       newX = newX.clamp(gameSize.x / 2, gameSize.x - player.size.x);
//     } else {
//       newX = newX.clamp(0, (gameSize.x / 2) - player.size.x);
//     }

//     newY = newY.clamp(0, gameSize.y - player.size.y);

//     player.position = Vector2(newX, newY);
//   }

//   void _checkCollisions() {
//     for (final component in gameWorld.children.toList()) {
//       if (component is Obstacle && !component.isForMirroredWorld) {
//         if (_checkRectCollision(normalPlayer, component)) {
//           _handleCollision(normalPlayer, component);
//         }
//       } else if (component is PowerUp) {
//         if (_checkRectCollision(normalPlayer, component)) {
//           gameManager.onPowerUpCollected(component.type);
//           component.removeFromParent();
//         }
//       }
//     }

//     for (final component in gameWorld.children.toList()) {
//       if (component is Obstacle && component.isForMirroredWorld) {
//         if (_checkRectCollision(mirroredPlayer, component)) {
//           _handleCollision(mirroredPlayer, component);
//         }
//       } else if (component is PowerUp) {
//         if (_checkRectCollision(mirroredPlayer, component)) {
//           gameManager.onPowerUpCollected(component.type);
//           component.removeFromParent();
//         }
//       }
//     }
//   }

//   void _handleCollision(Player player, Obstacle obstacle) {
//     final collisionCenter = Vector2(
//       player.position.x + player.size.x / 2,
//       player.position.y + player.size.y / 2,
//     );

//     final boom = BoomAnimation(
//       position: collisionCenter - Vector2.all(30),
//       maxRadius: 40,
//       color: Colors.red,
//     );

//     gameWorld.add(boom);

//     FlameAudio.play('bomb.mp3', volume: 0.8);

//     _vibrate();

//     if (player.isPoweredUp) {
//       player.registerPowerUpHit();
//     } else {
//       gameState.decreaseLife();
//     }

//     obstacle.removeFromParent();
//   }

//   Future<void> _vibrate() async {
//     try {
//       if (!kIsWeb) {
//         if (await Vibration.hasVibrator()) {
//           Vibration.vibrate(duration: 100);
//         }
//       }
//     } catch (e) {
//       debugPrint('Vibration not available: $e');
//     }
//   }

//   bool _checkRectCollision(PositionComponent a, PositionComponent b) {
//     return a.position.x < b.position.x + b.size.x &&
//         a.position.x + a.size.x > b.position.x &&
//         a.position.y < b.position.y + b.size.y &&
//         a.position.y + a.size.y > b.position.y;
//   }

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);

//     final linePaint =
//         Paint()
//           ..color = Colors.white
//           ..strokeWidth = 2;

//     canvas.drawLine(
//       Offset(size.x / 2, 0),
//       Offset(size.x / 2, size.y),
//       linePaint,
//     );

//     // Render time slowdown indicator if active
//     if (gameManager.isTimeSlowdownActive) {
//       final timeLeft =
//           gameManager.timeSlowdownDuration - gameManager.timeSlowdownTimer;
//       final indicatorPaint =
//           Paint()
//             ..color = Colors.cyan.withOpacity(0.3)
//             ..style = PaintingStyle.fill;

//       canvas.drawRect(Rect.fromLTWH(10, 10, 200, 20), indicatorPaint);

//       final borderPaint =
//           Paint()
//             ..color = Colors.cyan
//             ..style = PaintingStyle.stroke
//             ..strokeWidth = 2;

//       canvas.drawRect(Rect.fromLTWH(10, 10, 200, 20), borderPaint);

//       final progressWidth = 200 * (timeLeft / gameManager.timeSlowdownDuration);
//       final progressPaint = Paint()..color = Colors.cyan;

//       canvas.drawRect(Rect.fromLTWH(10, 10, progressWidth, 20), progressPaint);

//       final textStyle = TextStyle(
//         color: Colors.white,
//         fontSize: 12,
//         fontWeight: FontWeight.bold,
//       );

//       final textSpan = TextSpan(
//         text: 'SLOW TIME: ${timeLeft.toStringAsFixed(1)}s',
//         style: textStyle,
//       );

//       final textPainter = TextPainter(
//         text: textSpan,
//         textDirection: TextDirection.ltr,
//       );

//       textPainter.layout();
//       textPainter.paint(canvas, Offset(15, 12));
//     }
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'dart:math';
import 'package:mirror_world_runner/providers/game_state.dart';
import 'package:mirror_world_runner/game/components/player.dart';
import 'package:mirror_world_runner/game/components/obstacle.dart';
import 'package:mirror_world_runner/game/components/powerup.dart';
import 'package:mirror_world_runner/game/components/boom_animation.dart';
import 'package:mirror_world_runner/game/managers/game_manager.dart';
import 'package:mirror_world_runner/game/game_world.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MirrorWorldGame extends FlameGame
    with HasCollisionDetection, TapDetector {
  final GameState gameState;
  final Function(String)? onPowerUpCollected;
  late GameWorld gameWorld;
  late Player normalPlayer;
  late Player mirroredPlayer;
  late GameManager gameManager;
  final Random random = Random();

  late Vector2 gameSize;

  double _scoreTimer = 0;
  final double _scoreInterval = 0.1;
  double _targetDx = 0;
  double _targetDy = 0;
  double _moveSpeed = 400.0;

  MirrorWorldGame({
    required this.gameState,
    double initialSpeed = 400.0,
    this.onPowerUpCollected,
  }) {
    _moveSpeed = initialSpeed;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await FlameAudio.audioCache.loadAll(['bomb.mp3']);

    gameWorld = GameWorld();
    add(gameWorld);

    gameSize = size;

    normalPlayer = Player(
      isMirrored: false,
      gameSize: gameSize,
      position: Vector2(100, gameSize.y / 2),
      size: Vector2(50, 50),
    );
    gameWorld.add(normalPlayer);

    mirroredPlayer = Player(
      isMirrored: true,
      gameSize: gameSize,
      position: Vector2(gameSize.x - 150, gameSize.y / 2),
      size: Vector2(50, 50),
    );
    gameWorld.add(mirroredPlayer);

    gameManager = GameManager(
      world: gameWorld,
      gameSize: gameSize,
      onPlayerHit: () {
        gameState.decreaseLife();
      },
      onPowerUpCollected: (PowerUpType type) {
        if (type == PowerUpType.extraLife) {
          if (gameState.lives < 5) {
            gameState.increaseLife();
          }
          // Notify game screen about heart collection
          onPowerUpCollected?.call('heart');
        } else if (type == PowerUpType.timeSlowdown) {
          gameManager.activateTimeSlowdown();
        } else {
          normalPlayer.activatePowerUp();
          mirroredPlayer.activatePowerUp();
          // Notify game screen about star collection
          onPowerUpCollected?.call('star');
        }
      },
    );
    add(gameManager);
  }

  void setMovement(double dx, double dy, [double? speed]) {
    _targetDx = dx;
    _targetDy = dy;
    if (speed != null) {
      _moveSpeed = speed;
    }
  }

  @override
  void onTap() {
    if (gameState.isPaused) {
      gameState.togglePause();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameState.isPaused && !gameState.isGameOver) {
      _scoreTimer += dt;
      if (_scoreTimer >= _scoreInterval) {
        gameState.incrementScore(1);
        _scoreTimer = 0;
      }

      _applySmoothMovement(dt);

      normalPlayer.updatePowerUp(dt);
      mirroredPlayer.updatePowerUp(dt);

      _checkCollisions();
    }
  }

  void _applySmoothMovement(double dt) {
    if (_targetDx != 0 || _targetDy != 0) {
      final moveDistance = _moveSpeed * dt;
      final moveX = _targetDx * moveDistance;
      final moveY = _targetDy * moveDistance;

      _movePlayer(normalPlayer, moveX, moveY);
      _movePlayer(mirroredPlayer, moveX, moveY);
    }
  }

  void _movePlayer(Player player, double dx, double dy) {
    double newX = player.position.x + dx;
    double newY = player.position.y + dy;

    if (player.isMirrored) {
      newX = newX.clamp(gameSize.x / 2, gameSize.x - player.size.x);
    } else {
      newX = newX.clamp(0, (gameSize.x / 2) - player.size.x);
    }

    newY = newY.clamp(0, gameSize.y - player.size.y);

    player.position = Vector2(newX, newY);
  }

  void _checkCollisions() {
    for (final component in gameWorld.children.toList()) {
      if (component is Obstacle && !component.isForMirroredWorld) {
        if (_checkRectCollision(normalPlayer, component)) {
          _handleCollision(normalPlayer, component);
        }
      } else if (component is PowerUp) {
        if (_checkRectCollision(normalPlayer, component)) {
          gameManager.onPowerUpCollected(component.type);
          component.removeFromParent();
        }
      }
    }

    for (final component in gameWorld.children.toList()) {
      if (component is Obstacle && component.isForMirroredWorld) {
        if (_checkRectCollision(mirroredPlayer, component)) {
          _handleCollision(mirroredPlayer, component);
        }
      } else if (component is PowerUp) {
        if (_checkRectCollision(mirroredPlayer, component)) {
          gameManager.onPowerUpCollected(component.type);
          component.removeFromParent();
        }
      }
    }
  }

  void _handleCollision(Player player, Obstacle obstacle) {
    final collisionCenter = Vector2(
      player.position.x + player.size.x / 2,
      player.position.y + player.size.y / 2,
    );

    final boom = BoomAnimation(
      position: collisionCenter - Vector2.all(30),
      maxRadius: 40,
      color: Colors.red,
    );

    gameWorld.add(boom);

    FlameAudio.play('bomb.mp3', volume: 0.8);

    _vibrate();

    if (player.isPoweredUp) {
      player.registerPowerUpHit();
    } else {
      gameState.decreaseLife();
    }

    obstacle.removeFromParent();
  }

  Future<void> _vibrate() async {
    try {
      if (!kIsWeb) {
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 100);
        }
      }
    } catch (e) {
      debugPrint('Vibration not available: $e');
    }
  }

  bool _checkRectCollision(PositionComponent a, PositionComponent b) {
    return a.position.x < b.position.x + b.size.x &&
        a.position.x + a.size.x > b.position.x &&
        a.position.y < b.position.y + b.size.y &&
        a.position.y + a.size.y > b.position.y;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final linePaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2;

    canvas.drawLine(
      Offset(size.x / 2, 0),
      Offset(size.x / 2, size.y),
      linePaint,
    );

    // Render time slowdown indicator if active
    if (gameManager.isTimeSlowdownActive) {
      final timeLeft =
          gameManager.timeSlowdownDuration - gameManager.timeSlowdownTimer;
      final indicatorPaint =
          Paint()
            ..color = Colors.cyan.withOpacity(0.3)
            ..style = PaintingStyle.fill;

      canvas.drawRect(Rect.fromLTWH(10, 10, 200, 20), indicatorPaint);

      final borderPaint =
          Paint()
            ..color = Colors.cyan
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;

      canvas.drawRect(Rect.fromLTWH(10, 10, 200, 20), borderPaint);

      final progressWidth = 200 * (timeLeft / gameManager.timeSlowdownDuration);
      final progressPaint = Paint()..color = Colors.cyan;

      canvas.drawRect(Rect.fromLTWH(10, 10, progressWidth, 20), progressPaint);

      final textStyle = TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      );

      final textSpan = TextSpan(
        text: 'SLOW TIME: ${timeLeft.toStringAsFixed(1)}s',
        style: textStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(15, 12));
    }
  }
}
