// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:mirror_world_runner/providers/game_state.dart';
// import 'package:mirror_world_runner/screens/main_menu.dart';
// import 'package:mirror_world_runner/screens/game_screen.dart';

// class GameOverScreen extends StatelessWidget {
//   const GameOverScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final gameState = Provider.of<GameState>(context);

//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.deepPurple.shade800, Colors.black87],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.purpleAccent.withOpacity(0.4),
//               offset: const Offset(10, 10),
//               blurRadius: 50,
//               spreadRadius: 2,
//               blurStyle: BlurStyle.inner,
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(25),
//         width: 350,
//         height: 600,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 Text(
//                   'Game Over',
//                   style: TextStyle(
//                     fontSize: 48,
//                     fontWeight: FontWeight.bold,
//                     foreground:
//                         Paint()
//                           ..style = PaintingStyle.stroke
//                           ..strokeWidth = 1
//                           ..color = Colors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),

//                 ShaderMask(
//                   shaderCallback:
//                       (bounds) => const LinearGradient(
//                         colors: [Colors.red, Colors.orange],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ).createShader(bounds),
//                   child: const Text(
//                     'Game Over',
//                     style: TextStyle(
//                       fontSize: 48,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 25),

//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(color: Colors.yellowAccent, width: 2),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
//               child: Column(
//                 children: [
//                   Text(
//                     'Score: ${gameState.score}',
//                     style: const TextStyle(
//                       fontSize: 28,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'High Score: ${gameState.highScore}',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       color: Colors.yellowAccent,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 40),

