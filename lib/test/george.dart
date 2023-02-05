// import 'package:a_star_algorithm/a_star_algorithm.dart';
// import 'package:flame/components.dart';
// import 'package:flame/flame.dart';
// import 'package:flame/geometry.dart';
// import 'package:flame/sprite.dart';
// import 'package:flutter/services.dart';
// import 'package:goldrush/components/hud/hud.dart';
// import 'package:goldrush/components/skeleton.dart';
// import 'package:goldrush/components/water.dart';
// import 'package:goldrush/components/zombie.dart';
// import 'package:goldrush/components/coin.dart';
// import 'package:goldrush/main.dart';
// import 'package:goldrush/utils/map_utils.dart';
// import 'package:goldrush/utils/math_utils.dart';
// import 'package:flame/input.dart';
// import 'character.dart';
// import 'package:flame_audio/flame_audio.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:goldrush/utils/effects.dart';
// import 'package:flutter/material.dart';

class George extends Character with KeyboardHandler, HasGameRef<GoldRush> {
  George(
      {required this.barrierOffsets,
      required this.hud,
      required Vector2 position,
      required Vector2 size,
      required double speed})
      : super(position: position, size: size, speed: speed) {
    originalPosition = position;
  }

  final HudComponent hud;
  late double walkingSpeed, runningSpeed;
  late Vector2 targetLocation;
  bool movingToTouchedLocation = false;
  bool isMoving = false;
  late AudioPlayer audioPlayerRunning;
  int collisionDirection = Character.down;
  bool hasCollided = false;
  bool keyLeftPressed = false,
      keyRightPressed = false,
      keyUpPressed = false,
      keyDownPressed = false,
      keyRunningPressed = false;
  int health = 100;
  List<Offset> barrierOffsets;
  List<Offset> pathToTargetLocation = [];
  int currentPathStep = -1;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    walkingSpeed = speed;
    runningSpeed = speed * 2;

    var spriteImages = await Flame.images.load('george.png');
    final spriteSheet =
        SpriteSheet(image: spriteImages, srcSize: Vector2(width, height));

    downAnimation =
        spriteSheet.createAnimationByColumn(column: 0, stepTime: 0.2);
    leftAnimation =
        spriteSheet.createAnimationByColumn(column: 1, stepTime: 0.2);
    upAnimation = spriteSheet.createAnimationByColumn(column: 2, stepTime: 0.2);
    rightAnimation =
        spriteSheet.createAnimationByColumn(column: 3, stepTime: 0.2);

    animation = downAnimation;
    playing = false;
    anchor = Anchor.center;

    addHitbox(HitboxRectangle(relation: Vector2(0.7, 0.7))
      ..relativeOffset = Vector2(0.0, 0.1));

