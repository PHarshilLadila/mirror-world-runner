// // // ignore_for_file: prefer_final_fields

// // import 'package:flame/components.dart';
// // import 'package:flame/game.dart';
// // import 'package:flame/input.dart';
// // import 'package:flutter/material.dart';
// // import 'package:vibration/vibration.dart';
// // import 'dart:math';
// // import 'package:mirror_world_runner/providers/game_state.dart';
// // import 'package:mirror_world_runner/game/components/player.dart';
// // import 'package:mirror_world_runner/game/components/obstacle.dart';
// // import 'package:mirror_world_runner/game/components/powerup.dart';
// // import 'package:mirror_world_runner/game/components/boom_animation.dart';
// // import 'package:mirror_world_runner/game/managers/game_manager.dart';
// // import 'package:mirror_world_runner/game/game_world.dart';

// // class MirrorWorldGame extends FlameGame
// //     with HasCollisionDetection, TapDetector {
// //   final GameState gameState;
// //   late GameWorld gameWorld;
// //   late Player normalPlayer;
// //   late Player mirroredPlayer;
// //   late GameManager gameManager;
// //   final Random random = Random();

// //   late Vector2 gameSize;

// //   double _scoreTimer = 0;
// //   double _scoreInterval = 0.1;
// //   double _targetDx = 0;
// //   double _targetDy = 0;
// //   double _moveSpeed = 400.0;

// //   MirrorWorldGame({required this.gameState});

// //   @override
// //   Future<void> onLoad() async {
// //     await super.onLoad();

// //     gameWorld = GameWorld();
// //     add(gameWorld);

// //     gameSize = size;

// //     normalPlayer = Player(
// //       isMirrored: false,
// //       gameSize: gameSize,
// //       position: Vector2(100, gameSize.y / 2),
// //       size: Vector2(50, 50),
// //     );
// //     gameWorld.add(normalPlayer);

// //     mirroredPlayer = Player(
// //       isMirrored: true,
// //       gameSize: gameSize,
// //       position: Vector2(gameSize.x - 150, gameSize.y / 2),
// //       size: Vector2(50, 50),
// //     );
// //     gameWorld.add(mirroredPlayer);

// //     gameManager = GameManager(
// //       world: gameWorld,
// //       gameSize: gameSize,
// //       onPlayerHit: () {
// //         gameState.decreaseLife();
// //       },
// //       onPowerUpCollected: (PowerUpType type) {
// //         switch (type) {
// //           case PowerUpType.speedBoost:
// //             break;
// //           case PowerUpType.shield:
// //             break;
// //           case PowerUpType.scoreMultiplier:
// //             gameState.incrementScore(100);
// //             break;
// //         }
// //       },
// //     );
// //     add(gameManager);
// //   }

// //   void setMovement(double dx, double dy, double speed) {
// //     _targetDx = dx;
// //     _targetDy = dy;
// //     _moveSpeed = speed;
// //   }

// //   @override
// //   void onTap() {
// //     if (gameState.isPaused) {
// //       gameState.togglePause();
// //     }
// //   }

// //   @override
// //   void update(double dt) {
// //     super.update(dt);

// //     if (!gameState.isPaused && !gameState.isGameOver) {
// //       _scoreTimer += dt;
// //       if (_scoreTimer >= _scoreInterval) {
// //         gameState.incrementScore(1);
// //         _scoreTimer = 0;
// //       }

// //       _applySmoothMovement(dt);

// //       _checkCollisions();
// //     }
// //   }

// //   void _applySmoothMovement(double dt) {
// //     if (_targetDx != 0 || _targetDy != 0) {
// //       final moveDistance = _moveSpeed * dt;
// //       final moveX = _targetDx * moveDistance;
// //       final moveY = _targetDy * moveDistance;

// //       _movePlayer(normalPlayer, moveX, moveY);

// //       _movePlayer(mirroredPlayer, moveX, moveY);
// //     }
// //   }

// //   void _movePlayer(Player player, double dx, double dy) {
// //     double newX = player.position.x + dx;
// //     double newY = player.position.y + dy;

// //     if (player.isMirrored) {
// //       newX = newX.clamp(gameSize.x / 2, gameSize.x - player.size.x);
// //     } else {
// //       newX = newX.clamp(0, (gameSize.x / 2) - player.size.x);
// //     }

// //     newY = newY.clamp(0, gameSize.y - player.size.y);

// //     player.position = Vector2(newX, newY);
// //   }

