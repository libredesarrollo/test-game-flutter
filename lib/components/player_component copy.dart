import 'package:flutter/services.dart';

import 'package:flame/collisions.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';

import 'package:testgame/components/character.dart';
import 'package:testgame/components/ground.dart';
import 'package:testgame/components/life.dart';
import 'package:testgame/components/meteor_component.dart';
import 'package:testgame/main.dart';
import 'package:testgame/utils/create_animation_by_limit.dart';

class PlayerComponent extends Character {
  Vector2 mapSize;
  MyGame game;

  bool blockPlayer = false;
  double blockPlayerTime = 2.0;
  double blockPlayerElapseTime = 0;

  bool inviciblePlayer = false;
  double inviciblePlayerTime = 3.0;
  double inviciblePlayerElapseTime = 0;

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

    reset();

    body = RectangleHitbox(
        size: Vector2(spriteSheetWidth / 4 - 70, spriteSheetHeight / 4),
        position: Vector2(25, 0))
      ..collisionType = CollisionType.active;

    foot = RectangleHitbox(
        size: Vector2(50, 10),
        position: Vector2(55, spriteSheetHeight / 4 - 20))
      ..collisionType = CollisionType.passive;

    add(body);
    add(foot);

    return super.onLoad();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (blockPlayer) {
      return true;
    }

    if (keysPressed.isEmpty) {
      animation = idleAnimation;
      movementType = MovementType.idle;
      velocity = Vector2.all(0);
    }

