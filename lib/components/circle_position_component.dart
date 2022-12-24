import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/palette.dart';

import 'dart:math';

class CirclePositionComponent extends PositionComponent
    with CollisionCallbacks {
  CirclePositionComponent({this.countActive = false});

  bool countActive;
  int count = 0;

  static const int circleSpeed = 250;
  static const circleWidth = 100.0, circleHeight = 100.0;

  int circleDirectionX = 1;
  int circleDirectionY = 1;

  late double screenWidth, screenHeight, centerX, centerY;

  final ShapeHitbox hitbox = CircleHitbox();

  Random random = Random();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    circleDirectionX = random.nextInt(2) == 1 ? 1 : -1;
    circleDirectionY = random.nextInt(2) == 1 ? 1 : -1;

    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;

    centerX = (screenWidth / 2) - (circleWidth / 2);
    centerY = (screenHeight / 2) - (circleHeight / 2);

    // position = Vector2(centerX, centerY);

    position = Vector2(random.nextDouble() * 500, random.nextDouble() * 500);
    size = Vector2(circleWidth, circleHeight);
    // hitbox.paint.color = BasicPalette.green.color;
    hitbox.paint.color = ColorExtension.random();

    hitbox.renderShape = true;
    // hitbox.debugMode=true;
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
    if (other is ScreenHitbox) {
      if (points.first[1] <= 0.0) {
        // top
        circleDirectionX = random.nextInt(2) == 1 ? 1 : -1;
        circleDirectionY *= -1;
      } else if (points.first[0] <= 0.0) {
        // left
        circleDirectionX *= -1;
        circleDirectionY = random.nextInt(2) == 1 ? 1 : -1;
      } else {
        if (points.first[0] >= MediaQueryData.fromWindow(window).size.width) {
          // right
          circleDirectionX *= -1;
          circleDirectionY = random.nextInt(2) == 1 ? 1 : -1;
        } else {
          // (default) bottom
          circleDirectionX = random.nextInt(2) == 1 ? 1 : -1;
          circleDirectionY *= -1;
        }
      }
    }

    if (other is CirclePositionComponent) {
      circleDirectionX *= -1;
      circleDirectionY *= -1;
    }

    if (this.countActive) {
      count++;
      print(count);
    }
  }
}
