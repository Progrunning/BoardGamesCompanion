import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/player.dart';
import 'package:board_games_companion/widgets/custom_icon_button.dart';
import 'package:board_games_companion/widgets/icon_and_text_button.dart';
import 'package:board_games_companion/widgets/player_avatar.dart';
import 'package:board_games_companion/widgets/ripple_effect.dart';
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
        Align(
          alignment: Alignment.topRight,
          child: CustomIconButton(
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onTap: () async {
              await _navigateToCreateOrEditPlayer(context);
            },
          ),
        ),
        Positioned.fill(
          child: StackRippleEffect(
            onTap: () async {
              await _navigateToCreateOrEditPlayer(context);
            },
          ),
        ),
      ],
    );
  }

  Future _navigateToCreateOrEditPlayer(BuildContext context) async {
    await Navigator.pushNamed(context, Routes.createEditPlayer,
        arguments: player);
  }
}
