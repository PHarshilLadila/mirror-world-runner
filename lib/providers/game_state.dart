import 'package:flutter/foundation.dart';

class GameState with ChangeNotifier {
  int _score = 0;
  int _highScore = 0;
  bool _isPaused = false;
  bool _isGameOver = false;
  int _lives = 5;
  double _gameSpeed = 1.0;

  int _difficultyLevel = 2;

  int get score => _score;
  int get highScore => _highScore;
  bool get isPaused => _isPaused;
  bool get isGameOver => _isGameOver;
  int get lives => _lives;
  double get gameSpeed => _gameSpeed;
  int get difficultyLevel => _difficultyLevel;

  void incrementScore(int points) {
    _score += points;
    if (_score > _highScore) {
      _highScore = _score;
    }
    notifyListeners();
  }

  void resetScore() {
    _score = 0;
    notifyListeners();
  }

  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  void gameOver() {
    _isGameOver = true;
    _isPaused = true;
    notifyListeners();
  }

  void resetGame() {
    _score = 0;
    _isPaused = false;
    _isGameOver = false;
    _lives = 5;
    _gameSpeed = 1.0;
    notifyListeners();
  }

  void decreaseLife() {
    _lives--;
    if (_lives <= 0) {
      gameOver();
    }
    notifyListeners();
  }

  void increaseGameSpeed() {
    _gameSpeed += 0.1;
    notifyListeners();
  }

  void setDifficultyLevel(int level) {
    _difficultyLevel = level;
    notifyListeners();
  }

  double getObstacleSpeed() {
    double baseSpeed;
    switch (_difficultyLevel) {
      case 1:
        baseSpeed = 20;
        break;
      case 2:
        baseSpeed = 60;
        break;
      case 3:
        baseSpeed = 100;
        break;
      default:
        baseSpeed = 60;
    }

    double speedBoost = (_score / 100) * 8;
    return baseSpeed + speedBoost;
  }

  double getObstacleSpawnRate() {
    switch (_difficultyLevel) {
      case 1:
        return 2.0;
      case 2:
        return 1.0;
      case 3:
        return 0.8;
      default:
        return 1.0;
    }
  }

  void increaseLife() {
    if (_lives < 5) {
      _lives++;
      notifyListeners();
    }
  }
}
