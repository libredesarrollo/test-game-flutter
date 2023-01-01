import 'package:flame/collisions.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'package:flame/flame.dart';
import 'package:flame/components.dart';

import 'dart:ui';

import 'package:flutter/services.dart';

class PlayerComponent extends SpriteAnimationComponent
    with KeyboardHandler, CollisionCallbacks {
  PlayerComponent();

  double gravity = 5;
  Vector2 velocity = Vector2(0, 0);

  late double screenWidth, screenHeight, centerX, centerY;
  final double spriteSheetWidth = 680, spriteSheetHeight = 472;
  int posX = 0, posY = 0;

  double playerSpeed = 500;
  final double jumpForce = 130;

  int animationIndex = 0;

  bool right = true,
      collisionXRight = false,
      collisionXLeft = false,
      inGround = false;

  late SpriteAnimation dinoDeadAnimation,
      dinoIdleAnimation,
      dinoJumpAnimation,
      dinoRunAnimation,
      dinoWalkAnimation,
      dinoWalkSlowAnimation;

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.center;
    debugMode = true;

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
    dinoWalkSlowAnimation = spriteSheet.createAnimationByLimit(
        xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: .32);
    // end animation

    animation = dinoIdleAnimation;

    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;

    size = Vector2(spriteSheetWidth / 4, spriteSheetHeight / 4);

    centerX = (screenWidth / 2) - (spriteSheetWidth / 2);
    centerY = (screenHeight / 2) - (spriteSheetHeight / 2);

    position = Vector2(centerX, centerY);

    add(RectangleHitbox(
        size: Vector2(spriteSheetWidth / 4 - 70, spriteSheetHeight / 4),
        position: Vector2(25, 0)));

    return super.onLoad();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.isEmpty) {
      animation = dinoIdleAnimation;
    }

    //***X */
    // correr
    if ((keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD)) &&
        keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
      playerSpeed = 1500;

      if (!right) flipHorizontally();
      right = true;

      if (!collisionXRight) {
        animation = dinoRunAnimation;
        posX++;
      } else {
        animation = dinoWalkSlowAnimation;
      }
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      playerSpeed = 500;
      if (!right) flipHorizontally();
      right = true;

      if (!collisionXRight) {
        animation = dinoWalkAnimation;
        posX++;
      } else {
        animation = dinoWalkSlowAnimation;
      }
    }

    if ((keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA)) &&
        keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
      playerSpeed = 1500;

      if (right) flipHorizontally();
      right = false;

      if (!collisionXLeft) {
        animation = dinoRunAnimation;
        posX--;
      } else {
        animation = dinoWalkSlowAnimation;
      }
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      playerSpeed = 500;

      if (right) flipHorizontally();
      right = false;

      if (!collisionXLeft) {
        animation = dinoWalkAnimation;
        posX--;
      } else {
        animation = dinoWalkSlowAnimation;
      }
    }

    //***Y */
    if ((keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
            keysPressed.contains(LogicalKeyboardKey.keyW)) &&
        !inGround) {
      animation = dinoJumpAnimation;
      velocity.y = -jumpForce;
      position.y -= 15;
    }
    // if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
    //     keysPressed.contains(LogicalKeyboardKey.keyS)) {
    //   animation = dinoWalkAnimation;

    //   posY++;
    // }

    return true;
  }

  @override
  void update(double dt) {
    position.x += playerSpeed * dt * posX;
    position.y += playerSpeed * dt * posY;
    posX = 0;
    posY = 0;

    if (position.y < 900 - size[1]) {
      velocity.y += gravity;
      inGround = true;
    } else {
      velocity = Vector2.all(0);
      inGround = false;
    }

    position += velocity * dt;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    //if (other is ScreenHitbox) {
    if (points.first[0] <= 0.0) {
      // left
      collisionXLeft = true;
    } else if (points.first[0] >= 4000) {
      //MediaQueryData.fromWindow(window).size.height
      // left
      collisionXRight = true;
      //}
    }

    super.onCollision(points, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    collisionXLeft = collisionXRight = false;
    super.onCollisionEnd(other);
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
