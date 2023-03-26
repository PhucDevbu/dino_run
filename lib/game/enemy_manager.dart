import 'dart:math';

import 'package:flame/components.dart';

import '../models/player_data.dart';
import '/game/enemy.dart';
import '/game/dino_run.dart';
import '/models/enemy_data.dart';

class EnemyManager extends Component with HasGameRef<DinoRun> {
  final List<EnemyData> _data = [];

  int spawnLevel = 0;

  final Random _random = Random();

  final PlayerData playerData;

  Timer _timer = Timer(1, repeat: true);

  EnemyManager(this.playerData) {
    _timer = Timer(2 * (1 - playerData.currentScore * 0.05), repeat: true);
    _timer.onTick = spawnRandomEnemy;
  }

  void spawnRandomEnemy() {
    final randomIndex = _random.nextInt(_data.length);
    final enemyData = _data.elementAt(randomIndex);
    final enemy = Enemy(enemyData);

    enemy.anchor = Anchor.bottomLeft;
    enemy.position = Vector2(
      gameRef.size.x + 32,
      gameRef.size.y - 24,
    );

    if (enemyData.canFly) {
      final newHeight = _random.nextDouble() * 2 * enemyData.textureSize.y;
      enemy.position.y -= newHeight;
    }

    enemy.size = enemyData.textureSize;
    gameRef.add(enemy);
  }

  @override
  void onMount() {
    if (isMounted) {
      removeFromParent();
    }

    if (_data.isEmpty) {
      _data.addAll([
        EnemyData(
          image: gameRef.images.fromCache('Duck/Idle (36x36).png'),
          nFrames: 10,
          stepTime: 0.1,
          textureSize: Vector2(36, 36),
          speedX: 150,
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
          image: gameRef.images.fromCache('Rocks/Rock1_Run (38x34).png'),
          nFrames: 14,
          stepTime: 0.09,
          textureSize: Vector2(38, 34),
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
    super.update(dt);
  }

  void removeAllEnemies() {
    final enemies = gameRef.children.whereType<Enemy>();
    for (var enemy in enemies) {
      enemy.removeFromParent();
    }
  }
}
