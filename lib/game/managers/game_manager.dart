import 'package:flame/components.dart';
import 'dart:math';
import 'package:mirror_world_runner/game/components/obstacle.dart';
import 'package:mirror_world_runner/game/components/powerup.dart';
import 'package:mirror_world_runner/game/game_world.dart';

class GameManager extends Component {
  final GameWorld world;
  final Vector2 gameSize;
  final Function onPlayerHit;
  final Function onPowerUpCollected;

  double obstacleSpawnTimer = 0;
  double powerUpSpawnTimer = 0;
  double obstacleSpawnInterval = 2.0;
  double powerUpSpawnInterval = 10.0;
  final Random random = Random();

  GameManager({
    required this.world,
    required this.gameSize,
    required this.onPlayerHit,
    required this.onPowerUpCollected,
  });

  @override
  void update(double dt) {
    super.update(dt);

    obstacleSpawnTimer += dt;
    powerUpSpawnTimer += dt;

    if (obstacleSpawnTimer >= obstacleSpawnInterval) {
      spawnObstacles();
      obstacleSpawnTimer = 0;
      obstacleSpawnInterval = max(0.5, obstacleSpawnInterval - 0.05);
    }

    if (powerUpSpawnTimer >= powerUpSpawnInterval) {
      spawnPowerUp();
      powerUpSpawnTimer = 0;
    }
  }

  void spawnObstacles() {
    final normalObstacle = Obstacle(
      position: Vector2(gameSize.x, _randomYPosition()),
      size: Vector2(40, 40),
      isForMirroredWorld: false,
      speed: 200,
    );
    world.add(normalObstacle);

    final mirroredObstacle = Obstacle(
      position: Vector2(gameSize.x, _randomYPosition()),
      size: Vector2(40, 40),
      isForMirroredWorld: true,
      speed: 200,
    );
    world.add(mirroredObstacle);
  }

  void spawnPowerUp() {
    final powerUp = PowerUp(
      position: Vector2(gameSize.x, _randomYPosition()),
      size: Vector2(30, 30),
      type: PowerUpType.values[random.nextInt(PowerUpType.values.length)],
      speed: 150,
    );
    world.add(powerUp);
  }

  double _randomYPosition() {
    return (random.nextDouble() * (gameSize.y - 100)) + 50;
  }
}
