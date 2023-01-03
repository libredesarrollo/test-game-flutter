import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'package:flame/components.dart';

import 'package:testgame/utils/create_animation_by_limit.dart';

class MeteorComponent extends SpriteAnimationComponent with CollisionCallbacks {
  static const int circleSpeed = 500;
  static const double circleWidth = 100.0, circleHeight = 100.0;

  final double spriteSheetWidth = 80, spriteSheetHeight = 100;

  Random random = Random();

  late double screenWidth, screenHeight;

  final ShapeHitbox hitbox = CircleHitbox();

  @override
  Future<void>? onLoad() async {
    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;

    position = Vector2(random.nextDouble() * screenWidth, -circleHeight);
    size = Vector2(circleWidth, circleHeight);

    final spriteImage = await Flame.images.load('meteor.png');
    final spriteSheet = SpriteSheet(
        image: spriteImage,
        srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    //sprite = spriteSheet.getSprite(2, 1);

    // init animation
    animation = spriteSheet.createAnimationByLimit(
        xInit: 0, yInit: 0, step: 4, sizeX: 4, stepTime: .08);

    hitbox.paint.color = BasicPalette.green.color;
    hitbox.renderShape = false;

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
