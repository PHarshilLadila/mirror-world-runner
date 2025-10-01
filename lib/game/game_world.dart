// ignore_for_file: deprecated_member_use

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';

import 'package:flutter/material.dart';

class GameWorld extends Component with HasGameRef {
  final List<Vector2> _stars = [];
  final Random _random = Random();
  final dotsNumbers = kIsWeb ? 130 : 80;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    for (int i = 0; i < dotsNumbers; i++) {
      _stars.add(
        Vector2(
          _random.nextDouble() * gameRef.size.x,
          _random.nextDouble() * gameRef.size.y,
        ),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final backgroundPaint = Paint()..color = Color(0xFF1a1a2e);
    canvas.drawRect(
      Rect.fromLTWH(
        gameRef.size.x,
        gameRef.size.y,
        gameRef.size.x,
        gameRef.size.y,
      ),
      backgroundPaint,
    );

    final mirroredBackgroundPaint = Paint()..color = Color(0xFF16213e);
    canvas.drawRect(
      Rect.fromLTWH(gameRef.size.x / 2, 0, gameRef.size.x / 2, gameRef.size.y),
      mirroredBackgroundPaint,
    );

    final starPaint = Paint()..color = Colors.white.withOpacity(0.7);
    for (final star in _stars) {
      canvas.drawCircle(Offset(star.x, star.y), 1.5, starPaint);
    }

    final gridPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..strokeWidth = 1.0;

    for (double x = 0; x < gameRef.size.x; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, gameRef.size.y), gridPaint);
    }

    for (double y = 0; y < gameRef.size.y; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(gameRef.size.x, y), gridPaint);
    }
  }
}