// //   void _checkCollisions() {
// //     for (final component in gameWorld.children.toList()) {
// //       if (component is Obstacle && !component.isForMirroredWorld) {
// //         if (_checkRectCollision(normalPlayer, component)) {
// //           _handleCollision(normalPlayer, component);
// //         }
// //       } else if (component is PowerUp) {
// //         if (_checkRectCollision(normalPlayer, component)) {
// //           gameManager.onPowerUpCollected(component.type);
// //           component.removeFromParent();
// //         }
// //       }
// //     }

// //     for (final component in gameWorld.children.toList()) {
// //       if (component is Obstacle && component.isForMirroredWorld) {
// //         if (_checkRectCollision(mirroredPlayer, component)) {
// //           _handleCollision(mirroredPlayer, component);
// //         }
// //       } else if (component is PowerUp) {
// //         if (_checkRectCollision(mirroredPlayer, component)) {
// //           gameManager.onPowerUpCollected(component.type);
// //           component.removeFromParent();
// //         }
// //       }
// //     }
// //   }

// //   void _handleCollision(Player player, Obstacle obstacle) {
// //     final collisionCenter = Vector2(
// //       player.position.x + player.size.x / 2,
// //       player.position.y + player.size.y / 2,
// //     );

// //     final boom = BoomAnimation(
// //       position: collisionCenter - Vector2.all(30),
// //       maxRadius: 40,
// //       color: Colors.red,
// //     );

// //     gameWorld.add(boom);

// //     Vibration.vibrate(duration: 100);

// //     gameState.decreaseLife();
// //     obstacle.removeFromParent();
// //   }

// //   bool _checkRectCollision(PositionComponent a, PositionComponent b) {
// //     return a.position.x < b.position.x + b.size.x &&
// //         a.position.x + a.size.x > b.position.x &&
// //         a.position.y < b.position.y + b.size.y &&
// //         a.position.y + a.size.y > b.position.y;
// //   }

// //   @override
// //   void render(Canvas canvas) {
// //     super.render(canvas);

// //     final linePaint =
// //         Paint()
// //           ..color = Colors.white
// //           ..strokeWidth = 2;

// //     canvas.drawLine(
// //       Offset(size.x / 2, 0),
// //       Offset(size.x / 2, size.y),
// //       linePaint,
// //     );
// //   }
// // }
// // ignore_for_file: prefer_final_fields

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
//   double _scoreInterval = 0.1;
//   double _targetDx = 0;
//   double _targetDy = 0;
//   double _moveSpeed = 400.0;

//   MirrorWorldGame({required this.gameState, double initialSpeed = 400.0}) {
//     _moveSpeed = initialSpeed;
//   }

//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();

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
//         switch (type) {
//           case PowerUpType.speedBoost:
//             break;
//           case PowerUpType.shield:
//             break;
//           case PowerUpType.scoreMultiplier:
//             gameState.incrementScore(100);
//             break;
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

//       gameWorld.add(boom);

//     Vibration.vibrate(duration: 100);

//     gameState.decreaseLife();
//     obstacle.removeFromParent();
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
//   }
// }
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
import 'package:flame_audio/flame_audio.dart'; // Add this import

class MirrorWorldGame extends FlameGame
    with HasCollisionDetection, TapDetector {
  final GameState gameState;
  late GameWorld gameWorld;
  late Player normalPlayer;
  late Player mirroredPlayer;
  late GameManager gameManager;
  final Random random = Random();

  late Vector2 gameSize;

  double _scoreTimer = 0;
  double _scoreInterval = 0.1;
  double _targetDx = 0;
  double _targetDy = 0;
  double _moveSpeed = 400.0;

  MirrorWorldGame({required this.gameState, double initialSpeed = 400.0}) {
    _moveSpeed = initialSpeed;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load sound effects
    await FlameAudio.audioCache.loadAll([
      'bomb.mp3',
      // 'powerup.mp3'
    ]);

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
        switch (type) {
          case PowerUpType.speedBoost:
            break;
          case PowerUpType.shield:
            break;
          case PowerUpType.scoreMultiplier:
            gameState.incrementScore(100);
            // Play powerup sound
            // FlameAudio.play('powerup.mp3', volume: 0.7);
            break;
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

    // Play explosion sound
    FlameAudio.play('bomb.mp3', volume: 0.8);

    Vibration.vibrate(duration: 100);

    gameState.decreaseLife();
    obstacle.removeFromParent();
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
  }
}
