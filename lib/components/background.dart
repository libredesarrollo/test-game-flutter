import 'package:flame/components.dart';

import 'package:flame/flame.dart';

import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class Background extends SpriteComponent {
  late double screenWidth, screenHeight;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load('bg.jpg');
    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;

    //size = Vector2(screenWidth, screenHeight);
    size = sprite!.originalSize;
  }
}
