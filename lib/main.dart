import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testgame/components/circle_position_component.dart';

import 'package:testgame/components/player_sprite_sheet_component.dart';

class MyGame extends FlameGame
    with
        KeyboardEvents,
        /*TapDetector */ HasTappables,
        HasKeyboardHandlerComponents,
        HasCollisionDetection {
  double elapsedTime = 0.0;

  @override
  Future<void>? onLoad() {
    // add(PlayerImageSpriteComponent());
    //add(PlayerSpriteSheetComponent());

    add(PlayerSpriteSheetComponent());

    // add(CirclePositionComponent(countActive: true));
    // add(CirclePositionComponent());
    add(ScreenHitbox());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    elapsedTime += dt;
    if (elapsedTime > 3.0) {
      add(CirclePositionComponent());
      elapsedTime = 0.0;
    }

    super.update(dt);
  }
}

void main(List<String> args) {
  runApp(GameWidget(game: MyGame()));
}
