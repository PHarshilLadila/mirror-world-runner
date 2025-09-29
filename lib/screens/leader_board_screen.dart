// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  @override
  void initState() {
    super.initState();
    _setupParticles();
    _loadLeaderboard();
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
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'LEADERBOARD',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
                                return _buildLeaderboardItem(player, index + 1);
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

  Widget _buildLeaderboardItem(Map<String, dynamic> player, int rank) {
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

    return Card(
      color: Colors.white.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: rankColor.withOpacity(0.2),
          child: Icon(rankIcon, color: rankColor),
        ),
        title: Text(
          player['userName'] ?? 'Unknown',
          style: TextStyle(
            color: Colors.white,
            fontWeight: rank <= 3 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          'Games: ${player['totalGamesPlayed'] ?? 0}',
          style: TextStyle(color: Colors.white70),
        ),
        trailing: Text(
          '${player['highestScore'] ?? 0}',
          style: TextStyle(
            color: rankColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
