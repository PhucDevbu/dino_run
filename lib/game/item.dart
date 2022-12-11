import 'package:dino_run/game/dino.dart';
import 'package:dino_run/models/item_data.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../models/player_data.dart';
import '/game/dino_run.dart';

class Item extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<DinoRun> {
  // The data required for creation of this enemy.
  final ItemData itemData;

  final PlayerData playerData;

  Item(this.itemData, this.playerData) {
    animation = SpriteAnimation.fromFrameData(
      itemData.image,
      SpriteAnimationData.sequenced(
        amount: itemData.nFrames,
        stepTime: itemData.stepTime,
        textureSize: itemData.textureSize,
      ),
    );
  }

  @override
  void onMount() {
    size *= 0.6;
    add(
      RectangleHitbox.relative(
        Vector2.all(0.8),
        parentSize: size,
        position: Vector2(size.x * 0.2, size.y * 0.2) / 2,
      ),
    );
    super.onMount();
  }

  @override
  void update(double dt) {
    position.x -= itemData.speedX * dt;

    // Remove the enemy and increase player score
    // by 1, if enemy has gone past left end of the screen.
    if (position.x < -itemData.textureSize.x) {
      removeFromParent();
    }

    super.update(dt);
  }



  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // Call hit only if other component is an Enemy and dino
    // is not already in hit state.
    if ((other is Dino) ) {
      removeFromParent();
      
      if(playerData.lives<5){
      playerData.lives += 1;
    }
    }
    super.onCollision(intersectionPoints, other);
  }
}