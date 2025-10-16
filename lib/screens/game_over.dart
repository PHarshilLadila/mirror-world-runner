// // // ignore_for_file: deprecated_member_use

// // import 'package:flame_audio/flame_audio.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/scheduler.dart';
// // import 'package:mirror_world_runner/screens/game_history_screen.dart';
// // import 'package:mirror_world_runner/screens/leader_board_screen.dart';
// // import 'package:mirror_world_runner/service/auth_service.dart';
// // import 'package:mirror_world_runner/widgets/custom_loader.dart';
// // import 'package:mirror_world_runner/widgets/custom_toast.dart';
// // import 'package:mirror_world_runner/widgets/holographic_button.dart';
// // import 'package:mirror_world_runner/widgets/particle_painter.dart';
// // import 'package:mirror_world_runner/widgets/particles.dart';
// // import 'package:provider/provider.dart';
// // import 'package:mirror_world_runner/providers/game_state.dart';
// // import 'package:mirror_world_runner/screens/main_menu.dart';
// // import 'package:mirror_world_runner/screens/game_screen.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class GameOverScreen extends StatefulWidget {
// //   const GameOverScreen({super.key});

// //   @override
// //   State<GameOverScreen> createState() => _GameOverScreenState();
// // }

// // class _GameOverScreenState extends State<GameOverScreen>
// //     with TickerProviderStateMixin {
// //   int timeTaken = 0;
// //   late AnimationController animationController;
// //   late Animation<double> scaleAnimation;
// //   late Animation<double> fadeAnimation;
// //   late Animation<Offset> slideAnimation;
// //   late Animation<Offset> offsetAnimation;

// //   final List<Particles> particles = [];
// //   late Ticker ticker;
// //   final numberOfParticle = kIsWeb ? 60 : 50;
// //   Duration lastElapsed = Duration.zero;
// //   final ValueNotifier<int> particleNotifier = ValueNotifier<int>(0);

// //   final AuthService authService = AuthService();
// //   bool isSaving = false;
// //   Map<String, dynamic>? _userData;
// //   List<Map<String, dynamic>> gameHistory = [];
// //   Map<String, dynamic> _personalBests = {};

// //   @override
// //   void initState() {
// //     super.initState();
// //     loadGameOverSound();
// //     _initializeData();
// //     _setupAnimations();
// //     _setupParticles();
// //   }

// //   void loadGameOverSound() async {
// //     await FlameAudio.audioCache.loadAll(['game_over.mp3']);
// //     FlameAudio.play('game_over.mp3', volume: 0.7);
// //   }

// //   void _initializeData() async {
// //     await getTotalTakenTime();
// //     await _loadUserData();
// //     await _loadGameHistory();
// //     await _loadPersonalBests();
// //     await saveGameDataToFirebase();
// //   }

// //   void _setupAnimations() {
// //     animationController = AnimationController(
// //       duration: const Duration(milliseconds: 1200),
// //       vsync: this,
// //     );

// //     scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
// //       CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
// //     );

// //     fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
// //       CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
// //     );

// //     slideAnimation = Tween<Offset>(
// //       begin: const Offset(0, 0.3),
// //       end: Offset.zero,
// //     ).animate(
// //       CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
// //     );

// //     offsetAnimation = Tween<Offset>(
// //       begin: const Offset(0, -1.0),
// //       end: Offset.zero,
// //     ).animate(
// //       CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic),
// //     );

// //     animationController.forward();
// //   }

// //   void _setupParticles() {
// //     for (int i = 0; i < numberOfParticle; i++) {
// //       particles.add(Particles());
// //     }

// //     ticker = createTicker((elapsed) {
// //       final dt = (elapsed - lastElapsed).inMicroseconds / 1e6;
// //       lastElapsed = elapsed;

// //       for (var p in particles) {
// //         p.update(dt);
// //       }

// //       particleNotifier.value++;
// //     });
// //     ticker.start();
// //   }

// //   Future<void> getTotalTakenTime() async {
// //     SharedPreferences preferences = await SharedPreferences.getInstance();
// //     final data = preferences.getInt("lastGameTimeSeconds");
// //     if (mounted) {
// //       setState(() {
// //         timeTaken = data ?? 0;
// //       });
// //     }
// //   }

// //   Future<void> _loadUserData() async {
// //     final userData = await authService.getCurrentUserData();
// //     if (mounted) {
// //       setState(() {
// //         _userData = userData;
// //       });
// //     }
// //   }

// //   Future<void> _loadGameHistory() async {
// //     final history = await authService.getUserGameHistory(true);
// //     if (mounted) {
// //       setState(() {
// //         gameHistory = history;
// //       });
// //     }
// //   }

// //   Future<void> _loadPersonalBests() async {
// //     final personalBests = await authService.getUserPersonalBests();
// //     if (mounted) {
// //       setState(() {
// //         _personalBests = personalBests;
// //       });
// //     }
// //   }

// //   Future<void> saveGameDataToFirebase() async {
// //     if (isSaving) return;

// //     if (mounted) setState(() => isSaving = true);

// //     try {
// //       final gameState = Provider.of<GameState>(context, listen: false);

// //       await authService.saveGameData(
// //         score: gameState.score,
// //         timeTaken: timeTaken,
// //         livesLeft: gameState.lives,
// //         difficultyLevel: gameState.difficultyLevel,
// //       );

// //       await authService.updateMaxSurvivalTime(timeTaken);

// //       await _loadUserData();
// //       await _loadGameHistory();
// //       await _loadPersonalBests();

