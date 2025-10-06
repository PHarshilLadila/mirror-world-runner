// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mirror_world_runner/widgets/backgroung_painter.dart';
import 'package:mirror_world_runner/widgets/corner_painter.dart';
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
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  final List<Particles> particles = [];

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
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
                background(),

                ...particles.map(
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
                      animatedTitle(),
                      const SizedBox(height: 40),

                      gradientButton(
                        label: 'Resume Game',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                        ),
                        icon: Icons.play_arrow_rounded,
                        onTap: () {
                          animationController.reverse().then((_) {
                            Provider.of<GameState>(
                              context,
                              listen: false,
                            ).togglePause();
                            Navigator.pop(context);
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      gradientButton(
                        label: 'Main Menu',
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                        ),
                        icon: Icons.home_rounded,
                        onTap: () {
                          animationController.reverse().then((_) {
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

                cornerDecoration(Alignment.topLeft),
                cornerDecoration(Alignment.topRight),
                cornerDecoration(Alignment.bottomLeft),
                cornerDecoration(Alignment.bottomRight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget background() {
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
      child: CustomPaint(painter: BackgroundPainter()),
    );
  }

  Widget animatedTitle() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [Color(0xFF00B4DB), Color(0xFF0083B0), Color(0xFF00B4DB)],
          stops: [0.0, 0.5, 1.0],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 10 - (animationController.value * 10)),
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

  Widget gradientButton({
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

  Widget cornerDecoration(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: CustomPaint(painter: CornerPainter(alignment: alignment)),
    );
  }
}
