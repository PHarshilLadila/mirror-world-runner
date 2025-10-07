// ignore_for_file: deprecated_member_use

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';

import 'package:flutter/material.dart';

class GameWorld extends Component with HasGameRef {
  final List<Vector2> stars = [];
  final Random random = Random();
  final dotsNumbers = kIsWeb ? 130 : 80;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    for (int i = 0; i < dotsNumbers; i++) {
      stars.add(
        Vector2(
          random.nextDouble() * gameRef.size.x,
          random.nextDouble() * gameRef.size.y,
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
    for (final star in stars) {
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

// // // // // // // ignore_for_file: deprecated_member_use

// // // // // // import 'package:flame/components.dart';
// // // // // // import 'dart:math';
// // // // // // import 'package:flutter/material.dart';

// // // // // // class GameWorld extends Component with HasGameRef {
// // // // // //   final Random random = Random();
// // // // // //   final int treesCount = 25;
// // // // // //   final int birdsCount = 8;
// // // // // //   final int cloudsCount = 6;
// // // // // //   final int flowersCount = 40;
// // // // // //   final int grassBladesCount = 100;

// // // // // //   final List<Vector2> trees = [];
// // // // // //   final List<Map<String, dynamic>> birds = [];
// // // // // //   final List<Map<String, dynamic>> clouds = [];
// // // // // //   final List<Map<String, dynamic>> flowers = [];
// // // // // //   final List<Map<String, dynamic>> grass = [];

// // // // // //   @override
// // // // // //   Future<void> onLoad() async {
// // // // // //     super.onLoad();

// // // // // //     // Initialize trees with different sizes
// // // // // //     for (int i = 0; i < treesCount; i++) {
// // // // // //       trees.add(
// // // // // //         Vector2(
// // // // // //           random.nextDouble() * gameRef.size.x,
// // // // // //           gameRef.size.y - 80 - random.nextDouble() * 50,
// // // // // //         ),
// // // // // //       );
// // // // // //     }

// // // // // //     // Initialize birds with position and animation properties
// // // // // //     for (int i = 0; i < birdsCount; i++) {
// // // // // //       birds.add({
// // // // // //         'position': Vector2(
// // // // // //           random.nextDouble() * gameRef.size.x,
// // // // // //           50 + random.nextDouble() * 150,
// // // // // //         ),
// // // // // //         'speed': 0.5 + random.nextDouble() * 1.5,
// // // // // //         'wingState': 0.0,
// // // // // //         'direction': random.nextBool() ? 1 : -1,
// // // // // //       });
// // // // // //     }

// // // // // //     // Initialize clouds
// // // // // //     for (int i = 0; i < cloudsCount; i++) {
// // // // // //       clouds.add({
// // // // // //         'position': Vector2(
// // // // // //           random.nextDouble() * gameRef.size.x,
// // // // // //           30 + random.nextDouble() * 80,
// // // // // //         ),
// // // // // //         'speed': 0.1 + random.nextDouble() * 0.3,
// // // // // //         'size': 40 + random.nextDouble() * 40,
// // // // // //       });
// // // // // //     }

// // // // // //     // Initialize flowers with fixed colors
// // // // // //     for (int i = 0; i < flowersCount; i++) {
// // // // // //       flowers.add({
// // // // // //         'position': Vector2(
// // // // // //           random.nextDouble() * gameRef.size.x,
// // // // // //           gameRef.size.y - 20 - random.nextDouble() * 30,
// // // // // //         ),
// // // // // //         'color': _getRandomFlowerColor(),
// // // // // //       });
// // // // // //     }

// // // // // //     // Initialize grass blades
// // // // // //     for (int i = 0; i < grassBladesCount; i++) {
// // // // // //       grass.add({
// // // // // //         'position': Vector2(
// // // // // //           random.nextDouble() * gameRef.size.x,
// // // // // //           gameRef.size.y - 15 + random.nextDouble() * 10,
// // // // // //         ),
// // // // // //         'height': 10 + random.nextDouble() * 20,
// // // // // //         'sway': random.nextDouble() * pi,
// // // // // //       });
// // // // // //     }
// // // // // //   }

// // // // // //   @override
// // // // // //   void update(double dt) {
// // // // // //     super.update(dt);

// // // // // //     // Update bird animation and movement
// // // // // //     for (final bird in birds) {
// // // // // //       bird['position'].x += bird['speed'] * bird['direction'];
// // // // // //       bird['wingState'] = (bird['wingState'] + dt * 8) % (2 * pi);

// // // // // //       // Wrap birds around screen
// // // // // //       if (bird['position'].x > gameRef.size.x + 20) {
// // // // // //         bird['position'].x = -20;
// // // // // //       } else if (bird['position'].x < -20) {
// // // // // //         bird['position'].x = gameRef.size.x + 20;
// // // // // //       }
// // // // // //     }

// // // // // //     // Update cloud movement
// // // // // //     for (final cloud in clouds) {
// // // // // //       cloud['position'].x += cloud['speed'];
// // // // // //       if (cloud['position'].x > gameRef.size.x + cloud['size'] * 2) {
// // // // // //         cloud['position'].x = -cloud['size'] * 2;
// // // // // //       }
// // // // // //     }

// // // // // //     // Update grass swaying
// // // // // //     for (final blade in grass) {
// // // // // //       blade['sway'] = (blade['sway'] + dt * 2) % (2 * pi);
// // // // // //     }
// // // // // //   }

// // // // // //   @override
// // // // // //   void render(Canvas canvas) {
// // // // // //     super.render(canvas);

// // // // // //     // Draw sky gradient
// // // // // //     final skyGradient = LinearGradient(
// // // // // //       begin: Alignment.topCenter,
// // // // // //       end: Alignment.bottomCenter,
// // // // // //       colors: [Color(0xFF87CEEB), Color(0xFF98D8E8)],
// // // // // //     );
// // // // // //     final skyPaint =
// // // // // //         Paint()
// // // // // //           ..shader = skyGradient.createShader(
// // // // // //             Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
// // // // // //           );
// // // // // //     canvas.drawRect(
// // // // // //       Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
// // // // // //       skyPaint,
// // // // // //     );

// // // // // //     // Draw sun
// // // // // //     final sunPaint = Paint()..color = Color(0xFFFFEB3B);
// // // // // //     canvas.drawCircle(Offset(gameRef.size.x * 0.8, 70), 35, sunPaint);

// // // // // //     // Draw clouds
// // // // // //     for (final cloud in clouds) {
// // // // // //       _drawCloud(
// // // // // //         canvas,
// // // // // //         cloud['position'].x,
// // // // // //         cloud['position'].y,
// // // // // //         cloud['size'],
// // // // // //       );
// // // // // //     }

// // // // // //     // Draw distant mountains
// // // // // //     _drawMountains(canvas);

// // // // // //     // Draw birds
// // // // // //     for (final bird in birds) {
// // // // // //       _drawBird(
// // // // // //         canvas,
// // // // // //         bird['position'].x,
// // // // // //         bird['position'].y,
// // // // // //         bird['wingState'],
// // // // // //         bird['direction'],
// // // // // //       );
// // // // // //     }

// // // // // //     // Draw ground
// // // // // //     final groundPaint = Paint()..color = Color(0xFF8BC34A);
// // // // // //     canvas.drawRect(
// // // // // //       Rect.fromLTWH(0, gameRef.size.y - 50, gameRef.size.x, 50),
// // // // // //       groundPaint,
// // // // // //     );

// // // // // //     // Draw grass blades
// // // // // //     for (final blade in grass) {
// // // // // //       _drawGrassBlade(
// // // // // //         canvas,
// // // // // //         blade['position'].x,
// // // // // //         blade['position'].y,
// // // // // //         blade['height'],
// // // // // //         blade['sway'],
// // // // // //       );
// // // // // //     }

// // // // // //     // Draw flowers with fixed colors
// // // // // //     for (final flower in flowers) {
// // // // // //       _drawFlower(
// // // // // //         canvas,
// // // // // //         flower['position'].x,
// // // // // //         flower['position'].y,
// // // // // //         flower['color'],
// // // // // //       );
// // // // // //     }

// // // // // //     // Draw trees
// // // // // //     for (final tree in trees) {
// // // // // //       _drawTree(canvas, tree.x, tree.y);
// // // // // //     }

// // // // // //     // Draw mirrored side (forest continues)
// // // // // //     final mirroredForestPaint =
// // // // // //         Paint()..color = Color(0xFF7CB342).withOpacity(0.8);
// // // // // //     canvas.drawRect(
// // // // // //       Rect.fromLTWH(
// // // // // //         gameRef.size.x / 2,
// // // // // //         gameRef.size.y - 50,
// // // // // //         gameRef.size.x / 2,
// // // // // //         50,
// // // // // //       ),
// // // // // //       mirroredForestPaint,
// // // // // //     );
// // // // // //   }

// // // // // //   void _drawCloud(Canvas canvas, double x, double y, double size) {
// // // // // //     final cloudPaint = Paint()..color = Colors.white.withOpacity(0.9);

// // // // // //     canvas.drawCircle(Offset(x, y), size * 0.6, cloudPaint);
// // // // // //     canvas.drawCircle(
// // // // // //       Offset(x + size * 0.5, y - size * 0.2),
// // // // // //       size * 0.5,
// // // // // //       cloudPaint,
// // // // // //     );
// // // // // //     canvas.drawCircle(Offset(x + size * 0.9, y), size * 0.6, cloudPaint);
// // // // // //     canvas.drawCircle(
// // // // // //       Offset(x + size * 0.3, y + size * 0.2),
// // // // // //       size * 0.5,
// // // // // //       cloudPaint,
// // // // // //     );
// // // // // //     canvas.drawCircle(
// // // // // //       Offset(x + size * 0.7, y + size * 0.2),
// // // // // //       size * 0.5,
// // // // // //       cloudPaint,
// // // // // //     );
// // // // // //   }

// // // // // //   void _drawBird(
// // // // // //     Canvas canvas,
// // // // // //     double x,
// // // // // //     double y,
// // // // // //     double wingState,
// // // // // //     int direction,
// // // // // //   ) {
// // // // // //     final birdPaint = Paint()..color = Color(0xFF37474F);

// // // // // //     // Bird body
// // // // // //     canvas.drawCircle(Offset(x, y), 4, birdPaint);

// // // // // //     // Wings - animated
// // // // // //     final wingHeight = sin(wingState) * 3;
// // // // // //     final path = Path();
// // // // // //     path.moveTo(x, y);
// // // // // //     path.quadraticBezierTo(
// // // // // //       x - 8 * direction,
// // // // // //       y - 6 + wingHeight,
// // // // // //       x - 12 * direction,
// // // // // //       y - 2,
// // // // // //     );
// // // // // //     path.quadraticBezierTo(x - 8 * direction, y + 2, x, y);
// // // // // //     canvas.drawPath(path, birdPaint);

// // // // // //     // Tail
// // // // // //     final tailPath = Path();
// // // // // //     tailPath.moveTo(x + 4 * direction, y);
// // // // // //     tailPath.quadraticBezierTo(
// // // // // //       x + 8 * direction,
// // // // // //       y - 3,
// // // // // //       x + 6 * direction,
// // // // // //       y - 1,
// // // // // //     );
// // // // // //     canvas.drawPath(tailPath, birdPaint);
// // // // // //   }

// // // // // //   void _drawTree(Canvas canvas, double x, double y) {
// // // // // //     final trunkPaint = Paint()..color = Color(0xFF5D4037);
// // // // // //     final leavesPaint = Paint()..color = Color(0xFF2E7D32);

// // // // // //     // Draw trunk
// // // // // //     canvas.drawRect(
// // // // // //       Rect.fromCenter(center: Offset(x, y - 15), width: 8, height: 30),
// // // // // //       trunkPaint,
// // // // // //     );

// // // // // //     // Draw leaves (multiple circles for natural look)
// // // // // //     canvas.drawCircle(Offset(x, y - 35), 20, leavesPaint);
// // // // // //     canvas.drawCircle(Offset(x - 15, y - 30), 18, leavesPaint);
// // // // // //     canvas.drawCircle(Offset(x + 15, y - 30), 18, leavesPaint);
// // // // // //     canvas.drawCircle(Offset(x, y - 50), 15, leavesPaint);
// // // // // //   }

// // // // // //   void _drawFlower(Canvas canvas, double x, double y, Color color) {
// // // // // //     final stemPaint =
// // // // // //         Paint()
// // // // // //           ..color = Color(0xFF388E3C)
// // // // // //           ..strokeWidth = 1.5;

// // // // // //     final petalPaint = Paint()..color = color;
// // // // // //     final centerPaint = Paint()..color = Color(0xFFFFEB3B);

// // // // // //     // Draw stem
// // // // // //     canvas.drawLine(Offset(x, y), Offset(x, y - 15), stemPaint);

// // // // // //     // Draw petals
// // // // // //     for (int i = 0; i < 5; i++) {
// // // // // //       final angle = i * 2 * pi / 5;
// // // // // //       final petalX = x + cos(angle) * 6;
// // // // // //       final petalY = y - 15 + sin(angle) * 6;
// // // // // //       canvas.drawCircle(Offset(petalX, petalY), 4, petalPaint);
// // // // // //     }

// // // // // //     // Draw center
// // // // // //     canvas.drawCircle(Offset(x, y - 15), 3, centerPaint);
// // // // // //   }

// // // // // //   void _drawGrassBlade(
// // // // // //     Canvas canvas,
// // // // // //     double x,
// // // // // //     double y,
// // // // // //     double height,
// // // // // //     double sway,
// // // // // //   ) {
// // // // // //     final grassPaint =
// // // // // //         Paint()
// // // // // //           ..color = Color(0xFF4CAF50)
// // // // // //           ..strokeWidth = 1.2;

// // // // // //     final swayOffset = sin(sway) * 3;
// // // // // //     canvas.drawLine(
// // // // // //       Offset(x, y),
// // // // // //       Offset(x + swayOffset, y - height),
// // // // // //       grassPaint,
// // // // // //     );
// // // // // //   }

// // // // // //   void _drawMountains(Canvas canvas) {
// // // // // //     final mountainPaint = Paint()..color = Color(0xFF78909C).withOpacity(0.6);
// // // // // //     final path = Path();

// // // // // //     path.moveTo(0, gameRef.size.y - 100);

// // // // // //     // Create mountain peaks
// // // // // //     for (double x = 0; x < gameRef.size.x; x += 40) {
// // // // // //       final peakHeight = 80 + sin(x * 0.02) * 30 + cos(x * 0.015) * 20;
// // // // // //       path.lineTo(x, gameRef.size.y - 150 - peakHeight);
// // // // // //     }

// // // // // //     path.lineTo(gameRef.size.x, gameRef.size.y - 100);
// // // // // //     path.lineTo(gameRef.size.x, gameRef.size.y);
// // // // // //     path.lineTo(0, gameRef.size.y);
// // // // // //     path.close();

// // // // // //     canvas.drawPath(path, mountainPaint);
// // // // // //   }

// // // // // //   Color _getRandomFlowerColor() {
// // // // // //     final colors = [
// // // // // //       Color(0xFFE91E63), // Pink
// // // // // //       Color(0xFF9C27B0), // Purple
// // // // // //       Color(0xFF2196F3), // Blue
// // // // // //       Color(0xFF4CAF50), // Green
// // // // // //       Color(0xFFFF9800), // Orange
// // // // // //       Color(0xFFF44336), // Red
// // // // // //     ];
// // // // // //     return colors[random.nextInt(colors.length)];
// // // // // //   }
// // // // // // }

// // // // // // ignore_for_file: deprecated_member_use

// // // // // import 'package:flame/components.dart';
// // // // // import 'package:flutter/foundation.dart';
// // // // // import 'dart:math';
// // // // // import 'package:flutter/material.dart';

// // // // // class GameWorld extends Component with HasGameRef {
// // // // //   final Random random = Random();
// // // // //   final int treesCount = 20;
// // // // //   final int birdsCount = 6;
// // // // //   final int cloudsCount = 5;
// // // // //   final int flowersCount = 35;
// // // // //   final int grassBladesCount = 80;
// // // // //   final int butterfliesCount = 4;

// // // // //   final List<Map<String, dynamic>> trees = [];
// // // // //   final List<Map<String, dynamic>> birds = [];
// // // // //   final List<Map<String, dynamic>> clouds = [];
// // // // //   final List<Map<String, dynamic>> flowers = [];
// // // // //   final List<Map<String, dynamic>> grass = [];
// // // // //   final List<Map<String, dynamic>> butterflies = [];
// // // // //   double sunGlow = 0.0;

// // // // //   @override
// // // // //   Future<void> onLoad() async {
// // // // //     super.onLoad();
// // // // //     _initializeElements();
// // // // //   }

// // // // //   void _initializeElements() {
// // // // //     // Trees
// // // // //     for (int i = 0; i < treesCount; i++) {
// // // // //       trees.add({
// // // // //         'position': Vector2(
// // // // //           random.nextDouble() * gameRef.size.x,
// // // // //           gameRef.size.y - 60 - random.nextDouble() * 40,
// // // // //         ),
// // // // //         'size': 0.8 + random.nextDouble() * 0.4,
// // // // //       });
// // // // //     }

// // // // //     // Birds
// // // // //     for (int i = 0; i < birdsCount; i++) {
// // // // //       birds.add({
// // // // //         'position': Vector2(
// // // // //           random.nextDouble() * gameRef.size.x,
// // // // //           80 + random.nextDouble() * 120,
// // // // //         ),
// // // // //         'speed': 0.8 + random.nextDouble() * 1.2,
// // // // //         'wingState': random.nextDouble() * 2 * pi,
// // // // //         'direction': random.nextBool() ? 1 : -1,
// // // // //       });
// // // // //     }

// // // // //     // Clouds
// // // // //     for (int i = 0; i < cloudsCount; i++) {
// // // // //       clouds.add({
// // // // //         'position': Vector2(
// // // // //           random.nextDouble() * gameRef.size.x,
// // // // //           40 + random.nextDouble() * 60,
// // // // //         ),
// // // // //         'speed': 0.2 + random.nextDouble() * 0.2,
// // // // //         'size': 30 + random.nextDouble() * 25,
// // // // //       });
// // // // //     }

// // // // //     // Flowers
// // // // //     for (int i = 0; i < flowersCount; i++) {
// // // // //       flowers.add({
// // // // //         'position': Vector2(
// // // // //           random.nextDouble() * gameRef.size.x,
// // // // //           gameRef.size.y - 25 - random.nextDouble() * 20,
// // // // //         ),
// // // // //         'color': _getFlowerColor(),
// // // // //         'sway': random.nextDouble() * pi,
// // // // //       });
// // // // //     }

// // // // //     // Grass
// // // // //     for (int i = 0; i < grassBladesCount; i++) {
// // // // //       grass.add({
// // // // //         'position': Vector2(
// // // // //           random.nextDouble() * gameRef.size.x,
// // // // //           gameRef.size.y - 20 + random.nextDouble() * 8,
// // // // //         ),
// // // // //         'height': 12 + random.nextDouble() * 18,
// // // // //         'sway': random.nextDouble() * pi,
// // // // //         'thickness': 0.8 + random.nextDouble() * 0.6,
// // // // //       });
// // // // //     }

// // // // //     // Butterflies
// // // // //     for (int i = 0; i < butterfliesCount; i++) {
// // // // //       butterflies.add({
// // // // //         'position': Vector2(
// // // // //           random.nextDouble() * gameRef.size.x,
// // // // //           150 + random.nextDouble() * 100,
// // // // //         ),
// // // // //         'speed': 0.3 + random.nextDouble() * 0.4,
// // // // //         'wingState': random.nextDouble() * 2 * pi,
// // // // //         'color': _getButterflyColor(),
// // // // //         'direction': random.nextBool() ? 1 : -1,
// // // // //       });
// // // // //     }
// // // // //   }

// // // // //   @override
// // // // //   void update(double dt) {
// // // // //     super.update(dt);

// // // // //     // Sun glow animation
// // // // //     sunGlow = (sunGlow + dt * 0.5) % (2 * pi);

// // // // //     // Update birds
// // // // //     for (final bird in birds) {
// // // // //       bird['position'].x += bird['speed'] * bird['direction'];
// // // // //       bird['wingState'] = (bird['wingState'] + dt * 6) % (2 * pi);
// // // // //       if (bird['position'].x > gameRef.size.x + 25) bird['position'].x = -25;
// // // // //       if (bird['position'].x < -25) bird['position'].x = gameRef.size.x + 25;
// // // // //     }

// // // // //     // Update clouds
// // // // //     for (final cloud in clouds) {
// // // // //       cloud['position'].x += cloud['speed'];
// // // // //       if (cloud['position'].x > gameRef.size.x + cloud['size'] * 2) {
// // // // //         cloud['position'].x = -cloud['size'] * 2;
// // // // //       }
// // // // //     }

// // // // //     // Update grass and flowers sway
// // // // //     for (final blade in grass) {
// // // // //       blade['sway'] = (blade['sway'] + dt * 1.5) % (2 * pi);
// // // // //     }
// // // // //     for (final flower in flowers) {
// // // // //       flower['sway'] = (flower['sway'] + dt * 1.2) % (2 * pi);
// // // // //     }

// // // // //     // Update butterflies
// // // // //     for (final butterfly in butterflies) {
// // // // //       butterfly['position'].x += butterfly['speed'] * butterfly['direction'];
// // // // //       butterfly['position'].y += sin(butterfly['wingState']) * 0.5;
// // // // //       butterfly['wingState'] = (butterfly['wingState'] + dt * 10) % (2 * pi);
// // // // //       if (butterfly['position'].x > gameRef.size.x + 15)
// // // // //         butterfly['position'].x = -15;
// // // // //       if (butterfly['position'].x < -15)
// // // // //         butterfly['position'].x = gameRef.size.x + 15;
// // // // //     }
// // // // //   }

// // // // //   @override
// // // // //   void render(Canvas canvas) {
// // // // //     super.render(canvas);

// // // // //     // Sky gradient
// // // // //     final skyGradient = RadialGradient(
// // // // //       center: Alignment(0.3, -0.6),
// // // // //       radius: 1.5,
// // // // //       colors: [Color(0xFF64B5F6), Color(0xFFBBDEFB), Color(0xFFE3F2FD)],
// // // // //     );
// // // // //     final skyPaint =
// // // // //         Paint()
// // // // //           ..shader = skyGradient.createShader(
// // // // //             Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
// // // // //           );
// // // // //     canvas.drawRect(
// // // // //       Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
// // // // //       skyPaint,
// // // // //     );

// // // // //     // Sun with glow
// // // // //     final sunGlowSize = 50 + sin(sunGlow) * 5;
// // // // //     final sunGlowPaint = Paint()..color = Color(0xFFFFF176).withOpacity(0.3);
// // // // //     canvas.drawCircle(Offset(100, 100), sunGlowSize, sunGlowPaint);

// // // // //     final sunPaint = Paint()..color = Color(0xFFFFF59D);
// // // // //     canvas.drawCircle(Offset(100, 100), 35, sunPaint);

// // // // //     // Clouds
// // // // //     for (final cloud in clouds) {
// // // // //       _drawSoftCloud(
// // // // //         canvas,
// // // // //         cloud['position'].x,
// // // // //         cloud['position'].y,
// // // // //         cloud['size'],
// // // // //       );
// // // // //     }

// // // // //     // Distant hills
// // // // //     _drawHills(canvas);

// // // // //     // Birds
// // // // //     for (final bird in birds) {
// // // // //       _drawSmoothBird(
// // // // //         canvas,
// // // // //         bird['position'].x,
// // // // //         bird['position'].y,
// // // // //         bird['wingState'],
// // // // //         bird['direction'],
// // // // //       );
// // // // //     }

// // // // //     // Butterflies
// // // // //     for (final butterfly in butterflies) {
// // // // //       _drawButterfly(
// // // // //         canvas,
// // // // //         butterfly['position'].x,
// // // // //         butterfly['position'].y,
// // // // //         butterfly['wingState'],
// // // // //         butterfly['color'],
// // // // //       );
// // // // //     }

// // // // //     // Ground
// // // // //     final groundGradient = LinearGradient(
// // // // //       begin: Alignment.topCenter,
// // // // //       end: Alignment.bottomCenter,
// // // // //       colors: [Color(0xFF81C784), Color(0xFF66BB6A), Color(0xFF4CAF50)],
// // // // //     );
// // // // //     final groundPaint =
// // // // //         Paint()
// // // // //           ..shader = groundGradient.createShader(
// // // // //             Rect.fromLTWH(0, gameRef.size.y - 60, gameRef.size.x, 60),
// // // // //           );
// // // // //     canvas.drawRect(
// // // // //       Rect.fromLTWH(0, gameRef.size.y - 60, gameRef.size.x, 60),
// // // // //       groundPaint,
// // // // //     );

// // // // //     // Grass
// // // // //     for (final blade in grass) {
// // // // //       _drawGrassBlade(
// // // // //         canvas,
// // // // //         blade['position'].x,
// // // // //         blade['position'].y,
// // // // //         blade['height'],
// // // // //         blade['sway'],
// // // // //         blade['thickness'],
// // // // //       );
// // // // //     }

// // // // //     // Flowers
// // // // //     for (final flower in flowers) {
// // // // //       _drawFlower(
// // // // //         canvas,
// // // // //         flower['position'].x,
// // // // //         flower['position'].y,
// // // // //         flower['color'],
// // // // //         flower['sway'],
// // // // //       );
// // // // //     }

// // // // //     // Trees
// // // // //     for (final tree in trees) {
// // // // //       _drawSmoothTree(
// // // // //         canvas,
// // // // //         tree['position'].x,
// // // // //         tree['position'].y,
// // // // //         tree['size'],
// // // // //       );
// // // // //     }
// // // // //   }

// // // // //   void _drawSoftCloud(Canvas canvas, double x, double y, double size) {
// // // // //     final cloudPaint = Paint()..color = Colors.white.withOpacity(0.95);

// // // // //     canvas.drawCircle(Offset(x, y), size * 0.5, cloudPaint);
// // // // //     canvas.drawCircle(
// // // // //       Offset(x + size * 0.4, y - size * 0.15),
// // // // //       size * 0.45,
// // // // //       cloudPaint,
// // // // //     );
// // // // //     canvas.drawCircle(Offset(x + size * 0.75, y), size * 0.5, cloudPaint);
// // // // //     canvas.drawCircle(
// // // // //       Offset(x + size * 0.25, y + size * 0.15),
// // // // //       size * 0.4,
// // // // //       cloudPaint,
// // // // //     );
// // // // //     canvas.drawCircle(
// // // // //       Offset(x + size * 0.6, y + size * 0.15),
// // // // //       size * 0.4,
// // // // //       cloudPaint,
// // // // //     );
// // // // //   }

// // // // //   void _drawSmoothBird(
// // // // //     Canvas canvas,
// // // // //     double x,
// // // // //     double y,
// // // // //     double wingState,
// // // // //     int direction,
// // // // //   ) {
// // // // //     final birdPaint = Paint()..color = Color(0xFF455A64);
// // // // //     final wingOffset = sin(wingState) * 4;

// // // // //     // Smooth body (ellipse)
// // // // //     canvas.drawOval(
// // // // //       Rect.fromCenter(center: Offset(x, y), width: 10, height: 6),
// // // // //       birdPaint,
// // // // //     );

// // // // //     // Head
// // // // //     canvas.drawCircle(Offset(x + 4 * direction, y), 3, birdPaint);

// // // // //     // Wing
// // // // //     final wingPath = Path();
// // // // //     wingPath.moveTo(x, y);
// // // // //     wingPath.quadraticBezierTo(
// // // // //       x - 6 * direction,
// // // // //       y - 4 + wingOffset,
// // // // //       x - 3 * direction,
// // // // //       y + 2,
// // // // //     );
// // // // //     wingPath.close();
// // // // //     canvas.drawPath(wingPath, birdPaint);
// // // // //   }

// // // // //   void _drawSmoothTree(Canvas canvas, double x, double y, double size) {
// // // // //     final trunkPaint = Paint()..color = Color(0xFF6D4C41);
// // // // //     final leavesPaint = Paint()..color = Color(0xFF388E3C);

// // // // //     // Trunk with slight curve
// // // // //     final trunkPath = Path();
// // // // //     trunkPath.moveTo(x - 4 * size, y);
// // // // //     trunkPath.quadraticBezierTo(x - 2 * size, y - 40 * size, x, y - 60 * size);
// // // // //     trunkPath.quadraticBezierTo(x + 2 * size, y - 40 * size, x + 4 * size, y);
// // // // //     trunkPath.close();
// // // // //     canvas.drawPath(trunkPath, trunkPaint);

// // // // //     // Leaves cluster
// // // // //     canvas.drawCircle(Offset(x, y - 75 * size), 25 * size, leavesPaint);
// // // // //     canvas.drawCircle(
// // // // //       Offset(x - 18 * size, y - 65 * size),
// // // // //       22 * size,
// // // // //       leavesPaint,
// // // // //     );
// // // // //     canvas.drawCircle(
// // // // //       Offset(x + 18 * size, y - 65 * size),
// // // // //       22 * size,
// // // // //       leavesPaint,
// // // // //     );
// // // // //     canvas.drawCircle(Offset(x, y - 90 * size), 20 * size, leavesPaint);
// // // // //   }

// // // // //   void _drawFlower(
// // // // //     Canvas canvas,
// // // // //     double x,
// // // // //     double y,
// // // // //     Color color,
// // // // //     double sway,
// // // // //   ) {
// // // // //     final swayOffset = sin(sway) * 2;
// // // // //     final stemPaint =
// // // // //         Paint()
// // // // //           ..color = Color(0xFF388E3C)
// // // // //           ..strokeWidth = 1.2;

// // // // //     final petalPaint = Paint()..color = color;
// // // // //     final centerPaint = Paint()..color = Color(0xFFFFF59D);

// // // // //     // Stem with slight curve
// // // // //     canvas.drawLine(
// // // // //       Offset(x, y),
// // // // //       Offset(x + swayOffset * 0.3, y - 18),
// // // // //       stemPaint,
// // // // //     );

// // // // //     // Petals
// // // // //     for (int i = 0; i < 6; i++) {
// // // // //       final angle = i * 2 * pi / 6;
// // // // //       final petalX = x + swayOffset + cos(angle) * 5;
// // // // //       final petalY = y - 18 + sin(angle) * 5;
// // // // //       canvas.drawCircle(Offset(petalX, petalY), 3, petalPaint);
// // // // //     }

// // // // //     // Center
// // // // //     canvas.drawCircle(Offset(x + swayOffset, y - 18), 2.5, centerPaint);
// // // // //   }

// // // // //   void _drawGrassBlade(
// // // // //     Canvas canvas,
// // // // //     double x,
// // // // //     double y,
// // // // //     double height,
// // // // //     double sway,
// // // // //     double thickness,
// // // // //   ) {
// // // // //     final swayOffset = sin(sway) * 4;
// // // // //     final grassPaint =
// // // // //         Paint()
// // // // //           ..color = Color(0xFF4CAF50)
// // // // //           ..strokeWidth = thickness;

// // // // //     // Curved grass blade
// // // // //     final path = Path();
// // // // //     path.moveTo(x, y);
// // // // //     path.quadraticBezierTo(
// // // // //       x + swayOffset * 0.7,
// // // // //       y - height * 0.3,
// // // // //       x + swayOffset,
// // // // //       y - height,
// // // // //     );
// // // // //     canvas.drawPath(path, grassPaint);
// // // // //   }

// // // // //   void _drawButterfly(
// // // // //     Canvas canvas,
// // // // //     double x,
// // // // //     double y,
// // // // //     double wingState,
// // // // //     Color color,
// // // // //   ) {
// // // // //     final wingSpread = (sin(wingState) + 1) * 0.5; // 0 to 1
// // // // //     final wingHeight = 3 + wingSpread * 4;

// // // // //     final bodyPaint = Paint()..color = Color(0xFF5D4037);
// // // // //     final wingPaint = Paint()..color = color;

// // // // //     // Body
// // // // //     canvas.drawOval(
// // // // //       Rect.fromCenter(center: Offset(x, y), width: 6, height: 2),
// // // // //       bodyPaint,
// // // // //     );

// // // // //     // Upper wings
// // // // //     canvas.drawOval(
// // // // //       Rect.fromCenter(
// // // // //         center: Offset(x - 4, y - 2),
// // // // //         width: 8,
// // // // //         height: wingHeight,
// // // // //       ),
// // // // //       wingPaint,
// // // // //     );
// // // // //     canvas.drawOval(
// // // // //       Rect.fromCenter(
// // // // //         center: Offset(x + 4, y - 2),
// // // // //         width: 8,
// // // // //         height: wingHeight,
// // // // //       ),
// // // // //       wingPaint,
// // // // //     );

// // // // //     // Lower wings (smaller)
// // // // //     canvas.drawOval(
// // // // //       Rect.fromCenter(
// // // // //         center: Offset(x - 3, y + 1),
// // // // //         width: 6,
// // // // //         height: wingHeight * 0.7,
// // // // //       ),
// // // // //       wingPaint,
// // // // //     );
// // // // //     canvas.drawOval(
// // // // //       Rect.fromCenter(
// // // // //         center: Offset(x + 3, y + 1),
// // // // //         width: 6,
// // // // //         height: wingHeight * 0.7,
// // // // //       ),
// // // // //       wingPaint,
// // // // //     );
// // // // //   }

// // // // //   void _drawHills(Canvas canvas) {
// // // // //     final hillPaint = Paint()..color = Color(0xFF689F38).withOpacity(0.4);
// // // // //     final path = Path();

// // // // //     path.moveTo(0, gameRef.size.y - 80);
// // // // //     for (double x = 0; x < gameRef.size.x; x += 20) {
// // // // //       final height = 60 + sin(x * 0.01) * 25 + cos(x * 0.008) * 15;
// // // // //       path.lineTo(x, gameRef.size.y - 140 - height);
// // // // //     }
// // // // //     path.lineTo(gameRef.size.x, gameRef.size.y - 80);
// // // // //     path.lineTo(gameRef.size.x, gameRef.size.y);
// // // // //     path.lineTo(0, gameRef.size.y);
// // // // //     path.close();

// // // // //     canvas.drawPath(path, hillPaint);
// // // // //   }

// // // // //   Color _getFlowerColor() {
// // // // //     final colors = [
// // // // //       Color(0xFFE91E63),
// // // // //       Color(0xFF9C27B0),
// // // // //       Color(0xFF2196F3),
// // // // //       Color(0xFF4CAF50),
// // // // //       Color(0xFFFF9800),
// // // // //       Color(0xFFF44336),
// // // // //       Color(0xFFAB47BC),
// // // // //       Color(0xFFEC407A),
// // // // //     ];
// // // // //     return colors[random.nextInt(colors.length)];
// // // // //   }

// // // // //   Color _getButterflyColor() {
// // // // //     final colors = [
// // // // //       Color(0xFFE91E63),
// // // // //       Color(0xFF9C27B0),
// // // // //       Color(0xFF2196F3),
// // // // //       Color(0xFFFF9800),
// // // // //       Color(0xFFAB47BC),
// // // // //     ];
// // // // //     return colors[random.nextInt(colors.length)];
// // // // //   }
// // // // // }

// // // // // ignore_for_file: deprecated_member_use

// // // // import 'package:flame/components.dart';
// // // // import 'package:flutter/foundation.dart';
// // // // import 'dart:math';
// // // // import 'package:flutter/material.dart';

// // // // class GameWorld extends Component with HasGameRef {
// // // //   final Random random = Random();
// // // //   final int buildingsCount = 45;
// // // //   final int starsCount = 100;
// // // //   final int carsCount = 8;
// // // //   final int windowsCount = 60;

// // // //   final List<Map<String, dynamic>> buildings = [];
// // // //   final List<Vector2> stars = [];
// // // //   final List<Map<String, dynamic>> cars = [];
// // // //   final List<Map<String, dynamic>> windows = [];
// // // //   final List<Map<String, dynamic>> neonSigns = [];
// // // //   double time = 0.0;

// // // //   @override
// // // //   Future<void> onLoad() async {
// // // //     super.onLoad();
// // // //     _initializeElements();
// // // //   }

// // // //   void _initializeElements() {
// // // //     // Stars
// // // //     for (int i = 0; i < starsCount; i++) {
// // // //       stars.add(
// // // //         Vector2(
// // // //           random.nextDouble() * gameRef.size.x,
// // // //           random.nextDouble() * gameRef.size.y * 0.6,
// // // //         ),
// // // //       );
// // // //     }

// // // //     // Buildings
// // // //     double xPos = 0;
// // // //     for (int i = 0; i < buildingsCount; i++) {
// // // //       final buildingWidth = 40 + random.nextDouble() * 50;
// // // //       final buildingHeight = 120 + random.nextDouble() * 180;

// // // //       buildings.add({
// // // //         'position': Vector2(xPos, gameRef.size.y - buildingHeight),
// // // //         'size': Vector2(buildingWidth, buildingHeight),
// // // //         'color': _getBuildingColor(),
// // // //         'neonColor': _getNeonColor(),
// // // //       });

// // // //       // Add windows to this building
// // // //       final windowsInBuilding = 2 + random.nextInt(6);
// // // //       for (int j = 0; j < windowsInBuilding; j++) {
// // // //         windows.add({
// // // //           'position': Vector2(
// // // //             xPos + 5 + random.nextDouble() * (buildingWidth - 10),
// // // //             gameRef.size.y -
// // // //                 buildingHeight +
// // // //                 10 +
// // // //                 random.nextDouble() * (buildingHeight - 40),
// // // //           ),
// // // //           'lit': random.nextDouble() > 0.3,
// // // //           'flicker': random.nextDouble(),
// // // //         });
// // // //       }

// // // //       // Add neon signs to some buildings
// // // //       if (random.nextDouble() > 0.5) {
// // // //         neonSigns.add({
// // // //           'position': Vector2(
// // // //             xPos + buildingWidth / 2,
// // // //             gameRef.size.y - buildingHeight - 10,
// // // //           ),
// // // //           'color': _getNeonColor(),
// // // //           'size': buildingWidth * 0.8,
// // // //         });
// // // //       }

// // // //       xPos += buildingWidth + 5;
// // // //     }

// // // //     // Cars
// // // //     for (int i = 0; i < carsCount; i++) {
// // // //       cars.add({
// // // //         'position': Vector2(
// // // //           random.nextDouble() * gameRef.size.x,
// // // //           gameRef.size.y - 25,
// // // //         ),
// // // //         'speed': 1.5 + random.nextDouble() * 2,
// // // //         'color': _getCarColor(),
// // // //         'direction': random.nextBool() ? 1 : -1,
// // // //       });
// // // //     }
// // // //   }

// // // //   @override
// // // //   void update(double dt) {
// // // //     super.update(dt);
// // // //     time += dt;

// // // //     // Update cars
// // // //     for (final car in cars) {
// // // //       car['position'].x += car['speed'] * car['direction'];
// // // //       if (car['position'].x > gameRef.size.x + 30) car['position'].x = -30;
// // // //       if (car['position'].x < -30) car['position'].x = gameRef.size.x + 30;
// // // //     }

// // // //     // Randomly toggle some windows
// // // //     for (final window in windows) {
// // // //       if (random.nextDouble() < 0.01) {
// // // //         window['lit'] = !window['lit'];
// // // //       }
// // // //     }
// // // //   }

// // // //   @override
// // // //   void render(Canvas canvas) {
// // // //     super.render(canvas);

// // // //     // Night sky gradient
// // // //     final skyGradient = LinearGradient(
// // // //       begin: Alignment.topCenter,
// // // //       end: Alignment.bottomCenter,
// // // //       colors: [Color(0xFF0A0A2A), Color(0xFF1A1A4A), Color(0xFF2D2D5A)],
// // // //     );
// // // //     final skyPaint =
// // // //         Paint()
// // // //           ..shader = skyGradient.createShader(
// // // //             Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
// // // //           );
// // // //     canvas.drawRect(
// // // //       Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
// // // //       skyPaint,
// // // //     );

// // // //     // Stars with twinkling
// // // //     final starPaint = Paint()..color = Colors.white;
// // // //     for (final star in stars) {
// // // //       final twinkle = 0.7 + sin(time * 3 + star.x) * 0.3;
// // // //       starPaint.color = Colors.white.withOpacity(twinkle);
// // // //       canvas.drawCircle(Offset(star.x, star.y), 1.2, starPaint);
// // // //     }

// // // //     // Moon
// // // //     final moonPaint = Paint()..color = Color(0xFFE0E0E0);
// // // //     final moonGlowPaint = Paint()..color = Color(0xFFE0E0E0).withOpacity(0.2);
// // // //     canvas.drawCircle(Offset(gameRef.size.x - 80, 80), 25, moonGlowPaint);
// // // //     canvas.drawCircle(Offset(gameRef.size.x - 80, 80), 20, moonPaint);

// // // //     // Buildings
// // // //     for (final building in buildings) {
// // // //       _drawBuilding(
// // // //         canvas,
// // // //         building['position'].x,
// // // //         building['position'].y,
// // // //         building['size'].x,
// // // //         building['size'].y,
// // // //         building['color'],
// // // //       );
// // // //     }

// // // //     // Windows
// // // //     for (final window in windows) {
// // // //       if (window['lit']) {
// // // //         _drawWindow(
// // // //           canvas,
// // // //           window['position'].x,
// // // //           window['position'].y,
// // // //           window['flicker'],
// // // //         );
// // // //       }
// // // //     }

// // // //     // Neon signs
// // // //     for (final neon in neonSigns) {
// // // //       _drawNeonSign(
// // // //         canvas,
// // // //         neon['position'].x,
// // // //         neon['position'].y,
// // // //         neon['color'],
// // // //         neon['size'],
// // // //       );
// // // //     }

// // // //     // Road
// // // //     final roadPaint = Paint()..color = Color(0xFF333333);
// // // //     canvas.drawRect(
// // // //       Rect.fromLTWH(0, gameRef.size.y - 20, gameRef.size.x, 20),
// // // //       roadPaint,
// // // //     );

// // // //     // Road markings
// // // //     final markingPaint = Paint()..color = Color(0xFFFFD600);
// // // //     for (double x = 0; x < gameRef.size.x; x += 40) {
// // // //       canvas.drawRect(
// // // //         Rect.fromLTWH(x, gameRef.size.y - 10, 20, 2),
// // // //         markingPaint,
// // // //       );
// // // //     }

// // // //     // Cars
// // // //     for (final car in cars) {
// // // //       _drawCar(
// // // //         canvas,
// // // //         car['position'].x,
// // // //         car['position'].y,
// // // //         car['color'],
// // // //         car['direction'],
// // // //       );
// // // //     }

// // // //     // Car headlights/taillights
// // // //     for (final car in cars) {
// // // //       _drawCarLights(
// // // //         canvas,
// // // //         car['position'].x,
// // // //         car['position'].y,
// // // //         car['direction'],
// // // //       );
// // // //     }
// // // //   }

// // // //   void _drawBuilding(
// // // //     Canvas canvas,
// // // //     double x,
// // // //     double y,
// // // //     double width,
// // // //     double height,
// // // //     Color color,
// // // //   ) {
// // // //     final buildingPaint = Paint()..color = color;
// // // //     final highlightPaint = Paint()..color = color.withOpacity(0.3);

// // // //     // Main building
// // // //     canvas.drawRect(Rect.fromLTWH(x, y, width, height), buildingPaint);

// // // //     // Building highlights
// // // //     canvas.drawRect(Rect.fromLTWH(x + width - 2, y, 2, height), highlightPaint);
// // // //     canvas.drawRect(Rect.fromLTWH(x, y, width, 2), highlightPaint);
// // // //   }

// // // //   void _drawWindow(Canvas canvas, double x, double y, double flicker) {
// // // //     final brightness = 0.7 + sin(time * 5 + flicker * 10) * 0.3;
// // // //     final windowPaint =
// // // //         Paint()..color = Color(0xFFFFF59D).withOpacity(brightness);

// // // //     canvas.drawRect(
// // // //       Rect.fromCenter(center: Offset(x, y), width: 6, height: 8),
// // // //       windowPaint,
// // // //     );
// // // //   }

// // // //   void _drawNeonSign(
// // // //     Canvas canvas,
// // // //     double x,
// // // //     double y,
// // // //     Color color,
// // // //     double size,
// // // //   ) {
// // // //     final neonPaint =
// // // //         Paint()
// // // //           ..color = color
// // // //           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

// // // //     final glowPaint =
// // // //         Paint()
// // // //           ..color = color.withOpacity(0.3)
// // // //           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15);

// // // //     // Glow
// // // //     canvas.drawRect(
// // // //       Rect.fromCenter(center: Offset(x, y), width: size, height: 8),
// // // //       glowPaint,
// // // //     );
// // // //     // Neon tube
// // // //     canvas.drawRect(
// // // //       Rect.fromCenter(center: Offset(x, y), width: size, height: 6),
// // // //       neonPaint,
// // // //     );
// // // //   }

// // // //   void _drawCar(Canvas canvas, double x, double y, Color color, int direction) {
// // // //     final carPaint = Paint()..color = color;
// // // //     final windowPaint = Paint()..color = Color(0xFF1A237E);

// // // //     // Car body
// // // //     canvas.drawRRect(
// // // //       RRect.fromRectAndRadius(
// // // //         Rect.fromCenter(center: Offset(x, y), width: 25, height: 12),
// // // //         Radius.circular(3),
// // // //       ),
// // // //       carPaint,
// // // //     );

// // // //     // Windows
// // // //     canvas.drawRect(
// // // //       Rect.fromCenter(center: Offset(x, y - 2), width: 18, height: 4),
// // // //       windowPaint,
// // // //     );

// // // //     // Wheels
// // // //     final wheelPaint = Paint()..color = Color(0xFF212121);
// // // //     canvas.drawCircle(Offset(x - 7, y + 6), 3, wheelPaint);
// // // //     canvas.drawCircle(Offset(x + 7, y + 6), 3, wheelPaint);
// // // //   }

// // // //   void _drawCarLights(Canvas canvas, double x, double y, int direction) {
// // // //     final lightPaint =
// // // //         Paint()
// // // //           ..color = direction > 0 ? Color(0xFFFF5252) : Color(0xFFFFD740)
// // // //           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

// // // //     final lightX = x + (direction > 0 ? -13 : 13);
// // // //     canvas.drawCircle(Offset(lightX, y), 4, lightPaint);
// // // //   }

// // // //   Color _getBuildingColor() {
// // // //     final colors = [
// // // //       Color(0xFF2C3E50),
// // // //       Color(0xFF34495E),
// // // //       Color(0xFF2C2C2C),
// // // //       Color(0xFF36454F),
// // // //       Color(0xFF424242),
// // // //     ];
// // // //     return colors[random.nextInt(colors.length)];
// // // //   }

// // // //   Color _getNeonColor() {
// // // //     final colors = [
// // // //       Color(0xFFFF00FF),
// // // //       Color(0xFF00FFFF),
// // // //       Color(0xFFFF0000),
// // // //       Color(0xFF00FF00),
// // // //       Color(0xFFFFFF00),
// // // //       Color(0xFFFF00FF),
// // // //     ];
// // // //     return colors[random.nextInt(colors.length)];
// // // //   }

// // // //   Color _getCarColor() {
// // // //     final colors = [
// // // //       Color(0xFFFF0000),
// // // //       Color(0xFF0000FF),
// // // //       Color(0xFF00FF00),
// // // //       Color(0xFFFFFF00),
// // // //       Color(0xFFFF00FF),
// // // //       Color(0xFF00FFFF),
// // // //       Color(0xFFFFFFFF),
// // // //       Color(0xFF888888),
// // // //     ];
// // // //     return colors[random.nextInt(colors.length)];
// // // //   }
// // // // }

// // // // ignore_for_file: deprecated_member_use

// // // import 'package:flame/components.dart';
// // // import 'package:flutter/foundation.dart';
// // // import 'dart:math';
// // // import 'package:flutter/material.dart';

// // // class GameWorld extends Component with HasGameRef {
// // //   final Random random = Random();
// // //   final int rocksCount = 25;
// // //   final int bubblesCount = 15;
// // //   final int particlesCount = 50;

// // //   final List<Map<String, dynamic>> rocks = [];
// // //   final List<Map<String, dynamic>> bubbles = [];
// // //   final List<Map<String, dynamic>> particles = [];
// // //   final List<Map<String, dynamic>> fireFlies = [];
// // //   double lavaFlow = 0.0;
// // //   double time = 0.0;

// // //   @override
// // //   Future<void> onLoad() async {
// // //     super.onLoad();
// // //     _initializeElements();
// // //   }

// // //   void _initializeElements() {
// // //     // Rocks
// // //     for (int i = 0; i < rocksCount; i++) {
// // //       rocks.add({
// // //         'position': Vector2(
// // //           random.nextDouble() * gameRef.size.x,
// // //           gameRef.size.y - 40 - random.nextDouble() * 100,
// // //         ),
// // //         'size': 15 + random.nextDouble() * 25,
// // //         'type': random.nextInt(3),
// // //       });
// // //     }

// // //     // Bubbles in lava
// // //     for (int i = 0; i < bubblesCount; i++) {
// // //       bubbles.add({
// // //         'position': Vector2(
// // //           random.nextDouble() * gameRef.size.x,
// // //           gameRef.size.y + 10,
// // //         ),
// // //         'speed': 0.3 + random.nextDouble() * 0.4,
// // //         'size': 3 + random.nextDouble() * 6,
// // //         'wobble': random.nextDouble() * pi,
// // //       });
// // //     }

// // //     // Fire particles
// // //     for (int i = 0; i < particlesCount; i++) {
// // //       particles.add({
// // //         'position': Vector2(
// // //           random.nextDouble() * gameRef.size.x,
// // //           gameRef.size.y - 20 - random.nextDouble() * 50,
// // //         ),
// // //         'velocity': Vector2(
// // //           (random.nextDouble() - 0.5) * 0.8,
// // //           -1.5 - random.nextDouble() * 1.5,
// // //         ),
// // //         'life': random.nextDouble(),
// // //         'maxLife': 1.0 + random.nextDouble() * 2.0,
// // //         'size': 1 + random.nextDouble() * 3,
// // //       });
// // //     }

// // //     // Fireflies
// // //     for (int i = 0; i < 8; i++) {
// // //       fireFlies.add({
// // //         'position': Vector2(
// // //           random.nextDouble() * gameRef.size.x,
// // //           50 + random.nextDouble() * 150,
// // //         ),
// // //         'speed': Vector2(
// // //           (random.nextDouble() - 0.5) * 0.3,
// // //           (random.nextDouble() - 0.5) * 0.2,
// // //         ),
// // //         'brightness': random.nextDouble(),
// // //         'pulseSpeed': 2 + random.nextDouble() * 3,
// // //       });
// // //     }
// // //   }

// // //   @override
// // //   void update(double dt) {
// // //     super.update(dt);
// // //     time += dt;
// // //     lavaFlow = (lavaFlow + dt * 2) % (2 * pi);

// // //     // Update bubbles
// // //     for (final bubble in bubbles) {
// // //       bubble['position'].y -= bubble['speed'];
// // //       bubble['wobble'] = (bubble['wobble'] + dt * 3) % (2 * pi);
// // //       if (bubble['position'].y < gameRef.size.y - 150) {
// // //         bubble['position'].y = gameRef.size.y + 10;
// // //         bubble['position'].x = random.nextDouble() * gameRef.size.x;
// // //       }
// // //     }

// // //     // Update particles
// // //     for (final particle in particles) {
// // //       particle['position'] += particle['velocity'] * dt * 20;
// // //       particle['life'] += dt;
// // //       particle['velocity'].y += dt * 2; // Gravity

// // //       if (particle['life'] > particle['maxLife'] ||
// // //           particle['position'].y > gameRef.size.y - 20) {
// // //         _resetParticle(particle);
// // //       }
// // //     }

// // //     // Update fireflies
// // //     for (final firefly in fireFlies) {
// // //       firefly['position'] += firefly['speed'] * dt * 30;
// // //       firefly['brightness'] = (sin(time * firefly['pulseSpeed']) + 1) * 0.5;

// // //       // Keep fireflies in bounds with gentle bouncing
// // //       if (firefly['position'].x < 0 || firefly['position'].x > gameRef.size.x) {
// // //         firefly['speed'].x *= -1;
// // //       }
// // //       if (firefly['position'].y < 40 ||
// // //           firefly['position'].y > gameRef.size.y - 60) {
// // //         firefly['speed'].y *= -1;
// // //       }
// // //     }
// // //   }

// // //   void _resetParticle(Map<String, dynamic> particle) {
// // //     particle['position'].setValues(
// // //       random.nextDouble() * gameRef.size.x,
// // //       gameRef.size.y - 20 - random.nextDouble() * 10,
// // //     );
// // //     particle['velocity'].setValues(
// // //       (random.nextDouble() - 0.5) * 0.8,
// // //       -1.5 - random.nextDouble() * 1.5,
// // //     );
// // //     particle['life'] = 0;
// // //     particle['maxLife'] = 1.0 + random.nextDouble() * 2.0;
// // //   }

// // //   @override
// // //   void render(Canvas canvas) {
// // //     super.render(canvas);

// // //     // Dark volcanic sky
// // //     final skyGradient = RadialGradient(
// // //       center: Alignment(0.5, 0.2),
// // //       radius: 1.5,
// // //       colors: [Color(0xFF8B0000), Color(0xFF4A0000), Color(0xFF000000)],
// // //     );
// // //     final skyPaint =
// // //         Paint()
// // //           ..shader = skyGradient.createShader(
// // //             Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
// // //           );
// // //     canvas.drawRect(
// // //       Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
// // //       skyPaint,
// // //     );

// // //     // Distant volcano
// // //     _drawVolcano(canvas);

// // //     // Fireflies
// // //     for (final firefly in fireFlies) {
// // //       _drawFirefly(
// // //         canvas,
// // //         firefly['position'].x,
// // //         firefly['position'].y,
// // //         firefly['brightness'],
// // //       );
// // //     }

// // //     // Lava river with flowing effect
// // //     _drawLavaRiver(canvas);

// // //     // Bubbles
// // //     for (final bubble in bubbles) {
// // //       _drawBubble(
// // //         canvas,
// // //         bubble['position'].x,
// // //         bubble['position'].y,
// // //         bubble['size'],
// // //         bubble['wobble'],
// // //       );
// // //     }

// // //     // Rocks
// // //     for (final rock in rocks) {
// // //       _drawRock(
// // //         canvas,
// // //         rock['position'].x,
// // //         rock['position'].y,
// // //         rock['size'],
// // //         rock['type'],
// // //       );
// // //     }

// // //     // Fire particles
// // //     for (final particle in particles) {
// // //       _drawFireParticle(
// // //         canvas,
// // //         particle['position'].x,
// // //         particle['position'].y,
// // //         particle['size'],
// // //         particle['life'] / particle['maxLife'],
// // //       );
// // //     }

// // //     // Lava glow on rocks
// // //     for (final rock in rocks) {
// // //       _drawLavaGlow(
// // //         canvas,
// // //         rock['position'].x,
// // //         rock['position'].y,
// // //         rock['size'],
// // //       );
// // //     }
// // //   }

// // //   void _drawVolcano(Canvas canvas) {
// // //     final volcanoPaint = Paint()..color = Color(0xFF5D4037);
// // //     final lavaPaint = Paint()..color = Color(0xFFFF5722);

// // //     final path = Path();
// // //     path.moveTo(gameRef.size.x * 0.3, gameRef.size.y - 50);
// // //     path.lineTo(gameRef.size.x * 0.4, gameRef.size.y - 200);
// // //     path.lineTo(gameRef.size.x * 0.6, gameRef.size.y - 200);
// // //     path.lineTo(gameRef.size.x * 0.7, gameRef.size.y - 50);
// // //     path.close();

// // //     canvas.drawPath(path, volcanoPaint);

// // //     // Lava in crater
// // //     final lavaPath = Path();
// // //     lavaPath.moveTo(gameRef.size.x * 0.42, gameRef.size.y - 190);
// // //     lavaPath.lineTo(gameRef.size.x * 0.45, gameRef.size.y - 170);
// // //     lavaPath.lineTo(gameRef.size.x * 0.55, gameRef.size.y - 170);
// // //     lavaPath.lineTo(gameRef.size.x * 0.58, gameRef.size.y - 190);
// // //     lavaPath.close();

// // //     canvas.drawPath(lavaPath, lavaPaint);
// // //   }

// // //   void _drawLavaRiver(Canvas canvas) {
// // //     final lavaGradient = LinearGradient(
// // //       begin: Alignment.topCenter,
// // //       end: Alignment.bottomCenter,
// // //       colors: [
// // //         Color(0xFFFF6D00),
// // //         Color(0xFFFF5722),
// // //         Color(0xFFE65100),
// // //         Color(0xFFFF3D00),
// // //         Color(0xFFDD2C00),
// // //       ],
// // //     );

// // //     final flowOffset = sin(lavaFlow) * 3;
// // //     final lavaPaint =
// // //         Paint()
// // //           ..shader = lavaGradient.createShader(
// // //             Rect.fromLTWH(0, gameRef.size.y - 40, gameRef.size.x, 40),
// // //           );

// // //     // Wavy lava surface
// // //     final path = Path();
// // //     path.moveTo(0, gameRef.size.y - 40);
// // //     for (double x = 0; x < gameRef.size.x; x += 10) {
// // //       final wave = sin(x * 0.05 + lavaFlow) * 2 + flowOffset;
// // //       path.lineTo(x, gameRef.size.y - 40 + wave);
// // //     }
// // //     path.lineTo(gameRef.size.x, gameRef.size.y);
// // //     path.lineTo(0, gameRef.size.y);
// // //     path.close();

// // //     canvas.drawPath(path, lavaPaint);

// // //     // Lava glow
// // //     final glowPaint =
// // //         Paint()
// // //           ..color = Color(0xFFFF5722).withOpacity(0.3)
// // //           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);
// // //     canvas.drawRect(
// // //       Rect.fromLTWH(0, gameRef.size.y - 45, gameRef.size.x, 50),
// // //       glowPaint,
// // //     );
// // //   }

// // //   void _drawRock(Canvas canvas, double x, double y, double size, int type) {
// // //     final rockPaint = Paint()..color = Color(0xFF5D4037);
// // //     final highlightPaint = Paint()..color = Color(0xFF8D6E63);

// // //     // Different rock shapes
// // //     if (type == 0) {
// // //       // Round rock
// // //       canvas.drawCircle(Offset(x, y), size, rockPaint);
// // //       canvas.drawCircle(
// // //         Offset(x - size * 0.3, y - size * 0.3),
// // //         size * 0.4,
// // //         highlightPaint,
// // //       );
// // //     } else if (type == 1) {
// // //       // Angular rock
// // //       final path = Path();
// // //       path.moveTo(x - size, y);
// // //       path.lineTo(x - size * 0.5, y - size);
// // //       path.lineTo(x + size * 0.5, y - size * 0.8);
// // //       path.lineTo(x + size, y);
// // //       path.close();
// // //       canvas.drawPath(path, rockPaint);
// // //     } else {
// // //       // Irregular rock
// // //       canvas.drawOval(
// // //         Rect.fromCenter(center: Offset(x, y), width: size * 2, height: size),
// // //         rockPaint,
// // //       );
// // //     }
// // //   }

// // //   void _drawBubble(
// // //     Canvas canvas,
// // //     double x,
// // //     double y,
// // //     double size,
// // //     double wobble,
// // //   ) {
// // //     final bubblePaint = Paint()..color = Color(0xFFFFEB3B).withOpacity(0.7);
// // //     final highlightPaint = Paint()..color = Colors.white.withOpacity(0.9);

// // //     final wobbleOffset = sin(wobble) * 2;
// // //     canvas.drawCircle(Offset(x + wobbleOffset, y), size, bubblePaint);
// // //     canvas.drawCircle(
// // //       Offset(x + wobbleOffset - size * 0.3, y - size * 0.3),
// // //       size * 0.3,
// // //       highlightPaint,
// // //     );
// // //   }

// // //   void _drawFireParticle(
// // //     Canvas canvas,
// // //     double x,
// // //     double y,
// // //     double size,
// // //     double life,
// // //   ) {
// // //     final alpha = 1.0 - life;
// // //     final particlePaint =
// // //         Paint()
// // //           ..color = Color.fromRGBO(255, 165 - (165 * life).toInt(), 0, alpha);

// // //     canvas.drawCircle(Offset(x, y), size * (1 - life * 0.5), particlePaint);
// // //   }

// // //   void _drawFirefly(Canvas canvas, double x, double y, double brightness) {
// // //     final fireflyPaint =
// // //         Paint()
// // //           ..color = Color(0xFFFFFF00).withOpacity(brightness)
// // //           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

// // //     canvas.drawCircle(Offset(x, y), 2 + brightness * 2, fireflyPaint);
// // //   }

// // //   void _drawLavaGlow(Canvas canvas, double x, double y, double size) {
// // //     final glowPaint =
// // //         Paint()
// // //           ..color = Color(0xFFFF5722).withOpacity(0.2)
// // //           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

// // //     canvas.drawCircle(Offset(x, y), size * 1.5, glowPaint);
// // //   }
// // // }

// // // ignore_for_file: deprecated_member_use

// // import 'package:flame/components.dart';
// // import 'package:flutter/foundation.dart';
// // import 'dart:math';
// // import 'package:flutter/material.dart';

// // class GameWorld extends Component with HasGameRef {
// //   final Random random = Random();
// //   final int iceCrystalsCount = 30;
// //   final int snowflakesCount = 80;
// //   final int northernLightsCount = 3;

// //   final List<Map<String, dynamic>> iceCrystals = [];
// //   final List<Map<String, dynamic>> snowflakes = [];
// //   final List<Map<String, dynamic>> northernLights = [];
// //   final List<Map<String, dynamic>> reflections = [];
// //   double time = 0.0;

// //   @override
// //   Future<void> onLoad() async {
// //     super.onLoad();
// //     _initializeElements();
// //   }

// //   void _initializeElements() {
// //     // Ice crystals on ground
// //     for (int i = 0; i < iceCrystalsCount; i++) {
// //       iceCrystals.add({
// //         'position': Vector2(
// //           random.nextDouble() * gameRef.size.x,
// //           gameRef.size.y - 30 - random.nextDouble() * 25,
// //         ),
// //         'size': 8 + random.nextDouble() * 15,
// //         'rotation': random.nextDouble() * pi,
// //         'type': random.nextInt(2),
// //       });
// //     }

// //     // Snowflakes
// //     for (int i = 0; i < snowflakesCount; i++) {
// //       snowflakes.add({
// //         'position': Vector2(
// //           random.nextDouble() * gameRef.size.x,
// //           random.nextDouble() * gameRef.size.y,
// //         ),
// //         'speed': 0.5 + random.nextDouble() * 1.0,
// //         'size': 1 + random.nextDouble() * 3,
// //         'drift': random.nextDouble() * pi,
// //         'rotation': random.nextDouble() * pi,
// //       });
// //     }

// //     // Northern lights
// //     for (int i = 0; i < northernLightsCount; i++) {
// //       northernLights.add({
// //         'position': Vector2(
// //           random.nextDouble() * gameRef.size.x * 0.3 + i * gameRef.size.x * 0.3,
// //           20 + i * 15,
// //         ),
// //         'phase': random.nextDouble() * pi,
// //         'color': _getAuroraColor(i),
// //       });
// //     }

// //     // Reflection points
// //     for (int i = 0; i < 20; i++) {
// //       reflections.add({
// //         'position': Vector2(
// //           random.nextDouble() * gameRef.size.x,
// //           gameRef.size.y - 10 + random.nextDouble() * 20,
// //         ),
// //         'brightness': random.nextDouble(),
// //         'pulseSpeed': 1 + random.nextDouble() * 2,
// //       });
// //     }
// //   }

// //   @override
// //   void update(double dt) {
// //     super.update(dt);
// //     time += dt;

// //     // Update snowflakes
// //     for (final snowflake in snowflakes) {
// //       snowflake['position'].y += snowflake['speed'];
// //       snowflake['position'].x += sin(snowflake['drift'] + time) * 0.3;
// //       snowflake['rotation'] = (snowflake['rotation'] + dt * 0.5) % pi;
// //       snowflake['drift'] = (snowflake['drift'] + dt * 0.2) % (2 * pi);

// //       if (snowflake['position'].y > gameRef.size.y) {
// //         snowflake['position'].y = -10;
// //         snowflake['position'].x = random.nextDouble() * gameRef.size.x;
// //       }
// //     }

// //     // Update northern lights
// //     for (final aurora in northernLights) {
// //       aurora['phase'] = (aurora['phase'] + dt * 0.3) % (2 * pi);
// //     }

// //     // Update reflections
// //     for (final reflection in reflections) {
// //       reflection['brightness'] =
// //           (sin(time * reflection['pulseSpeed']) + 1) * 0.5;
// //     }
// //   }

// //   @override
// //   void render(Canvas canvas) {
// //     super.render(canvas);

// //     // Icy blue sky gradient
// //     final skyGradient = LinearGradient(
// //       begin: Alignment.topCenter,
// //       end: Alignment.bottomCenter,
// //       colors: [Color(0xFFE3F2FD), Color(0xFFB3E5FC), Color(0xFF81D4FA)],
// //     );
// //     final skyPaint =
// //         Paint()
// //           ..shader = skyGradient.createShader(
// //             Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
// //           );
// //     canvas.drawRect(
// //       Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
// //       skyPaint,
// //     );

// //     // Northern lights
// //     for (final aurora in northernLights) {
// //       _drawNorthernLight(
// //         canvas,
// //         aurora['position'].x,
// //         aurora['position'].y,
// //         aurora['phase'],
// //         aurora['color'],
// //       );
// //     }

// //     // Distant icy mountains
// //     _drawIcyMountains(canvas);

// //     // Snowflakes
// //     for (final snowflake in snowflakes) {
// //       _drawSnowflake(
// //         canvas,
// //         snowflake['position'].x,
// //         snowflake['position'].y,
// //         snowflake['size'],
// //         snowflake['rotation'],
// //       );
// //     }

// //     // Ice ground
// //     _drawIceGround(canvas);

// //     // Reflections on ice
// //     for (final reflection in reflections) {
// //       _drawReflection(
// //         canvas,
// //         reflection['position'].x,
// //         reflection['position'].y,
// //         reflection['brightness'],
// //       );
// //     }

// //     // Ice crystals
// //     for (final crystal in iceCrystals) {
// //       _drawIceCrystal(
// //         canvas,
// //         crystal['position'].x,
// //         crystal['position'].y,
// //         crystal['size'],
// //         crystal['rotation'],
// //         crystal['type'],
// //       );
// //     }

// //     // Mirror effect line
// //     final mirrorLinePaint =
// //         Paint()
// //           ..color = Colors.white.withOpacity(0.8)
// //           ..strokeWidth = 1.0;
// //     canvas.drawLine(
// //       Offset(0, gameRef.size.y - 15),
// //       Offset(gameRef.size.x, gameRef.size.y - 15),
// //       mirrorLinePaint,
// //     );
// //   }

// //   void _drawNorthernLight(
// //     Canvas canvas,
// //     double x,
// //     double y,
// //     double phase,
// //     Color color,
// //   ) {
// //     final auroraPaint =
// //         Paint()
// //           ..color = color.withOpacity(0.4)
// //           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15);

// //     final path = Path();
// //     path.moveTo(x, y);

// //     for (double i = 0; i < 100; i += 5) {
// //       final waveX = x + sin(phase + i * 0.1) * 30;
// //       final waveY = y + i * 2;
// //       path.lineTo(waveX, waveY);
// //     }

// //     for (double i = 100; i > 0; i -= 5) {
// //       final waveX = x + sin(phase + i * 0.1 + pi) * 30 + 40;
// //       final waveY = y + i * 2;
// //       path.lineTo(waveX, waveY);
// //     }

// //     path.close();
// //     canvas.drawPath(path, auroraPaint);
// //   }

// //   void _drawIcyMountains(Canvas canvas) {
// //     final mountainPaint = Paint()..color = Color(0xFFB3E5FC).withOpacity(0.6);
// //     final snowPaint = Paint()..color = Colors.white.withOpacity(0.8);

// //     final path = Path();
// //     path.moveTo(0, gameRef.size.y - 100);

// //     for (double x = 0; x < gameRef.size.x; x += 15) {
// //       final height = 80 + sin(x * 0.02) * 40 + cos(x * 0.015) * 25;
// //       path.lineTo(x, gameRef.size.y - 180 - height);
// //     }

// //     path.lineTo(gameRef.size.x, gameRef.size.y - 100);
// //     path.lineTo(gameRef.size.x, gameRef.size.y);
// //     path.lineTo(0, gameRef.size.y);
// //     path.close();

// //     canvas.drawPath(path, mountainPaint);

// //     // Snow caps
// //     final snowPath = Path();
// //     snowPath.moveTo(0, gameRef.size.y - 180);
// //     for (double x = 0; x < gameRef.size.x; x += 10) {
// //       final snowHeight = 20 + sin(x * 0.03) * 15;
// //       snowPath.lineTo(x, gameRef.size.y - 200 - snowHeight);
// //     }
// //     snowPath.lineTo(gameRef.size.x, gameRef.size.y - 180);
// //     snowPath.close();

// //     canvas.drawPath(snowPath, snowPaint);
// //   }

// //   void _drawIceGround(Canvas canvas) {
// //     final iceGradient = LinearGradient(
// //       begin: Alignment.topCenter,
// //       end: Alignment.bottomCenter,
// //       colors: [
// //         Color(0xFFE1F5FE).withOpacity(0.9),
// //         Color(0xFFB3E5FC).withOpacity(0.8),
// //         Color(0xFF81D4FA).withOpacity(0.7),
// //       ],
// //     );

// //     final icePaint =
// //         Paint()
// //           ..shader = iceGradient.createShader(
// //             Rect.fromLTWH(0, gameRef.size.y - 40, gameRef.size.x, 40),
// //           );

// //     canvas.drawRect(
// //       Rect.fromLTWH(0, gameRef.size.y - 40, gameRef.size.x, 40),
// //       icePaint,
// //     );

// //     // Ice cracks
// //     final crackPaint =
// //         Paint()
// //           ..color = Colors.white.withOpacity(0.3)
// //           ..strokeWidth = 0.8;

// //     for (double x = 0; x < gameRef.size.x; x += 40) {
// //       final crackY = gameRef.size.y - 20 + sin(x * 0.1) * 5;
// //       canvas.drawLine(
// //         Offset(x, gameRef.size.y - 40),
// //         Offset(x + 20, crackY),
// //         crackPaint,
// //       );
// //     }
// //   }

// //   void _drawSnowflake(
// //     Canvas canvas,
// //     double x,
// //     double y,
// //     double size,
// //     double rotation,
// //   ) {
// //     final snowPaint = Paint()..color = Colors.white.withOpacity(0.9);

// //     canvas.save();
// //     canvas.translate(x, y);
// //     canvas.rotate(rotation);

// //     // Simple snowflake shape
// //     for (int i = 0; i < 6; i++) {
// //       final angle = i * pi / 3;
// //       canvas.drawLine(
// //         Offset(0, 0),
// //         Offset(cos(angle) * size, sin(angle) * size),
// //         snowPaint,
// //       );
// //       canvas.drawLine(
// //         Offset(cos(angle) * size * 0.5, sin(angle) * size * 0.5),
// //         Offset(
// //           cos(angle + pi / 6) * size * 0.3,
// //           sin(angle + pi / 6) * size * 0.3,
// //         ),
// //         snowPaint,
// //       );
// //     }

// //     canvas.restore();
// //   }

// //   void _drawIceCrystal(
// //     Canvas canvas,
// //     double x,
// //     double y,
// //     double size,
// //     double rotation,
// //     int type,
// //   ) {
// //     final crystalPaint = Paint()..color = Colors.white.withOpacity(0.8);
// //     final highlightPaint = Paint()..color = Colors.white.withOpacity(0.95);

// //     canvas.save();
// //     canvas.translate(x, y);
// //     canvas.rotate(rotation);

// //     if (type == 0) {
// //       // Hexagonal crystal
// //       final path = Path();
// //       for (int i = 0; i < 6; i++) {
// //         final angle = i * pi / 3;
// //         final pointX = cos(angle) * size;
// //         final pointY = sin(angle) * size;
// //         if (i == 0) {
// //           path.moveTo(pointX, pointY);
// //         } else {
// //           path.lineTo(pointX, pointY);
// //         }
// //       }
// //       path.close();
// //       canvas.drawPath(path, crystalPaint);

// //       // Highlight
// //       canvas.drawCircle(
// //         Offset(-size * 0.3, -size * 0.3),
// //         size * 0.2,
// //         highlightPaint,
// //       );
// //     } else {
// //       // Star-like crystal
// //       for (int i = 0; i < 8; i++) {
// //         final angle = i * pi / 4;
// //         canvas.drawLine(
// //           Offset(0, 0),
// //           Offset(cos(angle) * size, sin(angle) * size),
// //           crystalPaint,
// //         );
// //       }
// //     }

// //     canvas.restore();
// //   }

// //   void _drawReflection(Canvas canvas, double x, double y, double brightness) {
// //     final reflectionPaint =
// //         Paint()
// //           ..color = Colors.white.withOpacity(brightness * 0.6)
// //           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

// //     canvas.drawCircle(Offset(x, y), 2 + brightness * 3, reflectionPaint);
// //   }

// //   Color _getAuroraColor(int index) {
// //     final colors = [
// //       Color(0xFF00E5FF), // Cyan
// //       Color(0xFF76FF03), // Light Green
// //       Color(0xFFEA80FC), // Pink
// //     ];
// //     return colors[index % colors.length];
// //   }
// // }
// // ignore_for_file: deprecated_member_use

// import 'package:flame/components.dart';
// import 'dart:math';
// import 'package:flutter/material.dart';

// class GameWorld extends Component with HasGameRef {
//   final Random random = Random();
//   final int starsCount = 100;
//   final int planetsCount = 0;
//   final int nebulaeCount = 0;
//   final int shootingStarsCount = 4;
//   final int dustParticlesCount = 50;

//   final List<Map<String, dynamic>> stars = [];
//   final List<Map<String, dynamic>> planets = [];
//   final List<Map<String, dynamic>> nebulae = [];
//   final List<Map<String, dynamic>> shootingStars = [];
//   final List<Map<String, dynamic>> dustParticles = [];
//   final List<Map<String, dynamic>> constellations = [];

//   double cosmicTime = 0.0;
//   double mirrorPulse = 0.0;
//   double galaxyRotation = 0.0;

//   @override
//   Future<void> onLoad() async {
//     super.onLoad();
//     _initializeCosmicElements();
//   }

//   void _initializeCosmicElements() {
//     for (int i = 0; i < starsCount; i++) {
//       stars.add({
//         'position': Vector2(
//           random.nextDouble() * gameRef.size.x,
//           random.nextDouble() * gameRef.size.y,
//         ),
//         'size': 0.5 + random.nextDouble() * 2.5,
//         'brightness': random.nextDouble(),
//         'twinkleSpeed': 1 + random.nextDouble() * 4,
//         'color': _getStarColor(),
//         'phase': random.nextDouble() * pi * 2,
//       });
//     }

//     // Distant planets with orbits
//     for (int i = 0; i < planetsCount; i++) {
//       final orbitRadius = 80 + i * 60;
//       final orbitSpeed = 0.1 + i * 0.05;
//       planets.add({
//         'orbitRadius': orbitRadius,
//         'orbitCenter': Vector2(gameRef.size.x * 0.3, gameRef.size.y * 0.4),
//         'angle': random.nextDouble() * pi * 2,
//         'speed': orbitSpeed,
//         'size': 8 + i * 3,
//         'color': _getPlanetColor(),
//         'hasRings': i % 3 == 0,
//         'moons': i > 1 ? 1 + random.nextInt(3) : 0,
//       });
//     }

//     // Nebulae with flowing gas clouds
//     for (int i = 0; i < nebulaeCount; i++) {
//       nebulae.add({
//         'position': Vector2(
//           gameRef.size.x * 0.7 + random.nextDouble() * 0.3 * gameRef.size.x,
//           gameRef.size.y * 0.2 + random.nextDouble() * 0.4 * gameRef.size.y,
//         ),
//         'size': 120 + random.nextDouble() * 80,
//         'color': _getNebulaColor(),
//         'density': 0.3 + random.nextDouble() * 0.4,
//         'drift': random.nextDouble() * pi * 2,
//         'pulseSpeed': 0.5 + random.nextDouble() * 1.0,
//       });
//     }

//     // Shooting stars that occasionally streak across
//     for (int i = 0; i < shootingStarsCount; i++) {
//       shootingStars.add({
//         'position': Vector2(-50, random.nextDouble() * gameRef.size.y * 0.3),
//         'speed': Vector2(
//           8 + random.nextDouble() * 4,
//           1 + random.nextDouble() * 2,
//         ),
//         'active': false,
//         'timer': random.nextDouble() * 10,
//         'trailLength': 20 + random.nextDouble() * 30,
//       });
//     }

//     // Space dust particles
//     for (int i = 0; i < dustParticlesCount; i++) {
//       dustParticles.add({
//         'position': Vector2(
//           random.nextDouble() * gameRef.size.x,
//           random.nextDouble() * gameRef.size.y,
//         ),
//         'size': 0.1 + random.nextDouble() * 0.5,
//         'drift': Vector2(
//           (random.nextDouble() - 0.5) * 0.1,
//           (random.nextDouble() - 0.5) * 0.1,
//         ),
//         'brightness': random.nextDouble() * 0.3,
//       });
//     }

//     // Create constellations
//     _createConstellations();
//   }

//   void _createConstellations() {
//     final constellationPatterns = [
//       [
//         Vector2(100, 100),
//         Vector2(120, 80),
//         Vector2(140, 110),
//         Vector2(160, 90),
//       ],
//       [
//         Vector2(200, 150),
//         Vector2(220, 130),
//         Vector2(240, 160),
//         Vector2(260, 140),
//         Vector2(280, 170),
//       ],
//       [
//         Vector2(150, 200),
//         Vector2(170, 220),
//         Vector2(190, 190),
//         Vector2(210, 210),
//       ],
//     ];

//     for (final pattern in constellationPatterns) {
//       constellations.add({
//         'stars': pattern,
//         'brightness': 0.7 + random.nextDouble() * 0.3,
//         'pulseSpeed': 0.8 + random.nextDouble() * 0.4,
//       });
//     }
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     cosmicTime += dt;
//     mirrorPulse = (mirrorPulse + dt * 2) % (pi * 2);
//     // galaxyRotation = (galaxyRotation + dt * 0.1) % (pi * 2);

//     // Update stars twinkling
//     for (final star in stars) {
//       star['phase'] = (star['phase'] + dt * star['twinkleSpeed']) % (pi * 2);
//       star['brightness'] = 0.5 + sin(star['phase']) * 0.5;
//     }

//     // Update planet orbits
//     for (final planet in planets) {
//       planet['angle'] = (planet['angle'] + dt * planet['speed']) % (pi * 2);
//     }

//     // Update nebulae
//     for (final nebula in nebulae) {
//       nebula['drift'] = (nebula['drift'] + dt * 0.2) % (pi * 2);
//     }

//     // Update shooting stars
//     for (final shooter in shootingStars) {
//       shooter['timer'] -= dt;
//       if (shooter['timer'] <= 0 && !shooter['active']) {
//         shooter['active'] = true;
//         shooter['position'].setValues(
//           -50,
//           random.nextDouble() * gameRef.size.y * 0.3,
//         );
//         shooter['speed'].setValues(
//           8 + random.nextDouble() * 4,
//           1 + random.nextDouble() * 2,
//         );
//       }

//       if (shooter['active']) {
//         shooter['position'] += shooter['speed'] * dt * 60;
//         if (shooter['position'].x > gameRef.size.x + 100 ||
//             shooter['position'].y > gameRef.size.y + 100) {
//           shooter['active'] = false;
//           shooter['timer'] = 5 + random.nextDouble() * 15;
//         }
//       }
//     }

//     // Update space dust
//     for (final dust in dustParticles) {
//       dust['position'] += dust['drift'] * dt * 10;

//       // Wrap around screen
//       if (dust['position'].x < 0) dust['position'].x = gameRef.size.x;
//       if (dust['position'].x > gameRef.size.x) dust['position'].x = 0;
//       if (dust['position'].y < 0) dust['position'].y = gameRef.size.y;
//       if (dust['position'].y > gameRef.size.y) dust['position'].y = 0;
//     }
//   }

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);

//     // Deep space background gradient
//     final spaceGradient = RadialGradient(
//       center: Alignment(0.2, 0.3),
//       radius: 1.5,
//       colors: [
//         Color(0xFF0F0B2A),
//         Color(0xFF1A1446),
//         Color(0xFF2D1B69),
//         Color(0xFF0F0B2A),
//       ],
//     );
//     final spacePaint =
//         Paint()
//           ..shader = spaceGradient.createShader(
//             Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
//           );
//     canvas.drawRect(
//       Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
//       spacePaint,
//     );

//     // Distant galaxy spiral
//     _drawGalaxy(canvas, gameRef.size.x * 0.8, gameRef.size.y * 0.2, 60);

//     // Nebulae
//     for (final nebula in nebulae) {
//       _drawNebula(
//         canvas,
//         nebula['position'].x,
//         nebula['position'].y,
//         nebula['size'],
//         nebula['color'],
//         nebula['density'],
//         nebula['drift'],
//       );
//     }

//     // Space dust
//     for (final dust in dustParticles) {
//       _drawDustParticle(
//         canvas,
//         dust['position'].x,
//         dust['position'].y,
//         dust['size'],
//         dust['brightness'],
//       );
//     }

//     // Twinkling stars
//     for (final star in stars) {
//       _drawStar(
//         canvas,
//         star['position'].x,
//         star['position'].y,
//         star['size'],
//         star['brightness'],
//         star['color'],
//       );
//     }

//     // Constellations
//     for (final constellation in constellations) {
//       _drawConstellation(
//         canvas,
//         constellation['stars'],
//         constellation['brightness'],
//         constellation['pulseSpeed'],
//       );
//     }

//     // Planets with orbits
//     for (final planet in planets) {
//       _drawPlanetWithOrbit(canvas, planet);
//     }

//     // Shooting stars
//     for (final shooter in shootingStars) {
//       if (shooter['active']) {
//         _drawShootingStar(
//           canvas,
//           shooter['position'].x,
//           shooter['position'].y,
//           shooter['speed'],
//           shooter['trailLength'],
//         );
//       }
//     }

//     // Central cosmic mirror
//     // _drawCosmicMirror(canvas);

//     // Mirror portal effect
//     // _drawMirrorPortal(canvas);

//     // Floating cosmic orbs
//     _drawFloatingOrbs(canvas);
//   }

//   void _drawGalaxy(Canvas canvas, double x, double y, double size) {
//     final galaxyPaint =
//         Paint()
//           ..color = Color(0xFF4A148C).withOpacity(0.4)
//           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

//     // Spiral arms
//     for (int arm = 0; arm < 2; arm++) {
//       final path = Path();
//       final armOffset = arm * pi;

//       for (double angle = 0; angle < pi * 4; angle += 0.1) {
//         final radius = size * (angle / 20);
//         // final spiralX = x + cos(angle + armOffset + galaxyRotation) * radius;
//         // final spiralY = y + sin(angle + armOffset + galaxyRotation) * radius;

//         // if (angle == 0) {
//         //   path.moveTo(spiralX, spiralY);
//         // } else {
//         //   path.lineTo(spiralX, spiralY);
//         // }
//       }

//       canvas.drawPath(path, galaxyPaint);
//     }

//     // Galaxy core
//     final corePaint = Paint()..color = Color(0xFFFFD600).withOpacity(0.6);
//     canvas.drawCircle(Offset(x, y), size * 0.3, corePaint);
//   }

//   void _drawNebula(
//     Canvas canvas,
//     double x,
//     double y,
//     double size,
//     Color color,
//     double density,
//     double drift,
//   ) {
//     final nebulaPaint =
//         Paint()
//           ..color = color.withOpacity(0.15)
//           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20);

//     final driftOffset = sin(drift) * 10;

//     // Main nebula cloud
//     canvas.drawCircle(Offset(x + driftOffset, y), size, nebulaPaint);

//     // Secondary clouds
//     canvas.drawCircle(
//       Offset(x - size * 0.3, y + size * 0.4),
//       size * 0.7,
//       nebulaPaint,
//     );
//     canvas.drawCircle(
//       Offset(x + size * 0.5, y - size * 0.3),
//       size * 0.6,
//       nebulaPaint,
//     );

//     // Bright nebula core
//     final corePaint =
//         Paint()
//           ..color = color.withOpacity(0.3)
//           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);
//     canvas.drawCircle(Offset(x, y), size * 0.4, corePaint);
//   }

//   void _drawStar(
//     Canvas canvas,
//     double x,
//     double y,
//     double size,
//     double brightness,
//     Color color,
//   ) {
//     final starPaint = Paint()..color = color.withOpacity(brightness);

//     // Main star body
//     canvas.drawCircle(Offset(x, y), size, starPaint);

//     // Star glow
//     final glowPaint =
//         Paint()
//           ..color = color.withOpacity(brightness * 0.3)
//           ..maskFilter = MaskFilter.blur(BlurStyle.normal, size * 2);
//     canvas.drawCircle(Offset(x, y), size * 3, glowPaint);

//     // Star spikes for brighter stars
//     if (size > 1.5 && brightness > 0.7) {
//       final spikePaint =
//           Paint()
//             ..color = color.withOpacity(brightness * 0.6)
//             ..strokeWidth = 0.8;

//       for (int i = 0; i < 4; i++) {
//         final angle = i * pi / 2 + cosmicTime * 0.5;
//         final spikeLength = size * 4;
//         canvas.drawLine(
//           Offset(x, y),
//           Offset(x + cos(angle) * spikeLength, y + sin(angle) * spikeLength),
//           spikePaint,
//         );
//       }
//     }
//   }

//   void _drawPlanetWithOrbit(Canvas canvas, Map<String, dynamic> planet) {
//     final orbitCenter = planet['orbitCenter'];
//     final orbitRadius = planet['orbitRadius'];
//     final angle = planet['angle'];

//     // Orbit path (faint)
//     final orbitPaint =
//         Paint()
//           ..color = Colors.white.withOpacity(0.1)
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 0.5;

//     canvas.drawCircle(
//       Offset(orbitCenter.x, orbitCenter.y),
//       orbitRadius,
//       orbitPaint,
//     );

//     // Planet position
//     final planetX = orbitCenter.x + cos(angle) * orbitRadius;
//     final planetY = orbitCenter.y + sin(angle) * orbitRadius;

//     // Planet body
//     final planetPaint = Paint()..color = planet['color'];
//     canvas.drawCircle(Offset(planetX, planetY), planet['size'], planetPaint);

//     // Planet details
//     final detailPaint = Paint()..color = planet['color'].withOpacity(0.3);
//     canvas.drawCircle(
//       Offset(planetX - planet['size'] * 0.3, planetY - planet['size'] * 0.2),
//       planet['size'] * 0.5,
//       detailPaint,
//     );

//     // Planet rings
//     if (planet['hasRings']) {
//       final ringPaint =
//           Paint()
//             ..color = Color(0xFFB39DDB).withOpacity(0.6)
//             ..style = PaintingStyle.stroke
//             ..strokeWidth = 1.5;

//       canvas.drawCircle(
//         Offset(planetX, planetY),
//         planet['size'] * 1.8,
//         ringPaint,
//       );
//       canvas.drawCircle(
//         Offset(planetX, planetY),
//         planet['size'] * 2.1,
//         ringPaint,
//       );
//     }

//     // Moons
//     for (int i = 0; i < planet['moons']; i++) {
//       final moonAngle = angle + (i + 1) * pi / 3 + cosmicTime;
//       final moonDistance = planet['size'] * 2.5;
//       final moonX = planetX + cos(moonAngle) * moonDistance;
//       final moonY = planetY + sin(moonAngle) * moonDistance;

//       final moonPaint = Paint()..color = Colors.white.withOpacity(0.8);
//       canvas.drawCircle(Offset(moonX, moonY), planet['size'] * 0.4, moonPaint);
//     }

//     // Planet glow
//     final glowPaint =
//         Paint()
//           ..color = planet['color'].withOpacity(0.2)
//           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);
//     canvas.drawCircle(Offset(planetX, planetY), planet['size'] * 2, glowPaint);
//   }

//   void _drawShootingStar(
//     Canvas canvas,
//     double x,
//     double y,
//     Vector2 speed,
//     double trailLength,
//   ) {
//     final trailPaint =
//         Paint()
//           ..color = Colors.white
//           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

//     // Trail
//     final trailStart = Vector2(
//       x - speed.x * trailLength * 0.1,
//       y - speed.y * trailLength * 0.1,
//     );
//     canvas.drawLine(
//       Offset(trailStart.x, trailStart.y),
//       Offset(x, y),
//       trailPaint,
//     );

//     // Shooting star head
//     final headPaint = Paint()..color = Color(0xFFFFF59D);
//     canvas.drawCircle(Offset(x, y), 2, headPaint);

//     // Glow
//     final glowPaint =
//         Paint()
//           ..color = Color(0xFFFFF59D).withOpacity(0.5)
//           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);
//     canvas.drawCircle(Offset(x, y), 6, glowPaint);
//   }

//   // void _drawCosmicMirror(Canvas canvas) {
//   //   final centerX = gameRef.size.x / 2;
//   //   final centerY = gameRef.size.y / 2;
//   //   final mirrorSize = 120.0;

//   //   // Mirror outer glow
//   //   final outerGlowPaint =
//   //       Paint()
//   //         ..color = Color(0xFF00E5FF).withOpacity(0.3)
//   //         ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20);
//   //   canvas.drawCircle(
//   //     Offset(centerX, centerY),
//   //     mirrorSize * 1.5,
//   //     outerGlowPaint,
//   //   );

//   //   // Mirror middle glow
//   //   final middleGlowPaint =
//   //       Paint()
//   //         ..color = Color(0xFF18FFFF).withOpacity(0.5)
//   //         ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15);
//   //   canvas.drawCircle(
//   //     Offset(centerX, centerY),
//   //     mirrorSize * 1.2,
//   //     middleGlowPaint,
//   //   );

//   //   // Mirror surface
//   //   final mirrorGradient = RadialGradient(
//   //     colors: [
//   //       Color(0xFFE0F7FA).withOpacity(0.9),
//   //       Color(0xFF80DEEA).withOpacity(0.7),
//   //       Color(0xFF26C6DA).withOpacity(0.8),
//   //       Colors.transparent,
//   //     ],
//   //     stops: [0.0, 0.3, 0.7, 1.0],
//   //   );

//   //   final mirrorPaint =
//   //       Paint()
//   //         ..shader = mirrorGradient.createShader(
//   //           Rect.fromCircle(
//   //             center: Offset(centerX, centerY),
//   //             radius: mirrorSize,
//   //           ),
//   //         );

//   //   canvas.drawCircle(Offset(centerX, centerY), mirrorSize, mirrorPaint);

//   //   // Mirror pulse effect
//   //   final pulseSize = mirrorSize * (1 + sin(mirrorPulse) * 0.2);
//   //   final pulsePaint =
//   //       Paint()
//   //         ..color = Color(0xFF00E5FF).withOpacity(0.2)
//   //         ..style = PaintingStyle.stroke
//   //         ..strokeWidth = 3;

//   //   canvas.drawCircle(Offset(centerX, centerY), pulseSize, pulsePaint);

//   //   // Mirror inner patterns
//   //   final patternPaint =
//   //       Paint()
//   //         ..color = Colors.white.withOpacity(0.6)
//   //         ..style = PaintingStyle.stroke
//   //         ..strokeWidth = 1;

//   //   for (int i = 0; i < 8; i++) {
//   //     final angle = i * pi / 4 + cosmicTime * 0.5;
//   //     final innerX = centerX + cos(angle) * mirrorSize * 0.6;
//   //     final innerY = centerY + sin(angle) * mirrorSize * 0.6;
//   //     canvas.drawLine(
//   //       Offset(centerX, centerY),
//   //       Offset(innerX, innerY),
//   //       patternPaint,
//   //     );
//   //   }
//   // }

//   // void _drawMirrorPortal(Canvas canvas) {
//   //   final centerX = gameRef.size.x / 2;
//   //   final centerY = gameRef.size.y / 2;

//   //   // Portal energy waves
//   //   for (int i = 0; i < 3; i++) {
//   //     final waveOffset = cosmicTime + i * 2;
//   //     final waveSize = 150 + sin(waveOffset) * 20;
//   //     final wavePaint =
//   //         Paint()
//   //           ..color = Color(0xFF00B0FF).withOpacity(0.15)
//   //           ..style = PaintingStyle.stroke
//   //           ..strokeWidth = 2
//   //           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

//   //     canvas.drawCircle(Offset(centerX, centerY), waveSize, wavePaint);
//   //   }

//   //   // Portal energy tendrils
//   //   final tendrilPaint =
//   //       Paint()
//   //         ..color = Color(0xFF18FFFF).withOpacity(0.7)
//   //         ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

//   //   for (int i = 0; i < 12; i++) {
//   //     final angle = i * pi / 6 + cosmicTime;
//   //     final length = 80 + sin(cosmicTime * 3 + i) * 30;
//   //     final endX = centerX + cos(angle) * length;
//   //     final endY = centerY + sin(angle) * length;

//   //     canvas.drawLine(
//   //       Offset(centerX, centerY),
//   //       Offset(endX, endY),
//   //       tendrilPaint,
//   //     );
//   //   }
//   // }

//   void _drawConstellation(
//     Canvas canvas,
//     List<Vector2> stars,
//     double brightness,
//     double pulseSpeed,
//   ) {
//     final pulse = 0.7 + sin(cosmicTime * pulseSpeed) * 0.3;
//     final linePaint =
//         Paint()
//           ..color = Color(0xFF82B1FF).withOpacity(brightness * pulse)
//           ..strokeWidth = 1.2;

//     final starPaint =
//         Paint()..color = Color(0xFFFFFFFF).withOpacity(brightness * pulse);

//     // Draw connecting lines
//     for (int i = 0; i < stars.length - 1; i++) {
//       canvas.drawLine(
//         Offset(stars[i].x, stars[i].y),
//         Offset(stars[i + 1].x, stars[i + 1].y),
//         linePaint,
//       );
//     }

//     // Draw constellation stars
//     for (final star in stars) {
//       canvas.drawCircle(Offset(star.x, star.y), 2, starPaint);

//       // Star glow
//       final glowPaint =
//           Paint()
//             ..color = Color(0xFF82B1FF).withOpacity(brightness * pulse * 0.3)
//             ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);
//       canvas.drawCircle(Offset(star.x, star.y), 6, glowPaint);
//     }
//   }

//   void _drawDustParticle(
//     Canvas canvas,
//     double x,
//     double y,
//     double size,
//     double brightness,
//   ) {
//     final dustPaint = Paint()..color = Colors.white.withOpacity(brightness);
//     canvas.drawCircle(Offset(x, y), size, dustPaint);
//   }

//   void _drawFloatingOrbs(Canvas canvas) {
//     for (int i = 0; i < 3; i++) {
//       final orbX = gameRef.size.x * 0.2 + cos(cosmicTime * 0.3 + i * 2) * 50;
//       final orbY = gameRef.size.y * 0.8 + sin(cosmicTime * 0.4 + i * 2) * 30;
//       final orbSize = 8 + i * 2;

//       final orbGradient = RadialGradient(
//         colors: [
//           _getOrbColor(i).withOpacity(0.9),
//           _getOrbColor(i).withOpacity(0.3),
//           Colors.transparent,
//         ],
//       );

//       final orbPaint =
//           Paint()
//             ..shader = orbGradient.createShader(
//               Rect.fromCircle(
//                 center: Offset(orbX, orbY),
//                 radius: orbSize.toDouble(),
//               ),
//             );

//       canvas.drawCircle(Offset(orbX, orbY), orbSize.toDouble(), orbPaint);

//       // Orb trail
//       final trailPaint =
//           Paint()
//             ..color = _getOrbColor(i).withOpacity(0.2)
//             ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

//       for (int j = 1; j <= 3; j++) {
//         final trailX = orbX - cos(cosmicTime * 0.3 + i * 2) * j * 3;
//         final trailY = orbY - sin(cosmicTime * 0.4 + i * 2) * j * 3;
//         canvas.drawCircle(
//           Offset(trailX, trailY),
//           orbSize * (1 - j * 0.2),
//           trailPaint,
//         );
//       }
//     }
//   }

//   Color _getStarColor() {
//     final colors = [
//       Color(0xFFFFFFFF), // White
//       Color(0xFFFFF59D), // Yellow
//       Color(0xFFFFAB91), // Orange
//       Color(0xFF90CAF9), // Blue
//     ];
//     return colors[random.nextInt(colors.length)];
//   }

//   Color _getPlanetColor() {
//     final colors = [
//       Color(0xFFEF5350), // Red
//       Color(0xFFAB47BC), // Purple
//       Color(0xFF5C6BC0), // Blue
//       Color(0xFF26A69A), // Teal
//       Color(0xFF66BB6A), // Green
//     ];
//     return colors[random.nextInt(colors.length)];
//   }

//   Color _getNebulaColor() {
//     final colors = [
//       Color(0xFFAB47BC), // Purple
//       Color(0xFFEC407A), // Pink
//       Color(0xFF5C6BC0), // Blue
//       Color(0xFF26C6DA), // Cyan
//     ];
//     return colors[random.nextInt(colors.length)];
//   }

//   Color _getOrbColor(int index) {
//     final colors = [
//       Color(0xFFFF4081), // Pink
//       Color(0xFF18FFFF), // Cyan
//       Color(0xFF76FF03), // Green
//     ];
//     return colors[index % colors.length];
//   }
// }
