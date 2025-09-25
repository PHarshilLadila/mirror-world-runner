// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mirror_world_runner/widgets/particles.dart';
import 'package:provider/provider.dart';
import 'package:mirror_world_runner/providers/game_state.dart';
import 'package:mirror_world_runner/screens/main_menu.dart';

class PauseMenu extends StatefulWidget {
  const PauseMenu({super.key});

  @override
  State<PauseMenu> createState() => _PauseMenuState();
}

class _PauseMenuState extends State<PauseMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final List<Particles> _particles = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            width: 380,
            height: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 25,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                _buildBackground(),

                ..._particles.map(
                  (particle) => Positioned(
                    left: particle.x,
                    top: particle.y,
                    child: Container(
                      width: particle.size,
                      height: particle.size,
                      decoration: BoxDecoration(
                        color: particle.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                Container(
                  width: 380,
                  height: 350,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.grey.shade900.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildAnimatedTitle(),
                      const SizedBox(height: 40),

                      _buildGradientButton(
                        label: 'Resume Game',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                        ),
                        icon: Icons.play_arrow_rounded,
                        onTap: () {
                          _controller.reverse().then((_) {
                            Provider.of<GameState>(
                              context,
                              listen: false,
                            ).togglePause();
                            Navigator.pop(context);
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      _buildGradientButton(
                        label: 'Main Menu',
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                        ),
                        icon: Icons.home_rounded,
                        onTap: () {
                          _controller.reverse().then((_) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainMenuScreen(),
                              ),
                              (route) => false,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),

                _buildCornerDecoration(Alignment.topLeft),
                _buildCornerDecoration(Alignment.topRight),
                _buildCornerDecoration(Alignment.bottomLeft),
                _buildCornerDecoration(Alignment.bottomRight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      width: 380,
      height: 350,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.blueAccent.withOpacity(0.1), Colors.transparent],
          radius: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: CustomPaint(painter: _BackgroundPainter()),
    );
  }

  Widget _buildAnimatedTitle() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [Color(0xFF00B4DB), Color(0xFF0083B0), Color(0xFF00B4DB)],
          stops: [0.0, 0.5, 1.0],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 10 - (_controller.value * 10)),
            child: Text(
              'GAME PAUSED',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Colors.blueAccent.withOpacity(0.8),
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGradientButton({
    required String label,
    required Gradient gradient,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCornerDecoration(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: CustomPaint(painter: _CornerPainter(alignment: alignment)),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.blueAccent.withOpacity(0.05),
              Colors.cyanAccent.withOpacity(0.03),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    for (double i = 0; i < size.width; i += 40) {
      for (double j = 0; j < size.height; j += 40) {
        path.addOval(Rect.fromCircle(center: Offset(i, j), radius: 1));
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CornerPainter extends CustomPainter {
  final Alignment alignment;

  _CornerPainter({required this.alignment});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blueAccent.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    final path = Path();

    if (alignment == Alignment.topLeft) {
      path.moveTo(10, 10);
      path.lineTo(30, 10);
      path.moveTo(10, 10);
      path.lineTo(10, 30);
    } else if (alignment == Alignment.topRight) {
      path.moveTo(size.width - 10, 10);
      path.lineTo(size.width - 30, 10);
      path.moveTo(size.width - 10, 10);
      path.lineTo(size.width - 10, 30);
    } else if (alignment == Alignment.bottomLeft) {
      path.moveTo(10, size.height - 10);
      path.lineTo(30, size.height - 10);
      path.moveTo(10, size.height - 10);
      path.lineTo(10, size.height - 30);
    } else if (alignment == Alignment.bottomRight) {
      path.moveTo(size.width - 10, size.height - 10);
      path.lineTo(size.width - 30, size.height - 10);
      path.moveTo(size.width - 10, size.height - 10);
      path.lineTo(size.width - 10, size.height - 30);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
