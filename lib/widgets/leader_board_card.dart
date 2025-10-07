// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class LeaderboardCard extends StatefulWidget {
  final int index;
  final int rank;
  final Map<String, dynamic> player;
  final Color rankColor;
  final IconData? rankIcon;
  final bool isCurrentPlayer;

  const LeaderboardCard({
    super.key,
    required this.index,
    required this.rank,
    required this.player,
    required this.rankColor,
    this.rankIcon,
    required this.isCurrentPlayer,
  });

  @override
  State<LeaderboardCard> createState() => _LeaderboardCardState();
}

class _LeaderboardCardState extends State<LeaderboardCard>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        alignment: Alignment.center,
        transform:
            Matrix4.identity()
              ..translate(0.0, isHovered ? -10 : 0.0)
              ..scale(isHovered ? 1.001 : 1.0),
        child: Card(
          color:
              widget.isCurrentPlayer
                  ? Colors.amber.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
          margin: EdgeInsets.only(top: isHovered ? 22 : 5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: widget.rankColor.withOpacity(0.2),
              child:
                  widget.rank <= 3
                      ? Icon(widget.rankIcon, color: widget.rankColor)
                      : Text(
                        "${widget.rank}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
            ),
            title: Text(
              widget.isCurrentPlayer
                  ? "You(${widget.player['userName'] ?? 'Unknown'})"
                  : widget.player['userName'] ?? 'Unknown',
              style: TextStyle(
                color: Colors.white,
                fontWeight:
                    widget.rank <= 3 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Games: ${widget.player['totalGamesPlayed'] ?? 0}',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            trailing: Text(
              '${widget.player['highestScore'] ?? 0}',
              style: TextStyle(
                color: widget.rankColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
