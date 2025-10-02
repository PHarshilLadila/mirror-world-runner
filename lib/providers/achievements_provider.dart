import 'package:flutter/material.dart';

class AchievementsProvider extends ChangeNotifier {
  final Map<String, List<Map<String, String>>> _achievementsData = {
    "Survival Achievements": [
      {"title": "First Steps", "desc": "Survive 60 seconds (1 minute)"},
      {"title": "Getting Serious", "desc": "Survive 5 minutes"},
      {"title": "Marathon Runner", "desc": "Survive 10 minutes"},
      {"title": "Legendary Runner", "desc": "Survive 15+ minutes"},
    ],
    "Power-Up Achievements": [
      {"title": "Power Collector", "desc": "Collect first star or heart"},
      {
        "title": "Invincible",
        "desc": "Activate star power-up 3 times in a run",
      },
      {"title": "Heart Collector", "desc": "Collect 5 hearts in total"},
      {"title": "Maximum Life", "desc": "Reach 5 lives in a run"},
      {"title": "Combo Master", "desc": "Collect 3 power-ups consecutively"},
    ],
    "Addicted Player": [
      {"title": "20 Games", "desc": "Play 20 games in 1 hour"},
      {"title": "100 Games", "desc": "Play 100 games in 1 day"},
      {"title": "1000 Games", "desc": "Play 1000 games in 1 week"},
      {"title": "25000 Games", "desc": "Play 25000 games in 3 weeks"},
      {"title": "60000 Games", "desc": "Play 60000 games in 1 month"},
    ],
    "Score-Based Achievements": [
      {"title": "Rising Star", "desc": "Score 100 points"},
      {"title": "High Flyer", "desc": "Score 500 points"},
      {"title": "Score King", "desc": "Score 1000 points"},
      {"title": "Ultimate Champion", "desc": "Score 5000 points"},
    ],
  };

  String _selectedCategory = "Survival Achievements";

  List<String> get categories => _achievementsData.keys.toList();

  String get selectedCategory => _selectedCategory;

  List<Map<String, String>> get currentAchievements =>
      _achievementsData[_selectedCategory] ?? [];

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
