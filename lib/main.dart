import 'package:flame/collisions.dart';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:testgame/components/meteor_component.dart';
import 'package:testgame/components/player_component.dart';
import 'package:testgame/components/tile_map_component.dart';
import 'package:testgame/overlay/game_over.dart';
import 'package:testgame/overlay/stadistics.dart';

class MyGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  double elapsedTime = 0.0;
  int colisionMeteors = 0;
  late PlayerComponent player;
  late TileMapComponent background;

  @override
  Future<void>? onLoad() {
    background = TileMapComponent();
    add(background);

    background.loaded.then(
      (value) {
        player = PlayerComponent(mapSize: background.tiledMap.size, game: this);
        add(player);
        print(background.tiledMap.size.y);
        camera.followComponent(player,
            worldBounds: Rect.fromLTRB(
                0, 0, background.tiledMap.size.x, background.tiledMap.size.y));
      },
    );

    add(ScreenHitbox());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (elapsedTime > 1.0) {
      add(MeteorComponent(cameraPosition: camera.position));
      elapsedTime = 0.0;
    }

    elapsedTime += dt;
    super.update(dt);
  }

  void addConsumibles() {
    background.addConsumibles();
  }

  @override
  Color backgroundColor() {
    super.backgroundColor();
    return Colors.purple;
  }
}

void main() {
  runApp(GameWidget(
    game: MyGame(),
    overlayBuilderMap: {
      'Statistics': (context, MyGame game) {
        return Statistics(
          game: game,
        );
      },
      'GameOver': (context, MyGame game) {
        return GameOver(
          game: game,
        );
      }
    },
    initialActiveOverlays: const ['Statistics'],
  ));
}
/*

   movePlayer(dt);
    playing = true;
    movingToTouchedLocation = false;

    if (!isMoving) {
      isMoving = true;
      audioPlayerRunning = await FlameAudio.loopLongAudio('sounds/running.wav', volume: 1.0);
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
void movePlayer(double delta) {
    if (!(hasCollided && collisionDirection == currentDirection)) {
      if (movingToTouchedLocation) {
        position.add((targetLocation - position).normalized() * (speed * delta));
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
 */