    await FlameAudio.audioCache.loadAll(
        ['sounds/enemy_dies.wav', 'sounds/running.wav', 'sounds/coin.wav']);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event.data.keyLabel.toLowerCase().contains('a')) {
      keyLeftPressed = (event is RawKeyDownEvent);
    }
    if (event.data.keyLabel.toLowerCase().contains('d')) {
      keyRightPressed = (event is RawKeyDownEvent);
    }
    if (event.data.keyLabel.toLowerCase().contains('w')) {
      keyUpPressed = (event is RawKeyDownEvent);
    }
    if (event.data.keyLabel.toLowerCase().contains('s')) {
      keyDownPressed = (event is RawKeyDownEvent);
    }
    if (event.data.keyLabel.toLowerCase().contains('r')) {
      keyRunningPressed = (event is RawKeyDownEvent);
    }

    return true;
  }

  void moveToLocation(TapUpInfo info) {
    pathToTargetLocation = AStar(
            rows: 50,
            columns: 50,
            start: worldToGridOffset(position),
            end: worldToGridOffset(info.eventPosition.game),
            withDiagonal: true,
            barriers: barrierOffsets)
        .findThePath()
        .toList();

    targetLocation = info.eventPosition.game;
    faceCorrectDirection();

    // As pathToTargetLocation[0] is the same as the current position, we set the currentPathStep to the next step, 1
    currentPathStep = 1;
    targetLocation = gridOffsetToWorld(pathToTargetLocation[currentPathStep]);
    targetLocation.add(Vector2(16, 16));

    movingToTouchedLocation = true;
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    super.onCollision(points, other);

    if (other is Zombie || other is Skeleton) {
      gameRef.add(
          ParticleComponent(explodingParticle(other.position, Colors.red)));
      other.removeFromParent();

      if (health > 0) {
        health -= 25;
        hud.healthText.setHealth(health);
      }

      if (health == 0) {
        Navigator.pushNamedAndRemoveUntil(
            gameRef.buildContext!, "/gameover", (r) => false);
      }

      FlameAudio.play('sounds/enemy_dies.wav', volume: 1.0);
    }

    if (other is Coin) {
      gameRef.add(
          ParticleComponent(explodingParticle(other.position, Colors.yellow)));
      other.removeFromParent();
      hud.scoreText.setScore(20);

      FlameAudio.play('sounds/coin.wav', volume: 1.0);
    }

    if (other is Water) {
      if (!hasCollided) {
        if (movingToTouchedLocation) {
          movingToTouchedLocation = false;
        } else {
          hasCollided = true;
          collisionDirection = currentDirection;
        }
      }
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    hasCollided = false;
  }

  @override
  void update(double dt) async {
    super.update(dt);

    speed = (hud.runButton.buttonPressed || keyRunningPressed)
        ? runningSpeed
        : walkingSpeed;
    final bool isMovingByKeys =
        keyLeftPressed || keyRightPressed || keyUpPressed || keyDownPressed;

    if (!hud.joystick.delta.isZero()) {
      moveByJoystick(dt);
    } else if (isMovingByKeys) {
      moveByKeyboard(dt);
    } else {
      if (movingToTouchedLocation) {
        moveByTouch(dt);
      } else {
        if (playing) {
          stopAnimations();
        }
        if (isMoving) {
          isMoving = false;
          audioPlayerRunning.stop();
        }
      }
    }
  }

  void moveByJoystick(double dt) async {
    movePlayer(dt);
    playing = true;
    movingToTouchedLocation = false;

    if (!isMoving) {
      isMoving = true;
      audioPlayerRunning =
          await FlameAudio.loopLongAudio('sounds/running.wav', volume: 1.0);
    }

    switch (hud.joystick.direction) {
      case JoystickDirection.up:
      case JoystickDirection.upRight:
      case JoystickDirection.upLeft:
        animation = upAnimation;
        currentDirection = Character.up;
        break;
      case JoystickDirection.down:
      case JoystickDirection.downRight:
      case JoystickDirection.downLeft:
        animation = downAnimation;
        currentDirection = Character.down;
        break;
      case JoystickDirection.left:
        animation = leftAnimation;
        currentDirection = Character.left;
        break;
      case JoystickDirection.right:
        animation = rightAnimation;
        currentDirection = Character.right;
        break;
      case JoystickDirection.idle:
        animation = null;
        break;
    }
  }

  void moveByKeyboard(double dt) async {
    movePlayer(dt);
    playing = true;
    movingToTouchedLocation = false;

    if (!isMoving) {
      isMoving = true;
      audioPlayerRunning =
          await FlameAudio.loopLongAudio('sounds/running.wav', volume: 1.0);
    }

    if (keyUpPressed && (keyLeftPressed || keyRightPressed)) {
      animation = upAnimation;
      currentDirection = Character.up;
    } else if (keyDownPressed && (keyLeftPressed || keyRightPressed)) {
      animation = downAnimation;
      currentDirection = Character.down;
    } else if (keyLeftPressed) {
      animation = leftAnimation;
      currentDirection = Character.left;
    } else if (keyRightPressed) {
      animation = rightAnimation;
      currentDirection = Character.right;
    } else if (keyUpPressed) {
      animation = upAnimation;
      currentDirection = Character.up;
    } else if (keyDownPressed) {
      animation = downAnimation;
      currentDirection = Character.down;
    } else {
      animation = null;
    }
  }

  void moveByTouch(double dt) async {
    if (!isMoving) {
      isMoving = true;
      audioPlayerRunning =
          await FlameAudio.loopLongAudio('sounds/running.wav', volume: 1.0);
    }

    movePlayer(dt);
    double threshold = 2.0;
    var difference = targetLocation - position;
    if (difference.x.abs() < threshold && difference.y.abs() < threshold) {
      if (currentPathStep < pathToTargetLocation.length - 1) {
        currentPathStep++;
        targetLocation =
            gridOffsetToWorld(pathToTargetLocation[currentPathStep]);
        targetLocation.add(Vector2(16, 16));
      } else {
        stopAnimations();
        audioPlayerRunning.stop();
        isMoving = false;

        movingToTouchedLocation = false;
        return;
      }
    }

    playing = true;
    if (currentPathStep <= pathToTargetLocation.length) {
      faceCorrectDirection();
    }
  }

  void faceCorrectDirection() {
    var angle = getAngle(position, targetLocation);
    if ((angle > 315 && angle < 360) || (angle > 0 && angle < 45)) {
      // Facing right
      animation = rightAnimation;
      currentDirection = Character.right;
    } else if (angle > 45 && angle < 135) {
      // Facing down
      animation = downAnimation;
      currentDirection = Character.down;
    } else if (angle > 135 && angle < 225) {
      // Facing left
      animation = leftAnimation;
      currentDirection = Character.left;
    } else if (angle > 225 && angle < 315) {
      // Facing up
      animation = upAnimation;
      currentDirection = Character.up;
    }
  }

  void movePlayer(double delta) {
    if (!(hasCollided && collisionDirection == currentDirection)) {
      if (movingToTouchedLocation) {
        position
            .add((targetLocation - position).normalized() * (speed * delta));
      } else {
        switch (currentDirection) {
          case Character.left:
            position.add(Vector2(delta * -speed, 0));
            break;
          case Character.right:
            position.add(Vector2(delta * speed, 0));
            break;
          case Character.up:
            position.add(Vector2(0, delta * -speed));
            break;
          case Character.down:
            position.add(Vector2(0, delta * speed));
            break;
        }
      }
    }
  }

  void stopAnimations() {
    animation?.currentIndex = 0;
    playing = false;

    keyLeftPressed = false;
    keyRightPressed = false;
    keyUpPressed = false;
    keyDownPressed = false;
  }

  void onPaused() {
    if (isMoving) {
      audioPlayerRunning.pause();
    }
  }

  void onResumed() async {
    if (isMoving) {
      audioPlayerRunning.resume();
    }
  }
}
















