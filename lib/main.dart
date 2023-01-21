import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:testgame/components/background.dart';
import 'package:testgame/components/meteor_component.dart';
import 'package:testgame/components/player_component.dart';
import 'package:testgame/components/tile_map_component.dart';
import 'package:testgame/overlay/game_over.dart';
import 'package:testgame/overlay/stadistics.dart';

class MyGame extends FlameGame
    with
        KeyboardEvents,
        /*TapDetector */ HasTappables,
        HasKeyboardHandlerComponents,
        HasCollisionDetection {
  double elapsedTime = 0.0;
  double colisionMeteors = 0;
  bool pauseGame = false;
  late PlayerComponent player;

  @override
  Future<void>? onLoad() {
    //var background = Background();
    //add(background);
    add(ScreenHitbox());

    var backgroundTile = TileMapComponent();

    add(backgroundTile);
    //
    // print(background.loaded);
    // print(background.isLoaded);

    // print(background.size.x.toString());

    backgroundTile.loaded.then((value) {
      print(backgroundTile.tiledMap.size.x.toString() +
          "    " +
          backgroundTile.tiledMap.size.y.toString());

      player = PlayerComponent(
          game: this,
          mapSize: Vector2(
              backgroundTile.tiledMap.size.x, backgroundTile.tiledMap.size.y));
      add(player);
      camera.followComponent(player,
          worldBounds: Rect.fromLTRB(0, 0, backgroundTile.tiledMap.size.x,
              backgroundTile.tiledMap.size.y));
    });
    // var p = ObjectGroup;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // print(camera.position.x.toString());
    // print(camera.position.y.toString());
    elapsedTime += dt;
    if (elapsedTime > 1.0) {
      add(MeteorComponent(cameraPosition: camera.position));
      elapsedTime = 0.0;
    }

    super.update(dt);
  }

  // @override
  // Color backgroundColor() {
  //   return Colors.purple;
  // }
}

//https://docs.flame-engine.org/1.5.0/tutorials/platformer/step_7.html?highlight=overlaybuildermap

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

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
