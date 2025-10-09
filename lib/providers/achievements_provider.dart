import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirror_world_runner/service/auth_service.dart';

class AchievementsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService authService = AuthService();

  final Map<String, List<Map<String, String>>> _achievementsData = {
    "Survival Master": [
      {"title": "First Steps", "desc": "Survive 1 minute"},
      {"title": "Getting Serious", "desc": "Survive 5 minutes"},
      {"title": "Marathon Runner", "desc": "Survive 10 minutes"},
      {"title": "Runner Master", "desc": "Survive 18 minutes"},
      {"title": "Legendary Runner", "desc": "Survive 25+ minutes"},
    ],
    "Power Collector": [
      {"title": "Power Collector", "desc": "Collect 10 star or heart"},
      {
        "title": "Invincible",
        "desc": "Activate star power-up 3 times in a run",
      },
      {"title": "Heart Collector", "desc": "Collect 5 hearts in total"},
      {"title": "Maximum Life", "desc": "Reach 5 lives in a run"},
      {"title": "Combo Master", "desc": "Collect 3 power-ups consecutively"},
    ],
    "Addicted Runner": [
      {"title": "20 Games", "desc": "Play 20 games"},
      {"title": "100 Games", "desc": "Play 100 games"},
      {"title": "1000 Games", "desc": "Play 1000 games"},
      {"title": "25000 Games", "desc": "Play 25000 games"},
      {"title": "60000 Games", "desc": "Play 60000 games"},
    ],
    "Score Champion": [
      {"title": "Rising Star", "desc": "Score 500 points"},
      {"title": "High Flyer", "desc": "Score 1500 points"},
      {"title": "Score King", "desc": "Score 4000 points"},
      {"title": "Score Breaker", "desc": "Score 7500 points"},
      {"title": "Ultimate Champion", "desc": "Score 11111 points"},
    ],
  };

  Map<String, Map<String, dynamic>> _userProgress = {};
  String _selectedCategory = "Survival Master";
  bool _isLoading = false;
  int _totalUniqueGames = 0;

  List<String> get categories => _achievementsData.keys.toList();
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  int get totalUniqueGames => _totalUniqueGames;

  List<Map<String, String>> get currentAchievements =>
      _achievementsData[_selectedCategory] ?? [];

  AchievementsProvider() {
    _initializeUserProgress();
  }

  void _initializeUserProgress() {
    _userProgress = {
      "First Steps": {"current": 0, "target": 1, "isUnlocked": false},
      "Getting Serious": {"current": 0, "target": 5, "isUnlocked": false},
      "Marathon Runner": {"current": 0, "target": 10, "isUnlocked": false},
      "Runner Master": {"current": 0, "target": 18, "isUnlocked": false},
      "Legendary Runner": {"current": 0, "target": 25, "isUnlocked": false},

      "Power Collector": {"current": 0, "target": 10, "isUnlocked": false},
      "Invincible": {"current": 0, "target": 3, "isUnlocked": false},
      "Heart Collector": {"current": 0, "target": 5, "isUnlocked": false},
      "Maximum Life": {"current": 0, "target": 5, "isUnlocked": false},
      "Combo Master": {"current": 0, "target": 3, "isUnlocked": false},

      "20 Games": {"current": 0, "target": 20, "isUnlocked": false},
      "100 Games": {"current": 0, "target": 100, "isUnlocked": false},
      "1000 Games": {"current": 0, "target": 1000, "isUnlocked": false},
      "25000 Games": {"current": 0, "target": 25000, "isUnlocked": false},
      "60000 Games": {"current": 0, "target": 60000, "isUnlocked": false},

      "Rising Star": {"current": 0, "target": 500, "isUnlocked": false},
      "High Flyer": {"current": 0, "target": 1500, "isUnlocked": false},
      "Score King": {"current": 0, "target": 4000, "isUnlocked": false},
      "Score Breaker": {"current": 0, "target": 7500, "isUnlocked": false},
      "Ultimate Champion": {"current": 0, "target": 11111, "isUnlocked": false},
    };
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

  Future<void> fetchUserAchievements(String userId) async {
    if (userId.isEmpty) return;

    _setLoading(true);
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists && userDoc.data() != null) {
        final userData = userDoc.data()!;

        final maxSurvivalTime = userData['maxSurvivalTime'] ?? 0;
        _updateSurvivalAchievements(maxSurvivalTime ~/ 60);

        final highScore = userData['highestScore'] ?? 0;
        _updateScoreAchievements(highScore);

        await _fetchAndUpdateGameHistory(userId);

        final achievementsProgress =
            userData['achievementsProgress'] as Map<String, dynamic>? ?? {};
        _updatePowerCollectorAchievements(achievementsProgress);
      }
    } catch (e) {
      debugPrint('Error fetching user achievements: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> _fetchAndUpdateGameHistory(String userId) async {
    try {
      final gameHistory = await authService.getUserGameHistory(false);

      final uniqueGames = getUniqueGames(gameHistory);
      _totalUniqueGames = uniqueGames.length;

      debugPrint("Total unique games for Addicted Runner: $_totalUniqueGames");

      _updateAddictedRunnerAchievements(_totalUniqueGames);
    } catch (e) {
      debugPrint('Error fetching game history for achievements: $e');
    }
  }

  void _updateSurvivalAchievements(int maxSurvivalTimeInMinutes) {
    _userProgress["First Steps"] = {
      "current": maxSurvivalTimeInMinutes,
      "target": 1,
      "isUnlocked": maxSurvivalTimeInMinutes >= 1,
    };
    _userProgress["Getting Serious"] = {
      "current": maxSurvivalTimeInMinutes,
      "target": 5,
      "isUnlocked": maxSurvivalTimeInMinutes >= 5,
    };
    _userProgress["Marathon Runner"] = {
      "current": maxSurvivalTimeInMinutes,
      "target": 10,
      "isUnlocked": maxSurvivalTimeInMinutes >= 10,
    };
    _userProgress["Runner Master"] = {
      "current": maxSurvivalTimeInMinutes,
      "target": 18,
      "isUnlocked": maxSurvivalTimeInMinutes >= 18,
    };
    _userProgress["Legendary Runner"] = {
      "current": maxSurvivalTimeInMinutes,
      "target": 25,
      "isUnlocked": maxSurvivalTimeInMinutes >= 25,
    };
  }

  void _updateScoreAchievements(int highScore) {
    _userProgress["Rising Star"] = {
      "current": highScore,
      "target": 500,
      "isUnlocked": highScore >= 500,
    };
    _userProgress["High Flyer"] = {
      "current": highScore,
      "target": 1500,
      "isUnlocked": highScore >= 1500,
    };
    _userProgress["Score King"] = {
      "current": highScore,
      "target": 4000,
      "isUnlocked": highScore >= 4000,
    };
    _userProgress["Score Breaker"] = {
      "current": highScore,
      "target": 7500,
      "isUnlocked": highScore >= 7500,
    };
    _userProgress["Ultimate Champion"] = {
      "current": highScore,
      "target": 11111,
      "isUnlocked": highScore >= 11111,
    };
  }

  void _updateAddictedRunnerAchievements(int totalGames) {
    _userProgress["20 Games"] = {
      "current": totalGames,
      "target": 20,
      "isUnlocked": totalGames >= 20,
    };
    _userProgress["100 Games"] = {
      "current": totalGames,
      "target": 100,
      "isUnlocked": totalGames >= 100,
    };
    _userProgress["1000 Games"] = {
      "current": totalGames,
      "target": 1000,
      "isUnlocked": totalGames >= 1000,
    };
    _userProgress["25000 Games"] = {
      "current": totalGames,
      "target": 25000,
      "isUnlocked": totalGames >= 25000,
    };
    _userProgress["60000 Games"] = {
      "current": totalGames,
      "target": 60000,
      "isUnlocked": totalGames >= 60000,
    };
  }

  void _updatePowerCollectorAchievements(Map<String, dynamic> progress) {
    final keys = [
      "Power Collector",
      "Invincible",
      "Heart Collector",
      "Maximum Life",
      "Combo Master",
    ];
    for (var key in keys) {
      final value = progress[key] ?? {};
      _userProgress[key] = {
        "current": value['current'] ?? 0,
        "target": _userProgress[key]?['target'] ?? 1,
        "isUnlocked": value['isUnlocked'] ?? false,
      };
    }
  }

  Map<String, dynamic> getAchievementProgress(String title) {
    final progress =
        _userProgress[title] ??
        {"current": 0, "target": 1, "isUnlocked": false};
    final current = progress["current"] as int;
    final target = progress["target"] as int;
    final isUnlocked = progress["isUnlocked"] as bool;

    return {
      "current": current,
      "target": target,
      "progress": isUnlocked ? 1.0 : (current / target).clamp(0.0, 1.0),
      "isUnlocked": isUnlocked,
    };
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int get unlockedAchievementsCount =>
      _userProgress.values.where((p) => p["isUnlocked"] == true).length;

  int get totalAchievementsCount => _userProgress.length;

  double get progressPercentage =>
      totalAchievementsCount == 0
          ? 0.0
          : unlockedAchievementsCount / totalAchievementsCount;

  Future<void> refreshAchievements(String userId) async {
    await fetchUserAchievements(userId);
  }

  void debugPrintState() {
    debugPrint('Current user progress state:');
    _userProgress.forEach((key, value) {
      debugPrint('$key: $value');
    });
    debugPrint('Total unique games: $_totalUniqueGames');
  }
}
