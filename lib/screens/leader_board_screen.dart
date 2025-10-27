// ignore_for_file: deprecated_member_use

// import 'dart:developer';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:mirror_world_runner/widgets/leader_board_card.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:mirror_world_runner/service/auth_service.dart';
// import 'package:mirror_world_runner/widgets/custom_loader.dart';
// import 'package:mirror_world_runner/widgets/particle_painter.dart';
// import 'package:mirror_world_runner/widgets/particles.dart';

// class LeaderboardScreen extends StatefulWidget {
//   const LeaderboardScreen({super.key});

//   @override
//   State<LeaderboardScreen> createState() => _LeaderboardScreenState();
// }

// class _LeaderboardScreenState extends State<LeaderboardScreen>
//     with SingleTickerProviderStateMixin {
//   final AuthService authService = AuthService();
//   final List<Particles> particles = [];
//   late Ticker ticker;
//   final numberOfParticle = kIsWeb ? 50 : 40;
//   Duration lastElapsed = Duration.zero;
//   final ValueNotifier<int> particleNotifier = ValueNotifier<int>(0);

//   List<Map<String, dynamic>> _leaderboard = [];
//   bool _isLoading = true;

//   final String userIdForPreference = "USERID";

//   String userUID = "";
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     getUserIdFromPreferences();
//     setupParticles();
//     loadLeaderboard();
//   }

//   Future<void> getUserIdFromPreferences() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//     final result = preferences.getString(userIdForPreference);
//     setState(() {
//       userUID = result ?? "";
//       isLoading = false;
//     });

//     log("[leaderboard.dart] User UID => $result");
//   }

//   void setupParticles() {
//     for (int i = 0; i < numberOfParticle; i++) {
//       particles.add(Particles());
//     }

//     ticker = createTicker((elapsed) {
//       final dt = (elapsed - lastElapsed).inMicroseconds / 1e6;
//       lastElapsed = elapsed;

//       for (var p in particles) {
//         p.update(dt);
//       }

//       particleNotifier.value++;
//     });
//     ticker.start();
//   }

//   Future<void> loadLeaderboard() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final leaderboard = await authService.getLeaderboard(limit: 20);
//       setState(() {
//         _leaderboard = leaderboard;
//       });
//     } catch (e) {
//       debugPrint("loadLeaderboard error: $e");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     ticker.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.purple.shade900,
//                   Colors.indigo.shade900,
//                   Colors.black87,
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 stops: const [0.0, 0.5, 1.0],
//               ),
//             ),
//           ),
//           RepaintBoundary(
//             child: ValueListenableBuilder<int>(
//               valueListenable: particleNotifier,
//               builder: (context, _, __) {
//                 return CustomPaint(
//                   painter: ParticlePainter(particles),
//                   size: Size.infinite,
//                 );
//               },
//             ),
//           ),

