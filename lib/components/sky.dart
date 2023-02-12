import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

class Sky extends SpriteComponent {
  // late double screenWidth, screenHeight;

  //Sky({required size}) : super(size: size);

  @override
  Future<void>? onLoad() async {
    position = Vector2(0, 0);

    sprite = await Sprite.load('background.jpg');

    //size = Vector2(screenWidth, screenHeight);
    size = sprite!.originalSize;

    return super.onLoad();
  }
}
