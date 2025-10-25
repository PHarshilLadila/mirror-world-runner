// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mirror_world_runner/auth/register_screen.dart';
import 'package:mirror_world_runner/providers/auth_provider.dart';
import 'package:mirror_world_runner/screens/main_menu.dart';
import 'package:mirror_world_runner/widgets/custom_loader.dart';
import 'package:mirror_world_runner/widgets/custom_toast.dart';
import 'package:mirror_world_runner/widgets/custome_text_field.dart';
import 'package:mirror_world_runner/widgets/holographic_button.dart';
import 'package:mirror_world_runner/widgets/particle_painter.dart';
import 'package:mirror_world_runner/widgets/particles.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController userInputController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late Ticker ticker;
  final List<Particles> particles = [];
  final ValueNotifier<int> particleNotifier = ValueNotifier<int>(0);

  Duration lastElapsed = Duration.zero;

  final numberOfParticle = kIsWeb ? 60 : 50;

  @override
  void initState() {
    super.initState();

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
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Scaffold(
            backgroundColor: Colors.black,
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

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'LOGIN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
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

                        const Text(
                          'Welcome back to Mirror World Adventure',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),

                        Container(
                          width: kIsWeb ? 350 : double.infinity,

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
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              GameInputField(
                                controller: userInputController,
                                label: "Username",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    "assets/images/png/person.png",
                                    width: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              GameInputField(
                                controller: passwordController,
                                label: "Password",
                                isPassword: true,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    "assets/images/png/lock.png",
                                    width: 25,

                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),

                              HolographicButton(
                                label: "LOGIN",
                                colors: const [
                                  Colors.purple,
                                  Colors.pinkAccent,
                                ],
                                verticalPadding: 12,
                                fontSize: 12,
                                width: double.infinity,
                                onTap: () async {
                                  try {
                                    await authProvider.login(
                                      userInputController.text.trim(),
                                      passwordController.text.trim(),
                                    );

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ChangeNotifierProvider(
                                              create:
                                                  (context) => AuthProvider(),
                                              child: const MainMenuScreen(),
                                            ),
                                      ),
                                    );

                                    CustomToast.show(
                                      context,
                                      message:
                                          "Login success, enjoy the game..!",
                                      type: GameToastType.success,
                                    );
                                  } catch (e) {
                                    CustomToast.show(
                                      context,
                                      message: "$e",
                                      type: GameToastType.error,
                                    );
                                  }
                                },
                              ),

                              const SizedBox(height: 10),

                              HolographicButton(
                                label: "CREATE NEW ACCOUNT",
                                colors: const [
                                  Colors.transparent,
                                  Colors.transparent,
                                ],
                                verticalPadding: 12,
                                fontSize: 10,
                                width: double.infinity,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterScreen(),
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 10),

                              HolographicButton(
                                label: "CONTINUE AS GUEST",
                                colors: const [Colors.grey, Colors.blueGrey],
                                verticalPadding: 12,
                                fontSize: 10,
                                width: double.infinity,
                                onTap: () async {
                                  try {
                                    await authProvider.signInAnonymously();

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ChangeNotifierProvider(
                                              create:
                                                  (context) => AuthProvider(),
                                              child: const MainMenuScreen(),
                                            ),
                                      ),
                                    );

                                    CustomToast.show(
                                      context,
                                      message:
                                          "Welcome Guest! Enjoy the game..!",
                                      type: GameToastType.success,
                                    );
                                  } catch (e) {
                                    CustomToast.show(
                                      context,
                                      message: "Guest login failed: $e",
                                      type: GameToastType.error,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        const Text(
                          '© 2025 Mirror World Runner',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                if (authProvider.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: GameLoadingWidget(width: 100, height: 100),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
