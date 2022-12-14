import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testgame/components/meteor_component.dart';
import 'package:testgame/components/player_component.dart';
import 'package:testgame/components/background.dart';

class MyGame extends FlameGame
    with
        KeyboardEvents,
        /*TapDetector */ HasTappables,
        HasKeyboardHandlerComponents,
        HasCollisionDetection {
  double elapsedTime = 0.0;

  @override
  Future<void>? onLoad() {
    add(Background());
    add(ScreenHitbox());
    // add(PlayerComponent());

    print('main' + size.x.toString());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    elapsedTime += dt;
    if (elapsedTime > 1.0) {
      //add(MeteorComponent());
      elapsedTime = 0.0;
    }

    super.update(dt);
  }

  // @override
  // Color backgroundColor() {
  //   return Colors.purple;
  // }
}

void main(List<String> args) {
  runApp(GameWidget(game: MyGame()));
}
