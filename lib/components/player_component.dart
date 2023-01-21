import 'dart:ui';

import 'package:testgame/components/ground.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flame/collisions.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';

import 'package:testgame/components/character.dart';
import 'package:testgame/components/meteor_component.dart';
import 'package:testgame/main.dart';
import 'package:testgame/utils/create_animation_by_limit.dart';

class PlayerComponent extends Character {
  Vector2 mapSize;
  MyGame game;

  PlayerComponent({required this.mapSize, required this.game}) : super() {
    anchor = Anchor.center;
    debugMode = true;
  }

  int count = 0;

  @override
  Future<void>? onLoad() async {
    final spriteImage = await Flame.images.load('dinofull.png');
    final spriteSheet = SpriteSheet(
        image: spriteImage,
        srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    // init animation
    deadAnimation = spriteSheet.createAnimationByLimit(
        xInit: 0, yInit: 0, step: 8, sizeX: 5, stepTime: .08, loop: false);
    idleAnimation = spriteSheet.createAnimationByLimit(
        xInit: 1, yInit: 2, step: 10, sizeX: 5, stepTime: .08);
    jumpAnimation = spriteSheet.createAnimationByLimit(
        xInit: 3, yInit: 0, step: 12, sizeX: 5, stepTime: .08, loop: false);
    runAnimation = spriteSheet.createAnimationByLimit(
        xInit: 5, yInit: 0, step: 8, sizeX: 5, stepTime: .08);
    walkAnimation = spriteSheet.createAnimationByLimit(
        xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: .08);
    walkSlowAnimation = spriteSheet.createAnimationByLimit(
        xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: .32);
    // end animation

    size = Vector2(spriteSheetWidth / 4, spriteSheetHeight / 4);

    reset();

    body = RectangleHitbox(
        size: Vector2(spriteSheetWidth / 4 - 70, spriteSheetHeight / 4 - 20),
        position: Vector2(25, 10))
      ..collisionType = CollisionType.active;

    foot = RectangleHitbox(
      size: Vector2(50, 10),
      position: Vector2(70, spriteSheetWidth / 4 - 70),
    )..collisionType = CollisionType.passive;

    add(foot);
    add(body);

    return super.onLoad();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.isEmpty) {
      movementType = MovementType.idle;
      animation = idleAnimation;
    }

    if (inGround) {
      //*** RIGHT
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.keyD)) {
        if (keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
          //RUN
          movementType = MovementType.runright;
        } else {
          movementType = MovementType.walkingright;
        }
      }
      //*** LEFT
      if ((keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
          keysPressed.contains(LogicalKeyboardKey.keyA))) {
        if (keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
          //RUN
          movementType = MovementType.runleft;
        } else {
          movementType = MovementType.walkingleft;
        }
      }
      //*** JUMP
      if ((keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
          keysPressed.contains(LogicalKeyboardKey.keyW))) {
        movementType = MovementType.jump;

        if ((keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD))) {
          movementType = MovementType.jumpright;
        } else if ((keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA))) {
          movementType = MovementType.jumpleft;
        }
      }

      switch (movementType) {
        case MovementType.walkingright:
        case MovementType.runright:
          if (!right) flipHorizontally();
          right = true;

          if (!collisionXRight) {
            animation = (movementType == MovementType.walkingright
                ? walkAnimation
                : runAnimation);

            velocity.x = jumpForceSide;
            position.x += jumpForceXY *
                (movementType == MovementType.walkingright ? 1 : 2);
          } else {
            animation = walkSlowAnimation;
          }
          break;

        case MovementType.walkingleft:
        case MovementType.runleft:
          if (right) flipHorizontally();
          right = false;

          if (!collisionXLeft) {
            animation = (movementType == MovementType.walkingleft
                ? walkAnimation
                : runAnimation);
            velocity.x = -jumpForceSide;
            position.x -= jumpForceXY *
                (movementType == MovementType.walkingleft ? 1 : 2);
          } else {
            animation = walkSlowAnimation;
          }
          break;
        case MovementType.jump:
        case MovementType.jumpleft:
        case MovementType.jumpright:
          animation = walkAnimation;
          velocity.y = -jumpForceUp;
          position.y -= jumpForceXY;
          inGround = false;
          animation = jumpAnimation;
          jumpUp = true;

          if (movementType == MovementType.jumpleft) {
            if (right) flipHorizontally();
            right = false;

            if (!collisionXLeft) {
              velocity.x = -jumpForceSide;
              position.x -= jumpForceXY;
            }
          } else if (movementType == MovementType.jumpright) {
            if (!right) flipHorizontally();
            right = true;

            if (!collisionXRight) {
              velocity.x = jumpForceSide;
              position.x += jumpForceXY;
            }
          }

          break;

        default:
      }
    }
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!inGround) {
      // en el aire
      velocity.y += gravity;
      position += velocity * dt;

      if (jumpUp && velocity.y * dt > 0) {
        velocity = Vector2.all(0);
        jumpUp = false;
      }
    }
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    if (other is ScreenHitbox) {
      if (points.first[0] <= 0.0) {
        // left
        collisionXLeft = true;
      } else if (points.first[0] >= mapSize.x
          //MediaQueryData.fromWindow(window).size.height

          ) {
        // left
        collisionXRight = true;
      }
    }

    super.onCollisionStart(points, other);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is ScreenHitbox) {
      if (points.first[0] <= 0.0) {
        // left
        collisionXLeft = true;
      } else if (points.first[0] >= mapSize.x
          //MediaQueryData.fromWindow(window).size.height

          ) {
        // left
        collisionXRight = true;
      }
    }

    if (other is Ground && !jumpUp) {
      if (foot.isColliding) {
        inGround = true;
      }
    }

    super.onCollision(points, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    collisionXLeft = collisionXRight = false;

    if (other is Ground) {
      inGround = false;
      jumpAnimation.reset();
    }

    if (other is MeteorComponent && body.isColliding) {
      print("dead ${game.colisionMeteors}");
      game.colisionMeteors++;

      game.overlays.remove('Statistics');
      game.overlays.add('Statistics');

      //reset(dead: true);
    }

    if (game.colisionMeteors >= 3) {
      reset(dead: true);
    }

    super.onCollisionEnd(other);
  }

  void reset({bool dead = false}) {
    movementType = MovementType.idle;
    velocity = Vector2.all(0);
    if (dead) {
      animation = deadAnimation;

      deadAnimation.onComplete = () {
        deadAnimation.reset();
        animation = idleAnimation;
        game.colisionMeteors = 0;
        position = Vector2(spriteSheetWidth / 4, mapSize.y - spriteSheetHeight);
      };
    } else {
      animation = idleAnimation;
      game.colisionMeteors = 0;
      position = Vector2(spriteSheetWidth / 4, mapSize.y - spriteSheetHeight);
    }
    // jumpVelocity = 0.0;
    // jumpCount = 0;
    // status = TRexStatus.running;
  }
}
