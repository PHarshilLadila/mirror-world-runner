// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mirror_world_runner/service/auth_service.dart';
import 'package:mirror_world_runner/widgets/custom_loader.dart';
import 'package:mirror_world_runner/widgets/particle_painter.dart';
import 'package:mirror_world_runner/widgets/particles.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final List<Particles> _particles = [];
  late Ticker _ticker;
  final numberOfParticle = kIsWeb ? 50 : 40;
  Duration _lastElapsed = Duration.zero;
  final ValueNotifier<int> _particleNotifier = ValueNotifier<int>(0);

  List<Map<String, dynamic>> _leaderboard = [];
  bool _isLoading = true;

  final String userIdForPreference = "USERID";

  String userUID = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserIdFromPreferences();
    _setupParticles();
    _loadLeaderboard();
  }

  Future<void> getUserIdFromPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final result = preferences.getString(userIdForPreference);
    setState(() {
      userUID = result ?? "";
      isLoading = false;
    });

    log("[leaderboard.dart] User UID => $result");
  }

  void _setupParticles() {
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

  Future<void> _loadLeaderboard() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final leaderboard = await _authService.getLeaderboard(limit: 20);
      setState(() {
        _leaderboard = leaderboard;
      });
    } catch (e) {
      debugPrint("_loadLeaderboard error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

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

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
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
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'LEADERBOARD',
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
                  const SizedBox(height: 20),

                  Expanded(
                    child:
                        _isLoading
                            ? const Center(
                              child: GameLoadingWidget(width: 80, height: 80),
                            )
                            : _leaderboard.isEmpty
                            ? const Center(
                              child: Text(
                                'No leaderboard data available',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                            : ListView.builder(
                              itemCount: _leaderboard.length,
                              itemBuilder: (context, index) {
                                final player = _leaderboard[index];
                                final playerUid = player['userId']?.toString();
                                final isCurrentPlayer = (playerUid == userUID);

                                return _buildLeaderboardItem(
                                  index: index,
                                  player: player,
                                  rank: index + 1,
                                  isCurrentPlayer: isCurrentPlayer,
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem({
    required int index,
    required Map<String, dynamic> player,
    required int rank,
    required bool isCurrentPlayer,
  }) {
    Color rankColor;
    IconData rankIcon;

    switch (rank) {
      case 1:
        rankColor = Colors.yellow;
        rankIcon = Icons.emoji_events;
        break;
      case 2:
        rankColor = Colors.grey;
        rankIcon = Icons.emoji_events;
        break;
      case 3:
        rankColor = Colors.orange;
        rankIcon = Icons.emoji_events;
        break;
      default:
        rankColor = Colors.white;
        rankIcon = Icons.person;
    }

    return LeaderboardCard(
      index: index,
      player: player,
      rank: rank,
      rankColor: rankColor,
      rankIcon: rankIcon,
      isCurrentPlayer: isCurrentPlayer,
    );
  }
}

class LeaderboardCard extends StatefulWidget {
  final int index;
  final int rank;
  final Map<String, dynamic> player;
  final Color rankColor;
  final IconData rankIcon;
  final bool isCurrentPlayer;

  const LeaderboardCard({
    super.key,
    required this.index,
    required this.rank,
    required this.player,
    required this.rankColor,
    required this.rankIcon,
    required this.isCurrentPlayer,
  });

  @override
  State<LeaderboardCard> createState() => _LeaderboardCardState();
}

class _LeaderboardCardState extends State<LeaderboardCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        alignment: Alignment.center,
        transform:
            Matrix4.identity()
              ..translate(0, _isHovered ? -10 : 0)
              ..scale(_isHovered ? 1.001 : 1.0),
        child: Card(
          color:
              widget.isCurrentPlayer
                  ? Colors.amber.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
          margin: EdgeInsets.only(top: _isHovered ? 22 : 5),
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