//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: GestureDetector(
//                             onTap: () => Navigator.pop(context),
//                             child: const Icon(
//                               Icons.arrow_back,
//                               color: Colors.white,
//                               size: 28,
//                             ),
//                           ),
//                         ),
//                         const Center(
//                           child: Text(
//                             'LEADERBOARD',
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   Expanded(
//                     child:
//                         _isLoading
//                             ? const Center(
//                               child: GameLoadingWidget(width: 80, height: 80),
//                             )
//                             : _leaderboard.isEmpty
//                             ? const Center(
//                               child: Text(
//                                 'No leaderboard data available',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             )
//                             : ListView.builder(
//                               itemCount: _leaderboard.length,
//                               itemBuilder: (context, index) {
//                                 final player = _leaderboard[index];
//                                 final playerUid = player['userId']?.toString();
//                                 final isCurrentPlayer = (playerUid == userUID);

//                                 return LeaderboardItem(
//                                   index: index,
//                                   player: player,
//                                   rank: index + 1,
//                                   isCurrentPlayer: isCurrentPlayer,
//                                 );
//                               },
//                             ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class LeaderboardItem extends StatelessWidget {
//   final int index;
//   final Map<String, dynamic> player;
//   final int rank;
//   final bool isCurrentPlayer;

//   const LeaderboardItem({
//     super.key,
//     required this.index,
//     required this.player,
//     required this.rank,
//     required this.isCurrentPlayer,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Color rankColor;
//     IconData rankIcon;

//     switch (rank) {
//       case 1:
//         rankColor = Colors.yellow;
//         rankIcon = Icons.emoji_events;
//         break;
//       case 2:
//         rankColor = Colors.grey;
//         rankIcon = Icons.emoji_events;
//         break;
//       case 3:
//         rankColor = Colors.orange;
//         rankIcon = Icons.emoji_events;
//         break;
//       default:
//         rankColor = Colors.white;
//         rankIcon = Icons.person;
//     }

//     return LeaderboardCard(
//       index: index,
//       player: player,
//       rank: rank,
//       rankColor: rankColor,
//       rankIcon: rankIcon,
//       isCurrentPlayer: isCurrentPlayer,
//     );
//   }
// }

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
import 'package:provider/provider.dart';
import 'package:mirror_world_runner/providers/auth_provider.dart';

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
  bool _isOnline = true;
  bool _hasLocalData = false;

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
      // Check online status first
      _isOnline = await authService.isOnline;

      if (_isOnline) {
        // Try to load from Firebase
        final leaderboard = await authService.getLeaderboard(limit: 20);
        setState(() {
          _leaderboard = leaderboard;
          _hasLocalData = false;
        });
      } else {
        // Load local leaderboard data
        await _loadLocalLeaderboard();
      }
    } catch (e) {
      debugPrint("loadLeaderboard error: $e");
      // Fallback to local data if online fails
      await _loadLocalLeaderboard();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Load leaderboard from local storage
  Future<void> _loadLocalLeaderboard() async {
    try {
      final localUserData = await authService.getCurrentUserData();
      if (localUserData != null) {
        // Create a local leaderboard with just the current user
        setState(() {
          _leaderboard = [
            {
              'userId': localUserData['uid'] ?? userUID,
              'userName': localUserData['userName'] ?? 'Local Player',
              'highestScore': localUserData['highestScore'] ?? 0,
              'totalGamesPlayed': localUserData['totalGamesPlayed'] ?? 0,
            },
          ];
          _hasLocalData = true;
        });
      } else {
        setState(() {
          _leaderboard = [];
          _hasLocalData = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading local leaderboard: $e");
      setState(() {
        _leaderboard = [];
        _hasLocalData = false;
      });
    }
  }

  // Refresh leaderboard with manual sync
  Future<void> _refreshLeaderboard() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.manualSync();
    await loadLeaderboard();
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
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Online/Offline indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isOnline ? Colors.green : Colors.red,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _isOnline ? Icons.wifi : Icons.wifi_off,
                                size: 12,
                                color: _isOnline ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isOnline ? 'Online' : 'Offline',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _isLoading ? null : _refreshLeaderboard,
                          icon: Icon(
                            Icons.refresh,
                            color: _isLoading ? Colors.grey : Colors.white,
                          ),
                          tooltip: 'Refresh',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Sync status message
                  if (_hasLocalData)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.orange, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Showing local data only. Connect to internet for full leaderboard.',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  Expanded(
                    child:
                        _isLoading
                            ? const Center(
                              child: GameLoadingWidget(width: 80, height: 80),
                            )
                            : _leaderboard.isEmpty
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.leaderboard_outlined,
                                  size: 64,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No leaderboard data available',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                if (!_isOnline)
                                  Text(
                                    'Connect to internet to view leaderboard',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                            )
                            : ListView.builder(
                              itemCount: _leaderboard.length,
                              itemBuilder: (context, index) {
                                final player = _leaderboard[index];
                                final playerUid = player['userId']?.toString();
                                final isCurrentPlayer = (playerUid == userUID);

                                return LeaderboardItem(
                                  index: index,
                                  player: player,
                                  rank: index + 1,
                                  isCurrentPlayer: isCurrentPlayer,
                                  isLocalData: _hasLocalData,
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
}

class LeaderboardItem extends StatelessWidget {
  final int index;
  final Map<String, dynamic> player;
  final int rank;
  final bool isCurrentPlayer;
  final bool isLocalData;

  const LeaderboardItem({
    super.key,
    required this.index,
    required this.player,
    required this.rank,
    required this.isCurrentPlayer,
    this.isLocalData = false,
  });

  @override
  Widget build(BuildContext context) {
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

    if (isLocalData) {
      rankColor = Colors.blue;
    }

    if (isCurrentPlayer) {
      rankColor = Colors.amber;
      rankIcon = Icons.star;
    }

    return LeaderboardCard(
      index: index,
      player: player,
      rank: rank,
      rankColor: rankColor,
      rankIcon: rankIcon,
      isCurrentPlayer: isCurrentPlayer,
      isLocalData: isLocalData,
    );
  }
}
