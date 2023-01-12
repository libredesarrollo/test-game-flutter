import 'package:flame/collisions.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'package:flame/flame.dart';
import 'package:flame/components.dart';

import 'dart:ui';

import 'package:flutter/services.dart';

class Character extends SpriteAnimationComponent
    with KeyboardHandler, CollisionCallbacks {
  int animationIndex = 0;

  double gravity = 9.8;
  Vector2 velocity = Vector2(0, 0);

  late double screenWidth, screenHeight, centerX, centerY;
  final double spriteSheetWidth = 680, spriteSheetHeight = 472;

  // int posX = 0, posY = 0;
  //double playerSpeed = 500;
  final double jumpForceUp = 360, jumpForceXY = 20, jumpForceSide = 100;

  bool inGround = false,
      jumpUp = false,
      right = true,
      collisionXRight = false,
      collisionXLeft = false;

  late SpriteAnimation deadAnimation,
      idleAnimation,
      jumpAnimation,
      runAnimation,
      walkAnimation,
      walkSlowAnimation;

  late RectangleHitbox foot, body;
}
