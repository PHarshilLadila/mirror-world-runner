// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/scheduler.dart';

class GameLoadingWidget extends StatefulWidget {
  final double width;
  final double height;

  const GameLoadingWidget({super.key, this.width = 200, this.height = 200});

  @override
  State<GameLoadingWidget> createState() => _GameLoadingWidgetState();
}

class _GameLoadingWidgetState extends State<GameLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController rotationController;
  late Ticker particleTicker;
  final List<_LoadingParticle> particles = [];
  Duration lastElapsed = Duration.zero;
  final int particleCount = 30;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < particleCount; i++) {
      particles.add(_LoadingParticle());
    }

    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    particleTicker = createTicker((elapsed) {
      final dt = (elapsed - lastElapsed).inMicroseconds / 1e6;
      lastElapsed = elapsed;

      for (var p in particles) {
        p.update(dt, widget.width, widget.height);
      }

      if (mounted) setState(() {});
    });

    particleTicker.start();
  }

  @override
  void dispose() {
    rotationController.dispose();
    particleTicker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(widget.width, widget.height),
            painter: _ParticlePainter(particles),
          ),

          RotationTransition(
            turns: rotationController,
            child: Container(
              width: widget.width * 0.4,
              height: widget.width * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Colors.cyanAccent,
                    Colors.blueAccent,
                    Colors.purpleAccent,
                    Colors.cyanAccent,
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.6),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingParticle {
  double x;
  double y;
  double radius;
  double speedX;
  double speedY;
  Color color;

  _LoadingParticle()
    : x = math.Random().nextDouble() * 200,
      y = math.Random().nextDouble() * 200,
      radius = math.Random().nextDouble() * 3 + 1,
      speedX = (math.Random().nextDouble() - 0.5) * 50,
      speedY = (math.Random().nextDouble() - 0.5) * 50,
      color = Colors.primaries[math.Random().nextInt(Colors.primaries.length)]
          .withOpacity(0.6);

  void update(double dt, double width, double height) {
    x += speedX * dt;
    y += speedY * dt;

    if (x < 0 || x > width) speedX = -speedX;
    if (y < 0 || y > height) speedY = -speedY;
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_LoadingParticle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var p in particles) {
      paint.color = p.color;
      canvas.drawCircle(Offset(p.x, p.y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
