import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/palette.dart';

import 'dart:math';

class CirclePositionComponent extends PositionComponent
    with CollisionCallbacks {
  static const int circleSpeed = 250;
  static const circleWidth = 100.0, circleHeight = 100.0;

  int circleDirectionX = 1;
  int circleDirectionY = 1;
  late double screenWidth, screenHeight, centerX, centerY;

  final ShapeHitbox hitbox = CircleHitbox();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;

    centerX = (screenWidth / 2) - (circleWidth / 2);
    centerY = (screenHeight / 2) - (circleHeight / 2);

    // position = Vector2(centerX, centerY);
    Random random = Random();
    position = Vector2(random.nextDouble() * 300, random.nextDouble() * 300);
    size = Vector2(circleWidth, circleHeight);
    // hitbox.paint.color = BasicPalette.green.color;
    hitbox.paint.color = ColorExtension.random();

    hitbox.renderShape = true;
    add(hitbox);
  }

  @override
  void update(double deltaTime) {
    super.update(deltaTime);
    // position.x += circleSpeed * circleDirection * deltaTime;

    position.x += circleSpeed * circleDirectionX * deltaTime;
    position.y += circleSpeed * circleDirectionY * deltaTime;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    // print(points.first[1]);

    if (other is ScreenHitbox) {
      if (circleDirectionX == 1) {
        // print('hit!');
        circleDirectionX = -1;
        circleDirectionY = 1 * -1;
      } else {
        // print('hit!');
        circleDirectionX = 1;
        circleDirectionY = 1 * -1;
      }
    }

    if (points.first[1] == 0.0) {
      // top
      circleDirectionY = 1;
      circleDirectionX *= -1; // invertimos la direccion en el X
    }
    if (points.first[0] == 0.0) {
      // left
      circleDirectionX = 1;
      circleDirectionY *= -1; // invertimos la direccion en el X
    }

    if (other is CirclePositionComponent) {
      print('CirclePositionComponent');
      circleDirectionX *= -1;
      // circleDirectionY *= -1;
    }
  }
}
