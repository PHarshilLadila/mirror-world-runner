// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mirror_world_runner/providers/game_state.dart';
import 'package:mirror_world_runner/screens/main_menu.dart';
import 'package:mirror_world_runner/widgets/custom_slider.dart';
import 'package:mirror_world_runner/widgets/custom_toast.dart';
import 'package:mirror_world_runner/widgets/difficulty_button.dart';
import 'package:mirror_world_runner/widgets/gradient_button.dart';
import 'package:mirror_world_runner/widgets/holographic_button.dart';
import 'package:mirror_world_runner/widgets/particle_painter.dart';
import 'package:mirror_world_runner/widgets/particles.dart';
import 'package:mirror_world_runner/widgets/toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  final bool isSettingScreen;
  final Function(double)? onSpeedChanged;
  final Function(String)? onDifficultyChanged;

  const SettingScreen({
    super.key,
    this.onSpeedChanged,
    this.onDifficultyChanged,
    this.isSettingScreen = false,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with SingleTickerProviderStateMixin {
  double movementSpeed = 5.0;
  double soundVolume = 7.0;
  String difficulty = "medium";
  bool enableSound = true;
  bool enableNotifications = true;
  late Ticker ticker;
  final numberOfParticle = kIsWeb ? 80 : 60;
  Duration lastElapsed = Duration.zero;
  final ValueNotifier<int> particleNotifier = ValueNotifier<int>(0);

  final List<Particles> particles = [];

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

    loadSettingsFromSharedpreference();
  }

  @override
  void dispose() {
    ticker.dispose();
    particleNotifier.dispose();
    super.dispose();
  }

  Future<void> loadSettingsFromSharedpreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      movementSpeed = prefs.getDouble('movementSpeed') ?? 5.0;
      soundVolume = prefs.getDouble('soundVolume') ?? 7.0;
      difficulty = prefs.getString('difficulty') ?? "medium";
      enableSound = prefs.getBool('enableSound') ?? true;
      enableNotifications = prefs.getBool('enableNotifications') ?? true;
    });
  }

  // save settings
  Future<void> saveSettingsInToSharedpreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('movementSpeed', movementSpeed);
    await prefs.setDouble('soundVolume', soundVolume);
    await prefs.setString('difficulty', difficulty);
    await prefs.setBool('enableSound', enableSound);
    await prefs.setBool('enableNotifications', enableNotifications);
  }

  // apply settings
  void applySettings() {
    saveSettingsInToSharedpreference();

    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.setDifficultyLevel(getDifficultyLevelFromString(difficulty));

    if (widget.onSpeedChanged != null) {
      widget.onSpeedChanged!(movementSpeed);
    }
    if (widget.onDifficultyChanged != null) {
      widget.onDifficultyChanged!(difficulty);
    }
    Navigator.pop(context);
  }

  // difficulty helpers
  int getDifficultyLevelFromString(String diff) {
    switch (diff) {
      case "easy":
        return 1;
      case "medium":
        return 2;
      case "hard":
        return 3;
      default:
        return 2;
    }
  }

  // string and color getters for difficulty
  String getDifficultyText(String diff) {
    switch (diff) {
      case "easy":
        return "Easy";
      case "medium":
        return "Medium";
      case "hard":
        return "Hard";
      default:
        return "Medium";
    }
  }

  Color getDifficultyColor(String diff) {
    switch (diff) {
      case "easy":
        return Colors.greenAccent;
      case "medium":
        return Colors.orangeAccent;
      case "hard":
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
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

          IgnorePointer(
            child: RepaintBoundary(
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
          ),

          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    height: 56,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: BackButton(color: Colors.white),
                        ),
                        const Center(
                          child: Text(
                            'SETTINGS',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Container(
                      width: kIsWeb ? 500 : double.infinity,
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.shade900,
                            Colors.indigo.shade900,
                            Colors.black87,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 50,
                            offset: Offset(5, 5),
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 18),

                            Column(
                              children: [
                                ToggleButton(
                                  title: "Sound",
                                  value: enableSound,
                                  icon: Icons.music_note,
                                  onChanged:
                                      (value) =>
                                          setState(() => enableSound = value),
                                ),
                                ToggleButton(
                                  title: "Notifications",
                                  value: enableNotifications,
                                  icon: Icons.notifications,
                                  onChanged:
                                      (value) => setState(() {
                                        enableNotifications = value;
                                      }),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            Divider(color: Colors.white24, thickness: 1),
                            const SizedBox(height: 20),

                            CustomSlider(
                              title: "Movement Speed",
                              value: movementSpeed,
                              min: 0,
                              max: 10,
                              icon: Icons.music_note,
                              color: Colors.cyanAccent,
                              isDisabled: false,
                              onChanged:
                                  (value) =>
                                      setState(() => movementSpeed = value),
                            ),

                            const SizedBox(height: 20),

                            enableSound
                                ? CustomSlider(
                                  title: "Sound Volume",
                                  value: soundVolume,
                                  min: 0,
                                  max: 10,
                                  icon: Icons.volume_up,
                                  color: Colors.pinkAccent,
                                  isDisabled: false,
                                  onChanged:
                                      (value) => setState(() {
                                        soundVolume = value;
                                      }),
                                )
                                : GestureDetector(
                                  onTap: () {
                                    CustomToast.show(
                                      context,
                                      message: "Please enable the sound first",
                                      type: GameToastType.error,
                                    );
                                  },
                                  child: CustomSlider(
                                    title: "Sound Volume",
                                    value: soundVolume,
                                    min: 0,
                                    max: 10,
                                    icon: Icons.volume_up,
                                    color: Colors.pinkAccent,
                                    isDisabled: true,
                                    onChanged: (value) {},
                                  ),
                                ),

                            const SizedBox(height: 20),

                            DifficultySection(),

                            widget.isSettingScreen
                                ? const SizedBox(height: 20)
                                : const SizedBox(height: 35),

                            if (!widget.isSettingScreen)
                              Row(
                                children: [
                                  Expanded(
                                    child: GradientButton(
                                      label: "Resume",
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF00C6FF),
                                          Color(0xFF0072FF),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      onTap: () {
                                        Provider.of<GameState>(
                                          context,
                                          listen: false,
                                        ).togglePause();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: GradientButton(
                                      label: "Main Menu",
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF0072FF),
                                          Color(0xFF00C6FF),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const MainMenuScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: HolographicButton(
                                    verticalPadding: 12,
                                    label:
                                        widget.isSettingScreen
                                            ? "BACK"
                                            : "CANCLE",
                                    fontSize: 13,
                                    colors: const [
                                      Colors.deepOrange,
                                      Colors.red,
                                    ],
                                    onTap: () => Navigator.pop(context),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: HolographicButton(
                                    verticalPadding: 12,
                                    label: "APPLY",
                                    fontSize: 13,
                                    colors: const [
                                      Color(0xFF56ab2f),
                                      Color(0xFF56ab2f),
                                    ],
                                    onTap: applySettings,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DifficultySection extends StatefulWidget {
  const DifficultySection({super.key});

  @override
  State<DifficultySection> createState() => _DifficultySectionState();
}

class _DifficultySectionState extends State<DifficultySection> {
  String difficulty = "easy";

  Color getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case "easy":
        return Colors.green;
      case "medium":
        return Colors.orange;
      case "hard":
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  String getDifficultyText(String difficulty) {
    switch (difficulty) {
      case "easy":
        return "Easy";
      case "medium":
        return "Medium";
      case "hard":
        return "Hard";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.leaderboard, color: Colors.orangeAccent, size: 22),
            const SizedBox(width: 8),
            const Text(
              "Difficulty Level",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: DifficultyButton(
                label: "Easy",
                value: "easy",
                selectedValue: difficulty,
                color: Colors.green,
                onSelected: (val) => setState(() => difficulty = val),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DifficultyButton(
                label: "Medium",
                value: "medium",
                selectedValue: difficulty,
                color: Colors.orange,
                onSelected: (val) => setState(() => difficulty = val),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DifficultyButton(
                label: "Hard",
                value: "hard",
                selectedValue: difficulty,
                color: Colors.red,
                onSelected: (val) => setState(() => difficulty = val),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: getDifficultyColor(difficulty).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: getDifficultyColor(difficulty).withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              "Current: ${getDifficultyText(difficulty)}",
              style: TextStyle(
                color: getDifficultyColor(difficulty),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
