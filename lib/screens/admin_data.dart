import 'package:flutter/material.dart';
import 'package:mirror_world_runner/service/auth_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> _allGames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllGames();
  }

  Future<void> _loadAllGames() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final games = await _authService.getAllGamesData(limit: 50);
      setState(() {
        _allGames = games;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load games data: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - All Games Data'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadAllGames),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _allGames.length,
                itemBuilder: (context, index) {
                  final game = _allGames[index];
                  return GameDataItem(game: game);
                },
              ),
    );
  }
}

class GameDataItem extends StatelessWidget {
  final Map<String, dynamic> game;

  const GameDataItem({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(child: Text(game['score'].toString())),
        title: Text(game['userName'] ?? 'Unknown User'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Score: ${game['score']} | Time: ${game['timeTaken']}s'),
            Text(
              'Lives: ${game['livesLeft']} | Difficulty: ${_getDifficultyText(game['difficultyLevel'])}',
            ),
            Text('Played: ${_formatDate(game['playedAt'])}'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
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
        return 'Unknown';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
