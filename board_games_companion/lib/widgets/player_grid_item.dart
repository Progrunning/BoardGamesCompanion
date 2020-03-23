import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/player.dart';
import 'package:board_games_companion/widgets/player_avatar.dart';
import 'package:flutter/material.dart';

class PlayerGridItem extends StatelessWidget {
  final Player player;

  const PlayerGridItem(this.player, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PlayerAvatar(
          imageUri: player?.imageUri,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: Dimensions.halfStandardSpacing,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  const Radius.circular(Styles.defaultCornerRadius),
                ),
                color: Theme.of(context)
                    .accentColor
                    .withAlpha(Styles.opacity70Percent),
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                  Dimensions.halfStandardSpacing,
                ),
                child: Text(
                  player?.name ?? 'No Name?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
