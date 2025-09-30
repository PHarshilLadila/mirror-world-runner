// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mirror_world_runner/auth/login_screen.dart';
import 'package:mirror_world_runner/providers/auth_provider.dart';
import 'package:mirror_world_runner/widgets/custom_loader.dart';
import 'package:mirror_world_runner/widgets/custom_toast.dart';
import 'package:mirror_world_runner/widgets/custome_text_field.dart';
import 'package:mirror_world_runner/widgets/holographic_button.dart';
import 'package:mirror_world_runner/widgets/particle_painter.dart';
import 'package:mirror_world_runner/widgets/particles.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  late Ticker _ticker;
  final List<Particles> _particles = [];
  final ValueNotifier<int> _particleNotifier = ValueNotifier<int>(0);
  Duration _lastElapsed = Duration.zero;
  final int numberOfParticle = kIsWeb ? 60 : 50;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < numberOfParticle; i++) {
      _particles.add(Particles());
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
    emailController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                    valueListenable: _particleNotifier,
                    builder: (context, _, __) {
                      return CustomPaint(
                        painter: ParticlePainter(_particles),
                        size: Size.infinite,
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 80),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'CREATE ACCOUNT',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
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
                            'Join the Mirror World Adventure',
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
                                  Colors.purple.shade900.withOpacity(0.8),
                                  Colors.indigo.shade900.withOpacity(0.8),
                                  Colors.black87.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: const [0.0, 0.5, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(12),
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
                                  controller: emailController,
                                  label: "Email Address",
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                      "assets/images/png/email.png",
                                      width: 26,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                GameInputField(
                                  controller: userNameController,
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
                                const SizedBox(height: 20),
                                GameInputField(
                                  controller: confirmPasswordController,
                                  label: "Confirm Password",
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
                                  label:
                                      authProvider.isLoading
                                          ? "CREATING ACCOUNT..."
                                          : "CREATE ACCOUNT",
                                  colors: const [
                                    Colors.purple,
                                    Colors.pinkAccent,
                                  ],
                                  verticalPadding: 12,
                                  fontSize: 12,
                                  width: double.infinity,
                                  onTap: () async {
                                    if (passwordController.text !=
                                        confirmPasswordController.text) {
                                      CustomToast.show(
                                        context,
                                        message: "Passwords do not match!",
                                        type: GameToastType.error,
                                      );
                                      return;
                                    }
                                    if (!_isValidEmail(emailController.text)) {
                                      CustomToast.show(
                                        context,
                                        message:
                                            "Please enter a valid email address!",
                                        type: GameToastType.error,
                                      );
                                      return;
                                    }
                                    try {
                                      await authProvider.register(
                                        emailController.text.trim(),
                                        userNameController.text.trim(),
                                        passwordController.text.trim(),
                                      );
                                      CustomToast.show(
                                        context,
                                        message:
                                            "Registration Successful! Welcome to Mirror World!",
                                        type: GameToastType.success,
                                      );
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(),
                                        ),
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
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: Colors.blueAccent.withOpacity(
                                          0.3,
                                        ),
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        'OR',
                                        style: TextStyle(
                                          color: Colors.blueAccent.withOpacity(
                                            0.7,
                                          ),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.blueAccent.withOpacity(
                                          0.3,
                                        ),
                                        thickness: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                HolographicButton(
                                  label: "BACK TO LOGIN",
                                  colors: const [
                                    Colors.transparent,
                                    Colors.transparent,
                                  ],
                                  verticalPadding: 10,
                                  fontSize: 10,
                                  width: double.infinity,
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'By creating an account, you agree to our Terms of Service and Privacy Policy',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '© 2025 Mirror World Runner',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
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

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