    if (inGround) {
      // RIGHT
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.keyD)) {
        if (keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
          // RUN
          movementType = MovementType.runright;
        } else {
          // WALKING
          movementType = MovementType.walkingright;
        }
      }
      // LEFT
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
          keysPressed.contains(LogicalKeyboardKey.keyA)) {
        if (keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
          // RUN
          movementType = MovementType.runleft;
        } else {
          // WALKING
          movementType = MovementType.walkingleft;
        }
      }
      // JUMP
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
          keysPressed.contains(LogicalKeyboardKey.keyW)) {
        movementType = MovementType.jump;
        if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD)) {
          // RIGHT
          movementType = MovementType.jumpright;
        } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA)) {
          // LEFT
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
            velocity.x = jumpForceUp *
                (movementType == MovementType.walkingright ? 1 : 2);
            // position.x += jumpForceXY *
            //     (movementType == MovementType.walkingright ? 1 : 2);
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
            // posX--;
            velocity.x = -jumpForceUp *
                (movementType == MovementType.walkingleft ? 1 : 2);
            // position.x -= jumpForceXY *
            //     (movementType == MovementType.walkingright ? 1 : 2);
          } else {
            animation = walkSlowAnimation;
          }

          break;
        case MovementType.jump:
        case MovementType.jumpright:
        case MovementType.jumpleft:
          velocity.y = -jumpForceUp;
          position.y -= 20;
          inGround = false;
          jumpUp = true;
          animation = jumpAnimation;
          if (movementType == MovementType.jumpright) {
            if (!right) flipHorizontally();
            right = true;

            if (!collisionXRight) {
              velocity.x = jumpForceSide;
              // position.x += jumpForceXY;
            }
          } else if (movementType == MovementType.jumpleft) {
            if (right) flipHorizontally();
            right = false;

            if (!collisionXLeft) {
              velocity.x = -jumpForceSide;
              // position.x -= jumpForceXY;
            }
          }

          break;
        case MovementType.idle:
          break;
      }

      // solo puede saltar o caminar/correr si el player esta en el piso
      //***X */
      // correr
      /*   if ((keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
              keysPressed.contains(LogicalKeyboardKey.keyD)) &&
          keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
        if (!right) flipHorizontally();
        right = true;
        if (!collisionXRight) {
          animation = runAnimation;
          // posX++;
          velocity.x = jumpForceUp;
          position.x += jumpForceXY * 2;
        } else {
          animation = walkSlowAnimation;
        }
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.keyD)) {
        if (!right) flipHorizontally();
        right = true;
        if (!collisionXRight) {
          animation = walkAnimation;
          //posX++;
          velocity.x = jumpForceUp;
          position.x += jumpForceXY;
        } else {
          animation = walkSlowAnimation;
        }
      }
      if ((keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
              keysPressed.contains(LogicalKeyboardKey.keyA)) &&
          keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
        if (right) flipHorizontally();
        right = false;
        if (!collisionXLeft) {
          animation = runAnimation;
          // posX--;
          velocity.x = -jumpForceUp;
          position.x -= jumpForceXY * 2;
        } else {
          animation = walkSlowAnimation;
        }
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
          keysPressed.contains(LogicalKeyboardKey.keyA)) {
        if (right) flipHorizontally();
        right = false;
        if (!collisionXLeft) {
          animation = walkAnimation;
          velocity.x = -jumpForceUp;
          position.x -= jumpForceXY;
        } else {
          animation = walkSlowAnimation;
        }
      }
      //***Y */
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
          keysPressed.contains(LogicalKeyboardKey.keyW)) {
        animation = walkAnimation;
        velocity.y = -jumpForceUp;
        position.y -= jumpForceXY;
        inGround = false;
        jumpUp = true;
        animation = jumpAnimation;
        if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA)) {
          if (right) flipHorizontally();
          right = false;
          if (!collisionXLeft) {
            velocity.x = -jumpForceSide;
            position.x -= jumpForceXY;
          }
        } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD)) {
          if (!right) flipHorizontally();
          right = true;
          if (!collisionXRight) {
            velocity.x = jumpForceSide;
            position.x += jumpForceXY;
          }
        }
      }*/
    }

    // if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
    //     keysPressed.contains(LogicalKeyboardKey.keyS)) {
    //   animation = walkAnimation;

    //   posY++;
    // }

    return true;
  }

  @override
  void update(double dt) {
    if (blockPlayer) {
      if (blockPlayerElapseTime > blockPlayerTime) {
        blockPlayer = false;
        blockPlayerElapseTime = 0.0;
      }
      blockPlayerElapseTime += dt;
    }

    if (inviciblePlayer) {
      if (inviciblePlayerElapseTime > inviciblePlayerTime) {
        inviciblePlayer = false;
        inviciblePlayerElapseTime = 0.0;
      }
      inviciblePlayerElapseTime += dt;
    }

    if (!inGround) {
      // en el aire

      if (velocity.y * dt > 0 && jumpUp) {
        jumpUp = false;
      }

      velocity.y += gravity;
      //
    } else {
      velocity.y = 0;
    }

    position += velocity * dt;

    super.update(dt);
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

    if (other is Ground && !jumpUp && foot.isColliding) {
      inGround = true;
      //velocity = Vector2.all(0);
    }

    if (other is Life && game.colisionMeteors > 0) {
      game.colisionMeteors--;
      game.overlays.remove('Statistics');
      game.overlays.add('Statistics');
      other.removeFromParent();
    }

    if (game.colisionMeteors >= 3 && !inviciblePlayer) {
      reset(dead: true);
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

    if (other is MeteorComponent && !inviciblePlayer /*&& body.isColliding*/) {
      game.colisionMeteors++;
      game.overlays.remove('Statistics');
      game.overlays.add('Statistics');
    }

    super.onCollisionEnd(other);
  }

  void reset({bool dead = false}) {
    velocity = Vector2.all(0);
    game.overlays.remove('Statistics');
    game.overlays.add('Statistics');

    game.addConsumibles();

    blockPlayer = true;
    inviciblePlayer = true;
    movementType = MovementType.idle;
    if (dead) {
      animation = deadAnimation;
      deadAnimation.onComplete = () {
        deadAnimation.reset();
        animation = idleAnimation;
        position = Vector2(spriteSheetWidth / 4, mapSize.y - spriteSheetHeight);
      };
    } else {
      animation = idleAnimation;
      position = Vector2(spriteSheetWidth / 4, mapSize.y - spriteSheetHeight);
      size = Vector2(spriteSheetWidth / 4, spriteSheetHeight / 4);
    }
    game.colisionMeteors = 0;

    //position = Vector2(spriteSheetWidth / 4, 0);
  }
}
