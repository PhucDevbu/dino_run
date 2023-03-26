import 'dart:math';

import 'package:dino_run/game/item.dart';
import 'package:dino_run/models/item_data.dart';
import 'package:flame/components.dart';

import '../models/player_data.dart';
import '/game/dino_run.dart';

class ItemManager extends Component with HasGameRef<DinoRun> {
  final List<ItemData> _data = [];

  final Random _random = Random();

  final PlayerData playerData;

  final Timer _timer = Timer(20, repeat: true);

  ItemManager(this.playerData) {
    _timer.onTick = spawnRandomItem;
  }

  void spawnRandomItem() {
    final randomIndex = _random.nextInt(_data.length);
    final itemData = _data.elementAt(randomIndex);
    final item = Item(itemData, playerData);

    item.anchor = Anchor.bottomLeft;
    item.position = Vector2(
      gameRef.size.x + 32,
      gameRef.size.y - 24,
    );

    if (itemData.canFly) {
      final newHeight = _random.nextDouble() * 2 * itemData.textureSize.y;
      item.position.y -= newHeight;
    }

    item.size = itemData.textureSize;
    gameRef.add(item);
  }

  @override
  void onMount() {
    if (isMounted) {
      removeFromParent();
    }

    if (_data.isEmpty) {
      _data.addAll([
        ItemData(
          image: gameRef.images.fromCache('Sprite_heart.png'),
          nFrames: 1,
          stepTime: 1,
          textureSize: Vector2(16, 16),
          speedX: 200,
          canFly: true,
        ),
      ]);
    }
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }

  void removeAllItems() {
    final items = gameRef.children.whereType<Item>();
    for (var item in items) {
      item.removeFromParent();
    }
  }
}