// //       if (mounted) {
// //         CustomToast.show(
// //           context,
// //           message: "Game data saved successfully!",
// //           type: GameToastType.success,
// //         );
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         CustomToast.show(
// //           context,
// //           message: "Failed to save game data: $e",
// //           type: GameToastType.error,
// //         );
// //       }
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           isSaving = false;
// //         });
// //       }
// //     }
// //   }

// //   List<Map<String, dynamic>> getUniqueGames(List<Map<String, dynamic>> games) {
// //     final seen = <String>{};
// //     final uniqueGames = <Map<String, dynamic>>[];

// //     for (var game in games) {
// //       final key = '${game['score']}_${game['timeTaken']}';
// //       if (!seen.contains(key)) {
// //         seen.add(key);
// //         uniqueGames.add(game);
// //       }
// //     }

// //     return uniqueGames;
// //   }

// //   int getTotalGamesCount(List<Map<String, dynamic>> games) {
// //     return games.length; // This includes ALL games (with duplicates)
// //   }

// //   @override
// //   void dispose() {
// //     ticker.dispose();
// //     animationController.dispose();
// //     super.dispose();
// //     loadGameOverSound();
// //   }

// //   String takenTimeFormate(int seconds) {
// //     final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
// //     final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
// //     return '$minutes:$remainingSeconds';
// //   }

// //   String formatDateTime(DateTime date) {
// //     return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
// //   }

// //   String _getDifficultyText(int level) {
// //     switch (level) {
// //       case 1:
// //         return 'Easy';
// //       case 2:
// //         return 'Medium';
// //       case 3:
// //         return 'Hard';
// //       default:
// //         return 'Medium';
// //     }
// //   }

// //   Color _getDifficultyColor(int level) {
// //     switch (level) {
// //       case 1:
// //         return Colors.greenAccent;
// //       case 2:
// //         return Colors.orangeAccent;
// //       case 3:
// //         return Colors.redAccent;
// //       default:
// //         return Colors.orangeAccent;
// //     }
// //   }

// //   Widget statItem(IconData icon, String title, String value, Color color) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.start,
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Icon(icon, color: color, size: 24),
// //         const SizedBox(width: 12),
// //         Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               title,
// //               style: TextStyle(
// //                 fontSize: 14,
// //                 color: Colors.white.withOpacity(0.8),
// //                 fontWeight: FontWeight.w600,
// //                 letterSpacing: 1,
// //               ),
// //             ),
// //             Text(
// //               value,
// //               style: TextStyle(
// //                 fontSize: 20,
// //                 color: color,
// //                 fontWeight: FontWeight.bold,
// //                 shadows: [
// //                   Shadow(color: color.withOpacity(0.5), blurRadius: 10),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   Widget buildAnimatedButton({
// //     required String label,
// //     required List<Color> colors,
// //     required VoidCallback onPressed,
// //     required IconData icon,
// //   }) {
// //     return MouseRegion(
// //       cursor: SystemMouseCursors.click,
// //       child: GestureDetector(
// //         onTap: onPressed,
// //         child: Container(
// //           width: double.infinity,
// //           height: 45,
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(12),
// //             gradient: LinearGradient(colors: colors),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: colors.first.withOpacity(0.4),
// //                 blurRadius: 15,
// //                 spreadRadius: 2,
// //                 offset: const Offset(0, 5),
// //               ),
// //             ],
// //             border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
// //           ),
// //           child: Center(
// //             child: Text(
// //               label,
// //               style: const TextStyle(
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //                 letterSpacing: 1.2,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final gameState = Provider.of<GameState>(context);
// //     final uniqueGames = getUniqueGames(gameHistory);
// //     final totalGamesCount = getTotalGamesCount(gameHistory);

// //     return Scaffold(
// //       backgroundColor: Colors.transparent,
// //       body: Stack(
// //         children: [
// //           Container(
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [
// //                   Colors.purple.shade900,
// //                   Colors.indigo.shade900,
// //                   Colors.black87,
// //                 ],
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //               ),
// //             ),
// //             child: Stack(
// //               children: [
// //                 Center(
// //                   child: ScaleTransition(
// //                     scale: scaleAnimation,
// //                     child: FadeTransition(
// //                       opacity: fadeAnimation,
// //                       child: Container(
// //                         width: kIsWeb ? 500 : 380,
// //                         height: kIsWeb ? 1000 : 1200,
// //                         decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         child: Padding(
// //                           padding: const EdgeInsets.all(16),
// //                           child: SingleChildScrollView(
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 SlideTransition(
// //                                   position: slideAnimation,
// //                                   child: Stack(
// //                                     alignment: Alignment.center,
// //                                     children: [BackButton()],
// //                                   ),
// //                                 ),
// //                                 const SizedBox(height: 15),
// //                                 Center(
// //                                   child: ShaderMask(
// //                                     shaderCallback:
// //                                         (bounds) => const LinearGradient(
// //                                           colors: [
// //                                             Colors.red,
// //                                             Colors.orange,
// //                                             Colors.yellow,
// //                                             Colors.green,
// //                                             Colors.blue,
// //                                             Colors.purple,
// //                                           ],
// //                                           stops: [0, 0.2, 0.4, 0.6, 0.8, 1.0],
// //                                           begin: Alignment.topLeft,
// //                                           end: Alignment.bottomRight,
// //                                         ).createShader(bounds),
// //                                     child: const Text(
// //                                       'GAME OVER',
// //                                       style: TextStyle(
// //                                         fontSize: 40,
// //                                         fontWeight: FontWeight.w900,
// //                                         color: Colors.white,
// //                                       ),
// //                                       textAlign: TextAlign.center,
// //                                       overflow: TextOverflow.ellipsis,
// //                                       maxLines: 2,
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 const SizedBox(height: 20),
// //                                 if (_userData != null) ...[
// //                                   SlideTransition(
// //                                     position: slideAnimation,
// //                                     child: Container(
// //                                       padding: const EdgeInsets.all(12),
// //                                       decoration: BoxDecoration(
// //                                         color: Colors.white.withOpacity(0.1),
// //                                         borderRadius: BorderRadius.circular(12),
// //                                       ),
// //                                       child: Stack(
// //                                         alignment: Alignment.center,
// //                                         children: [
// //                                           SlideTransition(
// //                                             position: offsetAnimation,
// //                                             child: Center(
// //                                               child: Image.asset(
// //                                                 'assets/images/png/winner.png',
// //                                                 width: 100,
// //                                               ),
// //                                             ),
// //                                           ),
// //                                           Row(
// //                                             mainAxisAlignment:
// //                                                 MainAxisAlignment.spaceBetween,
// //                                             crossAxisAlignment:
// //                                                 CrossAxisAlignment.center,
// //                                             children: [
// //                                               Column(
// //                                                 crossAxisAlignment:
// //                                                     CrossAxisAlignment.center,
// //                                                 mainAxisAlignment:
// //                                                     MainAxisAlignment.center,
// //                                                 children: [
// //                                                   Text(
// //                                                     'Player:',
// //                                                     style: TextStyle(
// //                                                       color: Colors.white,
// //                                                       fontSize: 14,
// //                                                       fontWeight:
// //                                                           FontWeight.w600,
// //                                                     ),
// //                                                     textAlign: TextAlign.center,
// //                                                   ),
// //                                                   Text(
// //                                                     '${_userData!['userName']}',
// //                                                     style: TextStyle(
// //                                                       color: Colors.white,
// //                                                       fontSize: 14,
// //                                                       fontWeight:
// //                                                           FontWeight.w600,
// //                                                     ),
// //                                                     textAlign: TextAlign.center,
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                               Column(
// //                                                 crossAxisAlignment:
// //                                                     CrossAxisAlignment.center,
// //                                                 mainAxisAlignment:
// //                                                     MainAxisAlignment
// //                                                         .spaceBetween,
// //                                                 children: [
// //                                                   Text(
// //                                                     'Best:',
// //                                                     style: TextStyle(
// //                                                       color: Colors.yellow,
// //                                                       fontSize: 14,
// //                                                       fontWeight:
// //                                                           FontWeight.w600,
// //                                                     ),
// //                                                     maxLines: 2,
// //                                                     overflow:
// //                                                         TextOverflow.ellipsis,
// //                                                     textAlign: TextAlign.center,
// //                                                   ),
// //                                                   Text(
// //                                                     '${_userData!['highestScore'] ?? 0}',
// //                                                     style: TextStyle(
// //                                                       color: Colors.yellow,
// //                                                       fontSize: 14,
// //                                                       fontWeight:
// //                                                           FontWeight.w600,
// //                                                     ),
// //                                                     maxLines: 2,
// //                                                     overflow:
// //                                                         TextOverflow.ellipsis,
// //                                                     textAlign: TextAlign.center,
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 10),
// //                                 ],
// //                                 SlideTransition(
// //                                   position: slideAnimation,
// //                                   child: Container(
// //                                     width: double.infinity,
// //                                     padding: const EdgeInsets.all(20),
// //                                     decoration: BoxDecoration(
// //                                       borderRadius: BorderRadius.circular(12),
// //                                       gradient: LinearGradient(
// //                                         colors: [
// //                                           Colors.black12,
// //                                           Colors.black12,
// //                                         ],
// //                                         begin: Alignment.topLeft,
// //                                         end: Alignment.bottomRight,
// //                                       ),
// //                                       border: Border.all(
// //                                         color: Colors.white.withOpacity(0.2),
// //                                         width: 0.5,
// //                                       ),
// //                                     ),
// //                                     child: Column(
// //                                       crossAxisAlignment:
// //                                           CrossAxisAlignment.start,
// //                                       children: [
// //                                         statItem(
// //                                           Icons.emoji_events,
// //                                           'SCORE',
// //                                           gameState.score.toString(),
// //                                           Colors.yellowAccent,
// //                                         ),
// //                                         const SizedBox(height: 8),
// //                                         Divider(color: Colors.white38),
// //                                         const SizedBox(height: 8),
// //                                         statItem(
// //                                           Icons.star,
// //                                           'HIGH SCORE',
// //                                           '${_userData?['highestScore'] ?? 0}',
// //                                           Colors.orangeAccent,
// //                                         ),
// //                                         const SizedBox(height: 8),
// //                                         Divider(color: Colors.white38),
// //                                         const SizedBox(height: 8),
// //                                         statItem(
// //                                           Icons.timer,
// //                                           'TIME TAKEN',
// //                                           takenTimeFormate(timeTaken),
// //                                           Colors.greenAccent,
// //                                         ),
// //                                         const SizedBox(height: 8),
// //                                         Divider(color: Colors.white38),
// //                                         const SizedBox(height: 8),
// //                                         statItem(
// //                                           Icons.speed,
// //                                           'DIFFICULTY',
// //                                           _getDifficultyText(
// //                                             gameState.difficultyLevel,
// //                                           ),
// //                                           _getDifficultyColor(
// //                                             gameState.difficultyLevel,
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 const SizedBox(height: 10),
// //                                 if (_personalBests.isNotEmpty) ...[
// //                                   SlideTransition(
// //                                     position: slideAnimation,
// //                                     child: Container(
// //                                       width: double.infinity,
// //                                       padding: const EdgeInsets.all(15),
// //                                       decoration: BoxDecoration(
// //                                         borderRadius: BorderRadius.circular(12),
// //                                         color: Colors.blue.withOpacity(0.1),
// //                                         border: Border.all(
// //                                           color: Colors.blue.withOpacity(0.3),
// //                                           width: 1,
// //                                         ),
// //                                       ),
// //                                       child: Column(
// //                                         crossAxisAlignment:
// //                                             CrossAxisAlignment.start,
// //                                         children: [
// //                                           Row(
// //                                             children: [
// //                                               Icon(
// //                                                 Icons.leaderboard,
// //                                                 color: Colors.blueAccent,
// //                                                 size: 20,
// //                                               ),
// //                                               const SizedBox(width: 8),
// //                                               Text(
// //                                                 'PERSONAL BESTS',
// //                                                 style: TextStyle(
// //                                                   color: Colors.blueAccent,
// //                                                   fontSize: 16,
// //                                                   fontWeight: FontWeight.bold,
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                           const SizedBox(height: 10),
// //                                           Row(
// //                                             mainAxisAlignment:
// //                                                 MainAxisAlignment.spaceBetween,
// //                                             children: [
// //                                               Text(
// //                                                 'Highest Score:',
// //                                                 style: TextStyle(
// //                                                   color: Colors.white70,
// //                                                 ),
// //                                               ),
// //                                               Text(
// //                                                 '${_personalBests['highestScore'] ?? 0}',
// //                                                 style: TextStyle(
// //                                                   color: Colors.yellow,
// //                                                   fontWeight: FontWeight.bold,
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                           const SizedBox(height: 5),
// //                                           Row(
// //                                             mainAxisAlignment:
// //                                                 MainAxisAlignment.spaceBetween,
// //                                             children: [
// //                                               Text(
// //                                                 'Total Games:',
// //                                                 style: TextStyle(
// //                                                   color: Colors.white70,
// //                                                 ),
// //                                               ),
// //                                               Text(
// //                                                 '${_personalBests['totalGamesPlayed'] ?? totalGamesCount}',
// //                                                 style: TextStyle(
// //                                                   color: Colors.white,
// //                                                   fontWeight: FontWeight.bold,
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 10),
// //                                 ],
// //                                 if (gameHistory.isNotEmpty) ...[
// //                                   SlideTransition(
// //                                     position: slideAnimation,
// //                                     child: Container(
// //                                       width: double.infinity,
// //                                       padding: const EdgeInsets.all(15),
// //                                       decoration: BoxDecoration(
// //                                         borderRadius: BorderRadius.circular(12),
// //                                         color: Colors.green.withOpacity(0.1),
// //                                         border: Border.all(
// //                                           color: Colors.green.withOpacity(0.3),
// //                                           width: 1,
// //                                         ),
// //                                       ),
// //                                       child: Column(
// //                                         crossAxisAlignment:
// //                                             CrossAxisAlignment.start,
// //                                         children: [
// //                                           Row(
// //                                             children: [
// //                                               Icon(
// //                                                 Icons.history,
// //                                                 color: Colors.greenAccent,
// //                                                 size: 20,
// //                                               ),
// //                                               const SizedBox(width: 8),
// //                                               Text(
// //                                                 'RECENT GAMES',
// //                                                 style: TextStyle(
// //                                                   color: Colors.greenAccent,
// //                                                   fontSize: 16,
// //                                                   fontWeight: FontWeight.bold,
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                           const SizedBox(height: 10),
// //                                           ...uniqueGames
// //                                               .take(3)
// //                                               .map(
// //                                                 (game) => Padding(
// //                                                   padding:
// //                                                       const EdgeInsets.only(
// //                                                         bottom: 8,
// //                                                       ),
// //                                                   child: Row(
// //                                                     mainAxisAlignment:
// //                                                         MainAxisAlignment
// //                                                             .spaceBetween,
// //                                                     children: [
// //                                                       Expanded(
// //                                                         child: Text(
// //                                                           'Score: ${game['score']}',
// //                                                           style: TextStyle(
// //                                                             color:
// //                                                                 Colors.white70,
// //                                                           ),
// //                                                         ),
// //                                                       ),
// //                                                       Expanded(
// //                                                         child: Text(
// //                                                           'Time: ${takenTimeFormate(game['timeTaken'] ?? 0)}',
// //                                                           style: TextStyle(
// //                                                             color:
// //                                                                 Colors.white70,
// //                                                           ),
// //                                                         ),
// //                                                       ),
// //                                                     ],
// //                                                   ),
// //                                                 ),
// //                                               ),
// //                                           HolographicButton(
// //                                             width:
// //                                                 kIsWeb ? null : double.infinity,
// //                                             verticalPadding: 6,
// //                                             label: "View All",
// //                                             fontSize: 12,
// //                                             colors: const [
// //                                               Colors.white24,
// //                                               Colors.white24,
// //                                             ],
// //                                             onTap: () {
// //                                               debugPrint(
// //                                                 "[GAME OVER] VIEW ALL GAMES HISTORY",
// //                                               );
// //                                               Navigator.push(
// //                                                 context,
// //                                                 MaterialPageRoute(
// //                                                   builder:
// //                                                       (context) =>
// //                                                           const GameHistoryScreen(),
// //                                                 ),
// //                                               );
// //                                             },
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 20),
// //                                 ],
// //                                 SlideTransition(
// //                                   position: slideAnimation,
// //                                   child: Column(
// //                                     children: [
// //                                       HolographicButton(
// //                                         width: kIsWeb ? null : double.infinity,
// //                                         verticalPadding: 14,
// //                                         label: "PLAY AGAIN",
// //                                         fontSize: 13,
// //                                         colors: const [
// //                                           Colors.purple,
// //                                           Colors.pinkAccent,
// //                                         ],
// //                                         onTap: () {
// //                                           gameState.resetGame();
// //                                           Navigator.pushAndRemoveUntil(
// //                                             context,
// //                                             MaterialPageRoute(
// //                                               builder:
// //                                                   (context) =>
// //                                                       const GameScreen(),
// //                                             ),
// //                                             (route) => false,
// //                                           );
// //                                         },
// //                                       ),
// //                                       const SizedBox(height: 15),
// //                                       HolographicButton(
// //                                         width: kIsWeb ? null : double.infinity,
// //                                         verticalPadding: 14,
// //                                         label: "VIEW LEADERBOARD",
// //                                         fontSize: 13,
// //                                         colors: const [
// //                                           Colors.amber,
// //                                           Colors.deepOrange,
// //                                         ],
// //                                         onTap: () {
// //                                           Navigator.push(
// //                                             context,
// //                                             MaterialPageRoute(
// //                                               builder:
// //                                                   (context) =>
// //                                                       LeaderboardScreen(),
// //                                             ),
// //                                           );
// //                                         },
// //                                       ),
// //                                       const SizedBox(height: 15),
// //                                       HolographicButton(
// //                                         width: kIsWeb ? null : double.infinity,
// //                                         verticalPadding: 14,
// //                                         label: "MAIN MENU",
// //                                         fontSize: 13,
// //                                         colors: [
// //                                           Colors.blue,
// //                                           Colors.cyanAccent,
// //                                         ],
// //                                         onTap: () {
// //                                           Navigator.pushAndRemoveUntil(
// //                                             context,
// //                                             MaterialPageRoute(
// //                                               builder:
// //                                                   (context) =>
// //                                                       const MainMenuScreen(),
// //                                             ),
// //                                             (route) => false,
// //                                           );
// //                                         },
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 if (isSaving) ...[
// //                   Container(
// //                     color: Colors.black.withOpacity(0.5),
// //                     child: const Center(
// //                       child: GameLoadingWidget(width: 100, height: 100),
// //                     ),
// //                   ),
// //                 ],
// //               ],
// //             ),
// //           ),
// //           IgnorePointer(
// //             child: RepaintBoundary(
// //               child: ValueListenableBuilder<int>(
// //                 valueListenable: particleNotifier,
// //                 builder: (context, _, __) {
// //                   return CustomPaint(
// //                     painter: ParticlePainter(particles),
// //                     size: Size.infinite,
// //                   );
// //                 },
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flame_audio/flame_audio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:mirror_world_runner/screens/game_history_screen.dart';
// import 'package:mirror_world_runner/screens/leader_board_screen.dart';
// import 'package:mirror_world_runner/service/auth_service.dart';
// import 'package:mirror_world_runner/widgets/custom_loader.dart';
// import 'package:mirror_world_runner/widgets/custom_toast.dart';
// import 'package:mirror_world_runner/widgets/holographic_button.dart';
// import 'package:mirror_world_runner/widgets/particle_painter.dart';
// import 'package:mirror_world_runner/widgets/particles.dart';
// import 'package:provider/provider.dart';
// import 'package:mirror_world_runner/providers/game_state.dart';
// import 'package:mirror_world_runner/screens/main_menu.dart';
// import 'package:mirror_world_runner/screens/game_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:scratcher/scratcher.dart';

// class GameOverScreen extends StatefulWidget {
//   const GameOverScreen({super.key});

//   @override
//   State<GameOverScreen> createState() => _GameOverScreenState();
// }

// class _GameOverScreenState extends State<GameOverScreen>
//     with TickerProviderStateMixin {
//   int timeTaken = 0;
//   late AnimationController animationController;
//   late Animation<double> scaleAnimation;
//   late Animation<double> fadeAnimation;
//   late Animation<Offset> slideAnimation;
//   late Animation<Offset> offsetAnimation;

//   final List<Particles> particles = [];
//   late Ticker ticker;
//   final numberOfParticle = kIsWeb ? 60 : 50;
//   Duration lastElapsed = Duration.zero;
//   final ValueNotifier<int> particleNotifier = ValueNotifier<int>(0);

//   final AuthService authService = AuthService();
//   bool isSaving = false;
//   Map<String, dynamic>? _userData;
//   List<Map<String, dynamic>> gameHistory = [];
//   Map<String, dynamic> _personalBests = {};

//   // Scratcher variables
//   bool _showScratcher = false;
//   int _rewardPoints = 0;
//   bool _isNewHighScore = false;
//   int _previousHighScore = 0;

//   @override
//   void initState() {
//     super.initState();
//     loadGameOverSound();
//     _initializeData();
//     _setupAnimations();
//     _setupParticles();
//   }

//   void loadGameOverSound() async {
//     await FlameAudio.audioCache.loadAll(['game_over.mp3']);
//     FlameAudio.play('game_over.mp3', volume: 0.7);
//   }

//   void _initializeData() async {
//     await getTotalTakenTime();
//     await _loadUserData(); // Load previous high score first

//     // Check for new high score and calculate reward if needed
//     await _checkForNewHighScore();

//     // Save game data to Firebase
//     await saveGameDataToFirebase();

//     // Load updated data
//     await _loadGameHistory();
//     await _loadPersonalBests();

//     // Now show the scratcher if there's a new high score
//     await _showScratcherIfNeeded();
//   }

//   void _setupAnimations() {
//     animationController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );

//     scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
//     );

//     fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
//     );

//     slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
//     );

//     offsetAnimation = Tween<Offset>(
//       begin: const Offset(0, -1.0),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic),
//     );

//     animationController.forward();
//   }

//   void _setupParticles() {
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

//   Future<void> getTotalTakenTime() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     final data = preferences.getInt("lastGameTimeSeconds");
//     if (mounted) {
//       setState(() {
//         timeTaken = data ?? 0;
//       });
//     }
//   }

//   Future<void> _loadUserData() async {
//     final userData = await authService.getCurrentUserData();
//     if (mounted) {
//       setState(() {
//         _userData = userData;
//         _previousHighScore = userData?['highestScore'] ?? 0;
//       });
//     }
//   }

//   Future<void> _loadGameHistory() async {
//     final history = await authService.getUserGameHistory(true);
//     if (mounted) {
//       setState(() {
//         gameHistory = history;
//       });
//     }
//   }

//   Future<void> _loadPersonalBests() async {
//     final personalBests = await authService.getUserPersonalBests();
//     if (mounted) {
//       setState(() {
//         _personalBests = personalBests;
//       });
//     }
//   }

//   Future<void> _checkForNewHighScore() async {
//     try {
//       final gameState = Provider.of<GameState>(context, listen: false);
//       final currentScore = gameState.score;
//       final previousHighScore = _previousHighScore;

//       debugPrint(
//         'Checking high score: Current=$currentScore, Previous=$previousHighScore',
//       );

//       if (currentScore > previousHighScore) {
//         debugPrint(
//           'New high score detected! Difference: ${currentScore - previousHighScore}',
//         );

//         if (mounted) {
//           setState(() {
//             _isNewHighScore = true;
//           });
//         }

//         // Just calculate reward, don't show scratcher yet
//         await _calculateReward(currentScore, previousHighScore);
//       } else {
//         debugPrint(
//           'No new high score. Current score is less than or equal to previous best.',
//         );
//       }
//     } catch (e) {
//       debugPrint('Error in _checkForNewHighScore: $e');
//       if (mounted) {
//         CustomToast.show(
//           context,
//           message: "Error checking high score",
//           type: GameToastType.error,
//         );
//       }
//     }
//   }

//   Future<void> _calculateReward(int currentScore, int previousHighScore) async {
//     final scoreDifference = currentScore - previousHighScore;

//     // Calculate reward points based on score difference
//     if (scoreDifference <= 100) {
//       _rewardPoints = _getRandomPoints(1, 5);
//     } else if (scoreDifference <= 500) {
//       _rewardPoints = _getRandomPoints(3, 8);
//     } else if (scoreDifference <= 1000) {
//       _rewardPoints = _getRandomPoints(5, 12);
//     } else {
//       _rewardPoints = _getRandomPoints(8, 15);
//     }

//     // Save reward points to Firebase
//     await authService.saveRewardPoints(_rewardPoints);

//     debugPrint('Reward calculated: $_rewardPoints points');
//   }

//   Future<void> _showScratcherIfNeeded() async {
//     if (_isNewHighScore && mounted) {
//       // Wait a bit for everything to settle and animations to complete
//       await Future.delayed(const Duration(milliseconds: 500));

//       if (mounted) {
//         setState(() {
//           _showScratcher = true;
//         });
//       }

//       debugPrint('Showing scratcher with $_rewardPoints points');
//     }
//   }

//   int _getRandomPoints(int min, int max) {
//     return min + (DateTime.now().microsecondsSinceEpoch % (max - min + 1));
//   }

//   Future<void> saveGameDataToFirebase() async {
//     if (isSaving) return;

//     if (mounted) setState(() => isSaving = true);

//     try {
//       final gameState = Provider.of<GameState>(context, listen: false);

//       await authService.saveGameData(
//         score: gameState.score,
//         timeTaken: timeTaken,
//         livesLeft: gameState.lives,
//         difficultyLevel: gameState.difficultyLevel,
//       );

//       await authService.updateMaxSurvivalTime(timeTaken);

//       await _loadUserData();
//       await _loadGameHistory();
//       await _loadPersonalBests();

//       if (mounted && !_isNewHighScore) {
//         CustomToast.show(
//           context,
//           message: "Game data saved successfully!",
//           type: GameToastType.success,
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         CustomToast.show(
//           context,
//           message: "Failed to save game data: $e",
//           type: GameToastType.error,
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           isSaving = false;
//         });
//       }
//     }
//   }

//   List<Map<String, dynamic>> getUniqueGames(List<Map<String, dynamic>> games) {
//     final seen = <String>{};
//     final uniqueGames = <Map<String, dynamic>>[];

//     for (var game in games) {
//       final key = '${game['score']}_${game['timeTaken']}';
//       if (!seen.contains(key)) {
//         seen.add(key);
//         uniqueGames.add(game);
//       }
//     }

//     return uniqueGames;
//   }

//   int getTotalGamesCount(List<Map<String, dynamic>> games) {
//     return games.length;
//   }

//   @override
//   void dispose() {
//     ticker.dispose();
//     animationController.dispose();
//     super.dispose();
//     loadGameOverSound();
//   }

//   String takenTimeFormate(int seconds) {
//     final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
//     final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
//     return '$minutes:$remainingSeconds';
//   }

//   String formatDateTime(DateTime date) {
//     return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
//   }

//   String _getDifficultyText(int level) {
//     switch (level) {
//       case 1:
//         return 'Easy';
//       case 2:
//         return 'Medium';
//       case 3:
//         return 'Hard';
//       default:
//         return 'Medium';
//     }
//   }

//   Color _getDifficultyColor(int level) {
//     switch (level) {
//       case 1:
//         return Colors.greenAccent;
//       case 2:
//         return Colors.orangeAccent;
//       case 3:
//         return Colors.redAccent;
//       default:
//         return Colors.orangeAccent;
//     }
//   }

//   // Dashboard Box Widget
//   Widget _dashboardBox({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//     required Color bgColor,
//     bool isLarge = false,
//   }) {
//     return Container(
//       height: isLarge ? 120 : 100,
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3), width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.2),
//             blurRadius: 10,
//             spreadRadius: 2,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: color, size: isLarge ? 32 : 28),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.8),
//               fontSize: isLarge ? 14 : 12,
//               fontWeight: FontWeight.w600,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: TextStyle(
//               color: color,
//               fontSize: isLarge ? 24 : 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Info Card Widget
//   Widget _infoCard({
//     required String title,
//     required IconData icon,
//     required Color color,
//     required List<Widget> children,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3), width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.1),
//             blurRadius: 8,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: color, size: 20),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       color: color,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildScratcherOverlay() {
//     return Container(
//       color: Colors.black.withOpacity(0.85),
//       child: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 '🎉 NEW HIGH SCORE! 🎉',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.yellow,
//                   shadows: [Shadow(blurRadius: 10, color: Colors.orange)],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Scratch to reveal your reward!',
//                 style: TextStyle(fontSize: 18, color: Colors.white),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 30),
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white.withOpacity(0.1),
//                   border: Border.all(color: Colors.yellow, width: 2),
//                 ),
//                 child: Scratcher(
//                   brushSize: 40,
//                   threshold: 50,
//                   image: Image.asset(
//                     "assets/images/scratch_card.png",
//                     fit: BoxFit.fill,
//                   ),
//                   // color: Colors.grey[800]!,
//                   onChange: (value) => print("Scratch progress: $value%"),
//                   onThreshold: () {
//                     CustomToast.show(
//                       context,
//                       message:
//                           "Congratulations! You earned $_rewardPoints points!",
//                       type: GameToastType.success,
//                     );
//                   },
//                   child: Container(
//                     width: 300,
//                     height: 200,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.blue.shade700, Colors.purple.shade700],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset('assets/images/png/winner.png', width: 100),
//                         const SizedBox(height: 15),
//                         Text(
//                           '$_rewardPoints Points!',
//                           style: const TextStyle(
//                             fontSize: 32,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             shadows: [
//                               Shadow(blurRadius: 5, color: Colors.black),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               HolographicButton(
//                 width: 200,
//                 verticalPadding: 14,
//                 label: "CONTINUE",
//                 fontSize: 16,
//                 colors: const [Colors.green, Colors.lightGreen],
//                 onTap: () {
//                   setState(() {
//                     _showScratcher = false;
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final gameState = Provider.of<GameState>(context);
//     final uniqueGames = getUniqueGames(gameHistory);
//     final totalGamesCount = getTotalGamesCount(gameHistory);

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final isSmallScreen = constraints.maxWidth < 600;
//           final isMediumScreen = constraints.maxWidth < 900;
//           final isLargeScreen = constraints.maxWidth >= 900;

//           return Stack(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.purple.shade900,
//                       Colors.indigo.shade900,
//                       Colors.black87,
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: Stack(
//                   children: [
//                     Center(
//                       child: ScaleTransition(
//                         scale: scaleAnimation,
//                         child: FadeTransition(
//                           opacity: fadeAnimation,
//                           child: Container(
//                             width:
//                                 isLargeScreen
//                                     ? 1100
//                                     : isMediumScreen
//                                     ? 800
//                                     : double.infinity,
//                             margin: EdgeInsets.all(isSmallScreen ? 12 : 20),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
//                               child: SingleChildScrollView(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     // Header with Back Button
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: const Icon(
//                                             Icons.arrow_back,
//                                             color: Colors.white,
//                                           ),
//                                           onPressed:
//                                               () => Navigator.pop(context),
//                                         ),
//                                         const SizedBox(width: 16),
//                                         Expanded(
//                                           child: ShaderMask(
//                                             shaderCallback:
//                                                 (bounds) =>
//                                                     const LinearGradient(
//                                                       colors: [
//                                                         Colors.red,
//                                                         Colors.orange,
//                                                         Colors.yellow,
//                                                         Colors.green,
//                                                         Colors.blue,
//                                                         Colors.purple,
//                                                       ],
//                                                       stops: [
//                                                         0,
//                                                         0.2,
//                                                         0.4,
//                                                         0.6,
//                                                         0.8,
//                                                         1.0,
//                                                       ],
//                                                       begin: Alignment.topLeft,
//                                                       end:
//                                                           Alignment.bottomRight,
//                                                     ).createShader(bounds),
//                                             child: Text(
//                                               _isNewHighScore
//                                                   ? 'NEW RECORD! 🎉'
//                                                   : 'GAME OVER',
//                                               style: TextStyle(
//                                                 fontSize:
//                                                     isSmallScreen ? 28 : 36,
//                                                 fontWeight: FontWeight.w900,
//                                                 color: Colors.white,
//                                               ),
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 20),

//                                     // Player Profile Section
//                                     if (_userData != null) ...[
//                                       _infoCard(
//                                         title: 'PLAYER PROFILE',
//                                         icon: Icons.person,
//                                         color: Colors.purpleAccent,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceAround,
//                                             children: [
//                                               Column(
//                                                 children: [
//                                                   Text(
//                                                     'Player Name',
//                                                     style: TextStyle(
//                                                       color: Colors.white70,
//                                                       fontSize: 14,
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     '${_userData!['userName']}',
//                                                     style: const TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 18,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Column(
//                                                 children: [
//                                                   Text(
//                                                     'Best Score',
//                                                     style: TextStyle(
//                                                       color: Colors.white70,
//                                                       fontSize: 14,
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     '${_userData!['highestScore'] ?? 0}',
//                                                     style: const TextStyle(
//                                                       color: Colors.yellow,
//                                                       fontSize: 18,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 20),
//                                     ],

//                                     // Main Stats Dashboard - Horizontal Section
//                                     SlideTransition(
//                                       position: slideAnimation,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             'GAME STATISTICS',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 16),
//                                           GridView.count(
//                                             shrinkWrap: true,
//                                             physics:
//                                                 const NeverScrollableScrollPhysics(),
//                                             crossAxisCount:
//                                                 isSmallScreen
//                                                     ? 2
//                                                     : isMediumScreen
//                                                     ? 3
//                                                     : 4,
//                                             crossAxisSpacing: 16,
//                                             mainAxisSpacing: 16,
//                                             childAspectRatio:
//                                                 isSmallScreen ? 1.0 : 1.2,
//                                             children: [
//                                               _dashboardBox(
//                                                 title: 'SCORE',
//                                                 value:
//                                                     gameState.score.toString(),
//                                                 icon: Icons.emoji_events,
//                                                 color:
//                                                     _isNewHighScore
//                                                         ? Colors.yellow
//                                                         : Colors.yellowAccent,
//                                                 bgColor: Colors.yellow
//                                                     .withOpacity(0.1),
//                                                 isLarge: false,
//                                               ),
//                                               _dashboardBox(
//                                                 title: 'HIGH SCORE',
//                                                 value:
//                                                     '${_userData?['highestScore'] ?? 0}',
//                                                 icon: Icons.star,
//                                                 color: Colors.orangeAccent,
//                                                 bgColor: Colors.orange
//                                                     .withOpacity(0.1),
//                                                 isLarge: false,
//                                               ),
//                                               _dashboardBox(
//                                                 title: 'TIME TAKEN',
//                                                 value: takenTimeFormate(
//                                                   timeTaken,
//                                                 ),
//                                                 icon: Icons.timer,
//                                                 color: Colors.greenAccent,
//                                                 bgColor: Colors.green
//                                                     .withOpacity(0.1),
//                                                 isLarge: false,
//                                               ),
//                                               _dashboardBox(
//                                                 title: 'DIFFICULTY',
//                                                 value: _getDifficultyText(
//                                                   gameState.difficultyLevel,
//                                                 ),
//                                                 icon: Icons.speed,
//                                                 color: _getDifficultyColor(
//                                                   gameState.difficultyLevel,
//                                                 ),
//                                                 bgColor: _getDifficultyColor(
//                                                   gameState.difficultyLevel,
//                                                 ).withOpacity(0.1),
//                                                 isLarge: false,
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(height: 20),

//                                     // Personal Bests & Recent Games - Horizontal Section
//                                     SlideTransition(
//                                       position: slideAnimation,
//                                       child:
//                                           isSmallScreen
//                                               ? Column(
//                                                 children: [
//                                                   if (_personalBests
//                                                       .isNotEmpty) ...[
//                                                     _infoCard(
//                                                       title: 'PERSONAL BESTS',
//                                                       icon: Icons.leaderboard,
//                                                       color: Colors.blueAccent,
//                                                       children: [
//                                                         _buildStatRow(
//                                                           'Highest Score',
//                                                           '${_personalBests['highestScore'] ?? 0}',
//                                                           Colors.yellow,
//                                                         ),
//                                                         const SizedBox(
//                                                           height: 8,
//                                                         ),
//                                                         _buildStatRow(
//                                                           'Total Games',
//                                                           '${_personalBests['totalGamesPlayed'] ?? totalGamesCount}',
//                                                           Colors.white,
//                                                         ),
//                                                         const SizedBox(
//                                                           height: 8,
//                                                         ),
//                                                         _buildStatRow(
//                                                           'Reward Points',
//                                                           '${_userData?['rewardPoints'] ?? 0}',
//                                                           Colors.greenAccent,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     const SizedBox(height: 16),
//                                                   ],
//                                                   if (gameHistory
//                                                       .isNotEmpty) ...[
//                                                     _infoCard(
//                                                       title: 'RECENT GAMES',
//                                                       icon: Icons.history,
//                                                       color: Colors.greenAccent,
//                                                       children: [
//                                                         ...uniqueGames
//                                                             .take(3)
//                                                             .map(
//                                                               (game) => Padding(
//                                                                 padding:
//                                                                     const EdgeInsets.only(
//                                                                       bottom: 8,
//                                                                     ),
//                                                                 child: Row(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .spaceBetween,
//                                                                   children: [
//                                                                     Expanded(
//                                                                       child: Text(
//                                                                         'Score: ${game['score']}',
//                                                                         style: TextStyle(
//                                                                           color:
//                                                                               Colors.white70,
//                                                                           fontSize:
//                                                                               14,
//                                                                         ),
//                                                                         overflow:
//                                                                             TextOverflow.ellipsis,
//                                                                       ),
//                                                                     ),
//                                                                     const SizedBox(
//                                                                       width: 8,
//                                                                     ),
//                                                                     Expanded(
//                                                                       child: Text(
//                                                                         'Time: ${takenTimeFormate(game['timeTaken'] ?? 0)}',
//                                                                         style: TextStyle(
//                                                                           color:
//                                                                               Colors.white70,
//                                                                           fontSize:
//                                                                               14,
//                                                                         ),
//                                                                         overflow:
//                                                                             TextOverflow.ellipsis,
//                                                                         textAlign:
//                                                                             TextAlign.right,
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                         const SizedBox(
//                                                           height: 12,
//                                                         ),
//                                                         HolographicButton(
//                                                           width:
//                                                               double.infinity,
//                                                           verticalPadding: 10,
//                                                           label:
//                                                               "VIEW ALL HISTORY",
//                                                           fontSize: 12,
//                                                           colors: const [
//                                                             Colors.white24,
//                                                             Colors.white24,
//                                                           ],
//                                                           onTap: () {
//                                                             Navigator.push(
//                                                               context,
//                                                               MaterialPageRoute(
//                                                                 builder:
//                                                                     (context) =>
//                                                                         const GameHistoryScreen(),
//                                                               ),
//                                                             );
//                                                           },
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ],
//                                               )
//                                               : Row(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   if (_personalBests
//                                                       .isNotEmpty) ...[
//                                                     Expanded(
//                                                       child: _infoCard(
//                                                         title: 'PERSONAL BESTS',
//                                                         icon: Icons.leaderboard,
//                                                         color:
//                                                             Colors.blueAccent,
//                                                         children: [
//                                                           _buildStatRow(
//                                                             'Highest Score',
//                                                             '${_personalBests['highestScore'] ?? 0}',
//                                                             Colors.yellow,
//                                                           ),
//                                                           const SizedBox(
//                                                             height: 8,
//                                                           ),
//                                                           _buildStatRow(
//                                                             'Total Games',
//                                                             '${_personalBests['totalGamesPlayed'] ?? totalGamesCount}',
//                                                             Colors.white,
//                                                           ),
//                                                           const SizedBox(
//                                                             height: 8,
//                                                           ),
//                                                           _buildStatRow(
//                                                             'Reward Points',
//                                                             '${_userData?['rewardPoints'] ?? 0}',
//                                                             Colors.greenAccent,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     const SizedBox(width: 16),
//                                                   ],
//                                                   if (gameHistory
//                                                       .isNotEmpty) ...[
//                                                     Expanded(
//                                                       child: _infoCard(
//                                                         title: 'RECENT GAMES',
//                                                         icon: Icons.history,
//                                                         color:
//                                                             Colors.greenAccent,
//                                                         children: [
//                                                           ...uniqueGames
//                                                               .take(3)
//                                                               .map(
//                                                                 (
//                                                                   game,
//                                                                 ) => Padding(
//                                                                   padding:
//                                                                       const EdgeInsets.only(
//                                                                         bottom:
//                                                                             8,
//                                                                       ),
//                                                                   child: Row(
//                                                                     mainAxisAlignment:
//                                                                         MainAxisAlignment
//                                                                             .spaceBetween,
//                                                                     children: [
//                                                                       Expanded(
//                                                                         child: Text(
//                                                                           'Score: ${game['score']}',
//                                                                           style: TextStyle(
//                                                                             color:
//                                                                                 Colors.white70,
//                                                                             fontSize:
//                                                                                 14,
//                                                                           ),
//                                                                           overflow:
//                                                                               TextOverflow.ellipsis,
//                                                                         ),
//                                                                       ),
//                                                                       const SizedBox(
//                                                                         width:
//                                                                             8,
//                                                                       ),
//                                                                       Expanded(
//                                                                         child: Text(
//                                                                           'Time: ${takenTimeFormate(game['timeTaken'] ?? 0)}',
//                                                                           style: TextStyle(
//                                                                             color:
//                                                                                 Colors.white70,
//                                                                             fontSize:
//                                                                                 14,
//                                                                           ),
//                                                                           overflow:
//                                                                               TextOverflow.ellipsis,
//                                                                           textAlign:
//                                                                               TextAlign.right,
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                           const SizedBox(
//                                                             height: 12,
//                                                           ),
//                                                           HolographicButton(
//                                                             width:
//                                                                 double.infinity,
//                                                             verticalPadding: 10,
//                                                             label:
//                                                                 "VIEW ALL HISTORY",
//                                                             fontSize: 12,
//                                                             colors: const [
//                                                               Colors.white24,
//                                                               Colors.white24,
//                                                             ],
//                                                             onTap: () {
//                                                               Navigator.push(
//                                                                 context,
//                                                                 MaterialPageRoute(
//                                                                   builder:
//                                                                       (
//                                                                         context,
//                                                                       ) =>
//                                                                           const GameHistoryScreen(),
//                                                                 ),
//                                                               );
//                                                             },
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ],
//                                               ),
//                                     ),
//                                     const SizedBox(height: 20),

//                                     // Action Buttons Section
//                                     SlideTransition(
//                                       position: slideAnimation,
//                                       child: Column(
//                                         children: [
//                                           if (isSmallScreen == true) ...[
//                                             // Vertical buttons for small screens
//                                             Center(
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.center,
//                                                 children: [
//                                                   HolographicButton(
//                                                     width: double.infinity,
//                                                     verticalPadding: 16,
//                                                     label: "PLAY AGAIN",
//                                                     fontSize: 16,
//                                                     colors: const [
//                                                       Colors.purple,
//                                                       Colors.pinkAccent,
//                                                     ],
//                                                     onTap: () {
//                                                       gameState.resetGame();
//                                                       Navigator.pushAndRemoveUntil(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder:
//                                                               (context) =>
//                                                                   const GameScreen(),
//                                                         ),
//                                                         (route) => false,
//                                                       );
//                                                     },
//                                                   ),
//                                                   const SizedBox(height: 12),
//                                                   HolographicButton(
//                                                     width: double.infinity,
//                                                     verticalPadding: 16,
//                                                     label: "VIEW LEADERBOARD",
//                                                     fontSize: 16,
//                                                     colors: const [
//                                                       Colors.amber,
//                                                       Colors.deepOrange,
//                                                     ],
//                                                     onTap: () {
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder:
//                                                               (context) =>
//                                                                   LeaderboardScreen(),
//                                                         ),
//                                                       );
//                                                     },
//                                                   ),
//                                                   const SizedBox(height: 12),
//                                                   HolographicButton(
//                                                     width: double.infinity,
//                                                     verticalPadding: 16,
//                                                     label: "MAIN MENU",
//                                                     fontSize: 16,
//                                                     colors: [
//                                                       Colors.blue,
//                                                       Colors.cyanAccent,
//                                                     ],
//                                                     onTap: () {
//                                                       Navigator.pushAndRemoveUntil(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder:
//                                                               (context) =>
//                                                                   const MainMenuScreen(),
//                                                         ),
//                                                         (route) => false,
//                                                       );
//                                                     },
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],

//                                           if (isLargeScreen ||
//                                               isMediumScreen) ...[
//                                             Row(
//                                               children: [
//                                                 Expanded(
//                                                   child: HolographicButton(
//                                                     verticalPadding: 16,
//                                                     label: "PLAY AGAIN",
//                                                     fontSize: 16,
//                                                     colors: const [
//                                                       Colors.purple,
//                                                       Colors.pinkAccent,
//                                                     ],
//                                                     onTap: () {
//                                                       gameState.resetGame();
//                                                       Navigator.pushAndRemoveUntil(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder:
//                                                               (context) =>
//                                                                   const GameScreen(),
//                                                         ),
//                                                         (route) => false,
//                                                       );
//                                                     },
//                                                   ),
//                                                 ),
//                                                 const SizedBox(width: 16),
//                                                 Expanded(
//                                                   child: HolographicButton(
//                                                     verticalPadding: 16,
//                                                     label: "VIEW LEADERBOARD",
//                                                     fontSize: 16,
//                                                     colors: const [
//                                                       Colors.amber,
//                                                       Colors.deepOrange,
//                                                     ],
//                                                     onTap: () {
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder:
//                                                               (context) =>
//                                                                   LeaderboardScreen(),
//                                                         ),
//                                                       );
//                                                     },
//                                                   ),
//                                                 ),
//                                                 const SizedBox(width: 16),
//                                                 Expanded(
//                                                   child: HolographicButton(
//                                                     verticalPadding: 16,
//                                                     label: "MAIN MENU",
//                                                     fontSize: 16,
//                                                     colors: [
//                                                       Colors.blue,
//                                                       Colors.cyanAccent,
//                                                     ],
//                                                     onTap: () {
//                                                       Navigator.pushAndRemoveUntil(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder:
//                                                               (context) =>
//                                                                   const MainMenuScreen(),
//                                                         ),
//                                                         (route) => false,
//                                                       );
//                                                     },
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(height: 20),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     if (isSaving) ...[
//                       Container(
//                         color: Colors.black.withOpacity(0.5),
//                         child: const Center(
//                           child: GameLoadingWidget(width: 100, height: 100),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               IgnorePointer(
//                 child: RepaintBoundary(
//                   child: ValueListenableBuilder<int>(
//                     valueListenable: particleNotifier,
//                     builder: (context, _, __) {
//                       return CustomPaint(
//                         painter: ParticlePainter(particles),
//                         size: Size.infinite,
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               if (_showScratcher) _buildScratcherOverlay(),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStatRow(String label, String value, Color color) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: Text(
//             label,
//             style: TextStyle(color: Colors.white70, fontSize: 14),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             value,
//             style: TextStyle(
//               color: color,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.right,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mirror_world_runner/screens/game_history_screen.dart';
import 'package:mirror_world_runner/screens/leader_board_screen.dart';
import 'package:mirror_world_runner/service/auth_service.dart';
import 'package:mirror_world_runner/widgets/custom_loader.dart';
import 'package:mirror_world_runner/widgets/custom_toast.dart';
import 'package:mirror_world_runner/widgets/holographic_button.dart';
import 'package:mirror_world_runner/widgets/particle_painter.dart';
import 'package:mirror_world_runner/widgets/particles.dart';
import 'package:provider/provider.dart';
import 'package:mirror_world_runner/providers/game_state.dart';
import 'package:mirror_world_runner/screens/main_menu.dart';
import 'package:mirror_world_runner/screens/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scratcher/scratcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with TickerProviderStateMixin {
  int timeTaken = 0;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<Offset> offsetAnimation;

  final List<Particles> particles = [];
  late Ticker ticker;
  final numberOfParticle = kIsWeb ? 60 : 50;
  Duration lastElapsed = Duration.zero;
  final ValueNotifier<int> particleNotifier = ValueNotifier<int>(0);

  final AuthService authService = AuthService();
  bool isSaving = false;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> gameHistory = [];
  Map<String, dynamic> _personalBests = {};

  // Scratcher variables
  bool _showScratcher = false;
  int _rewardPoints = 0;
  bool _isNewHighScore = false;
  int _previousHighScore = 0;
  bool _isScratched = false;
  bool _showDoubleRewardOption = false;
  bool _rewardDoubled = false;

  // Ads variables
  RewardedAd? _rewardedAd;
  bool _isRewardedAdLoaded = false;
  bool _isLoadingAd = false;
  final String _adUnitId =
      kDebugMode
          ? 'ca-app-pub-3940256099942544/5224354917' // Test ID
          : 'ca-app-pub-3940256099942544/5224354917'; // Production ID - ca-app-pub-3779258307133143/8933683902

  @override
  void initState() {
    super.initState();
    loadGameOverSound();
    _initializeData();
    _setupAnimations();
    _setupParticles();

    // Initialize ads (only for mobile platforms)
    if (!kIsWeb) {
      _loadRewardedAd();
    }
  }

  void loadGameOverSound() async {
    await FlameAudio.audioCache.loadAll(['game_over.mp3']);
    FlameAudio.play('game_over.mp3', volume: 0.7);
  }

  void _initializeData() async {
    await getTotalTakenTime();
    await _loadUserData();

    await _checkForNewHighScore();
    await saveGameDataToFirebase();
    await _loadGameHistory();
    await _loadPersonalBests();
    await _showScratcherIfNeeded();
  }

  void _setupAnimations() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic),
    );

    animationController.forward();
  }

  void _setupParticles() {
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

  // Ads Methods
  void _loadRewardedAd() {
    if (kIsWeb) return; // Skip ads on web

    _isLoadingAd = true;

    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          _rewardedAd = ad;
          _isRewardedAdLoaded = true;
          _isLoadingAd = false;

          // Set full screen content callbacks
          _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent:
                (ad) => debugPrint('$ad onAdShowedFullScreenContent.'),
            onAdImpression: (ad) => debugPrint('$ad impression occurred.'),
            onAdFailedToShowFullScreenContent: (ad, err) {
              debugPrint('$ad onAdFailedToShowFullScreenContent: $err');
              ad.dispose();
              _resetAd();
            },
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('$ad onAdDismissedFullScreenContent.');
              ad.dispose();
              _resetAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
          _isRewardedAdLoaded = false;
          _isLoadingAd = false;
        },
      ),
    );
  }

  void _resetAd() {
    if (mounted) {
      setState(() {
        _isRewardedAdLoaded = false;
        _rewardedAd = null;
      });
    }
    // Reload ad for next time
    if (!kIsWeb) {
      _loadRewardedAd();
    }
  }

  void _showRewardedAd() {
    if (!_isRewardedAdLoaded || _rewardedAd == null) {
      CustomToast.show(
        context,
        message: "Ad not ready yet. Please try again.",
        type: GameToastType.error,
      );
      _loadRewardedAd();
      return;
    }

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint('User earned reward: ${reward.amount} ${reward.type}');

        // Double the reward points
        if (mounted) {
          setState(() {
            _rewardPoints *= 2;
            _rewardDoubled = true;
            _showDoubleRewardOption = false;
          });

          // Save doubled points to Firebase
          _saveDoubledReward();

          CustomToast.show(
            context,
            message: "Congratulations! You earned ${_rewardPoints} points!",
            type: GameToastType.success,
          );
        }
      },
    );
  }

  Future<void> _saveDoubledReward() async {
    try {
      await authService.saveRewardPoints(_rewardPoints);
      debugPrint('Doubled reward points saved: $_rewardPoints');
    } catch (e) {
      debugPrint('Error saving doubled reward: $e');
    }
  }

  Future<void> getTotalTakenTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = preferences.getInt("lastGameTimeSeconds");
    if (mounted) {
      setState(() {
        timeTaken = data ?? 0;
      });
    }
  }

  Future<void> _loadUserData() async {
    final userData = await authService.getCurrentUserData();
    if (mounted) {
      setState(() {
        _userData = userData;
        _previousHighScore = userData?['highestScore'] ?? 0;
      });
    }
  }

  Future<void> _loadGameHistory() async {
    final history = await authService.getUserGameHistory(true);
    if (mounted) {
      setState(() {
        gameHistory = history;
      });
    }
  }

  Future<void> _loadPersonalBests() async {
    final personalBests = await authService.getUserPersonalBests();
    if (mounted) {
      setState(() {
        _personalBests = personalBests;
      });
    }
  }

  Future<void> _checkForNewHighScore() async {
    try {
      final gameState = Provider.of<GameState>(context, listen: false);
      final currentScore = gameState.score;
      final previousHighScore = _previousHighScore;

      debugPrint(
        'Checking high score: Current=$currentScore, Previous=$previousHighScore',
      );

      if (currentScore > previousHighScore) {
        debugPrint(
          'New high score detected! Difference: ${currentScore - previousHighScore}',
        );

        if (mounted) {
          setState(() {
            _isNewHighScore = true;
          });
        }

        await _calculateReward(currentScore, previousHighScore);
      } else {
        debugPrint(
          'No new high score. Current score is less than or equal to previous best.',
        );
      }
    } catch (e) {
      debugPrint('Error in _checkForNewHighScore: $e');
      if (mounted) {
        CustomToast.show(
          context,
          message: "Error checking high score",
          type: GameToastType.error,
        );
      }
    }
  }

  Future<void> _calculateReward(int currentScore, int previousHighScore) async {
    final scoreDifference = currentScore - previousHighScore;

    if (scoreDifference <= 100) {
      _rewardPoints = _getRandomPoints(1, 5);
    } else if (scoreDifference <= 500) {
      _rewardPoints = _getRandomPoints(3, 8);
    } else if (scoreDifference <= 1000) {
      _rewardPoints = _getRandomPoints(5, 12);
    } else {
      _rewardPoints = _getRandomPoints(8, 15);
    }

    await authService.saveRewardPoints(_rewardPoints);

    debugPrint('Reward calculated: $_rewardPoints points');
  }

  Future<void> _showScratcherIfNeeded() async {
    if (_isNewHighScore && mounted) {
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          _showScratcher = true;
        });
      }

      debugPrint('Showing scratcher with $_rewardPoints points');
    }
  }

  int _getRandomPoints(int min, int max) {
    return min + (DateTime.now().microsecondsSinceEpoch % (max - min + 1));
  }

  Future<void> saveGameDataToFirebase() async {
    if (isSaving) return;

    if (mounted) setState(() => isSaving = true);

    try {
      final gameState = Provider.of<GameState>(context, listen: false);

      await authService.saveGameData(
        score: gameState.score,
        timeTaken: timeTaken,
        livesLeft: gameState.lives,
        difficultyLevel: gameState.difficultyLevel,
      );

      await authService.updateMaxSurvivalTime(timeTaken);

      await _loadUserData();
      await _loadGameHistory();
      await _loadPersonalBests();

      if (mounted && !_isNewHighScore) {
        CustomToast.show(
          context,
          message: "Game data saved successfully!",
          type: GameToastType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomToast.show(
          context,
          message: "Failed to save game data: $e",
          type: GameToastType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> getUniqueGames(List<Map<String, dynamic>> games) {
    final seen = <String>{};
    final uniqueGames = <Map<String, dynamic>>[];

    for (var game in games) {
      final key = '${game['score']}_${game['timeTaken']}';
      if (!seen.contains(key)) {
        seen.add(key);
        uniqueGames.add(game);
      }
    }

    return uniqueGames;
  }

  int getTotalGamesCount(List<Map<String, dynamic>> games) {
    return games.length;
  }

  @override
  void dispose() {
    ticker.dispose();
    animationController.dispose();
    _rewardedAd?.dispose();
    super.dispose();
    loadGameOverSound();
  }

  String takenTimeFormate(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  String formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getDifficultyText(int level) {
    switch (level) {
      case 1:
        return 'Easy';
      case 2:
        return 'Medium';
      case 3:
        return 'Hard';
      default:
        return 'Medium';
    }
  }

  Color _getDifficultyColor(int level) {
    switch (level) {
      case 1:
        return Colors.greenAccent;
      case 2:
        return Colors.orangeAccent;
      case 3:
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  // Dashboard Box Widget
  Widget _dashboardBox({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
    bool isLarge = false,
  }) {
    return Container(
      height: isLarge ? 120 : 100,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: isLarge ? 32 : 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: isLarge ? 14 : 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: isLarge ? 24 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Info Card Widget
  Widget _infoCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildScratcherOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🎉 NEW HIGH SCORE! 🎉',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                  shadows: [Shadow(blurRadius: 10, color: Colors.orange)],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                _isScratched
                    ? (_rewardDoubled
                        ? 'DOUBLED REWARD!'
                        : 'Scratch to reveal your reward!')
                    : 'Scratch to reveal your reward!',
                style: const TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.1),
                  border: Border.all(color: Colors.yellow, width: 2),
                ),
                child: Scratcher(
                  brushSize: 40,
                  threshold: 50,
                  image: Image.asset(
                    "assets/images/scratch_card.png",
                    fit: BoxFit.fill,
                  ),
                  onChange: (value) => print("Scratch progress: $value%"),
                  onThreshold: () {
                    if (!_isScratched) {
                      setState(() {
                        _isScratched = true;
                        _showDoubleRewardOption = true;
                      });

                      if (!_showDoubleRewardOption) {
                        CustomToast.show(
                          context,
                          message:
                              "Congratulations! You earned $_rewardPoints points!",
                          type: GameToastType.success,
                        );
                      }
                    }
                  },
                  child: Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.purple.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/png/winner.png', width: 100),
                        const SizedBox(height: 15),
                        Text(
                          _rewardDoubled
                              ? '${_rewardPoints} Points!'
                              : '$_rewardPoints Points!',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(blurRadius: 5, color: Colors.black),
                            ],
                          ),
                        ),
                        if (_rewardDoubled)
                          const Text(
                            'DOUBLED! 🎉',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Double Reward Button (only shown after scratching and if not already doubled)
              if (_showDoubleRewardOption && !_rewardDoubled) ...[
                const SizedBox(height: 30),
                const Text(
                  'Watch an ad to double your reward!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HolographicButton(
                      width: 140,
                      verticalPadding: 14,
                      label: _isLoadingAd ? "LOADING..." : "WATCH AD 2x",
                      fontSize: 16,
                      colors: [Colors.green, Colors.lightGreen],
                      onTap:
                          _isLoadingAd || !_isRewardedAdLoaded
                              ? () {}
                              : _showRewardedAd,
                    ),
                    const SizedBox(width: 20),
                    HolographicButton(
                      width: 140,
                      verticalPadding: 14,
                      label: "SKIP",
                      fontSize: 16,
                      colors: const [Colors.grey, Colors.white24],
                      onTap: () {
                        setState(() {
                          _showDoubleRewardOption = false;
                        });
                        CustomToast.show(
                          context,
                          message: "You earned $_rewardPoints points!",
                          type: GameToastType.success,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (!_isRewardedAdLoaded && !kIsWeb)
                  const Text(
                    'Ad not ready. You can skip or wait.',
                    style: TextStyle(color: Colors.orange, fontSize: 12),
                  ),
              ],

              // Continue Button (shown when not showing double reward option)
              if (!_showDoubleRewardOption || _rewardDoubled) ...[
                const SizedBox(height: 30),
                HolographicButton(
                  width: 200,
                  verticalPadding: 14,
                  label: "CONTINUE",
                  fontSize: 16,
                  colors: const [Colors.green, Colors.lightGreen],
                  onTap: () {
                    setState(() {
                      _showScratcher = false;
                    });
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final uniqueGames = getUniqueGames(gameHistory);
    final totalGamesCount = getTotalGamesCount(gameHistory);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          final isMediumScreen = constraints.maxWidth < 900;
          final isLargeScreen = constraints.maxWidth >= 900;

          return Stack(
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
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        child: FadeTransition(
                          opacity: fadeAnimation,
                          child: Container(
                            width:
                                isLargeScreen
                                    ? 1100
                                    : isMediumScreen
                                    ? 800
                                    : double.infinity,
                            margin: EdgeInsets.all(isSmallScreen ? 12 : 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header with Back Button
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          ),
                                          onPressed:
                                              () => Navigator.pop(context),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: ShaderMask(
                                            shaderCallback:
                                                (bounds) =>
                                                    const LinearGradient(
                                                      colors: [
                                                        Colors.red,
                                                        Colors.orange,
                                                        Colors.yellow,
                                                        Colors.green,
                                                        Colors.blue,
                                                        Colors.purple,
                                                      ],
                                                      stops: [
                                                        0,
                                                        0.2,
                                                        0.4,
                                                        0.6,
                                                        0.8,
                                                        1.0,
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ).createShader(bounds),
                                            child: Text(
                                              _isNewHighScore
                                                  ? 'NEW RECORD! 🎉'
                                                  : 'GAME OVER',
                                              style: TextStyle(
                                                fontSize:
                                                    isSmallScreen ? 28 : 36,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),

                                    // Player Profile Section
                                    if (_userData != null) ...[
                                      _infoCard(
                                        title: 'PLAYER PROFILE',
                                        icon: Icons.person,
                                        color: Colors.purpleAccent,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    'Player Name',
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${_userData!['userName']}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    'Best Score',
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${_userData!['highestScore'] ?? 0}',
                                                    style: const TextStyle(
                                                      color: Colors.yellow,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                    ],

                                    // Main Stats Dashboard - Horizontal Section
                                    SlideTransition(
                                      position: slideAnimation,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'GAME STATISTICS',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          GridView.count(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            crossAxisCount:
                                                isSmallScreen
                                                    ? 2
                                                    : isMediumScreen
                                                    ? 3
                                                    : 4,
                                            crossAxisSpacing: 16,
                                            mainAxisSpacing: 16,
                                            childAspectRatio:
                                                isSmallScreen ? 1.0 : 1.2,
                                            children: [
                                              _dashboardBox(
                                                title: 'SCORE',
                                                value:
                                                    gameState.score.toString(),
                                                icon: Icons.emoji_events,
                                                color:
                                                    _isNewHighScore
                                                        ? Colors.yellow
                                                        : Colors.yellowAccent,
                                                bgColor: Colors.yellow
                                                    .withOpacity(0.1),
                                                isLarge: false,
                                              ),
                                              _dashboardBox(
                                                title: 'HIGH SCORE',
                                                value:
                                                    '${_userData?['highestScore'] ?? 0}',
                                                icon: Icons.star,
                                                color: Colors.orangeAccent,
                                                bgColor: Colors.orange
                                                    .withOpacity(0.1),
                                                isLarge: false,
                                              ),
                                              _dashboardBox(
                                                title: 'TIME TAKEN',
                                                value: takenTimeFormate(
                                                  timeTaken,
                                                ),
                                                icon: Icons.timer,
                                                color: Colors.greenAccent,
                                                bgColor: Colors.green
                                                    .withOpacity(0.1),
                                                isLarge: false,
                                              ),
                                              _dashboardBox(
                                                title: 'DIFFICULTY',
                                                value: _getDifficultyText(
                                                  gameState.difficultyLevel,
                                                ),
                                                icon: Icons.speed,
                                                color: _getDifficultyColor(
                                                  gameState.difficultyLevel,
                                                ),
                                                bgColor: _getDifficultyColor(
                                                  gameState.difficultyLevel,
                                                ).withOpacity(0.1),
                                                isLarge: false,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // Personal Bests & Recent Games - Horizontal Section
                                    SlideTransition(
                                      position: slideAnimation,
                                      child:
                                          isSmallScreen
                                              ? Column(
                                                children: [
                                                  if (_personalBests
                                                      .isNotEmpty) ...[
                                                    _infoCard(
                                                      title: 'PERSONAL BESTS',
                                                      icon: Icons.leaderboard,
                                                      color: Colors.blueAccent,
                                                      children: [
                                                        _buildStatRow(
                                                          'Highest Score',
                                                          '${_personalBests['highestScore'] ?? 0}',
                                                          Colors.yellow,
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        _buildStatRow(
                                                          'Total Games',
                                                          '${_personalBests['totalGamesPlayed'] ?? totalGamesCount}',
                                                          Colors.white,
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        _buildStatRow(
                                                          'Reward Points',
                                                          '${_userData?['rewardPoints'] ?? 0}',
                                                          Colors.greenAccent,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 16),
                                                  ],
                                                  if (gameHistory
                                                      .isNotEmpty) ...[
                                                    _infoCard(
                                                      title: 'RECENT GAMES',
                                                      icon: Icons.history,
                                                      color: Colors.greenAccent,
                                                      children: [
                                                        ...uniqueGames
                                                            .take(3)
                                                            .map(
                                                              (game) => Padding(
                                                                padding:
                                                                    const EdgeInsets.only(
                                                                      bottom: 8,
                                                                    ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Score: ${game['score']}',
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.white70,
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Time: ${takenTimeFormate(game['timeTaken'] ?? 0)}',
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.white70,
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        HolographicButton(
                                                          width:
                                                              double.infinity,
                                                          verticalPadding: 10,
                                                          label:
                                                              "VIEW ALL HISTORY",
                                                          fontSize: 12,
                                                          colors: const [
                                                            Colors.white24,
                                                            Colors.white24,
                                                          ],
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const GameHistoryScreen(),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ],
                                              )
                                              : Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (_personalBests
                                                      .isNotEmpty) ...[
                                                    Expanded(
                                                      child: _infoCard(
                                                        title: 'PERSONAL BESTS',
                                                        icon: Icons.leaderboard,
                                                        color:
                                                            Colors.blueAccent,
                                                        children: [
                                                          _buildStatRow(
                                                            'Highest Score',
                                                            '${_personalBests['highestScore'] ?? 0}',
                                                            Colors.yellow,
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          _buildStatRow(
                                                            'Total Games',
                                                            '${_personalBests['totalGamesPlayed'] ?? totalGamesCount}',
                                                            Colors.white,
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          _buildStatRow(
                                                            'Reward Points',
                                                            '${_userData?['rewardPoints'] ?? 0}',
                                                            Colors.greenAccent,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                  ],
                                                  if (gameHistory
                                                      .isNotEmpty) ...[
                                                    Expanded(
                                                      child: _infoCard(
                                                        title: 'RECENT GAMES',
                                                        icon: Icons.history,
                                                        color:
                                                            Colors.greenAccent,
                                                        children: [
                                                          ...uniqueGames
                                                              .take(3)
                                                              .map(
                                                                (
                                                                  game,
                                                                ) => Padding(
                                                                  padding:
                                                                      const EdgeInsets.only(
                                                                        bottom:
                                                                            8,
                                                                      ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Text(
                                                                          'Score: ${game['score']}',
                                                                          style: TextStyle(
                                                                            color:
                                                                                Colors.white70,
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            8,
                                                                      ),
                                                                      Expanded(
                                                                        child: Text(
                                                                          'Time: ${takenTimeFormate(game['timeTaken'] ?? 0)}',
                                                                          style: TextStyle(
                                                                            color:
                                                                                Colors.white70,
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          HolographicButton(
                                                            width:
                                                                double.infinity,
                                                            verticalPadding: 10,
                                                            label:
                                                                "VIEW ALL HISTORY",
                                                            fontSize: 12,
                                                            colors: const [
                                                              Colors.white24,
                                                              Colors.white24,
                                                            ],
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (
                                                                        context,
                                                                      ) =>
                                                                          const GameHistoryScreen(),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                    ),
                                    const SizedBox(height: 20),

                                    // Action Buttons Section
                                    SlideTransition(
                                      position: slideAnimation,
                                      child: Column(
                                        children: [
                                          if (isSmallScreen == true) ...[
                                            // Vertical buttons for small screens
                                            Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  HolographicButton(
                                                    width: double.infinity,
                                                    verticalPadding: 16,
                                                    label: "PLAY AGAIN",
                                                    fontSize: 16,
                                                    colors: const [
                                                      Colors.purple,
                                                      Colors.pinkAccent,
                                                    ],
                                                    onTap: () {
                                                      gameState.resetGame();
                                                      Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  const GameScreen(),
                                                        ),
                                                        (route) => false,
                                                      );
                                                    },
                                                  ),
                                                  const SizedBox(height: 12),
                                                  HolographicButton(
                                                    width: double.infinity,
                                                    verticalPadding: 16,
                                                    label: "VIEW LEADERBOARD",
                                                    fontSize: 16,
                                                    colors: const [
                                                      Colors.amber,
                                                      Colors.deepOrange,
                                                    ],
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  LeaderboardScreen(),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  const SizedBox(height: 12),
                                                  HolographicButton(
                                                    width: double.infinity,
                                                    verticalPadding: 16,
                                                    label: "MAIN MENU",
                                                    fontSize: 16,
                                                    colors: [
                                                      Colors.blue,
                                                      Colors.cyanAccent,
                                                    ],
                                                    onTap: () {
                                                      Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  const MainMenuScreen(),
                                                        ),
                                                        (route) => false,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],

                                          if (isLargeScreen ||
                                              isMediumScreen) ...[
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: HolographicButton(
                                                    verticalPadding: 16,
                                                    label: "PLAY AGAIN",
                                                    fontSize: 16,
                                                    colors: const [
                                                      Colors.purple,
                                                      Colors.pinkAccent,
                                                    ],
                                                    onTap: () {
                                                      gameState.resetGame();
                                                      Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  const GameScreen(),
                                                        ),
                                                        (route) => false,
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: HolographicButton(
                                                    verticalPadding: 16,
                                                    label: "VIEW LEADERBOARD",
                                                    fontSize: 16,
                                                    colors: const [
                                                      Colors.amber,
                                                      Colors.deepOrange,
                                                    ],
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  LeaderboardScreen(),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: HolographicButton(
                                                    verticalPadding: 16,
                                                    label: "MAIN MENU",
                                                    fontSize: 16,
                                                    colors: [
                                                      Colors.blue,
                                                      Colors.cyanAccent,
                                                    ],
                                                    onTap: () {
                                                      Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  const MainMenuScreen(),
                                                        ),
                                                        (route) => false,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isSaving) ...[
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: GameLoadingWidget(width: 100, height: 100),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IgnorePointer(
                child: RepaintBoundary(
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
              ),
              if (_showScratcher) _buildScratcherOverlay(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/*
app ID:
Mirror World Runner           ca-app-pub-3779258307133143~6639187899
-------
ad unit ID:
rewards_point                       ca-app-pub-3779258307133143/8933683902
android:value="ca-app-pub-3779258307133143~6639187899"/>

 */
