import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/widgets/common/ripple_effect.dart';
import 'package:board_games_companion/widgets/common/shadow_box_widget.dart';
import 'package:board_games_companion/widgets/player/player_avatar.dart';
import 'package:flutter/material.dart';

class PlayerGridItem extends StatelessWidget {
  final Player player;
  final Widget topRightCornerActionWidget;
  final GestureTapCallback onTap;

  const PlayerGridItem(
    this.player, {
    this.topRightCornerActionWidget,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
      child: ShadowBox(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Styles.defaultCornerRadius),
          child: Stack(
            children: <Widget>[
              Hero(
                tag: '${AnimationTags.playerImageHeroTag}${player?.id}',
                child: PlayerAvatar(
                  imageUri: player?.imageUri,
                ),
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
                          color: AppTheme.defaultTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (topRightCornerActionWidget != null)
                topRightCornerActionWidget,
              Positioned.fill(
                child: StackRippleEffect(
                  onTap: onTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}