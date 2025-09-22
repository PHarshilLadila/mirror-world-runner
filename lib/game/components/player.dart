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
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player.png');
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

// import 'package:flame/components.dart';
// import 'package:flutter/material.dart';

// class Player extends PositionComponent {
//   final bool isMirrored;
//   final Vector2 gameSize;
//   final Color playerColor;

//   Player({
//     required this.isMirrored,
//     required this.gameSize,
//     required Vector2 position,
//     required Vector2 size,
//   }) : playerColor = isMirrored ? Colors.blue : Colors.green,
//        super(position: position, size: size);

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);

//     // Draw player as a circle with a border
//     final center = Offset(size.x / 2, size.y / 2);
//     final radius = size.x / 2;

//     // Outer circle
//     final outerPaint =
//         Paint()
//           ..color = playerColor
//           ..style = PaintingStyle.fill;

//     canvas.drawCircle(center, radius, outerPaint);

//     // Inner circle
//     final innerPaint =
//         Paint()
//           ..color = Colors.white
//           ..style = PaintingStyle.fill;

//     canvas.drawCircle(center, radius * 0.6, innerPaint);

//     // Direction indicator
//     final directionPaint =
//         Paint()
//           ..color = playerColor
//           ..style = PaintingStyle.fill;

//     final path = Path();
//     path.moveTo(center.dx + radius * 0.7, center.dy);
//     path.lineTo(center.dx - radius * 0.2, center.dy - radius * 0.5);
//     path.lineTo(center.dx - radius * 0.2, center.dy + radius * 0.5);
//     path.close();

//     canvas.drawPath(path, directionPaint);
//   }
// }
