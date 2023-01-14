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
  double dead = 0;

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
      'MainMenu': (context, MyGame game) {
        return MainMenu(game: game);
      },
      'GameOver': (context, MyGame game) {
        return GameOver(game: game);
      },
    },
    initialActiveOverlays: const ['GameOver'],
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
      "Holasas asa sas as asas as ${widget.game.dead}",
      style: TextStyle(color: Colors.white),
    );
  }
}

class GameOver extends StatelessWidget {
  // Reference to parent game.
  final MyGame game;
  const GameOver({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 200,
          width: 300,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    //game.reset();
                    game.overlays.remove('GameOver');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Play Again',
                    style: TextStyle(
                      fontSize: 28.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
