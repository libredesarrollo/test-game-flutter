import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testgame/components/meteor_component.dart';
import 'package:testgame/components/player_component.dart';

class MyGame extends FlameGame
    with
        KeyboardEvents,
        /*TapDetector */ HasTappables,
        HasKeyboardHandlerComponents,
        HasCollisionDetection {
  double elapsedTime = 0.0;

  // @override
  // Color backgroundColor() {
  //   return Colors.red;
  // }

  @override
  Future<void>? onLoad() {
    add(ScreenHitbox());
    add(PlayerComponent());

    print('main' + size.x.toString());

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
}

void main(List<String> args) {
  runApp(GameWidget(game: MyGame()));
}
