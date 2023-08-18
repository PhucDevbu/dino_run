import 'package:dino_run/game/item_manager.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:hive/hive.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import '/game/dino.dart';
import '/widgets/hud.dart';
import '/models/settings.dart';
import '/game/audio_manager.dart';
import '/game/enemy_manager.dart';
import '/models/player_data.dart';
import '/widgets/pause_menu.dart';
import '/widgets/game_over_menu.dart';

// This is the main flame game class.
class DinoRun extends FlameGame with TapDetector, HasCollisionDetection {
  // List of all the image assets.
  static const _imageAssets = [
    'DinoSprites - vita.png',
    'DinoSprites - tard.png',
    'DinoSprites - doux.png',
    'DinoSprites - mort.png',
    'Rino/Run (52x34).png',
    'BlueBird/Flying (32x32).png',
    'Chicken/Run (32x34).png',
    'Ghost/Idle (44x30).png',
    'Slime/Idle-Run (44x30).png',
    'Skull/Orange Particle.png',
    'Sprite_heart.png',
    'Rocks/Rock1_Run (38x34).png',
    'Duck/Idle (36x36).png',
    'parallax/plx-1.png',
    'parallax/plx-2.png',
    'parallax/plx-3.png',
    'parallax/plx-4.png',
    'parallax/plx-5.png',
    'parallax/plx-6.png',
  ];

  // List of all the audio assets.
  static const _audioAssets = [
    '8BitPlatformerLoop.wav',
    'hurt7.wav',
    'jump14.wav',
  ];

  late Dino _dino;
  late Settings settings;
  late PlayerData playerData;
  late EnemyManager _enemyManager;
  late ItemManager _itemManager;

  @override
  Future<void> onLoad() async {
    playerData = await _readPlayerData();
    settings = await _readSettings();

    await AudioManager.instance.init(_audioAssets, settings);

    AudioManager.instance.startBgm('8BitPlatformerLoop.wav');

    await images.loadAll(_imageAssets);

    camera.viewport = FixedResolutionViewport(Vector2(360, 180));

    final parallaxBackground = await loadParallaxComponent(
      [
        ParallaxImageData('Background/parallax-forest-back-trees.png'),
        ParallaxImageData('Background/parallax-forest-front-trees.png'),
        ParallaxImageData('Background/parallax-forest-lights.png'),
        ParallaxImageData('Background/parallax-forest-middle-trees.png'),
        ParallaxImageData('parallax/plx-6.png'),
      ],
      baseVelocity: Vector2(25, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
    );
    add(parallaxBackground);

    return super.onLoad();
  }

  void startGamePlay() {
    if (playerData.dino == 'DinoSprites - mort.png') {
      playerData.lives = 5;
    } else if (playerData.dino == 'DinoSprites - tard.png') {
      playerData.lives = 1;
    } else {
      playerData.lives = 3;
    }
    _dino = Dino(images.fromCache(playerData.dino), playerData);
    _enemyManager = EnemyManager(playerData);
    _itemManager = ItemManager(playerData);

    add(_dino);
    add(_enemyManager);
    add(_itemManager);
  }

  void _disconnectActors() {
    _dino.removeFromParent();
    _enemyManager.removeAllEnemies();
    _enemyManager.removeFromParent();
    _itemManager.removeAllItems();
    _itemManager.removeFromParent();
  }

  void reset() {
    _disconnectActors();

    playerData.currentScore = 0;
    if (playerData.dino == 'DinoSprites - mort.png') {
      playerData.lives = 5;
    } else if (playerData.dino == 'DinoSprites - tard.png') {
      playerData.lives = 1;
    } else {
      playerData.lives = 3;
    }
  }

  @override
  void update(double dt) {
    if (playerData.lives <= 0) {
      overlays.add(GameOverMenu.id);
      overlays.remove(Hud.id);
      pauseEngine();
      AudioManager.instance.pauseBgm();
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (overlays.isActive(Hud.id)) {
      _dino.jump();
    }
    super.onTapDown(info);
  }

  Future<PlayerData> _readPlayerData() async {
    final playerDataBox =
        await Hive.openBox<PlayerData>('DinoRun.PlayerDataBox');
    final playerData = playerDataBox.get('DinoRun.PlayerData');

    if (playerData == null) {
      await playerDataBox.put('DinoRun.PlayerData', PlayerData());
    }

    return playerDataBox.get('DinoRun.PlayerData')!;
  }

  Future<Settings> _readSettings() async {
    final settingsBox = await Hive.openBox<Settings>('DinoRun.SettingsBox');
    final settings = settingsBox.get('DinoRun.Settings');

    if (settings == null) {
      await settingsBox.put(
        'DinoRun.Settings',
        Settings(bgm: true, sfx: true),
      );
    }

    return settingsBox.get('DinoRun.Settings')!;
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!(overlays.isActive(PauseMenu.id)) &&
            !(overlays.isActive(GameOverMenu.id))) {
          resumeEngine();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        if (overlays.isActive(Hud.id)) {
          overlays.remove(Hud.id);
          overlays.add(PauseMenu.id);
        }
        pauseEngine();
        break;
    }
    super.lifecycleStateChange(state);
  }
}
