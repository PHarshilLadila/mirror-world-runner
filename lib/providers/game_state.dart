// import 'package:flutter/foundation.dart';

// class GameState with ChangeNotifier {
//   int _score = 0;
//   int _highScore = 0;
//   bool _isPaused = false;
//   bool _isGameOver = false;
//   int _lives = 5;
//   double _gameSpeed = 1.0;

//   int get score => _score;
//   int get highScore => _highScore;
//   bool get isPaused => _isPaused;
//   bool get isGameOver => _isGameOver;
//   int get lives => _lives;
//   double get gameSpeed => _gameSpeed;

//   void incrementScore(int points) {
//     _score += points;
//     if (_score > _highScore) {
//       _highScore = _score;
//     }
//     notifyListeners();
//   }

//   void resetScore() {
//     _score = 0;
//     notifyListeners();
//   }

//   void togglePause() {
//     _isPaused = !_isPaused;
//     notifyListeners();
//   }

//   void gameOver() {
//     _isGameOver = true;
//     _isPaused = true;

//     notifyListeners();
//   }

//   void resetGame() {
//     _score = 0;
//     _isPaused = false;
//     _isGameOver = false;
//     _lives = 5;
//     _gameSpeed = 1.0;
//     notifyListeners();
//   }

//   void decreaseLife() {
//     _lives--;
//     if (_lives <= 0) {
//       gameOver();
//     }
//     notifyListeners();
//   }

//   void increaseGameSpeed() {
//     _gameSpeed += 0.1;
//     notifyListeners();
//   }
// }
import 'package:flutter/foundation.dart';

class GameState with ChangeNotifier {
  int _score = 0;
  int _highScore = 0;
  bool _isPaused = false;
  bool _isGameOver = false;
  int _lives = 5;
  double _gameSpeed = 1.0;

  // NEW: difficulty level (1 = Easy, 2 = Medium, 3 = Hard)
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

  // NEW: Set difficulty
  void setDifficultyLevel(int level) {
    _difficultyLevel = level;
    notifyListeners();
  }

  // NEW: Calculate obstacle speed factor based on difficulty + score
  double getObstacleSpeed() {
    double baseSpeed;
    switch (_difficultyLevel) {
      case 1: // Easy
        baseSpeed = 20; // slower
        break;
      case 2: // Medium
        baseSpeed = 60;
        break;
      case 3: // Hard
        baseSpeed = 100; // faster
        break;
      default:
        baseSpeed = 60;
    }

    // Increase with score progression (dynamic difficulty)
    double speedBoost = (_score / 100) * 8;
    return baseSpeed + speedBoost;
  }

  // NEW: Calculate obstacle spawn rate factor
  double getObstacleSpawnRate() {
    switch (_difficultyLevel) {
      case 1:
        return 2.0; // fewer obstacles
      case 2:
        return 1.0; // normal
      case 3:
        return 0.8; // more obstacles
      default:
        return 1.0;
    }
  }
}
