import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:testgame/components/background.dart';
import 'package:testgame/components/circle_position_component.dart';
import 'package:testgame/components/tiger.dart';
import 'components/player.dart';

void main() async {
  // Create an instance of the game
  final goldRush = GoldRush();

  // Setup Flutter widgets and start the game in full screen portrait orientation
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  // Run the app, passing the games widget here
  runApp(GameWidget(game: goldRush));
}

class GoldRush extends FlameGame
    with /*HasCollidables*/ HasCollisionDetection,
        TapDetector,
        /*KeyboardHandler,*/ KeyboardEvents,
        HasKeyboardHandlerComponents {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    //  add(Player());
    //add(Background());

    // add(
    //   KeyboardListenerComponent(
    //     keyDown: {
    //       LogicalKeyboardKey.arrowDown: (keysPressed) {
    //         return true;
    //       },
    //       LogicalKeyboardKey.arrowUp: (keysPressed) {
    //         return true;
    //       },
    //     },
    //     keyUp: {
    //       LogicalKeyboardKey.arrowDown: (keysPressed) {
    //         print('LogicalKeyboardKey.arrowDown');
    //         return true;
    //       },
    //       LogicalKeyboardKey.arrowUp: (keysPressed) {
    //         return true;
    //       },
    //     },
    //   ),
    // );
    // add(Player());
    add(CirclePositionComponent());
    // add(Tiger());
    // add(ScreenHitbox());
  }

  @override
  bool onTapDown(TapDownInfo info) {
    print("Player tap down on ${info.eventPosition.game}");
    return true;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    print("Player tap up on ${info.eventPosition.game}");
    return true;
  }

  // @override
  // bool onKeyEvent(
  //   RawKeyEvent event,
  //   Set<LogicalKeyboardKey> keysPressed,
  // ) {
  //   print('father');

  //   return true;
  // }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);

    final isKeyDown = event is RawKeyDownEvent;

    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);
    print(keysPressed);
    if (isSpace && isKeyDown) {
      if (keysPressed.contains(LogicalKeyboardKey.altLeft) ||
          keysPressed.contains(LogicalKeyboardKey.altRight)) {
        print(keysPressed);
      } else {
        print('otro');
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.handled;
  }
}
