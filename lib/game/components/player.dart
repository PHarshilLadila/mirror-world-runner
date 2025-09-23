// ignore_for_file: deprecated_member_use

import 'package:flame/components.dart';

class Player extends SpriteComponent with HasGameRef {
  final bool isMirrored;
  final Vector2 gameSize;

  Player({
    required this.isMirrored,
    required this.gameSize,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size * 1);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player.png');
    size = size * 1;
  }

  void moveUp() {
    if (position.y > 0) {
      position.y -= 10;
    }
  }

  void moveDown() {
    if (position.y < gameSize.y - size.y) {
      position.y += 10;
    }
  }

  void moveLeft() {
    if (position.x > 0) {
      position.x -= 10;
    }
  }

  void moveRight() {
    if (isMirrored) {
      if (position.x < gameSize.x - size.x) {
        position.x += 10;
      }
    } else {
      if (position.x < (gameSize.x / 2) - size.x) {
        position.x += 10;
      }
    }
  }
}
