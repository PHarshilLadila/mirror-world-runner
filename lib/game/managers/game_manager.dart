import 'package:flame/components.dart';
import 'dart:math';
import 'package:mirror_world_runner/game/components/obstacle.dart';
import 'package:mirror_world_runner/game/components/powerup.dart';
import 'package:mirror_world_runner/game/game_world.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameManager extends Component {
  final GameWorld world;
  final Vector2 gameSize;
  final Function onPlayerHit;
  final Function onPowerUpCollected;

  double obstacleSpawnTimer = 0;
  double powerUpSpawnTimer = 0;
  double obstacleSpawnInterval = 2.0;
  double powerUpSpawnInterval = 10.0;
  double baseObstacleSpeed = 200.0;
  String currentDifficulty = "medium";
  final Random random = Random();

  bool isTimeSlowdownActive = false;
  double timeSlowdownTimer = 0.0;
  final double timeSlowdownDuration = 10.0;
  double timeSlowdownFactor = 0.5;

  GameManager({
    required this.world,
    required this.gameSize,
    required this.onPlayerHit,
    required this.onPowerUpCollected,
  });

  @override
  void onLoad() {
    super.onLoad();
    loadDifficultySettings();
  }

  Future<void> loadDifficultySettings() async {
    final prefs = await SharedPreferences.getInstance();
    currentDifficulty = prefs.getString('difficulty') ?? "medium";
    applyDifficultySettings();
  }

  void setDifficulty(String difficulty) {
    currentDifficulty = difficulty;
    applyDifficultySettings();
  }

  void applyDifficultySettings() {
    switch (currentDifficulty) {
      case "easy":
        obstacleSpawnInterval = 4.0;
        baseObstacleSpeed = 100.0;
        break;
      case "medium":
        obstacleSpawnInterval = 3.0;
        baseObstacleSpeed = 140.0;
        break;
      case "hard":
        obstacleSpawnInterval = 3.5;
        baseObstacleSpeed = 160.0;
        break;
      default:
        obstacleSpawnInterval = 3.0;
        baseObstacleSpeed = 140.0;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    obstacleSpawnTimer += dt;
    powerUpSpawnTimer += dt;

    if (isTimeSlowdownActive) {
      timeSlowdownTimer += dt;
      if (timeSlowdownTimer >= timeSlowdownDuration) {
        deactivateTimeSlowdown();
      }
    }

    if (obstacleSpawnTimer >= obstacleSpawnInterval) {
      spawnObstacles();
      obstacleSpawnTimer = 0;

      increaseDifficultyOverTime();
    }

    if (powerUpSpawnTimer >= powerUpSpawnInterval) {
      spawnPowerUp();
      powerUpSpawnTimer = 0;
    }
  }

  void activateTimeSlowdown() {
    if (!isTimeSlowdownActive) {
      isTimeSlowdownActive = true;
      timeSlowdownTimer = 0.0;
      applyTimeSlowdownToObstacles();
    } else {
      timeSlowdownTimer = 0.0;
    }
  }

  void deactivateTimeSlowdown() {
    isTimeSlowdownActive = false;
    timeSlowdownTimer = 0.0;
    resetObstacleSpeeds();
  }

  void applyTimeSlowdownToObstacles() {
    for (final component in world.children.toList()) {
      if (component is Obstacle) {
        component.setSpeed(component.originalSpeed * timeSlowdownFactor);
      }
    }
  }

  void resetObstacleSpeeds() {
    for (final component in world.children.toList()) {
      if (component is Obstacle) {
        component.resetSpeed();
      }
    }
  }

  void increaseDifficultyOverTime() {
    double reductionAmount = 0.0;
    double speedIncrease = 0.0;

    switch (currentDifficulty) {
      case "easy":
        reductionAmount = 0.02;
        speedIncrease = 1;
        break;
      case "medium":
        reductionAmount = 0.03;
        speedIncrease = 1.5;
        break;
      case "hard":
        reductionAmount = 0.06;
        speedIncrease = 2.0;
        break;
    }

    obstacleSpawnInterval = max(0.8, obstacleSpawnInterval - reductionAmount);
    baseObstacleSpeed = min(350.0, baseObstacleSpeed + speedIncrease);

    if (!isTimeSlowdownActive) {
      for (final component in world.children.toList()) {
        if (component is Obstacle) {
          component.originalSpeed = baseObstacleSpeed;
          component.resetSpeed();
        }
      }
    }
  }

  void spawnObstacles() {
    int numberOfObstacles = 1;

    switch (currentDifficulty) {
      case "easy":
        numberOfObstacles = 1;
        break;
      case "medium":
        numberOfObstacles = random.nextDouble() > 0.7 ? 1 : 1;
        break;
      case "hard":
        numberOfObstacles = random.nextDouble() > 0.5 ? 2 : 1;
        break;
    }

    for (int i = 0; i < numberOfObstacles; i++) {
      final normalObstacle = Obstacle(
        position: Vector2(gameSize.x, randomYPosition()),
        size: Vector2(40, 40),
        isForMirroredWorld: false,
        speed:
            isTimeSlowdownActive
                ? baseObstacleSpeed * timeSlowdownFactor
                : baseObstacleSpeed,
      );
      normalObstacle.originalSpeed = baseObstacleSpeed;
      world.add(normalObstacle);

      final mirroredObstacle = Obstacle(
        position: Vector2(gameSize.x, randomYPosition()),
        size: Vector2(40, 40),
        isForMirroredWorld: true,
        speed:
            isTimeSlowdownActive
                ? baseObstacleSpeed * timeSlowdownFactor
                : baseObstacleSpeed,
      );
      mirroredObstacle.originalSpeed = baseObstacleSpeed;
      world.add(mirroredObstacle);
    }
  }

  void spawnPowerUp() {
    final types = PowerUpType.values;
    final chosen = types[random.nextInt(types.length)];

    final powerUp = PowerUp(
      position: Vector2(gameSize.x, randomYPosition()),
      size: Vector2(30, 30),
      type: chosen,
      speed: 150,
    );
    world.add(powerUp);
  }

  double randomYPosition() {
    return (random.nextDouble() * (gameSize.y - 100)) + 50;
  }
}
