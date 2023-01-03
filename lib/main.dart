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
    var player = PlayerComponent();
    var background = Background();

    add(ScreenHitbox());
    add(TileMapComponent());
    //add(background);
    add(player);
    // print(background.loaded);
    // print(background.isLoaded);

    // print(background.size.x.toString());

    // background.loaded.then((value) {
    //   print('*****' + background.size.x.toString());
    //   camera.followComponent(player,
    //       worldBounds:
    //           Rect.fromLTRB(0, 0, background.size.x, background.size.y));
    //   print('cargado');
    // });
    // var p = ObjectGroup;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    elapsedTime += dt;
    if (elapsedTime > 1.0) {
      add(MeteorComponent());
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
