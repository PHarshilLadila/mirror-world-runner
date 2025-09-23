// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mirror_world_runner/screens/setting_screen.dart';
import 'package:provider/provider.dart';
import 'package:mirror_world_runner/providers/game_state.dart';
import 'package:mirror_world_runner/screens/game_screen.dart';
import 'package:flutter/scheduler.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final List<Particle> _particles = [];
  final ValueNotifier<int> _particleNotifier = ValueNotifier<int>(0);

  Duration _lastElapsed = Duration.zero;

  final numberOfParticle = kIsWeb ? 60 : 50;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < numberOfParticle; i++) {
      _particles.add(Particle());
    }

    _ticker = createTicker((elapsed) {
      final dt = (elapsed - _lastElapsed).inMicroseconds / 1e6;
      _lastElapsed = elapsed;

      for (var p in _particles) {
        p.update(dt);
      }

      _particleNotifier.value++;
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade900,
                  Colors.indigo.shade900,
                  Colors.black87,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          RepaintBoundary(
            child: ValueListenableBuilder<int>(
              valueListenable: _particleNotifier,
              builder: (context, _, __) {
                return CustomPaint(
                  painter: ParticlePainter(_particles),
                  size: Size.infinite,
                );
              },
            ),
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.05),
                  Colors.transparent,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'MIRROR-WORLD',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        foreground:
                            Paint()
                              ..shader = const LinearGradient(
                                colors: [
                                  Colors.cyan,
                                  Colors.blueAccent,
                                  Colors.purpleAccent,
                                ],
                              ).createShader(
                                const Rect.fromLTWH(0, 0, 400, 100),
                              ),
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 20,
                            offset: const Offset(4, 4),
                          ),
                          Shadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(-2, -2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text(
                    'RUNNER',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                      letterSpacing: 3,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.8),
                          blurRadius: 15,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 70),

                  _buildHolographicButton(
                    context,
                    label: 'START GAME',
                    colors: const [
                      Colors.blueAccent,
                      Colors.lightBlueAccent,
                      Colors.cyan,
                    ],
                    onTap: () {
                      Provider.of<GameState>(
                        context,
                        listen: false,
                      ).resetGame();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  _buildHolographicButton(
                    context,
                    label: 'HOW TO PLAY',
                    colors: const [Colors.greenAccent, Colors.tealAccent],
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => _buildHowToPlayDialog(),
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  _buildHolographicButton(
                    context,
                    label: 'SETTINGS',
                    colors: const [
                      Colors.purpleAccent,
                      Colors.pinkAccent,
                      Colors.redAccent,
                    ],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const SettingScreen(isSettingScreen: true),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 80),

                  Text(
                    '© 2025 Mirror World Runner',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHolographicButton(
    BuildContext context, {
    required String label,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return AnimatedButton(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowToPlayDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.85),
              Colors.indigo.shade900,
              Colors.purple.shade900,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
        ),
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'HOW TO PLAY',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.underline,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.8),
                    blurRadius: 10,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '🌟 Control both characters simultaneously.\n\n'
              '🎯 Avoid obstacles in mirrored worlds.\n\n'
              '⚡ Collect power-ups for special abilities.\n\n'
              '👆 Drag anywhere to move both players.\n\n'
              '🎮 Use arrow keys for precise control.\n\n'
              '❤️ Survive as long as possible!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 25),
            AnimatedButton(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 30,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.greenAccent, Colors.tealAccent],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'GOT IT!',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const AnimatedButton({super.key, required this.child, required this.onTap});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse().then((_) {
      widget.onTap();
    });
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}

class Particle {
  double x = 0;
  double y = 0;
  double size = 0;
  double speed = 0;
  Color color = Colors.white;
  double opacity = 0;

  Particle() {
    reset();
  }

  void reset() {
    if (kIsWeb) {
      x = Random.nextDouble() * 1800;
    } else {
      x = Random.nextDouble() * 400;
    }

    y = Random.nextDouble() * 1000;

    size = Random.nextDouble() * 3 + 1;

    speed = Random.nextDouble() * 50 + 20;

    opacity = Random.nextDouble() * 0.5 + 0.1;

    color = Colors.accents[Random.nextInt(Colors.accents.length)].withOpacity(
      opacity,
    );
  }

  void update(double dt) {
    y += speed * dt;

    if (y > 1000) {
      reset();
      y = 0;
    }

    x += math.sin(y * 0.01) * 0.5;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint =
          Paint()
            ..color = particle.color
            ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(particle.x, particle.y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Random {
  static final _random = math.Random();

  static double nextDouble() => _random.nextDouble();
  static int nextInt(int max) => _random.nextInt(max);
}
