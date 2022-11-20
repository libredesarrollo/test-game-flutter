import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'dart:ui';
import 'package:flame/palette.dart';

class George extends SpriteAnimationComponent {
  late double screenWidth, screenHeight, centerX, centerY;
  late double georgeSizeWidth = 48.0, georgeSizeHeight = 48.0;

  late SpriteAnimation georgeDownAnimation,
      georgeLeftAnimation,
      georgeUpAnimation,
      georgeRightAnimation;
  double elapsedTime = 0.0;
  double georgeSpeed = 40.0;
  int currentDirection = down;
  static const int down = 0, left = 1, up = 2, right = 3;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;
    centerX = (screenWidth / 2) - (georgeSizeWidth / 2);
    centerY = (screenHeight / 2) - (georgeSizeHeight / 2);
    var spriteImages = await Flame.images.load('george.png');
    final spriteSheet = SpriteSheet(
        image: spriteImages,
        srcSize: Vector2(georgeSizeWidth, georgeSizeHeight));

    //sprite = spriteSheet.getSprite(0, 0);
    position = Vector2(centerX, centerY);
    size = Vector2(georgeSizeWidth, georgeSizeHeight);

    //animation = spriteSheet.createAnimationByColumn(column: 0, stepTime: 0.2);

    georgeDownAnimation =
        spriteSheet.createAnimationByColumn(column: 0, stepTime: 0.2);
    georgeLeftAnimation =
        spriteSheet.createAnimationByColumn(column: 1, stepTime: 0.2);
    georgeUpAnimation =
        spriteSheet.createAnimationByColumn(column: 2, stepTime: 0.2);
    georgeRightAnimation =
        spriteSheet.createAnimationByColumn(column: 3, stepTime: 0.2);
    changeDirection();
  }

  void changeDirection() {
    Random random = Random();
    int newDirection = random.nextInt(4);
    switch (newDirection) {
      case down:
        animation = georgeDownAnimation;
        break;
      case left:
        animation = georgeLeftAnimation;
        break;
      case up:
        animation = georgeUpAnimation;
        break;
      case right:
        animation = georgeRightAnimation;
        break;
    }
    currentDirection = newDirection;
  }
}

extension CreateAnimationByColumn on SpriteSheet {
  SpriteAnimation createAnimationByColumn({
    required int column,
    required double stepTime,
    bool loop = true,
    int from = 0,
    int? to,
  }) {
    to ??= columns;
    final spriteList = List<int>.generate(to - from, (i) => from + i)
        .map((e) => getSprite(e, column))
        .toList();
    return SpriteAnimation.spriteList(
      spriteList,
      stepTime: stepTime,
      loop: loop,
    );
  }
}
