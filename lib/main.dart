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
