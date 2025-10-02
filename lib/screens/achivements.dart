import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mirror_world_runner/providers/auth_provider.dart';
import 'package:mirror_world_runner/widgets/particle_painter.dart';
import 'package:mirror_world_runner/widgets/particles.dart';
import 'package:mirror_world_runner/providers/achievements_provider.dart';
import 'package:provider/provider.dart';

class AchivementsScreen extends StatefulWidget {
  const AchivementsScreen({super.key});

  @override
  State<AchivementsScreen> createState() => _AchivementsScreenState();
}

class _AchivementsScreenState extends State<AchivementsScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final List<Particles> _particles = [];
  final ValueNotifier<int> _particleNotifier = ValueNotifier<int>(0);
  Duration _lastElapsed = Duration.zero;
  final numberOfParticle = kIsWeb ? 60 : 50;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.fetchCurrentUser();
    });

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width >= 1024;
    final isTablet = screenSize.width >= 600 && screenSize.width < 1024;
    final isMobile = screenSize.width < 600;

    return ChangeNotifierProvider(
      create: (_) => AchievementsProvider(),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;

            // Responsive grid calculation
            int crossAxisCount = 2;
            double childAspectRatio = 1.5;
            double headerFontSize = 16;
            double achievementTitleFontSize = 16;
            double achievementDescFontSize = 12;
            double statValueFontSize = 20;
            double statLabelFontSize = 12;
            double iconSize = 36;
            double headerPadding = 20;
            double gridPadding = 8;
            double achievementPadding = 14;

            // Desktop - Large screens
            if (width >= 1400) {
              crossAxisCount = 5;
              childAspectRatio = 1;
              headerFontSize = 28;
              achievementTitleFontSize = 18;
              achievementDescFontSize = 13;
              statValueFontSize = 24;
              statLabelFontSize = 14;
              iconSize = 40;
              headerPadding = 30;
              gridPadding = 12;
              achievementPadding = 18;
            } else if (width >= 1200) {
              crossAxisCount = 5;
              childAspectRatio = 1;
              headerFontSize = 28;
              achievementTitleFontSize = 18;
              achievementDescFontSize = 13;
              statValueFontSize = 24;
              statLabelFontSize = 14;
              iconSize = 40;
              headerPadding = 30;
              gridPadding = 12;
              achievementPadding = 18;
            } else if (width >= 1024) {
              crossAxisCount = 4;
              childAspectRatio = 1;
              headerFontSize = 26;
              achievementTitleFontSize = 17;
              achievementDescFontSize = 12;
              statValueFontSize = 22;
              statLabelFontSize = 13;
              iconSize = 38;
              headerPadding = 25;
              gridPadding = 10;
              achievementPadding = 16;
            } else if (width >= 900) {
              crossAxisCount = 3;
              childAspectRatio = 1.3;
              headerFontSize = 24;
              achievementTitleFontSize = 16;
              achievementDescFontSize = 12;
              statValueFontSize = 20;
              statLabelFontSize = 12;
              iconSize = 36;
              headerPadding = 22;
              gridPadding = 10;
              achievementPadding = 15;
            } else if (width >= 600) {
              crossAxisCount = 2;
              childAspectRatio = height > 1000 ? 1.6 : 1.4;
              headerFontSize = 22;
              achievementTitleFontSize = 15;
              achievementDescFontSize = 11;
              statValueFontSize = 18;
              statLabelFontSize = 11;
              iconSize = 32;
              headerPadding = 18;
              gridPadding = 8;
              achievementPadding = 12;
            } else if (width >= 390) {
              crossAxisCount = 2;
              childAspectRatio = 1;
              headerFontSize = 20;
              achievementTitleFontSize = 14;
              achievementDescFontSize = 10;
              statValueFontSize = 16;
              statLabelFontSize = 10;
              iconSize = 30;
              headerPadding = 16;
              gridPadding = 6;
              achievementPadding = 10;
            } else {
              crossAxisCount = 1;
              childAspectRatio = 1.8;
              headerFontSize = 18;
              achievementTitleFontSize = 13;
              achievementDescFontSize = 9;
              statValueFontSize = 14;
              statLabelFontSize = 9;
              iconSize = 28;
              headerPadding = 12;
              gridPadding = 4;
              achievementPadding = 8;
            }

            return Stack(
              children: [
                // Background gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade900,
                        Colors.indigo.shade900,
                        Colors.black87,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),

                // Particle effect
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

                // Content
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(headerPadding),
                    child: Column(
                      children: [
                        // Header
                        SizedBox(
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white24,
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Colors.white,
                                      size: isDesktop ? 24 : 20,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '🏆 ACHIEVEMENTS',
                                style: TextStyle(
                                  fontSize: headerFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black54,
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height:
                              isDesktop
                                  ? 30
                                  : isTablet
                                  ? 20
                                  : 16,
                        ),

                        Consumer<AchievementsProvider>(
                          builder: (context, provider, _) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blueGrey.shade800.withOpacity(0.6),
                                    Colors.black.withOpacity(0.4),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 1,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true, // Important for mobile
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  dropdownColor: Colors.grey.shade900,
                                  value: provider.selectedCategory,
                                  items:
                                      provider.categories
                                          .map(
                                            (cat) => DropdownMenuItem<String>(
                                              value: cat,
                                              child: Flexible(
                                                child: Text(
                                                  cat,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      provider.setCategory(value);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(
                          height:
                              isDesktop
                                  ? 25
                                  : isTablet
                                  ? 18
                                  : 16,
                        ),

                        // Stats Bar
                        if (!(isMobile && height > width && width < 400))
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(
                              isDesktop
                                  ? 20
                                  : isTablet
                                  ? 16
                                  : 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueGrey.shade800.withOpacity(0.6),
                                  Colors.black.withOpacity(0.4),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white24,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  isDesktop
                                      ? MainAxisAlignment.spaceAround
                                      : MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStatItem(
                                  "12",
                                  "Total",
                                  statValueFontSize,
                                  statLabelFontSize,
                                ),
                                _buildStatItem(
                                  "8",
                                  "Unlocked",
                                  statValueFontSize,
                                  statLabelFontSize,
                                ),
                                if (width >= 400)
                                  _buildStatItem(
                                    "4",
                                    "Locked",
                                    statValueFontSize,
                                    statLabelFontSize,
                                  ),
                                if (width >= 500)
                                  _buildStatItem(
                                    "67%",
                                    "Progress",
                                    statValueFontSize,
                                    statLabelFontSize,
                                  ),
                              ],
                            ),
                          ),
                        if (!(isMobile && height > width && width < 400))
                          SizedBox(
                            height:
                                isDesktop
                                    ? 20
                                    : isTablet
                                    ? 16
                                    : 12,
                          ),

                        // Achievements Grid
                        Expanded(
                          child: Consumer<AchievementsProvider>(
                            builder: (context, provider, _) {
                              final achievements = provider.currentAchievements;
                              return GridView.builder(
                                padding: EdgeInsets.all(gridPadding),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing:
                                          isDesktop
                                              ? 20
                                              : isTablet
                                              ? 15
                                              : 10,
                                      mainAxisSpacing:
                                          isDesktop
                                              ? 20
                                              : isTablet
                                              ? 15
                                              : 10,
                                      childAspectRatio: childAspectRatio,
                                    ),
                                itemCount: achievements.length,
                                itemBuilder: (context, index) {
                                  final achv = achievements[index];
                                  final achievementProgress = provider
                                      .getAchievementProgress(
                                        achv["title"] ?? "",
                                      );
                                  final isUnlocked =
                                      achievementProgress['isUnlocked'] ??
                                      false;
                                  final currentValue =
                                      achievementProgress['current'] ?? 0;
                                  final targetValue =
                                      achievementProgress['target'] ?? 1;
                                  final progress =
                                      achievementProgress['progress'] ?? 0.0;

                                  return TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0.9, end: 1.0),
                                    duration: Duration(
                                      milliseconds: 400 + index * 80,
                                    ),
                                    curve: Curves.easeOutBack,
                                    builder: (context, scale, child) {
                                      return Transform.scale(
                                        scale: scale,
                                        child: child,
                                      );
                                    },
                                    child: _AchievementCard(
                                      title: achv["title"] ?? "",
                                      description: achv["desc"] ?? "",
                                      isUnlocked: isUnlocked,
                                      currentValue: currentValue,
                                      targetValue: targetValue,
                                      progress: progress,
                                      iconSize: iconSize,
                                      achievementPadding: achievementPadding,
                                      isDesktop: isDesktop,
                                      achievementTitleFontSize:
                                          achievementTitleFontSize,
                                      achievementDescFontSize:
                                          achievementDescFontSize,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    double valueSize,
    double labelSize,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.amber,
            fontSize: valueSize,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(
                color: Colors.black54,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        SizedBox(height: valueSize * 0.2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: labelSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _AchievementCard extends StatefulWidget {
  final String title;
  final String description;
  final bool isUnlocked;
  final int currentValue;
  final int targetValue;
  final double progress;
  final double iconSize;
  final double achievementPadding;
  final bool isDesktop;
  final double achievementTitleFontSize;
  final double achievementDescFontSize;

  const _AchievementCard({
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.currentValue,
    required this.targetValue,
    required this.progress,
    required this.iconSize,
    required this.achievementPadding,
    required this.isDesktop,
    required this.achievementTitleFontSize,
    required this.achievementDescFontSize,
  });

  @override
  State<_AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<_AchievementCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * 3.14159;
          final transform =
              Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child:
                _controller.value < 0.5
                    ? _buildFrontSide()
                    : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.14159),
                      child: _buildBackSide(),
                    ),
          );
        },
      ),
    );
  }

  Widget _buildFrontSide() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade800, Colors.grey.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(widget.isDesktop ? 20 : 16),
        border: Border.all(
          color:
              widget.isUnlocked ? Colors.amber.shade400 : Colors.grey.shade600,
          width: widget.isDesktop ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color:
                widget.isUnlocked
                    ? Colors.amber.withOpacity(0.2)
                    : Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(widget.achievementPadding),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(widget.isDesktop ? 10 : 6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors:
                          widget.isUnlocked
                              ? [Colors.amber.shade600, Colors.orange.shade400]
                              : [Colors.grey.shade600, Colors.grey.shade800],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            widget.isUnlocked
                                ? Colors.amber.withOpacity(0.4)
                                : Colors.grey.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.isUnlocked ? Icons.emoji_events : Icons.lock,
                    color: Colors.white,
                    size: widget.iconSize,
                  ),
                ),
                SizedBox(height: widget.isDesktop ? 12 : 8),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        widget.isUnlocked ? Colors.white : Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: widget.achievementTitleFontSize,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: widget.isDesktop ? 6 : 4),
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        widget.isUnlocked
                            ? Colors.white70
                            : Colors.grey.shade500,
                    fontSize: widget.achievementDescFontSize,
                    height: 1.3,
                  ),
                ),
                if (!widget.isUnlocked)
                  SizedBox(height: widget.isDesktop ? 10 : 6),
                if (!widget.isUnlocked)
                  Container(
                    height: widget.isDesktop ? 6 : 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width:
                              (MediaQuery.of(context).size.width * 0.15) *
                              widget.progress,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade400,
                                Colors.orange.shade400,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (widget.isUnlocked)
                  (Container(
                    color: Colors.pink,
                    child: Text("Achievement Done"),
                  )),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.flip,
                color: Colors.white70,
                size: widget.isDesktop ? 16 : 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackSide() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(widget.isDesktop ? 20 : 16),
        border: Border.all(
          color: Colors.blueGrey.shade400,
          width: widget.isDesktop ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(widget.achievementPadding),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: widget.isDesktop ? 100 : 80,
                      height: widget.isDesktop ? 100 : 80,
                      child: CircularProgressIndicator(
                        value: widget.progress,

                        strokeWidth: widget.isDesktop ? 8 : 6,
                        backgroundColor: Colors.grey.shade800,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.isUnlocked
                              ? Colors.amber
                              : Colors.blue.shade400,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${widget.currentValue}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.isDesktop ? 16 : 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '/${widget.targetValue}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: widget.isDesktop ? 12 : 9,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: widget.isDesktop ? 12 : 8),

                // Progress Text
                Text(
                  '${(widget.progress * 100).toStringAsFixed(0)}% Complete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.achievementDescFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: widget.isDesktop ? 8 : 4),

                // Linear Progress
                Container(
                  height: widget.isDesktop ? 8 : 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width:
                            (MediaQuery.of(context).size.width * 0.2) *
                            widget.progress,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:
                                widget.isUnlocked
                                    ? [
                                      Colors.amber.shade400,
                                      Colors.orange.shade400,
                                    ]
                                    : [
                                      Colors.blue.shade400,
                                      Colors.blue.shade600,
                                    ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: widget.isDesktop ? 8 : 4),

                // Status
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.isDesktop ? 12 : 8,
                    vertical: widget.isDesktop ? 4 : 2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        widget.isUnlocked
                            ? Colors.amber.withOpacity(0.2)
                            : Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.isUnlocked ? Colors.amber : Colors.blue,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.isUnlocked ? 'UNLOCKED' : 'IN PROGRESS',
                    style: TextStyle(
                      color:
                          widget.isUnlocked
                              ? Colors.amber
                              : Colors.blue.shade300,
                      fontSize: widget.isDesktop ? 12 : 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Flip indicator
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.flip,
                color: Colors.white70,
                size: widget.isDesktop ? 16 : 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
