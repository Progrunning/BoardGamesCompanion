import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:flutter/material.dart';

class PlayerAvatarSubtitle extends StatelessWidget {
  const PlayerAvatarSubtitle({
    Key key,
    @required this.player,
  }) : super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Align(
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
                color: AppTheme.defaultTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
