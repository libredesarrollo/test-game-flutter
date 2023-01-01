import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testgame/components/background.dart';
import 'package:testgame/components/meteor_component.dart';
import 'package:testgame/components/player_component.dart';

class MyGame extends FlameGame
    with
        KeyboardEvents,
        /*TapDetector */ HasTappables,
        HasKeyboardHandlerComponents,
        HasCollisionDetection {
  double elapsedTime = 0.0;

  var bg = Background();

  @override
  Future<void>? onLoad() {
    var player = PlayerComponent();

    add(ScreenHitbox());
    add(bg);
    add(player);
    print(bg.loaded);
    print(bg.isLoaded);

    bg.loaded.then((value) {
      camera.followComponent(player,
          worldBounds: Rect.fromLTRB(0, 0, bg.size.x, bg.size.y));
      print('cargado');
    });

    return super.onLoad();
  }

  @override
  void update(double dt) {
    print(bg.size.x);

    elapsedTime += dt;
    if (elapsedTime > 1.0) {
      add(MeteorComponent());
      elapsedTime = 0.0;
    }

    super.update(dt);
  }

  @override
  Color backgroundColor() {
    return Colors.purple;
  }
}

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  runApp(GameWidget(game: MyGame()));
}
