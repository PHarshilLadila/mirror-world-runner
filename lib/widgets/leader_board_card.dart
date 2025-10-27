// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';

// class LeaderboardCard extends StatefulWidget {
//   final int index;
//   final int rank;
//   final Map<String, dynamic> player;
//   final Color rankColor;
//   final IconData? rankIcon;
//   final bool isCurrentPlayer;
//   final bool isLocalData;

//   const LeaderboardCard({
//     super.key,
//     required this.index,
//     required this.rank,
//     required this.player,
//     required this.rankColor,
//     this.rankIcon,
//     required this.isCurrentPlayer,
//     this.isLocalData = false,
//   });

//   @override
//   State<LeaderboardCard> createState() => _LeaderboardCardState();
// }

// class _LeaderboardCardState extends State<LeaderboardCard>
//     with SingleTickerProviderStateMixin {
//   bool isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => isHovered = true),
//       onExit: (_) => setState(() => isHovered = false),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOutBack,
//         alignment: Alignment.center,
//         transform:
//             Matrix4.identity()
//               ..translate(0.0, isHovered ? -10 : 0.0)
//               ..scale(isHovered ? 1.001 : 1.0),
//         child: Card(
//           color:
//               widget.isCurrentPlayer
//                   ? Colors.amber.withOpacity(0.3)
//                   : Colors.white.withOpacity(0.1),
//           margin: EdgeInsets.only(top: isHovered ? 22 : 5),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: widget.rankColor.withOpacity(0.2),
//               child:
//                   widget.rank <= 3
//                       ? Icon(widget.rankIcon, color: widget.rankColor)
//                       : Text(
//                         "${widget.rank}",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//             ),
//             title: Text(
//               widget.isCurrentPlayer
//                   ? "You(${widget.player['userName'] ?? 'Unknown'})"
//                   : widget.player['userName'] ?? 'Unknown',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight:
//                     widget.rank <= 3 ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//             subtitle: Padding(
//               padding: EdgeInsets.only(top: 8.0),
//               child: Text(
//                 'Games: ${widget.player['totalGamesPlayed'] ?? 0}',
//                 style: const TextStyle(color: Colors.white70),
//               ),
//             ),
//             trailing: Text(
//               '${widget.player['highestScore'] ?? 0}',
//               style: TextStyle(
//                 color: widget.rankColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LeaderboardCard extends StatefulWidget {
  final int index;
  final int rank;
  final Map<String, dynamic> player;
  final Color rankColor;
  final IconData? rankIcon;
  final bool isCurrentPlayer;
  final bool isLocalData;

  const LeaderboardCard({
    super.key,
    required this.index,
    required this.rank,
    required this.player,
    required this.rankColor,
    this.rankIcon,
    required this.isCurrentPlayer,
    this.isLocalData = false,
  });

  @override
  State<LeaderboardCard> createState() => _LeaderboardCardState();
}

class _LeaderboardCardState extends State<LeaderboardCard>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  void _handleHover(bool hovering) {
    setState(() => isHovered = hovering);
    if (hovering) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0.0, isHovered ? -8.0 : 0.0),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Card(
                // elevation: _elevationAnimation.value,
                elevation: 0,
                // shadowColor: widget.rankColor.withOpacity(0.5),
                color:
                    widget.isCurrentPlayer
                        ? Colors.amber.withOpacity(0.15)
                        : Colors.white.withOpacity(0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color:
                        widget.isCurrentPlayer
                            ? Colors.amber.withOpacity(0.6)
                            : (widget.isLocalData
                                ? Colors.orange.withOpacity(0.4)
                                : Colors.transparent),
                    width:
                        widget.isCurrentPlayer || widget.isLocalData
                            ? 1.0
                            : 0.0,
                  ),
                ),
                margin:
                    kIsWeb
                        ? EdgeInsets.only(
                          top: isHovered ? 16.0 : 4.0,
                          bottom: 4.0,
                          left: 8.0,
                          right: 8.0,
                        )
                        : EdgeInsets.all(0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient:
                        isHovered
                            ? LinearGradient(
                              colors: [
                                widget.rankColor.withOpacity(0.1),
                                Colors.transparent,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                            : null,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.rankColor.withOpacity(0.3),
                            widget.rankColor.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.rankColor.withOpacity(0.5),
                          width: 2.0,
                        ),
                      ),
                      margin: EdgeInsets.all(2),
                      child: Stack(
                        children: [
                          Center(
                            child:
                                widget.rank <= 3
                                    ? Icon(
                                      widget.rankIcon,
                                      color: widget.rankColor,
                                      size: 24,
                                    )
                                    : Text(
                                      "${widget.rank}",
                                      style: TextStyle(
                                        color: widget.rankColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                          ),
                          if (widget.isCurrentPlayer) ...[
                            Positioned(
                              bottom: -2,
                              right: -2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                ),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.isCurrentPlayer
                                ? "You (${widget.player['userName'] ?? 'Unknown'})"
                                : widget.player['userName'] ?? 'Unknown',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight:
                                  widget.rank <= 3
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                              fontSize: 14,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.isLocalData) ...[
                          const SizedBox(width: 6),
                          Icon(
                            Icons.sync_disabled,
                            color: Colors.orange,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.sports_esports,
                            color: Colors.white70,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.player['totalGamesPlayed'] ?? 0} games',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.rankColor.withOpacity(0.3),
                            widget.rankColor.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.rankColor.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        '${widget.player['highestScore'] ?? 0}',
                        style: TextStyle(
                          color: widget.rankColor,
                          fontSize: kIsWeb ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
