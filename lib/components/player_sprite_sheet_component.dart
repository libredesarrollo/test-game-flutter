import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:flutter/services.dart';

class PlayeSpriteSheetComponent extends SpriteAnimationComponent
    with KeyboardHandler, HasGameRef {
  late double screenWidth, screenHeight, centerX, centerY;
  final double spriteWidth = 512.0, spriteHeight = 512.0;

  late double spriteSheetWidth = 680.0, spriteSheetHeight = 472.0;

  // late SpriteAnimation dinoAnimation;

  late SpriteAnimation dinoIdleAnimation,
      dinoWalkAnimation,
      dinoDeadAnimation,
      dinoJumpAnimation,
      dinoRunAnimation;

  bool right = true;

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (keysPressed.isEmpty) {
      animation = dinoIdleAnimation;
    }

    print('aaa');

    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      position.y--;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS)) {
      position.y++;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      position.x += 5;
      // print(position.x);
      if (!right) flipHorizontally();
      right = true;
      animation = dinoWalkAnimation;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      position.x -= 5;
      if (right) flipHorizontally();
      right = false;
      animation = dinoWalkAnimation;
    }

    return true;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;

    centerX = (screenWidth / 2) - (spriteSheetWidth / 2);
    centerY = (screenHeight / 2) - (spriteSheetHeight / 2);

    var spriteImages = await Flame.images.load('dinofull.png');

    final spriteSheet = SpriteSheet(
        image: spriteImages,
        srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    //sprite = spriteSheet.getSprite(1, 1);
    // position = Vector2(centerX, centerY);

    final gameSize = gameRef.size;
    // To add a position component in the center of the screen for example:
    // (when the camera isn't moved)
    position = gameSize / 2;

    size = Vector2(spriteSheetWidth, spriteSheetHeight);

    //sprite = await Sprite.load('Sprite.png');

    // dinoAnimation =
    //     spriteSheet.createAnimationByColumn(column: 0, stepTime: 1, to: 4);

    // dinoAnimation = spriteSheet.createAnimationByLimit(
    //     xInit: 1, yInit: 1, xEnd: 2, yEnd: 1, stepTime: .08);

    dinoDeadAnimation = spriteSheet.createAnimationByLimit(
        xInit: 0, yInit: 0, step: 8, sizeX: 5, stepTime: .08);

    dinoIdleAnimation = spriteSheet.createAnimationByLimit(
        xInit: 1, yInit: 2, step: 11, sizeX: 5, stepTime: .08);

    dinoJumpAnimation = spriteSheet.createAnimationByLimit(
        xInit: 3, yInit: 0, step: 12, sizeX: 5, stepTime: .08);

    dinoRunAnimation = spriteSheet.createAnimationByLimit(
        xInit: 5, yInit: 0, step: 8, sizeX: 5, stepTime: .08);

    dinoWalkAnimation = spriteSheet.createAnimationByLimit(
        xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: .08);

    scale = Vector2.all(.2);
    anchor = Anchor.center;
    animation = dinoIdleAnimation;
  }

  // @override
  // void render(Canvas canvas) {
  //   canvas.drawRect(
  //       Rect.fromPoints(Offset(0, 0),
  //           Offset(centerX + spriteSheetWidth, centerX + spriteSheetHeight)),
  //       BasicPalette.red.paint());
  //   super.render(canvas);
  // }

  @override
  void update(double dt) {
    // position = Vector2(centerX++, centerY++);
    //angle += dt * 3;
    // flipVertically();

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
