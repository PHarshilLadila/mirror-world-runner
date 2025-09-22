// import 'package:flame/components.dart';

// class Obstacle extends SpriteComponent with HasGameRef {
//   final bool isForMirroredWorld;
//   final double speed;

//   Obstacle({
//     required Vector2 position,
//     required Vector2 size,
//     required this.isForMirroredWorld,
//     required this.speed,
//   }) : super(position: position, size: size);

//   @override
//   Future<void> onLoad() async {
//     sprite = await gameRef.loadSprite('obstacle.png');
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);

//     // Move obstacle from right → left
//     position.x -= speed * dt;

//     // Remove if it goes off screen
//     if (position.x < -size.x) {
//       removeFromParent();
//     }
//   }
// }
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Obstacle extends PositionComponent {
  final bool isForMirroredWorld;
  final double speed;
  final Color obstacleColor;

  Obstacle({
    required Vector2 position,
    required Vector2 size,
    required this.isForMirroredWorld,
    required this.speed,
  }) : obstacleColor = isForMirroredWorld ? Colors.purple : Colors.orange,
       super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(size.x / 2, size.y / 2);

    final paint =
        Paint()
          ..color = obstacleColor
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(center.dx, center.dy - size.y / 2);
    path.lineTo(center.dx + size.x / 2, center.dy);
    path.lineTo(center.dx, center.dy + size.y / 2);
    path.lineTo(center.dx - size.x / 2, center.dy);
    path.close();

    canvas.drawPath(path, paint);

    final borderPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    canvas.drawPath(path, borderPaint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;

    if (position.x < -size.x) {
      removeFromParent();
    }
  }
}
