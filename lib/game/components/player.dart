// ignore_for_file: deprecated_member_use

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class Player extends SpriteComponent with HasGameRef {
  final bool isMirrored;
  final Vector2 gameSize;

  bool isPoweredUp = false;
  double powerUpTimer = 0;
  int obstacleHitsDuringPowerUp = 0;
  Vector2 normalSize = Vector2.zero();
  Vector2 poweredUpSize = Vector2.zero();

  Player({
    required this.isMirrored,
    required this.gameSize,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size) {
    normalSize = size;
    poweredUpSize = size * 1.5;
  }

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player.png');
    size = normalSize;
  }

  void moveUp() {
    if (position.y > 0) {
      position.y -= 10;
    }
  }

  void moveDown() {
    if (position.y < gameSize.y - size.y) {
      position.y += 10;
    }
  }

  void moveLeft() {
    if (position.x > 0) {
      position.x -= 10;
    }
  }

  void moveRight() {
    if (isMirrored) {
      if (position.x < gameSize.x - size.x) {
        position.x += 10;
      }
    } else {
      if (position.x < (gameSize.x / 2) - size.x) {
        position.x += 10;
      }
    }
  }

  void activatePowerUp() {
    if (isPoweredUp) return;

    isPoweredUp = true;
    powerUpTimer = 5.0;
    obstacleHitsDuringPowerUp = 0;

    children.whereType<Effect>().forEach(remove);

    final heartBeat = SequenceEffect(
      [
        SizeEffect.to(
          normalSize * 1.2,
          EffectController(duration: 0.12, curve: Curves.easeOut),
        ),
        SizeEffect.to(
          normalSize,
          EffectController(duration: 0.12, curve: Curves.easeIn),
        ),
        SizeEffect.to(
          normalSize * 1.25,
          EffectController(duration: 0.12, curve: Curves.easeOut),
        ),
        SizeEffect.to(
          normalSize,
          EffectController(duration: 0.12, curve: Curves.easeIn),
        ),
        SizeEffect.to(
          poweredUpSize,
          EffectController(duration: 0.35, curve: Curves.easeOutBack),
        ),
      ],
      onComplete: () {
        size = poweredUpSize;
      },
    );

    add(heartBeat);
  }

  void updatePowerUp(double dt) {
    if (isPoweredUp) {
      powerUpTimer -= dt;
      if (powerUpTimer <= 0 || obstacleHitsDuringPowerUp >= 3) {
        deactivatePowerUp();
      }
    }
  }

  void registerPowerUpHit() {
    if (isPoweredUp) {
      obstacleHitsDuringPowerUp++;
      if (obstacleHitsDuringPowerUp >= 3) {
        deactivatePowerUp();
      }
    }
  }

  void deactivatePowerUp() {
    isPoweredUp = false;
    powerUpTimer = 0;
    obstacleHitsDuringPowerUp = 0;

    children.whereType<Effect>().forEach(remove);

    add(
      SizeEffect.to(
        normalSize,
        EffectController(duration: 0.35, curve: Curves.easeInBack),
        onComplete: () {
          size = normalSize;
        },
      ),
    );
  }
}
