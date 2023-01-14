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

      final player = PlayerComponent(
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
      //add(MeteorComponent(cameraPosition: camera.position));
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

  runApp(GameWidget(
    game: MyGame(),
    overlayBuilderMap: {
      'MainMenu': (context, MyGame game) => MainMenu(game: game),
    },
  ));
}

class MainMenu extends StatefulWidget {
  MainMenu({Key? key, required this.game}) : super(key: key);
  @override
  State<MainMenu> createState() => _MainMenuState();
  final MyGame game;
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Holasas asa sas as asas as",
      style: TextStyle(color: Colors.white),
    );
  }
}
