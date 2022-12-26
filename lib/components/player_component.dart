import 'package:flame/collisions.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'package:flame/flame.dart';
import 'package:flame/components.dart';

import 'dart:ui';

import 'package:flutter/services.dart';

class PlayerComponent extends SpriteAnimationComponent
    with Tappable, KeyboardHandler, CollisionCallbacks {
  late double screenWidth, screenHeight, centerX, centerY;
  final double spriteSheetWidth = 680, spriteSheetHeight = 472;
  int posX = 0, posY = 0;
  double playerSpeed = 500;

  int animationIndex = 0;

  bool right = true;

  late SpriteAnimation dinoDeadAnimation,
      dinoIdleAnimation,
      dinoJumpAnimation,
      dinoRunAnimation,
      dinoWalkAnimation;

  @override
  Future<void>? onLoad() async {
    //sprite = await Sprite.load('tiger.png');

    anchor = Anchor.center;

    final spriteImage = await Flame.images.load('dinofull.png');
    final spriteSheet = SpriteSheet(
        image: spriteImage,
        srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    //sprite = spriteSheet.getSprite(2, 1);

    // init animation
    dinoDeadAnimation = spriteSheet.createAnimationByLimit(
        xInit: 0, yInit: 0, step: 8, sizeX: 5, stepTime: .08);
    dinoIdleAnimation = spriteSheet.createAnimationByLimit(
        xInit: 1, yInit: 2, step: 10, sizeX: 5, stepTime: .08);
    dinoJumpAnimation = spriteSheet.createAnimationByLimit(
        xInit: 3, yInit: 0, step: 12, sizeX: 5, stepTime: .08);
    dinoRunAnimation = spriteSheet.createAnimationByLimit(
        xInit: 5, yInit: 0, step: 8, sizeX: 5, stepTime: .08);
    dinoWalkAnimation = spriteSheet.createAnimationByLimit(
        xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: .08);
    // end animation

    animation = dinoIdleAnimation;

    //animation = spriteSheet.createAnimationByLimit(xInit: 0, yInit: 0, step: 7, sizeX: 2, stepTime: .08);

    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;

    size = Vector2(spriteSheetWidth / 4, spriteSheetHeight / 4);

    centerX = (screenWidth / 2) - (spriteSheetWidth / 2);
    centerY = (screenHeight / 2) - (spriteSheetHeight / 2);

    debugMode = true;

    position = Vector2(centerX, screenHeight - (spriteSheetHeight / 8) - 20);

    // add(RectangleHitbox());
    // add(RectangleHitbox.relative(
    //     Vector2(spriteSheetWidth / 4, spriteSheetHeight / 4),
    //     relation: Vector2(spriteSheetWidth / 4, spriteSheetHeight / 4),
    //     //position: Vector2(100, 100),
    //     anchor: Anchor.bottomCenter,

    //     //angle: 50.0,

    //     parentSize: Vector2(1,
    //         1))); //.relative(Vector2(spriteSheetWidth,spriteSheetHeight), parentSize: Vector2(1, 1)

    add(RectangleHitbox(
        size: Vector2(spriteSheetWidth / 4 - 60, spriteSheetHeight / 4),
        position: Vector2(30, 0)));

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    print(other);

    super.onCollision(points, other);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    // animationIndex++;
    // if (animationIndex > 4) {
    //   animationIndex = 0;
    // }

    // switch (animationIndex) {
    //   case 1:
    //     animation = dinoIdleAnimation;
    //     break;
    //   case 2:
    //     animation = dinoJumpAnimation;
    //     break;
    //   case 3:
    //     animation = dinoRunAnimation;
    //     break;
    //   case 4:
    //     animation = dinoWalkAnimation;
    //     break;
    //   case 0:
    //   default:
    //     animation = dinoDeadAnimation;
    // }

    super.onTapDown(info);

    return true;
  }

  // @override
  // bool onTapUp(TapUpInfo info) {
  //   print(info);
  //   super.onTapUp(info);
  //   return true;
  // }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.isEmpty) {
      animation = dinoIdleAnimation;
    }

    // print(keysPressed);

    //***X */
    // correr
    if ((keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD)) &&
        keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
      animation = dinoRunAnimation;

      playerSpeed = 1500;

      if (!right) flipHorizontally();
      right = true;
      // position.x += 5;
      posX++;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      animation = dinoWalkAnimation;
      playerSpeed = 500;
      if (!right) flipHorizontally();
      right = true;
      // position.x += 5;
      posX++;
    }

    if ((keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA)) &&
        keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
      animation = dinoRunAnimation;

      playerSpeed = 1500;

      if (right) flipHorizontally();
      right = false;

      //position.x -= 5;
      posX--;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      animation = dinoWalkAnimation;

      playerSpeed = 500;

      if (right) flipHorizontally();
      right = false;

      //position.x -= 5;
      posX--;
    }

    //***Y */
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      animation = dinoWalkAnimation;

      //position.y -= 5;
      posY--;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS)) {
      animation = dinoWalkAnimation;
      //position.y ++= 5;
      posY++;
    }

    return true;
  }

  @override
  void update(double dt) {
    position.x += playerSpeed * dt * posX;
    position.y += playerSpeed * dt * posY;
    posX = 0;
    posY = 0;

    super.update(dt);
  }
}

extension CreateAnimationByLimit on SpriteSheet {
  SpriteAnimation createAnimationByLimit({
    required int xInit,
    required int yInit,
    required int step,
    required int sizeX,
    required double stepTime,
    bool loop = true,
  }) {
    final List<Sprite> spriteList = [];

    int x = xInit;
    int y = yInit - 1;

    for (var i = 0; i < step; i++) {
      if (y >= sizeX) {
        y = 0;
        x++;
      } else {
        y++;
      }

      spriteList.add(getSprite(x, y));
      // print(x.toString() + ' ' + y.toString());
    }

    return SpriteAnimation.spriteList(spriteList,
        stepTime: stepTime, loop: loop);
  }
}