//             ElevatedButton(
//               onPressed: () {
//                 gameState.resetGame();
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => const GameScreen()),
//                   (route) => false,
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 60,
//                   vertical: 18,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 backgroundColor: Colors.deepPurpleAccent,
//                 elevation: 8,
//                 shadowColor: Colors.purpleAccent,
//               ),
//               child: const Text(
//                 'Play Again',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const MainMenuScreen(),
//                   ),
//                   (route) => false,
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 60,
//                   vertical: 18,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 backgroundColor: Colors.white,
//                 elevation: 8,
//                 shadowColor: Colors.greenAccent,
//               ),
//               child: const Text(
//                 'Main Menu',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirror_world_runner/providers/game_state.dart';
import 'package:mirror_world_runner/screens/main_menu.dart';
import 'package:mirror_world_runner/screens/game_screen.dart';
import 'dart:math';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Initialize particles
    for (int i = 0; i < 50; i++) {
      particles.add(Particle());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Animated background with particles
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Update particles
              for (var particle in particles) {
                particle.update();
              }

              return CustomPaint(
                painter: BackgroundPainter(_controller.value, particles),
                size: Size.infinite,
              );
            },
          ),

          // Content
          Center(
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.shade800.withOpacity(0.9),
                      Colors.black87.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(25),
                width: 350,
                height: 600,
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: DialogBorderPainter(),
                      size: Size(350, 600),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              'Game Over',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                foreground:
                                    Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 4
                                      ..color = Colors.purple.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),

                            // Inner text with gradient
                            ShaderMask(
                              shaderCallback:
                                  (bounds) => const LinearGradient(
                                    colors: [
                                      Colors.red,
                                      Colors.orange,
                                      Colors.yellow,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds),
                              child: const Text(
                                'Game Over',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),

                        // Score container with custom shape
                        ClipPath(
                          clipper: ScoreContainerClipper(),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade900,
                                  Colors.purple.shade700,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 30,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Score: ${gameState.score}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'High Score: ${gameState.highScore}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.yellowAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Play Again button with gradient
                        // Container(
                        //   decoration: BoxDecoration(
                        //     gradient: const LinearGradient(
                        //       colors: [Colors.purpleAccent, Colors.deepPurple],
                        //       begin: Alignment.topCenter,
                        //       end: Alignment.bottomCenter,
                        //     ),
                        //     borderRadius: BorderRadius.circular(30),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.purple.withOpacity(0.3),
                        //         blurRadius: 10,
                        //         spreadRadius: 2,
                        //         offset: Offset(0, 4),
                        //       ),
                        //     ],
                        //   ),
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       gameState.resetGame();
                        //       Navigator.pushAndRemoveUntil(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => const GameScreen(),
                        //         ),
                        //         (route) => false,
                        //       );
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       padding: const EdgeInsets.symmetric(
                        //         horizontal: 60,
                        //         vertical: 18,
                        //       ),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(30),
                        //       ),
                        //       backgroundColor: Colors.transparent,
                        //       shadowColor: Colors.transparent,
                        //       elevation: 0,
                        //     ),
                        //     child: const Text(
                        //       'Play Again',
                        //       style: TextStyle(
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.white,
                        //       ),
                        //       textAlign: TextAlign.center,
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 20),

                        // // Main Menu button
                        // Container(
                        //   decoration: BoxDecoration(
                        //     gradient: const LinearGradient(
                        //       colors: [Colors.blueAccent, Colors.blue],
                        //       begin: Alignment.topCenter,
                        //       end: Alignment.bottomCenter,
                        //     ),
                        //     borderRadius: BorderRadius.circular(30),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.blue.withOpacity(0.6),
                        //         blurRadius: 10,
                        //         spreadRadius: 2,
                        //         offset: Offset(0, 4),
                        //       ),
                        //     ],
                        //   ),
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       Navigator.pushAndRemoveUntil(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => const MainMenuScreen(),
                        //         ),
                        //         (route) => false,
                        //       );
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       padding: const EdgeInsets.symmetric(
                        //         horizontal: 60,
                        //         vertical: 18,
                        //       ),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(30),
                        //       ),
                        //       backgroundColor: Colors.transparent,
                        //       shadowColor: Colors.transparent,
                        //       elevation: 0,
                        //     ),
                        //     child: const Text(
                        //       'Main Menu',
                        //       style: TextStyle(
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.white,
                        //       ),
                        //       textAlign: TextAlign.center,
                        //     ),
                        //   ),
                        // ),
                        // Play Again Button
                        GradientButton(
                          label: "Play Again",
                          colors: [Colors.purpleAccent, Colors.deepPurple],
                          onPressed: () {
                            gameState.resetGame();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GameScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // Main Menu Button
                        GradientButton(
                          label: "Main Menu",
                          colors: [Colors.blueAccent, Colors.blue],
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainMenuScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Particle class for background animation
class Particle {
  double x = Random.nextDouble() * 400;
  double y = Random.nextDouble() * 800;
  double radius = Random.nextDouble() * 3 + 1;
  double dx = Random.nextDouble() * 2 - 1;
  double dy = Random.nextDouble() * 2 - 1;
  Color color = Colors.primaries[Random.nextInt(Colors.primaries.length)]
      .withOpacity(Random.nextDouble() * 0.5 + 0.2);

  void update() {
    x += dx;
    y += dy;

    if (x < 0 || x > 400) dx = -dx;
    if (y < 0 || y > 800) dy = -dy;
  }
}

class GradientButton extends StatelessWidget {
  final String label;
  final List<Color> colors;
  final VoidCallback onPressed;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.label,
    required this.colors,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for the animated background
class BackgroundPainter extends CustomPainter {
  final double animationValue;
  final List<Particle> particles;

  BackgroundPainter(this.animationValue, this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw gradient background
    // final gradient = RadialGradient(
    //   colors: [
    //     Colors.deepPurple.withOpacity(0.7),
    //     Colors.black.withOpacity(0.9),
    //   ],
    //   center: Alignment(animationValue * 2 - 1, animationValue * 2 - 1),
    //   radius: 1.5,
    // );

    // final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // final paint = Paint()..shader = gradient.createShader(rect);
    // canvas.drawRect(rect, paint);

    // Draw particles
    for (var particle in particles) {
      final particlePaint = Paint()..color = particle.color;
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.radius,
        particlePaint,
      );
    }

    // Draw some light effects
    final lightGradient = RadialGradient(
      colors: [Colors.purpleAccent.withOpacity(0.2), Colors.transparent],
    );

    final lightPaint =
        Paint()
          ..shader = lightGradient.createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.25, size.height * 0.75),
              radius: 150,
            ),
          );

    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.75),
      150,
      lightPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.25),
      100,
      lightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom painter for dialog border
class DialogBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.purpleAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..shader = LinearGradient(
            colors: [Colors.purpleAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path =
        Path()
          ..moveTo(20, 0)
          ..lineTo(size.width - 20, 0)
          ..quadraticBezierTo(size.width, 0, size.width, 20)
          ..lineTo(size.width, size.height - 20)
          ..quadraticBezierTo(
            size.width,
            size.height,
            size.width - 20,
            size.height,
          )
          ..lineTo(20, size.height)
          ..quadraticBezierTo(0, size.height, 0, size.height - 20)
          ..lineTo(0, 20)
          ..quadraticBezierTo(0, 0, 20, 0)
          ..close();

    canvas.drawPath(path, paint);

    // Draw some corner decorations
    final cornerPaint =
        Paint()
          ..color = Colors.yellowAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    // Top left corner
    canvas.drawLine(Offset(0, 20), Offset(10, 10), cornerPaint);
    canvas.drawLine(Offset(10, 10), Offset(20, 0), cornerPaint);

    // Top right corner
    canvas.drawLine(
      Offset(size.width - 20, 0),
      Offset(size.width - 10, 10),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width - 10, 10),
      Offset(size.width, 20),
      cornerPaint,
    );

    // Bottom right corner
    canvas.drawLine(
      Offset(size.width, size.height - 20),
      Offset(size.width - 10, size.height - 10),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width - 10, size.height - 10),
      Offset(size.width - 20, size.height),
      cornerPaint,
    );

    // Bottom left corner
    canvas.drawLine(
      Offset(20, size.height),
      Offset(10, size.height - 10),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(10, size.height - 10),
      Offset(0, size.height - 20),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom clipper for the score container
class ScoreContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(20, 0);
    path.lineTo(size.width - 20, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 20);
    path.lineTo(size.width, size.height - 20);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - 20,
      size.height,
    );
    path.lineTo(20, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - 20);
    path.lineTo(0, 20);
    path.quadraticBezierTo(0, 0, 20, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
