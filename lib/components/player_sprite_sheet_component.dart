import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

class PlayeSpriteSheetComponent extends SpriteAnimationComponent {
  late double screenWidth, screenHeight, centerX, centerY;
  final double spriteWidth = 512.0, spriteHeight = 512.0;

  late double spriteSheetWidth = 680.0, spriteSheetHeight = 472.0;

  late SpriteAnimation dinoAnimation;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;

    centerX = (screenWidth / 2) - (spriteSheetWidth / 2);
    centerY = (screenHeight / 2) - (spriteSheetHeight / 2);

    var spriteImages = await Flame.images.load('dino.png');

    final spriteSheet = SpriteSheet(
        image: spriteImages,
        srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    //sprite = spriteSheet.getSprite(1, 1);
    position = Vector2(centerX, centerY);
    size = Vector2(spriteSheetWidth, spriteSheetHeight);
    //sprite = await Sprite.load('Sprite.png');

    // dinoAnimation =
    //     spriteSheet.createAnimationByColumn(column: 0, stepTime: 1, to: 4);

    // dinoAnimation = spriteSheet.createAnimationByLimit(
    //     xInit: 1, yInit: 1, xEnd: 2, yEnd: 1, stepTime: .08);

    dinoAnimation = spriteSheet.createAnimationByLimit(
        xInit: 0, yInit: 0, step: 10, sizeX: 2, stepTime: .08);

    animation = dinoAnimation;
  }

  @override
  void update(double dt) {
    // position = Vector2(centerX++, centerY++);

    super.update(dt);
  }
}

extension CreateAnimationByColumn on SpriteSheet {
  SpriteAnimation createAnimationByColumn({
    required int column,
    required double stepTime,
    bool loop = true,
    int from = 0,
    int? to,
  }) {
    print(columns);

    to ??= columns;
    final spriteList = List<int>.generate(to - from, (i) => from + i).map((e) {
      print(e.toString() + " " + column.toString());
      return getSprite(e, column);
    }).toList();

    //spriteList.add();

    return SpriteAnimation.spriteList(
      spriteList,
      stepTime: stepTime,
      loop: loop,
    );
  }
}

extension CreateAnimationByLimit on SpriteSheet {
  SpriteAnimation createAnimationByLimit(
      // {required int xInit,
      // required int xEnd,
      // required int yInit,
      // required int yEnd,
      {required int xInit,
      required int yInit,
      required int step,
      required int sizeX,
      required double stepTime,
      bool loop = true}) {
    final List<Sprite> spriteList = [];

    var x = xInit;
    var y = yInit - 1;
    for (var i = 0; i < step; i++) {
      if (y >= sizeX) {
        // 2 ancho
        y = 0;
        x++;
      } else {
        y++;
      }

      print(x.toString() + " -- " + y.toString());
      spriteList.add(getSprite(x, y));
    }

    // for (var i = xInit; i < xEnd; i++) {
    //   for (var j = yInit; j < yEnd; j++) {
    //     //print(i.toString() + " " + j.toString());
    //     spriteList.add(getSprite(i, j));
    //   }
    // }

    return SpriteAnimation.spriteList(
      spriteList,
      stepTime: stepTime,
      loop: loop,
    );
  }
}
