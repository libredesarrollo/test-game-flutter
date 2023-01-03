import 'package:flame/collisions.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components.dart';

class Character extends SpriteAnimationComponent
    with KeyboardHandler, CollisionCallbacks {

  double gravity = 5;
  Vector2 velocity = Vector2(0, 0);

  late double screenWidth, screenHeight;
  final double spriteSheetWidth = 680, spriteSheetHeight = 472;
  int posX = 0, posY = 0;

  double playerSpeed = 500;
  final double jumpForce = 130;

  int animationIndex = 0;

  bool right = true,
      collisionXRight = false,
      collisionXLeft = false,
      inGround = false;

  late SpriteAnimation deadAnimation,
      idleAnimation,
      jumpAnimation,
      runAnimation,
      walkAnimation,
      walkSlowAnimation;
}


