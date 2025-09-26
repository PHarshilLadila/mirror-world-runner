import 'package:flutter/material.dart';
import 'package:mirror_world_runner/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:mirror_world_runner/providers/game_state.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> _leaderboard = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load leaderboard: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade900, Colors.indigo.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    // Current user stats
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'YOUR SCORE',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                gameState.highScore.toString(),
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'YOUR RANK',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '#${_getUserRank(gameState.highScore)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: _leaderboard.length,
                        itemBuilder: (context, index) {
                          final player = _leaderboard[index];
                          return LeaderboardItem(
                            rank: index,
                            player: player,
                            isCurrentUser:
                                player['highestScore'] == gameState.highScore,
                          );
                        },
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  int _getUserRank(int userScore) {
    for (int i = 0; i < _leaderboard.length; i++) {
      if (_leaderboard[i]['highestScore'] <= userScore) {
        return i + 1;
      }
    }
    return _leaderboard.length + 1;
  }
}

class LeaderboardItem extends StatelessWidget {
  final int rank;
  final Map<String, dynamic> player;
  final bool isCurrentUser;

  const LeaderboardItem({
    super.key,
    required this.rank,
    required this.player,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isCurrentUser
                ? Colors.yellow.withOpacity(0.2)
                : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: isCurrentUser ? Border.all(color: Colors.yellow) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _getRankColor(rank),
              shape: BoxShape.circle,
            ),
            child: Text(
              rank.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player['userName'] ?? 'Unknown',
                  style: TextStyle(
                    color: isCurrentUser ? Colors.yellow : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Games: ${player['totalGamesPlayed'] ?? 0}',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            player['highestScore'].toString(),
            style: TextStyle(
              color: isCurrentUser ? Colors.yellow : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
