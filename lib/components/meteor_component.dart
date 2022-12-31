import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import 'package:flame/components.dart';

class MeteorComponent extends PositionComponent with CollisionCallbacks {
  static const int circleSpeed = 500;
  static const double circleWidth = 100.0, circleHeight = 100.0;

  Random random = Random();

  late double screenWidth, screenHeight;

  final ShapeHitbox hitbox = CircleHitbox();

  @override
  Future<void>? onLoad() {
    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;

    position = Vector2(random.nextDouble() * screenWidth, -circleHeight);
    size = Vector2(circleWidth, circleHeight);

    hitbox.paint.color = BasicPalette.green.color;
    hitbox.renderShape = true;

    add(hitbox);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += circleSpeed * dt;
    super.update(dt);
    if (position.y > screenHeight) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is ScreenHitbox) {}

    super.onCollision(points, other);
  }
}
