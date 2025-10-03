// ignore_for_file: deprecated_member_use, use_build_context_synchronously

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
    with TickerProviderStateMixin {
  late Ticker _ticker;
  final List<Particles> _particles = [];
  final ValueNotifier<int> _particleNotifier = ValueNotifier<int>(0);
  Duration _lastElapsed = Duration.zero;
  final numberOfParticle = kIsWeb ? 60 : 50;

  late AnimationController _categoryAnimationController;
  late Animation<double> _categoryImageAnimation;
  late Animation<Offset> _categoryTextAnimation;

  String _currentCategory = "Survival Master";
  String _previousCategory = "Survival Master";
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.fetchCurrentUser();
    });

    _categoryAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _categoryImageAnimation = Tween<double>(begin: 10.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _categoryAnimationController,
        curve: const Interval(0.0, 0.7, curve: Curves.fastEaseInToSlowEaseOut),
      ),
    );

    _categoryTextAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _categoryAnimationController,
        curve: const Interval(0.1, 1.0, curve: Curves.easeOutBack),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCategoryAnimation();
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

  void _startCategoryAnimation() {
    _categoryAnimationController.forward(from: 0.0);
  }

  void _onCategoryChanged(String newCategory) {
    if (newCategory != _currentCategory && !_isAnimating) {
      setState(() {
        _previousCategory = _currentCategory;
        _currentCategory = newCategory;
        _isAnimating = true;
      });

      _categoryAnimationController.forward(from: 0.0).then((_) {
        setState(() {
          _isAnimating = false;
        });
      });
    }
  }

  String _getCategoryImagePath(String category) {
    switch (category) {
      case "Survival Master":
        return 'assets/images/png/survival.png';
      case "Power Collector":
        return 'assets/images/png/powerup.png';
      case "Addicted Runner":
        return 'assets/images/png/addicted.png';
      case "Score Champion":
        return 'assets/images/png/score_master.png';
      default:
        return 'assets/images/png/survival.png';
    }
  }

  String _getCategoryTitle(String category) {
    switch (category) {
      case "Survival Master":
        return "SURVIVAL MASTER";
      case "Power Collector":
        return "POWER COLLECTOR";
      case "Addicted Runner":
        return "ADDICTED RUNNER";
      case "Score Champion":
        return "SCORE CHAMPION";
      default:
        return "ACHIEVEMENTS";
    }
  }

  String _getCategoryDescription(String category) {
    switch (category) {
      case "Survival Master":
        return "Prove your endurance by surviving against all odds";
      case "Power Collector":
        return "Master the art of collecting powerful items";
      case "Addicted Runner":
        return "Show your dedication with countless runs";
      case "Score Champion":
        return "Reach new heights with incredible scores";
      default:
        return "Unlock amazing achievements";
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _categoryAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width >= 1024;
    final isTablet = screenSize.width >= 600 && screenSize.width < 1024;
    final isMobile = screenSize.width < 600;
    final isSmallMobile = screenSize.width < 400;
    final isExtraSmallMobile = screenSize.width < 280;

    return ChangeNotifierProvider(
      create: (_) => AchievementsProvider(),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;

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
              crossAxisCount = 4;
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
                    padding: EdgeInsets.all(headerPadding),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: BackButton(),
                              ),
                              Text(
                                'ACHIEVEMENTS',
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
                                  isExpanded: true,
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
                                              child: Text(
                                                cat,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      provider.setCategory(value);
                                      _onCategoryChanged(value);
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
                        AnimatedBuilder(
                          animation: _categoryAnimationController,
                          builder: (context, child) {
                            return Container(
                              width: double.infinity,
                              height:
                                  isDesktop
                                      ? 200
                                      : isTablet
                                      ? 180
                                      : isMobile
                                      ? 200
                                      : isSmallMobile
                                      ? 180
                                      : isExtraSmallMobile
                                      ? 200
                                      : 180,
                              margin: EdgeInsets.only(
                                bottom:
                                    isDesktop
                                        ? 25
                                        : isTablet
                                        ? 18
                                        : 16,
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blueGrey.shade800.withOpacity(
                                            0.7,
                                          ),
                                          Colors.black.withOpacity(0.5),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white24,
                                        width: 1,
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.all(
                                      isDesktop
                                          ? 20
                                          : isTablet
                                          ? 16
                                          : 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: SlideTransition(
                                            position: _categoryTextAnimation,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _getCategoryTitle(
                                                    _currentCategory,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize:
                                                        isDesktop
                                                            ? 28
                                                            : isTablet
                                                            ? 22
                                                            : 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.amber,
                                                    letterSpacing: 1.2,
                                                    shadows: const [
                                                      Shadow(
                                                        color: Colors.black54,
                                                        offset: Offset(2, 2),
                                                        blurRadius: 4,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: isDesktop ? 8 : 6,
                                                ),
                                                Text(
                                                  _getCategoryDescription(
                                                    _currentCategory,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize:
                                                        isDesktop
                                                            ? 16
                                                            : isTablet
                                                            ? 14
                                                            : 12,
                                                    color: Colors.white70,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(
                                                  height: isDesktop ? 12 : 8,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        isDesktop ? 16 : 12,
                                                    vertical: isDesktop ? 8 : 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.amber.shade600,
                                                        Colors.orange.shade400,
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.amber
                                                            .withOpacity(0.4),
                                                        blurRadius: 10,
                                                        offset: const Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    '${_getAchievementsCount(_currentCategory)} ACHIEVEMENTS',
                                                    style: TextStyle(
                                                      fontSize:
                                                          isDesktop
                                                              ? 14
                                                              : isTablet
                                                              ? 12
                                                              : 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      letterSpacing: 0.5,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: ScaleTransition(
                                            scale: _categoryImageAnimation,
                                            child: SizedBox(
                                              height: double.infinity,
                                              child: Image.asset(
                                                _getCategoryImagePath(
                                                  _currentCategory,
                                                ),
                                                fit: BoxFit.contain,
                                                filterQuality:
                                                    FilterQuality.high,
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
                          },
                        ),
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
                              borderRadius: BorderRadius.circular(12),
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
                                  "18",
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
                                    child: AchievementCard(
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

  int _getAchievementsCount(String category) {
    switch (category) {
      case "Survival Master":
        return 4;
      case "Power Collector":
        return 5;
      case "Addicted Runner":
        return 5;
      case "Score Champion":
        return 4;
      default:
        return 0;
    }
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

class AchievementCard extends StatefulWidget {
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

  const AchievementCard({
    super.key,
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
  State<AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<AchievementCard>
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

  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _flipCard,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..translate(0.0, _isHovered ? -10.0 : 0.0)
                ..scale(_isHovered ? 1.005 : 1.0),
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
                          transform: Matrix4.identity()..rotateY(3.14159),
                          alignment: Alignment.center,
                          child: _buildBackSide(),
                        ),
              );
            },
          ),
        ),
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
        borderRadius: BorderRadius.circular(12),
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
                  maxLines: 3,
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
                  maxLines: 3,
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
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Column(
              children: [
                Container(
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
                SizedBox(height: 4),
                Text(
                  "Flip",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(fontSize: 6),
                ),
              ],
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
        borderRadius: BorderRadius.circular(12),
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

                Text(
                  '${(widget.progress * 100).toStringAsFixed(0)}% Complete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.achievementDescFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: widget.isDesktop ? 8 : 4),

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
                    borderRadius: BorderRadius.circular(12),
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
