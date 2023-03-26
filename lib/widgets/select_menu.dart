import 'dart:ui';

import 'package:dino_run/models/player_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/game/dino_run.dart';
import '/widgets/main_menu.dart';


class SelectMenu extends StatelessWidget {
  static const id = 'SelectMenu';


  final DinoRun gameRef;

  const SelectMenu(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gameRef.playerData,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.black.withAlpha(100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Selector<PlayerData, String>(
                        selector: (_, playerData) => playerData.dino,
                        builder: (context, dino, __) {
                          return SizedBox(
                            height: 250,
                            child: ListView(
                              children: [
                                ListTile(
                                  leading: Image.asset(
                                    "assets/images/DinoSprites_doux.gif",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                  title: const Text(
                                    'Khủng long xanh biển nghiêm túc',
                                  ),
                                  subtitle: const Text(
                                    'Bạn không có gì đặc biệt',
                                  ),
                                  textColor: Colors.white,
                                  onTap: () {
                                    Provider.of<PlayerData>(context,
                                            listen: false)
                                        .dino = 'DinoSprites - doux.png';
                                  },
                                  selected: dino == 'DinoSprites - doux.png',
                                ),
                                ListTile(
                                  leading: Image.asset(
                                    "assets/images/DinoSprites_mort.gif",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                  textColor: Colors.white,
                                  title: const Text(
                                    'Khủng long đỏ trâu bò',
                                  ),
                                  subtitle: const Text(
                                    'Bạn bắt đầu với nhiều mạng hơn',
                                  ),
                                  onTap: () {
                                    Provider.of<PlayerData>(context,
                                            listen: false)
                                        .dino = 'DinoSprites - mort.png';
                                  },
                                  selected: dino == 'DinoSprites - mort.png',
                                ),
                                ListTile(
                                  leading: Image.asset(
                                    "assets/images/DinoSprites_tard.gif",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                  textColor: Colors.white,
                                  title: const Text(
                                    'Khủng long vàng ngáo ngơ',
                                  ),
                                  subtitle: const Text(
                                    'Bạn bắt đầu với ít mạng hơn',
                                  ),
                                  onTap: () {
                                    Provider.of<PlayerData>(context,
                                            listen: false)
                                        .dino = 'DinoSprites - tard.png';
                                  },
                                  selected: dino == 'DinoSprites - tard.png',
                                ),
                                ListTile(
                                  leading: Image.asset(
                                    "assets/images/DinoSprites_vita.gif",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                  textColor: Colors.white,
                                  title: const Text(
                                    'Khủng long xanh lá nhảy cao',
                                  ),
                                  subtitle: const Text(
                                    'Bạn được nhảy cao hơn',
                                  ),
                                  onTap: () {
                                    Provider.of<PlayerData>(context,
                                            listen: false)
                                        .dino = 'DinoSprites - vita.png';
                                  },
                                  selected: dino == 'DinoSprites - vita.png',
                                ),
                              ],
                            ),
                          );
                        }),
                    TextButton(
                      onPressed: () {
                        gameRef.overlays.remove(SelectMenu.id);
                        gameRef.overlays.add(MainMenu.id);
                      },
                      child: const Icon(Icons.arrow_back_ios_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
