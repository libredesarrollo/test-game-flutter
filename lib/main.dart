import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:testgame/components/background.dart';
import 'package:testgame/components/meteor_component.dart';
import 'package:testgame/components/player_component.dart';
import 'package:testgame/components/tile_map_component.dart';

class MyGame extends FlameGame
    with
        KeyboardEvents,
        /*TapDetector */ HasTappables,
        HasKeyboardHandlerComponents,
        HasCollisionDetection {
  double elapsedTime = 0.0;

  @override
  Future<void>? onLoad() {
    var background = Background();
    add(background);
    add(ScreenHitbox());
    //add(TileMapComponent());
    //
    // print(background.loaded);
    // print(background.isLoaded);

    // print(background.size.x.toString());

    background.loaded.then((value) {
      print('*****' + background.size.x.toString());
      final player = PlayerComponent(
          mapSize: Vector2(background.size.x, background.size.y));
      add(player);
      camera.followComponent(player,
          worldBounds:
              Rect.fromLTRB(0, 0, background.size.x, background.size.y));
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

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  runApp(GameWidget(game: MyGame()));
}
