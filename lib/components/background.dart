import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class Background extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load('bg.jpg');
    size = sprite!.originalSize;
  }
}
