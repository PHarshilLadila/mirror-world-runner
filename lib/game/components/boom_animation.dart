// ignore_for_file: deprecated_member_use

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BoomAnimation extends PositionComponent {
  final double maxRadius;
  final Color color;
  double currentRadius = 0;
  final double expansionSpeed = 200.0;

  BoomAnimation({
    required Vector2 position,
    required this.maxRadius,
    this.color = Colors.red,
  }) : super(position: position, size: Vector2.all(maxRadius * 2));

  @override
  void update(double dt) {
    super.update(dt);
    currentRadius += expansionSpeed * dt;

    if (currentRadius >= maxRadius) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (currentRadius <= maxRadius) {
      final progress = currentRadius / maxRadius;

      final outerOpacity = (1.0 - progress).clamp(0.0, 1.0);
      final paint =
          Paint()
            ..color = color.withOpacity(outerOpacity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.0;

      canvas.drawCircle(Offset(size.x / 2, size.y / 2), currentRadius, paint);

      final innerOpacity = (0.8 - progress).clamp(0.0, 0.8);
      final innerPaint =
          Paint()
            ..color = Colors.white.withOpacity(innerOpacity)
            ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(size.x / 2, size.y / 2),
        currentRadius * 0.5,
        innerPaint,
      );
    }
  }
}
