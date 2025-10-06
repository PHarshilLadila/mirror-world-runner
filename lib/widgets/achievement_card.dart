// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

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
  late AnimationController animationController;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void flipCard() {
    if (isFront) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
    isFront = !isFront;
  }

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: flipCard,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..translate(0.0, isHovered ? -10.0 : 0.0)
                ..scale(isHovered ? 1.005 : 1.0),
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              final angle = animationController.value * 3.14159;
              final transform =
                  Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle);

              return Transform(
                transform: transform,
                alignment: Alignment.center,
                child:
                    animationController.value < 0.5
                        ? frontSide()
                        : Transform(
                          transform: Matrix4.identity()..rotateY(3.14159),
                          alignment: Alignment.center,
                          child: backSide(),
                        ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget frontSide() {
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
                if (widget.isUnlocked)
                  SizedBox(height: widget.isDesktop ? 10 : 6),
                if (widget.isUnlocked)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.isDesktop ? 12 : 8,
                      vertical: widget.isDesktop ? 4 : 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),

                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber, width: 1),
                    ),
                    child: Text(
                      'ACHIEVED',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: widget.isDesktop ? 12 : 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
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

  Widget backSide() {
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
                        backgroundColor: Colors.white12,
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

                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors:
                            widget.isUnlocked
                                ? [
                                  Colors.amber.shade400,
                                  Colors.orange.shade400,
                                ]
                                : [Colors.blue.shade400, Colors.blue.shade600],
                      ).createShader(bounds);
                    },
                    child: LinearProgressIndicator(
                      value: widget.progress,
                      minHeight: widget.isDesktop ? 8 : 6,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: widget.isDesktop ? 12 : 4),

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
                    widget.isUnlocked ? 'COMPLETE' : 'IN PROGRESS',
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

class AchievedBadge extends StatefulWidget {
  final bool isDesktop;
  final Duration zoomOutDuration;

  const AchievedBadge({
    super.key,
    this.isDesktop = false,
    this.zoomOutDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AchievedBadge> createState() => _AchievedBadgeState();
}

class _AchievedBadgeState extends State<AchievedBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: widget.zoomOutDuration,
    );

    scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.isDesktop ? 12 : 8,
          vertical: widget.isDesktop ? 4 : 2,
        ),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber, width: 1),
        ),
        child: Text(
          'ACHIEVED',
          style: TextStyle(
            color: Colors.amber,
            fontSize: widget.isDesktop ? 12 : 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
