import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import 'dart:ui';

import 'package:flutter/services.dart';

class Tiger extends SpriteComponent with KeyboardHandler {
  late double screenWidth, screenHeight, centerX, centerY;
  late double spriteSizeWidth = 680.0, SpriteSizeHeight = 472.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;
    centerX = (screenWidth / 2) - (spriteSizeWidth / 2);
    centerY = (screenHeight / 2) - (SpriteSizeHeight / 2);

    var spriteImages = await Flame.images.load('dino.png');

     final spriteSheet = SpriteSheet(
         image: spriteImages, srcSize: Vector2(spriteSizeWidth, SpriteSizeHeight));

    sprite = spriteSheet.getSprite(3, 1);
    position = Vector2(centerX, centerY);
    size = Vector2(spriteSizeWidth, SpriteSizeHeight);
    //sprite = await Sprite.load('Sprite.png');
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
