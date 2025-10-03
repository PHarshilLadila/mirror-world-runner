import 'package:flutter/material.dart';

class AchievementsProvider extends ChangeNotifier {
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

  final Map<String, Map<String, dynamic>> _userProgress = {
    "First Steps": {"current": 60, "target": 1, "isUnlocked": true},
    "Getting Serious": {"current": 180, "target": 5, "isUnlocked": false},
    "Marathon Runner": {"current": 0, "target": 10, "isUnlocked": false},
    "Runner Master": {"current": 50, "target": 18, "isUnlocked": false},
    "Legendary Runner": {"current": 0, "target": 25, "isUnlocked": false},
    "Power Collector": {"current": 1, "target": 1, "isUnlocked": true},
    "Invincible": {"current": 2, "target": 3, "isUnlocked": false},
    "Heart Collector": {"current": 3, "target": 5, "isUnlocked": false},
    "Maximum Life": {"current": 2, "target": 5, "isUnlocked": false},
    "Combo Master": {"current": 1, "target": 3, "isUnlocked": false},
    "20 Games": {"current": 10, "target": 20, "isUnlocked": false},
    "100 Games": {"current": 45, "target": 100, "isUnlocked": false},
    "1000 Games": {"current": 250, "target": 1000, "isUnlocked": false},
    "25000 Games": {"current": 5000, "target": 25000, "isUnlocked": false},
    "60000 Games": {"current": 12000, "target": 60000, "isUnlocked": false},
    "Rising Star": {"current": 150, "target": 100, "isUnlocked": true},
    "High Flyer": {"current": 320, "target": 500, "isUnlocked": false},
    "Score King": {"current": 750, "target": 1000, "isUnlocked": false},
    "Ultimate Champion": {"current": 1200, "target": 5000, "isUnlocked": false},
  };

  String _selectedCategory = "Survival Master";

  List<String> get categories => _achievementsData.keys.toList();

  String get selectedCategory => _selectedCategory;

  List<Map<String, String>> get currentAchievements =>
      _achievementsData[_selectedCategory] ?? [];

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
}
