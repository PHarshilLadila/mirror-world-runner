import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

enum PowerUpType { speedBoost, shield, scoreMultiplier, extraLife }

class PowerUp extends PositionComponent {
  final PowerUpType type;
  final double speed;
  final Color powerUpColor;
  double _rotation = 0;

  PowerUp({
    required Vector2 position,
    required Vector2 size,
    required this.type,
    required this.speed,
  }) : powerUpColor = _getColorForType(type),
       super(position: position, size: size) {
    anchor = Anchor.center;
  }

  static Color _getColorForType(PowerUpType type) {
    switch (type) {
      case PowerUpType.speedBoost:
        return Colors.yellow;
      case PowerUpType.shield:
        return Colors.blue;
      case PowerUpType.scoreMultiplier:
        return Colors.green;
      case PowerUpType.extraLife:
        return Colors.red;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;
    _rotation += dt * 2;

    if (position.x < -size.x) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.save();

    final center = Offset(size.x / 2, size.y / 2);
    canvas.translate(center.dx, center.dy);
    canvas.rotate(_rotation);
    canvas.translate(-center.dx, -center.dy);

    if (type == PowerUpType.extraLife) {
      final paint =
          Paint()
            ..color = powerUpColor
            ..style = PaintingStyle.fill;

      final border =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;

      final path = Path();
      final w = size.x;
      final h = size.y;

      path.moveTo(w * 0.5, h * 0.85);
      path.cubicTo(w * 0.1, h * 0.6, w * 0.0, h * 0.35, w * 0.25, h * 0.2);
      path.cubicTo(w * 0.4, h * 0.05, w * 0.5, h * 0.18, w * 0.5, h * 0.3);
      path.cubicTo(w * 0.5, h * 0.18, w * 0.6, h * 0.05, w * 0.75, h * 0.2);
      path.cubicTo(w * 1.0, h * 0.35, w * 0.9, h * 0.6, w * 0.5, h * 0.85);
      path.close();

      canvas.drawPath(path, paint);
      canvas.drawPath(path, border);
    } else {
      final paint =
          Paint()
            ..color = powerUpColor
            ..style = PaintingStyle.fill;

      final borderPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;

      final path = Path();
      final numberOfPoints = 5;
      final outerRadius = size.x / 2;
      final innerRadius = outerRadius / 2;

      final centerLocal = Offset(size.x / 2, size.y / 2);

      for (int i = 0; i < numberOfPoints * 2; i++) {
        double radius = i % 2 == 0 ? outerRadius : innerRadius;
        double angle = pi / numberOfPoints * i;
        double x = centerLocal.dx + radius * cos(angle);
        double y = centerLocal.dy + radius * sin(angle);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      path.close();
      canvas.drawPath(path, paint);
      canvas.drawPath(path, borderPaint);
    }

    canvas.restore();
  }
}
