import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

void main() async {
  runApp(GameWidget(game: MyCircle()));
}

class MyCircle with Game {
  double circlePos = 10;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // init
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
        Offset(circlePos, circlePos), 10, BasicPalette.red.paint());

    // canvas.drawRect(Rect.fromCircle(center: const Offset(0, 0), radius: 20),
    //     BasicPalette.red.paint());
  }

  @override
  void update(double dt) {
    circlePos++;
  }
}
