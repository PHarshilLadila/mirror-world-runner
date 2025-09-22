// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirror_world_runner/providers/game_state.dart';
import 'package:mirror_world_runner/screens/main_menu.dart';
import 'package:mirror_world_runner/screens/game_screen.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
