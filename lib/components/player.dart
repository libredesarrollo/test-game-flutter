import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:flame/palette.dart';

// https://github.com/flame-engine/flame/blob/main/examples/lib/stories/input/gesture_hitboxes_example.dart

class Player extends PositionComponent
    with /*Collidable, HasHitboxes,*/ CollisionCallbacks, GestureHitboxes {
  static const int squareSpeed = 250; // The speed that our square will animate
  static final squarePaint =
      BasicPalette.green.paint(); // The color of the square
  static final squareWidth = 100.0,
      squareHeight =
          100.0; // The width and height of our square will be 100 x 100

  // The direction our square is travelling in, 1 for left to right, -1 for right to left
  int squareDirection = 1;
  late double screenWidth, screenHeight, centerX, centerY;

  final ShapeHitbox hitbox = CircleHitbox();
  late final Color baseColor;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Get the width and height of our screen canvas
    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;

    // Calculate the center of the screen, allowing for the adjustment for the squares size
    centerX = (screenWidth / 2) - (squareWidth / 2);
    centerY = (screenHeight / 2) - (squareHeight / 2);

    // Set the initial position of the green square at the center of the screen with a size of 100 width and height
    position = Vector2(centerX, centerY);
    size = Vector2(squareWidth, squareHeight);

    baseColor = ColorExtension.random(withAlpha: 0.8, base: 100);
    hitbox.paint.color = baseColor;
    hitbox.renderShape = true;
    add(hitbox);

    // addHitbox(HitboxRectangle());
  }

  @override
  void onCollision(
      Set<Vector2> points, /*Collidable*/ PositionComponent other) {
    print('------------------something was hit!!!!!');

    if (other is ScreenHitbox) {
      if (squareDirection == 1) {
        print('something was hit');
        squareDirection = -1;
      } else {
        print('something was hit 2');
        squareDirection = 1;
      }
    }
  }

  @override
  void update(double deltaTime) {
    super.update(deltaTime);

    // Update the x position of the square based on the speed and direction and the time elapsed
    position.x += squareSpeed * squareDirection * deltaTime;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    //renderHitboxes(canvas, paint: squarePaint);
  }
}
