import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:flame_tiled/flame_tiled.dart';
import 'package:testgame/components/ground.dart';

import 'package:tiled/tiled.dart';

class TileMapComponent extends PositionComponent {
  late TiledComponent tiledMap;

  @override
  Future<void>? onLoad() async {
    tiledMap = await TiledComponent.load('map.tmx', Vector2.all(32));
    add(tiledMap);

    final objGroup = tiledMap.tileMap.getLayer<ObjectGroup>("ground");

    for (final obj in objGroup!.objects) {
      print(obj.x);
      print(obj.x);
      print(obj.x);
      print(obj.x);

      add(Ground(size: Vector2(obj.width, 1), position: Vector2(obj.x, obj.y)));
    }

    // List<Offset> barrierOffsets = [];
    // final water = tiledMap.tileMap.getObjectGroupFromLayer('Water');
    // water.objects.forEach((rect) {
    //   if (rect.width == 32 && rect.height == 32) {
    //     barrierOffsets.add(worldToGridOffset(Vector2(rect.x, rect.y)));
    //   }
    //   add(Water(
    //       position: Vector2(
    //           rect.x + gameScreenBounds.left, rect.y + gameScreenBounds.top),
    //       size: Vector2(rect.width, rect.height),
    //       id: rect.id));
    // });

    return super.onLoad();
  }
}
