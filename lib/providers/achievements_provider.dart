import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AchievementsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, List<Map<String, String>>> _achievementsData = {
    "Survival Master": [
      {"title": "First Steps", "desc": "Survive 1 minute"},
      {"title": "Getting Serious", "desc": "Survive 5 minutes"},
      {"title": "Marathon Runner", "desc": "Survive 10 minutes"},
      {"title": "Runner Master", "desc": "Survive 18 minutes"},
      {"title": "Legendary Runner", "desc": "Survive 25+ minutes"},
    ],
    "Power Collector": [
      {"title": "Power Collector", "desc": "Collect first star or heart"},
      {
        "title": "Invincible",
        "desc": "Activate star power-up 3 times in a run",
      },
      {"title": "Heart Collector", "desc": "Collect 5 hearts in total"},
      {"title": "Maximum Life", "desc": "Reach 5 lives in a run"},
      {"title": "Combo Master", "desc": "Collect 3 power-ups consecutively"},
    ],
    "Addicted Runner": [
      {"title": "20 Games", "desc": "Play 20 games in 1 hour"},
      {"title": "100 Games", "desc": "Play 100 games in 1 day"},
      {"title": "1000 Games", "desc": "Play 1000 games in 1 week"},
      {"title": "25000 Games", "desc": "Play 25000 games in 3 weeks"},
      {"title": "60000 Games", "desc": "Play 60000 games in 1 month"},
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

  List<String> get categories => _achievementsData.keys.toList();
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

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
      "Power Collector": {"current": 0, "target": 1, "isUnlocked": false},
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

  Future<void> fetchUserAchievements(String userId) async {
    if (userId.isEmpty) {
      debugPrint('User ID is empty, cannot fetch achievements');
      return;
    }

    _setLoading(true);
    try {
      debugPrint('Fetching achievements for user: $userId');

      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        debugPrint('User data found: $userData');

        if (userData != null) {
          final survivalTime = userData['totalPlayTime'] ?? 0;
          debugPrint('Total survival time: $survivalTime seconds');

          final highScore = userData['highestScore'] ?? 0;
          debugPrint('Highest score: $highScore');

          _updateSurvivalAchievements(survivalTime);

          _updateScoreAchievements(highScore);

          final achievementsProgress =
              userData['achievementsProgress'] as Map<String, dynamic>?;
          if (achievementsProgress != null) {
            debugPrint('Found achievements progress: $achievementsProgress');
            _updateOtherAchievements(achievementsProgress);
          }

          notifyListeners();
          debugPrint('Achievements updated successfully');
        }
      } else {
        debugPrint('User document does not exist for ID: $userId');
      }
    } catch (e) {
      debugPrint('Error fetching user achievements: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _updateSurvivalAchievements(int totalSurvivalTime) {
    final survivalTimeInMinutes = totalSurvivalTime ~/ 60;
    debugPrint('Survival time in minutes: $survivalTimeInMinutes');

    _userProgress["First Steps"] = {
      "current": survivalTimeInMinutes,
      "target": 1,
      "isUnlocked": survivalTimeInMinutes >= 1,
    };

    _userProgress["Getting Serious"] = {
      "current": survivalTimeInMinutes,
      "target": 5,
      "isUnlocked": survivalTimeInMinutes >= 5,
    };

    _userProgress["Marathon Runner"] = {
      "current": survivalTimeInMinutes,
      "target": 10,
      "isUnlocked": survivalTimeInMinutes >= 10,
    };

    _userProgress["Runner Master"] = {
      "current": survivalTimeInMinutes,
      "target": 18,
      "isUnlocked": survivalTimeInMinutes >= 18,
    };

    _userProgress["Legendary Runner"] = {
      "current": survivalTimeInMinutes,
      "target": 25,
      "isUnlocked": survivalTimeInMinutes >= 25,
    };
  }

  void _updateScoreAchievements(int highScore) {
    debugPrint('Updating score achievements with high score: $highScore');

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

    debugPrint('Score achievements updated: ${_userProgress["Rising Star"]}');
    debugPrint('Score achievements updated: ${_userProgress["High Flyer"]}');
    debugPrint('Score achievements updated: ${_userProgress["Score King"]}');
    debugPrint('Score achievements updated: ${_userProgress["Score Breaker"]}');
    debugPrint(
      'Score achievements updated: ${_userProgress["Ultimate Champion"]}',
    );
  }

  void _updateOtherAchievements(Map<String, dynamic> achievementsProgress) {
    achievementsProgress.forEach((key, value) {
      if (_userProgress.containsKey(key)) {
        final progressData = value as Map<String, dynamic>;
        _userProgress[key] = {
          "current": progressData['current'] ?? 0,
          "target": _userProgress[key]!["target"],
          "isUnlocked": progressData['isUnlocked'] ?? false,
        };
      }
    });
  }

  Future<void> updateAchievementProgress(
    String userId,
    String achievementId,
    int newValue,
  ) async {
    if (userId.isEmpty) return;

    try {
      if (_userProgress.containsKey(achievementId)) {
        final target = _userProgress[achievementId]!["target"] as int;
        final isUnlocked = newValue >= target;

        _userProgress[achievementId] = {
          "current": newValue,
          "target": target,
          "isUnlocked": isUnlocked,
        };

        await _firestore.collection('users').doc(userId).set({
          'achievementsProgress': {
            achievementId: {
              'current': newValue,
              'isUnlocked': isUnlocked,
              'updatedAt': FieldValue.serverTimestamp(),
            },
          },
        }, SetOptions(merge: true));

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating achievement progress: $e');
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

  int get unlockedAchievementsCount {
    return _userProgress.values
        .where((progress) => progress["isUnlocked"] == true)
        .length;
  }

  int get totalAchievementsCount {
    return _userProgress.length;
  }

  double get progressPercentage {
    return unlockedAchievementsCount / totalAchievementsCount;
  }

  Future<void> refreshAchievements(String userId) async {
    await fetchUserAchievements(userId);
  }

  void debugPrintState() {
    debugPrint('Current user progress state:');
    _userProgress.forEach((key, value) {
      debugPrint('$key: $value');
    });
  }
}
