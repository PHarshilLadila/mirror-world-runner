// ignore_for_file: deprecated_member_use

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Obstacle extends PositionComponent {
  final bool isForMirroredWorld;
  double speed;
  final Color bodyColor;
  double originalSpeed;

  late Timer fireTimer;
  final Random random = Random();

  Obstacle({
    required Vector2 position,
    required Vector2 size,
    required this.isForMirroredWorld,
    required this.speed,
  }) : bodyColor = isForMirroredWorld ? Colors.purple : Colors.orange,
       originalSpeed = speed,
       super(position: position, size: size) {
    fireTimer = Timer(0.04, onTick: emitFire, repeat: true);
  }

  void setSpeed(double newSpeed) {
    speed = newSpeed;
  }

  void resetSpeed() {
    speed = originalSpeed;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    fireTimer.start();
  }

  void emitFire() {
    final firePosition = Vector2(position.x + size.x, position.y + size.y / 2);

    parent?.add(
      ParticleSystemComponent(
        position: firePosition,
        particle: Particle.generate(
          count: 5,
          generator: (i) {
            final baseColor =
                [
                  Colors.red,
                  Colors.deepOrange,
                  Colors.orange,
                  Colors.yellow,
                ][random.nextInt(4)];

            return AcceleratedParticle(
              lifespan: 0.5 + random.nextDouble() * 0.3,
              acceleration: Vector2(0, -20),
              speed: Vector2(
                -50 - random.nextDouble() * 50,
                (random.nextDouble() - 0.5) * 60,
              ),
              child: ComputedParticle(
                renderer: (canvas, particle) {
                  final t = particle.progress;
                  final radius = (1 - t) * (random.nextDouble() * 12 + 6);

                  final paint =
                      Paint()
                        ..shader = RadialGradient(
                          colors: [
                            baseColor.withOpacity(0.9 - t * 0.6),
                            Colors.transparent,
                          ],
                        ).createShader(
                          Rect.fromCircle(center: Offset.zero, radius: radius),
                        );

                  canvas.drawCircle(Offset.zero, radius, paint);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;

    fireTimer.update(dt);

    if (position.x < -size.x) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    final bodyPaint = Paint()..color = bodyColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      bodyPaint,
    );

    final borderPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      borderPaint,
    );

    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;
    final eyeRadius = size.y * 0.15;

    canvas.drawCircle(Offset(size.x * 0.3, size.y * 0.3), eyeRadius, eyePaint);
    canvas.drawCircle(
      Offset(size.x * 0.3, size.y * 0.3),
      eyeRadius * 0.5,
      pupilPaint,
    );

    canvas.drawCircle(Offset(size.x * 0.3, size.y * 0.7), eyeRadius, eyePaint);
    canvas.drawCircle(
      Offset(size.x * 0.3, size.y * 0.7),
      eyeRadius * 0.5,
      pupilPaint,
    );

    final mouthPaint = Paint()..color = Colors.black;
    final mouthRect = Rect.fromLTWH(
      size.x * 0.65,
      size.y * 0.35,
      size.x * 0.25,
      size.y * 0.3,
    );
    canvas.drawRect(mouthRect, mouthPaint);

    final teethPaint = Paint()..color = Colors.white;
    for (int i = 0; i < 3; i++) {
      final toothPath = Path();
      final tx = mouthRect.left + i * (mouthRect.width / 3);
      toothPath.moveTo(tx, mouthRect.top);
      toothPath.lineTo(
        tx + mouthRect.width / 6,
        mouthRect.top + mouthRect.height / 2,
      );
      toothPath.lineTo(tx + mouthRect.width / 3, mouthRect.top);
      toothPath.close();
      canvas.drawPath(toothPath, teethPaint);
    }
  }
}
