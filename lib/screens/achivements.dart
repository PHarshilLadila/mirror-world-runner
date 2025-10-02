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

            int crossAxisCount = 2;
            double childAspectRatio = 1.5;
            double headerFontSize = 20;
            double categoryFontSize = 14;
            double achievementTitleFontSize = 16;
            double achievementDescFontSize = 12;
            double statValueFontSize = 20;
            double statLabelFontSize = 12;
            double iconSize = 36;
            double categoryHeight = 55;
            double headerPadding = 20;
            double categoryPadding = 20;
            double gridPadding = 8;
            double categoryItemPadding = 18;
            double achievementPadding = 14;

            if (width >= 1200) {
              crossAxisCount = 5;
              childAspectRatio = 1;
              headerFontSize = 20;
              categoryFontSize = 16;
              achievementTitleFontSize = 18;
              achievementDescFontSize = 13;
              statValueFontSize = 24;
              statLabelFontSize = 14;
              iconSize = 40;
              categoryHeight = 65;
              headerPadding = 30;
              categoryPadding = 25;
              gridPadding = 12;
              categoryItemPadding = 22;
              achievementPadding = 18;
            }
            // Desktop - Medium screens
            else if (width >= 1024) {
              crossAxisCount = 4;
              childAspectRatio = 1;
              headerFontSize = 20;
              categoryFontSize = 15;
              achievementTitleFontSize = 17;
              achievementDescFontSize = 12;
              statValueFontSize = 22;
              statLabelFontSize = 13;
              iconSize = 38;
              categoryHeight = 60;
              headerPadding = 25;
              categoryPadding = 22;
              gridPadding = 10;
              categoryItemPadding = 20;
              achievementPadding = 16;
            }
            // Tablet - Landscape
            else if (width >= 900) {
              crossAxisCount = 3;
              childAspectRatio = 1.3;
              headerFontSize = 18;
              categoryFontSize = 14;
              achievementTitleFontSize = 16;
              achievementDescFontSize = 12;
              statValueFontSize = 20;
              statLabelFontSize = 12;
              iconSize = 36;
              categoryHeight = 58;
              headerPadding = 22;
              categoryPadding = 20;
              gridPadding = 10;
              categoryItemPadding = 18;
              achievementPadding = 15;
            } else if (width >= 800) {
              crossAxisCount = 3;
              childAspectRatio = 1.3;
              headerFontSize = 17;
              categoryFontSize = 14;
              achievementTitleFontSize = 16;
              achievementDescFontSize = 12;
              statValueFontSize = 20;
              statLabelFontSize = 12;
              iconSize = 36;
              categoryHeight = 58;
              headerPadding = 22;
              categoryPadding = 20;
              gridPadding = 10;
              categoryItemPadding = 18;
              achievementPadding = 15;
            }
            // Tablet - Portrait
            else if (width >= 600) {
              crossAxisCount = 2;
              childAspectRatio = height > 1000 ? 1.6 : 1.4;
              headerFontSize = 16;
              categoryFontSize = 13;
              achievementTitleFontSize = 15;
              achievementDescFontSize = 11;
              statValueFontSize = 18;
              statLabelFontSize = 11;
              iconSize = 32;
              categoryHeight = 52;
              headerPadding = 18;
              categoryPadding = 16;
              gridPadding = 8;
              categoryItemPadding = 16;
              achievementPadding = 12;
            }
            // Mobile - Large
            else if (width >= 390) {
              crossAxisCount = 2;
              childAspectRatio = 1;
              headerFontSize = 15;
              categoryFontSize = 12;
              achievementTitleFontSize = 14;
              achievementDescFontSize = 10;
              statValueFontSize = 16;
              statLabelFontSize = 10;
              iconSize = 30;
              categoryHeight = 48;
              headerPadding = 16;
              categoryPadding = 14;
              gridPadding = 6;
              categoryItemPadding = 14;
              achievementPadding = 10;
            }
            // Mobile - Small
            else {
              crossAxisCount = 1;
              childAspectRatio = 1.8;
              headerFontSize = 15;
              categoryFontSize = 11;
              achievementTitleFontSize = 13;
              achievementDescFontSize = 9;
              statValueFontSize = 14;
              statLabelFontSize = 9;
              iconSize = 28;
              categoryHeight = 45;
              headerPadding = 12;
              categoryPadding = 12;
              gridPadding = 4;
              categoryItemPadding = 12;
              achievementPadding = 8;
            }

            if (height > 1000 && isMobile) {
              childAspectRatio = 1.3;
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
                            return SizedBox(
                              height: isDesktop ? 60 : 50,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isDesktop ? 12 : 8,
                                ),
                                itemCount: provider.categories.length,
                                separatorBuilder:
                                    (_, __) =>
                                        SizedBox(width: isDesktop ? 12 : 6),
                                itemBuilder: (context, index) {
                                  final category = provider.categories[index];
                                  final isSelected =
                                      category == provider.selectedCategory;

                                  return GestureDetector(
                                    onTap: () => provider.setCategory(category),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeInOut,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: categoryItemPadding,
                                        vertical:
                                            isDesktop
                                                ? 14
                                                : isTablet
                                                ? 10
                                                : 8,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient:
                                            isSelected
                                                ? LinearGradient(
                                                  colors: [
                                                    Colors.amber.shade400,
                                                    Colors.orange.shade600,
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                )
                                                : const LinearGradient(
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.transparent,
                                                  ],
                                                ),
                                        borderRadius: BorderRadius.circular(12),
                                        border:
                                            isSelected
                                                ? null
                                                : Border.all(
                                                  color: Colors.white38,
                                                  width: 1,
                                                ),
                                        boxShadow:
                                            isSelected
                                                ? [
                                                  BoxShadow(
                                                    color: Colors.amber
                                                        .withOpacity(0.5),
                                                    blurRadius: 12,
                                                    spreadRadius: 2,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                                : [],
                                      ),
                                      child: Center(
                                        child: Text(
                                          category,
                                          style: TextStyle(
                                            color:
                                                isSelected
                                                    ? Colors.black
                                                    : Colors.white70,
                                            fontWeight: FontWeight.w600,
                                            fontSize: categoryFontSize,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
                                  final isUnlocked = index % 3 != 0;
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient:
                                            isUnlocked
                                                ? LinearGradient(
                                                  colors: [
                                                    Colors.blueGrey.shade800,
                                                    Colors.black.withOpacity(
                                                      0.8,
                                                    ),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                )
                                                : LinearGradient(
                                                  colors: [
                                                    Colors.grey.shade800,
                                                    Colors.grey.shade900,
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                        borderRadius: BorderRadius.circular(
                                          isDesktop ? 20 : 16,
                                        ),
                                        border: Border.all(
                                          color:
                                              isUnlocked
                                                  ? Colors.amber.shade400
                                                  : Colors.grey.shade600,
                                          width: isDesktop ? 2 : 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                isUnlocked
                                                    ? Colors.amber.withOpacity(
                                                      0.2,
                                                    )
                                                    : Colors.black.withOpacity(
                                                      0.4,
                                                    ),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(
                                        achievementPadding,
                                      ),
                                      child: Stack(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(
                                                  isDesktop ? 10 : 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient:
                                                      isUnlocked
                                                          ? LinearGradient(
                                                            colors: [
                                                              Colors
                                                                  .amber
                                                                  .shade200,
                                                              Colors
                                                                  .orange
                                                                  .shade400,
                                                            ],
                                                          )
                                                          : LinearGradient(
                                                            colors: [
                                                              Colors
                                                                  .grey
                                                                  .shade500,
                                                              Colors
                                                                  .grey
                                                                  .shade700,
                                                            ],
                                                          ),
                                                  boxShadow:
                                                      isUnlocked
                                                          ? [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .amber
                                                                  .withOpacity(
                                                                    0.4,
                                                                  ),
                                                              blurRadius: 15,
                                                              spreadRadius: 2,
                                                            ),
                                                          ]
                                                          : [],
                                                ),
                                                child: Icon(
                                                  isUnlocked
                                                      ? Icons.emoji_events
                                                      : Icons.lock_outline,
                                                  color:
                                                      isUnlocked
                                                          ? Colors.white
                                                          : Colors
                                                              .grey
                                                              .shade300,
                                                  size: iconSize,
                                                ),
                                              ),
                                              SizedBox(
                                                height: isDesktop ? 12 : 8,
                                              ),

                                              Text(
                                                achv["title"] ?? "",
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color:
                                                      isUnlocked
                                                          ? Colors.white
                                                          : Colors
                                                              .grey
                                                              .shade400,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      achievementTitleFontSize,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              SizedBox(
                                                height: isDesktop ? 6 : 4,
                                              ),

                                              Text(
                                                achv["desc"] ?? "",
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color:
                                                      isUnlocked
                                                          ? Colors.white70
                                                          : Colors
                                                              .grey
                                                              .shade500,
                                                  fontSize:
                                                      achievementDescFontSize,
                                                  height: 1.3,
                                                ),
                                              ),
                                              SizedBox(
                                                height: isDesktop ? 10 : 6,
                                              ),

                                              if (!isUnlocked)
                                                Container(
                                                  height: isDesktop ? 6 : 4,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade800,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          3,
                                                        ),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        width: 60,
                                                        decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  Colors
                                                                      .amber
                                                                      .shade400,
                                                                  Colors
                                                                      .orange
                                                                      .shade400,
                                                                ],
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                3,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),

                                          if (isUnlocked)
                                            Positioned(
                                              bottom: isDesktop ? 8 : 4,
                                              right: isDesktop ? 8 : 4,
                                              child: Container(
                                                width: isDesktop ? 28 : 20,
                                                height: isDesktop ? 28 : 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.green.shade500,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.green
                                                          .withOpacity(0.6),
                                                      blurRadius: 6,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: isDesktop ? 16 : 12,
                                                ),
                                              ),
                                            ),

                                          if (!isUnlocked && index % 2 == 0)
                                            Positioned(
                                              bottom: isDesktop ? 8 : 4,
                                              right: isDesktop ? 8 : 4,
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        isDesktop ? 12 : 8,
                                                    vertical: isDesktop ? 6 : 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                          colors: [
                                                            Colors.green,
                                                            Colors.lightGreen,
                                                          ],
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          isDesktop ? 12 : 8,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.green
                                                            .withOpacity(0.4),
                                                        blurRadius: 8,
                                                        offset: const Offset(
                                                          0,
                                                          2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    'COLLECT',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          isDesktop ? 10 : 8,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                          if (!isUnlocked && index % 2 != 0)
                                            Positioned(
                                              top: isDesktop ? 8 : 4,
                                              right: isDesktop ? 8 : 4,
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                  isDesktop ? 4 : 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.lock,
                                                  color: Colors.grey.shade400,
                                                  size: isDesktop ? 16 : 12,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
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
