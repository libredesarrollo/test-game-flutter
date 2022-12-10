import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import 'dart:ui';

import 'package:flutter/services.dart';

class Tiger extends SpriteComponent with KeyboardHandler {
  late double screenWidth, screenHeight, centerX, centerY;
  late double tigerSizeWidth = 512.0, tigerSizeHeight = 512.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;
    centerX = (screenWidth / 2) - (tigerSizeWidth / 2);
    centerY = (screenHeight / 2) - (tigerSizeHeight / 2);

    // var spriteImages = await Flame.images.load('george.png');

    // final spriteSheet = SpriteSheet(
    //     image: spriteImages, srcSize: Vector2(tigerSizeWidth, tigerSizeHeight));

    // sprite = spriteSheet.getSprite(0, 2);
    position = Vector2(centerX, centerY);
    size = Vector2(tigerSizeWidth, tigerSizeHeight);
    sprite = await Sprite.load('tiger.png');
  }

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      position = Vector2(centerX, centerY--);
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS)) {
      position = Vector2(centerX, centerY++);
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      position = Vector2(centerX++, centerY);
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      position = Vector2(centerX--, centerY);
    }

    return true;
  }
}
