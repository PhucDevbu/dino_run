import 'dart:math';

import 'package:dino_run/game/item.dart';
import 'package:dino_run/models/item_data.dart';
import 'package:flame/components.dart';

import '../models/player_data.dart';
import '/game/enemy.dart';
import '/game/dino_run.dart';
import '/models/enemy_data.dart';

// This class is responsible for spawning random enemies at certain
// interval of time depending upon players current score.
class ItemManager extends Component with HasGameRef<DinoRun> {
  // A list to hold data for all the enemies.
  final List<ItemData> _data = [];

  final Random _random = Random();

  final PlayerData playerData;
  // Timer to decide when to spawn next enemy.
  final Timer _timer = Timer(20, repeat: true);

  ItemManager(this.playerData) {
    _timer.onTick = spawnRandomItem;
  }

  // This method is responsible for spawning a random enemy.
  void spawnRandomItem() {
    /// Generate a random index within [_data] and get an [EnemyData].
    final randomIndex = _random.nextInt(_data.length);
    final itemData = _data.elementAt(randomIndex);
    final item = Item(itemData,playerData);

    // Help in setting all enemies on ground.
    item.anchor = Anchor.bottomLeft;
    item.position = Vector2(
      gameRef.size.x + 32,
      gameRef.size.y - 24,
    );

    // If this enemy can fly, set its y position randomly.
    if (itemData.canFly) {
      final newHeight = _random.nextDouble() * 2 * itemData.textureSize.y;
      item.position.y -= newHeight;
    }

    // Due to the size of our viewport, we can
    // use textureSize as size for the components.
    item.size = itemData.textureSize;
    gameRef.add(item);
  }

  @override
  void onMount() {
    if (isMounted) {
      removeFromParent();
    }

    // Don't fill list again and again on every mount.
    if (_data.isEmpty) {
      // As soon as this component is mounted, initilize all the data.
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
