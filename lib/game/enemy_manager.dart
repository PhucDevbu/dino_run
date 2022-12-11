import 'dart:math';

import 'package:flame/components.dart';

import '../models/player_data.dart';
import '/game/enemy.dart';
import '/game/dino_run.dart';
import '/models/enemy_data.dart';

// This class is responsible for spawning random enemies at certain
// interval of time depending upon players current score.
class EnemyManager extends Component with HasGameRef<DinoRun> {
  // A list to hold data for all the enemies.
  final List<EnemyData> _data = [];

  // Random generator required for randomly selecting enemy type.
  final Random _random = Random();

  final PlayerData playerData;

  // Timer to decide when to spawn next enemy.
  Timer _timer= Timer(2, repeat: true);

  EnemyManager(this.playerData) {
    _timer.onTick = spawnRandomEnemy;
  }

  // This method is responsible for spawning a random enemy.
  void spawnRandomEnemy() {
    /// Generate a random index within [_data] and get an [EnemyData].
    final randomIndex = _random.nextInt(_data.length);
    final enemyData = _data.elementAt(randomIndex);
    final enemy = Enemy(enemyData);

    // Help in setting all enemies on ground.
    enemy.anchor = Anchor.bottomLeft;
    enemy.position = Vector2(
      gameRef.size.x + 32,
      gameRef.size.y - 24,
    );

    // If this enemy can fly, set its y position randomly.
    if (enemyData.canFly) {
      final newHeight = _random.nextDouble() * 2 * enemyData.textureSize.y;
      enemy.position.y -= newHeight;
    }

    // Due to the size of our viewport, we can
    // use textureSize as size for the components.
    enemy.size = enemyData.textureSize;
    gameRef.add(enemy);
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
        EnemyData(
          image: gameRef.images.fromCache('AngryPig/Walk (36x30).png'),
          nFrames: 16,
          stepTime: 0.1,
          textureSize: Vector2(36, 30),
          speedX: 80,
          canFly: false,
        ),
        EnemyData(
          image: gameRef.images.fromCache('BlueBird/Flying (32x32).png'),
          nFrames: 9,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          speedX: 100,
          canFly: true,
        ),
        EnemyData(
          image: gameRef.images.fromCache('Rino/Run (52x34).png'),
          nFrames: 6,
          stepTime: 0.09,
          textureSize: Vector2(52, 34),
          speedX: 150,
          canFly: false,
        ),
        EnemyData(
          image: gameRef.images.fromCache('Chicken/Run (32x34).png'),
          nFrames: 14,
          stepTime: 0.06,
          textureSize: Vector2(32, 34),
          speedX: 150,
          canFly: false,
        ),
        EnemyData(
          image: gameRef.images.fromCache('Ghost/Idle (44x30).png'),
          nFrames: 10,
          stepTime: 0.05,
          textureSize: Vector2(44, 30),
          speedX: 300,
          canFly: true,
        ),
        EnemyData(
          image: gameRef.images.fromCache('Slime/Idle-Run (44x30).png'),
          nFrames: 10,
          stepTime: 0.1,
          textureSize: Vector2(44, 30),
          speedX: 80,
          canFly: false,
        ),
      ]);
    }
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    //_timer = Timer(2*(1+playerData.currentScore*0.05), repeat: true);
    super.update(dt);
  }

  void removeAllEnemies() {
    final enemies = gameRef.children.whereType<Enemy>();
    for (var enemy in enemies) {
      enemy.removeFromParent();
    }
  }
}
