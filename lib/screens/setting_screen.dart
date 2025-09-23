// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mirror_world_runner/providers/game_state.dart';
import 'package:mirror_world_runner/screens/main_menu.dart';
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
  late Ticker _ticker;
  final numberOfParticle = kIsWeb ? 80 : 60;
  Duration _lastElapsed = Duration.zero;
  final ValueNotifier<int> _particleNotifier = ValueNotifier<int>(0);

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

    _loadSettingsFromSharedpreference();
  }

  Future<void> _loadSettingsFromSharedpreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      movementSpeed = prefs.getDouble('movementSpeed') ?? 5.0;
      soundVolume = prefs.getDouble('soundVolume') ?? 7.0;
      difficulty = prefs.getString('difficulty') ?? "medium";
      enableSound = prefs.getBool('enableSound') ?? true;
      enableNotifications = prefs.getBool('enableNotifications') ?? true;
    });
  }

  Future<void> _saveSettingsInToSharedpreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('movementSpeed', movementSpeed);
    await prefs.setDouble('soundVolume', soundVolume);
    await prefs.setString('difficulty', difficulty);
    await prefs.setBool('enableSound', enableSound);
    await prefs.setBool('enableNotifications', enableNotifications);
  }

  void _applySettings() {
    _saveSettingsInToSharedpreference();
    if (widget.onSpeedChanged != null) {
      widget.onSpeedChanged!(movementSpeed);
    }
    if (widget.onDifficultyChanged != null) {
      widget.onDifficultyChanged!(difficulty);
    }
    Navigator.pop(context);
  }

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

  final List<Particle> _particles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
          Center(child: buildSettingDialog()),
        ],
      ),
    );
  }

  Widget buildSettingDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12),
      child: Container(
        width: kIsWeb ? 500 : double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.35),
              Colors.indigo.shade900,
              Colors.purple.shade900,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 80,
              spreadRadius: 50,
            ),
          ],
        ),
        padding: const EdgeInsets.all(28),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 18),
              Text(
                'SETTINGS',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black87,
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              Column(
                children: [
                  _buildToggleSetting(
                    "Sound",
                    enableSound,
                    Icons.music_note,
                    (value) => setState(() => enableSound = value),
                  ),
                  _buildToggleSetting(
                    "Notifications",
                    enableNotifications,
                    Icons.notifications,
                    (value) => setState(() => enableNotifications = value),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Divider(color: Colors.white24, thickness: 1),
              const SizedBox(height: 20),

              _buildSliderSetting(
                "Movement Speed",
                movementSpeed,
                1,
                10,
                Icons.speed,
                Colors.cyanAccent,
                false,
                (value) => setState(() => movementSpeed = value),
              ),
              const SizedBox(height: 20),
              enableSound == true
                  ? _buildSliderSetting(
                    "Sound Volume",
                    soundVolume,
                    0,
                    10,
                    Icons.volume_up,
                    Colors.pinkAccent,
                    false,
                    (value) => setState(() {
                      soundVolume = value;
                    }),
                  )
                  : GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enable the sound first"),
                        ),
                      );
                    },
                    child: _buildSliderSetting(
                      "Sound Volume",
                      soundVolume,
                      0,
                      10,
                      Icons.volume_up,
                      Colors.pinkAccent,
                      true,
                      (value) => setState(() {
                        // soundVolume = value;
                      }),
                    ),
                  ),
              const SizedBox(height: 20),

              _buildDifficultySection(),

              widget.isSettingScreen == true
                  ? SizedBox(height: 20)
                  : const SizedBox(height: 35),
              widget.isSettingScreen == true
                  ? SizedBox()
                  : Row(
                    children: [
                      Expanded(
                        child: _buildGradientButton(
                          label: 'Resume',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
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
                        child: _buildGradientButton(
                          label: 'Main Menu',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0072FF), Color(0xFF00C6FF)],
                          ),
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainMenuScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildActionButton(
                      "CANCEL",
                      Icons.close_rounded,
                      Color(0xFFFF4E50),
                      () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 12),

                  Expanded(
                    child: _buildActionButton(
                      "APPLY",
                      Icons.check_circle_rounded,
                      Color(0xFF56ab2f),
                      _applySettings,
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

  Widget _buildDifficultySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.leaderboard, color: Colors.orangeAccent, size: 22),
            const SizedBox(width: 8),
            Text(
              "Difficulty Level",
              style: const TextStyle(
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
              child: _buildDifficultyButton("Easy", "easy", Colors.greenAccent),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildDifficultyButton(
                "Medium",
                "medium",
                Colors.orangeAccent,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildDifficultyButton("Hard", "hard", Colors.redAccent),
            ),
          ],
        ),
        SizedBox(height: 8),

        Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: getDifficultyColor(difficulty).withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: getDifficultyColor(difficulty).withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                color: getDifficultyColor(difficulty),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "Current: ${getDifficultyText(difficulty)}",
                style: TextStyle(
                  color: getDifficultyColor(difficulty),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyButton(String label, String value, Color color) {
    bool isSelected = difficulty == value;

    return AnimatedButton(
      onTap: () => setState(() => difficulty = value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: [color, Color.lerp(color, Colors.black, 0.3)!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                  : null,
          color: isSelected ? null : Colors.grey.shade800.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade600,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return AnimatedButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderSetting(
    String title,
    double value,
    double min,
    double max,
    IconData icon,
    Color color,
    bool isDisable,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            thumbShape: CustomThumbShape(),
            overlayColor: color.withOpacity(0.2),
            activeTrackColor: color,
            inactiveTrackColor: Colors.white24,
            thumbColor: color,
            disabledActiveTrackColor: Colors.grey.shade700,
            disabledInactiveTrackColor: Colors.grey.shade800,
            disabledThumbColor: Colors.grey.shade600,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            label: value.toStringAsFixed(1),
            onChanged: isDisable ? null : onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSetting(
    String title,
    bool value,
    IconData icon,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.cyanAccent,
            activeTrackColor: Colors.cyanAccent.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    Function() onTap,
  ) {
    return AnimatedButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, Color.lerp(color, Colors.black, 0.4)!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: Transform.scale(
        scale: _isPressed ? 0.95 : 1.0,
        child: AnimatedOpacity(
          opacity: _isPressed ? 0.8 : 1.0,
          duration: Duration(milliseconds: 100),
          child: widget.child,
        ),
      ),
    );
  }
}

class CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(18, 18);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Paint paint =
        Paint()
          ..shader = RadialGradient(
            colors: [sliderTheme.thumbColor!, Colors.white],
          ).createShader(Rect.fromCircle(center: center, radius: 10));

    canvas.drawCircle(center, 9, paint);
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);
  }
}
