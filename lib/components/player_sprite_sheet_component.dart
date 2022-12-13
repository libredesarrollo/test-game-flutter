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

    dinoAnimation =
        spriteSheet.createAnimationByColumn(column: 0, stepTime: 1, to: 4);

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
    final spriteList = List<int>.generate(to - from, (i) => from + i)
        .map((e) {
          print(e.toString()+" "+column.toString());
        return getSprite(e, column);
        })
        .toList();




    //spriteList.add();


    return SpriteAnimation.spriteList(
      spriteList,
      stepTime: stepTime,
      loop: loop,
    );
  }
}
// extension CreateAnimationByLimit on SpriteSheet {
//   SpriteAnimation createAnimationByColumn({
//     required int column,
//     required double stepTime,
//     bool loop = true,
//     int from = 0,
//     int? to,
//   }) {

//     print(columns);

//     to ??= columns;
//     final spriteList = List<int>.generate(to - from, (i) => from + i)
//         .map((e) => getSprite(e, column))
//         .toList();
//     return SpriteAnimation.spriteList(
//       spriteList,
//       stepTime: stepTime,
//       loop: loop,
//     );
//   }
// }