import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import '../my_george_game.dart';

class GeorgeComponent extends SpriteAnimationComponent
    with HasHitboxes, Collidable, HasGameRef {
  final MyGeorgeGame game;
  GeorgeComponent({required this.game}) {
    addHitbox(HitboxRectangle(relation: Vector2.all(0.4)));
  }
  late SpriteAnimation downAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation idleAnimation;
  final double animationSpeed = .1;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = SpriteSheet(
        image: await gameRef.images.load('george2.png'),
        srcSize: Vector2(48, 48));

    // new
    downAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 4);
    leftAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: animationSpeed, to: 4);
    upAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: animationSpeed, to: 4);
    rightAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: animationSpeed, to: 4);
    idleAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 1);
    animation = idleAnimation;
  }

  @override
  void update(double dt) {
    if (!game.showDialog) {
      switch (game.direction) {
        case 0:
          animation = idleAnimation;
          break;
        case 1:
          animation = downAnimation;
          if (y < game.mapHeight - height) {
            if (game.collisionDirection != 1) {
              y += dt * game.characterSpeed;
            }
          }
          break;
        case 2:
          animation = leftAnimation;
          if (x > 0) {
            if (game.collisionDirection != 2) {
              x -= dt * game.characterSpeed;
            }
          }

          break;
        case 3:
          animation = upAnimation;
          if (y > 0) {
            if (game.collisionDirection != 3) {
              y -= dt * game.characterSpeed;
            }
          }

          break;
        case 4:
          animation = rightAnimation;
          if (x < game.mapWidth - width) {
            if (game.collisionDirection != 4) {
              x += dt * game.characterSpeed;
            }
          }
          break;
      }
    }
    super.update(dt);
  }
}











import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:george/characters/george_component.dart';
import 'package:george/main.dart';

import '../my_george_game.dart';

class ObstacleComponent extends PositionComponent with HasHitboxes, Collidable {
  final MyGeorgeGame game;
  bool _hasCollided = false;
  ObstacleComponent({required this.game}) {
    addHitbox(HitboxRectangle());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if (other is GeorgeComponent) {
      if (!_hasCollided) {
        game.collisionDirection = game.direction;
        _hasCollided = true;
        print(
            'collision with obstacle in direction: ${game.collisionDirection}');
      }
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    if (other is GeorgeComponent) {
      game.collisionDirection = -1;
      _hasCollided = false;
    }
  }
}
