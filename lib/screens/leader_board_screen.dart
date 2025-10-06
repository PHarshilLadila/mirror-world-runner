// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mirror_world_runner/widgets/leader_board_card.dart';
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
  final AuthService authService = AuthService();
  final List<Particles> particles = [];
  late Ticker ticker;
  final numberOfParticle = kIsWeb ? 50 : 40;
  Duration lastElapsed = Duration.zero;
  final ValueNotifier<int> particleNotifier = ValueNotifier<int>(0);

  List<Map<String, dynamic>> _leaderboard = [];
  bool _isLoading = true;

  final String userIdForPreference = "USERID";

  String userUID = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserIdFromPreferences();
    setupParticles();
    loadLeaderboard();
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

  void setupParticles() {
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
  }

  Future<void> loadLeaderboard() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final leaderboard = await authService.getLeaderboard(limit: 20);
      setState(() {
        _leaderboard = leaderboard;
      });
    } catch (e) {
      debugPrint("loadLeaderboard error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    ticker.dispose();
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
              valueListenable: particleNotifier,
              builder: (context, _, __) {
                return CustomPaint(
                  painter: ParticlePainter(particles),
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

                                return buildLeaderboardItem(
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

  Widget buildLeaderboardItem({
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
