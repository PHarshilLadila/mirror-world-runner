// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, use_build_context_synchronously

import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mirror_world_runner/auth/login_screen.dart';
import 'package:mirror_world_runner/providers/auth_provider.dart';
import 'package:mirror_world_runner/screens/achivements_screen.dart';
import 'package:mirror_world_runner/screens/game_history_screen.dart';
import 'package:mirror_world_runner/screens/leader_board_screen.dart';
import 'package:mirror_world_runner/screens/setting_screen.dart';
import 'package:mirror_world_runner/widgets/animated_button.dart';
import 'package:mirror_world_runner/widgets/custom_toast.dart';
import 'package:mirror_world_runner/widgets/holographic_button.dart';
import 'package:mirror_world_runner/widgets/particle_painter.dart';
import 'package:mirror_world_runner/widgets/particles.dart';
import 'package:motion/motion.dart';
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
  late Ticker ticker;
  final List<Particles> particles = [];
  final ValueNotifier<int> particleNotifier = ValueNotifier<int>(0);

  Duration lastElapsed = Duration.zero;

  final numberOfParticle = kIsWeb ? 60 : 50;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.fetchCurrentUser();
    });

    for (int i = 0; i < numberOfParticle; i++) {
      particles.add(Particles());
    }

    ticker = createTicker((elapsed) {
      final dt = (elapsed - lastElapsed).inMicroseconds / 1e6;
      lastElapsed = elapsed;

      for (var p in particles) {
        p.update(dt);
      }

      particleNotifier.value++;
    });
    ticker.start();
  }

  @override
  void dispose() {
    ticker.dispose();
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
              valueListenable: particleNotifier,
              builder: (context, _, __) {
                return CustomPaint(
                  painter: ParticlePainter(particles),
                  size: Size.infinite,
                );
              },
            ),
          ),

          Center(
            child: SingleChildScrollView(
              child: ClarityUnmask(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'MIRROR WORLD',
                        textAlign: TextAlign.center,
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

                    const SizedBox(height: 20),

                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        if (authProvider.isLoading) {
                          return const Text(
                            "Loading...",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          );
                        }

                        final userName =
                            authProvider.currentUser?['userName'] ?? "";
                        return Text(
                          "Welcome back $userName..",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        if (authProvider.isLoading) {
                          return const Text(
                            "",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          );
                        }

                        final email = authProvider.currentUser?['email'] ?? "";
                        return Column(
                          children: [
                            Text(
                              "$email",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: email == "" ? 30 : 70),
                          ],
                        );
                      },
                    ),

                    Motion(
                      filterQuality: FilterQuality.none,
                      glare: GlareConfiguration(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        children: [
                          HolographicButton(
                            label: "START GAME",
                            colors: const [Colors.blue, Colors.cyanAccent],
                            showShadow: false,
                            onTap: () {
                              debugPrint("START GAME");
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

                          const SizedBox(height: 12),

                          HolographicButton(
                            label: "HOW TO PLAY",
                            colors: const [
                              Colors.green,
                              Colors.lightGreenAccent,
                            ],
                            showShadow: false,
                            onTap: () {
                              debugPrint("HOW TO PLAY");
                              showDialog(
                                context: context,
                                builder: (context) => GameInstrcutionDialog(),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          HolographicButton(
                            label: "LEADER BOARD",
                            colors: const [Colors.amber, Colors.amberAccent],
                            showShadow: false,
                            onTap: () {
                              debugPrint("LEADER BOARD");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const LeaderboardScreen(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 12),
                          HolographicButton(
                            label: "HISTORY",
                            colors: const [
                              Colors.purpleAccent,
                              Colors.deepPurple,
                            ],
                            showShadow: false,
                            onTap: () {
                              debugPrint("HISTORY");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GameHistoryScreen(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 12),
                          HolographicButton(
                            label: "ACHIVEMENTS",
                            colors: const [Colors.purple, Colors.pinkAccent],
                            showShadow: false,
                            onTap: () {
                              debugPrint("ACHIVEMENTS");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const AchivementsScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          HolographicButton(
                            label: "SETTINGS",
                            colors: const [
                              Colors.orange,
                              Colors.deepOrangeAccent,
                            ],
                            showShadow: false,
                            onTap: () {
                              debugPrint("SETTINGS");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const SettingScreen(
                                        isSettingScreen: true,
                                      ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          // Add this button to your MainMenuScreen in the column of buttons
                          HolographicButton(
                            label: "SYNC DATA",
                            colors: const [
                              Colors.deepOrangeAccent,
                              Colors.deepOrange,
                            ],
                            onTap: () async {
                              final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              );
                              try {
                                await authProvider.manualSync();
                                CustomToast.show(
                                  context,
                                  message: "Data synchronized successfully!",
                                  type: GameToastType.success,
                                );
                              } catch (e) {
                                CustomToast.show(
                                  context,
                                  message: "Sync failed: $e",
                                  type: GameToastType.error,
                                );
                              }
                            },
                          ),

                          const SizedBox(height: 12),

                          HolographicButton(
                            label: "LOGOUT",
                            colors: const [
                              Colors.red,
                              Color(0xFFFF4D4D),
                              Color(0xFFEC1404),
                            ],
                            showShadow: false,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => LogoutDailog(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        'Info: Play on web for the best gaming experience.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '© 2025 Mirror World Runner',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 80),
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

class LogoutDailog extends StatelessWidget {
  const LogoutDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: kIsWeb ? 400 : double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.45),
              Colors.indigo.shade900,
              Colors.purple.shade900,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
        ),
        padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Logout',
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
                'Are you sure you want to logout?\n\n',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AnimatedButton(
                      onTap: () async {
                        debugPrint("Log Out Cancle");
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 30,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.redAccent, Colors.red],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AnimatedButton(
                      onTap: () async {
                        debugPrint("Log Out");
                        final authProvider = Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        );
                        await authProvider.logout();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                        debugPrint("Log Out Done");
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 30,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.green, Colors.lightGreenAccent],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameInstrcutionDialog extends StatelessWidget {
  const GameInstrcutionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: kIsWeb ? 400 : double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.45),
              Colors.indigo.shade900,
              Colors.purple.shade900,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
        ),
        padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        child: SingleChildScrollView(
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
                  fontSize: 14,
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
                      colors: [Colors.green, Colors.lightGreenAccent],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'GOT IT!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
