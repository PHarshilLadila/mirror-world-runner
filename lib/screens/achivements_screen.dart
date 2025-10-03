// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mirror_world_runner/widgets/achievement_card.dart';
import 'package:mirror_world_runner/widgets/particle_painter.dart';
import 'package:mirror_world_runner/widgets/particles.dart';
import 'package:mirror_world_runner/providers/achievements_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isAnimating = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

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
      _initializeAchievements();
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

  void _initializeAchievements() async {
    if (_isInitialized) return;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString("USERID") ?? "";

    if (userId.isNotEmpty) {
      debugPrint('User ID from SharedPreferences: $userId');

      final achievementsProvider = Provider.of<AchievementsProvider>(
        context,
        listen: false,
      );
      await achievementsProvider.fetchUserAchievements(userId);

      _isInitialized = true;
    } else {
      debugPrint('No user ID found in SharedPreferences');
    }
  }

  void _startCategoryAnimation() {
    _categoryAnimationController.forward(from: 0.0);
  }

  void _onCategoryChanged(String newCategory) {
    if (newCategory != _currentCategory && !_isAnimating) {
      setState(() {
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

    return Scaffold(
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
            childAspectRatio = 0.9;
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
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
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
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height:
                              isDesktop
                                  ? 30
                                  : isTablet
                                  ? 20
                                  : 16,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Consumer<AchievementsProvider>(
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
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height:
                              isDesktop
                                  ? 25
                                  : isTablet
                                  ? 18
                                  : 16,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: AnimatedBuilder(
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
                      ),
                      SliverToBoxAdapter(
                        child: Consumer<AchievementsProvider>(
                          builder: (context, provider, _) {
                            final unlockedCount =
                                provider.unlockedAchievementsCount;
                            final totalCount = provider.totalAchievementsCount;
                            final progressPercentage =
                                provider.progressPercentage;

                            return Container(
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
                                    totalCount.toString(),
                                    "Total",
                                    statValueFontSize,
                                    statLabelFontSize,
                                  ),
                                  _buildStatItem(
                                    unlockedCount.toString(),
                                    "Unlocked",
                                    statValueFontSize,
                                    statLabelFontSize,
                                  ),
                                  _buildStatItem(
                                    (totalCount - unlockedCount).toString(),
                                    "Locked",
                                    statValueFontSize,
                                    statLabelFontSize,
                                  ),
                                  _buildStatItem(
                                    "${(progressPercentage * 100).toStringAsFixed(0)}%",
                                    "Progress",
                                    statValueFontSize,
                                    statLabelFontSize,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      if (!(isMobile && height > width && width < 400))
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height:
                                isDesktop
                                    ? 20
                                    : isTablet
                                    ? 16
                                    : 12,
                          ),
                        ),
                      Consumer<AchievementsProvider>(
                        builder: (context, provider, _) {
                          final achievements = provider.currentAchievements;
                          return SliverPadding(
                            padding: EdgeInsets.all(gridPadding),
                            sliver: SliverGrid(
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
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final achv = achievements[index];
                                final achievementProgress = provider
                                    .getAchievementProgress(
                                      achv["title"] ?? "",
                                    );
                                final isUnlocked =
                                    achievementProgress['isUnlocked'] ?? false;
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
                              }, childCount: achievements.length),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  int _getAchievementsCount(String category) {
    switch (category) {
      case "Survival Master":
        return 5;
      case "Power Collector":
        return 5;
      case "Addicted Runner":
        return 5;
      case "Score Champion":
        return 5;
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
