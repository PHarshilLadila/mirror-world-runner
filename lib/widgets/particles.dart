// ignore_for_file: deprecated_member_use

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Particles {
  double x = 0;
  double y = 0;
  double size = 0;
  double speed = 0;
  Color color = Colors.white;
  double opacity = 0;

  Particles() {
    reset();
  }

  void reset() {
    if (kIsWeb) {
      x = Random.nextDouble() * 1800;
    } else {
      x = Random.nextDouble() * 400;
    }

    y = Random.nextDouble() * 1000;

    size = Random.nextDouble() * 3 + 1;

    speed = Random.nextDouble() * 50 + 20;

    opacity = Random.nextDouble() * 0.5 + 0.1;

    color = Colors.accents[Random.nextInt(Colors.accents.length)].withOpacity(
      opacity,
    );
  }

  void update(double dt) {
    y += speed * dt;

    if (y > 1000) {
      reset();
      y = 0;
    }

    x += math.sin(y * 0.01) * 0.5;
  }
}

class Random {
  static final _random = math.Random();

  static double nextDouble() => _random.nextDouble();
  static int nextInt(int max) => _random.nextInt(max);
}
