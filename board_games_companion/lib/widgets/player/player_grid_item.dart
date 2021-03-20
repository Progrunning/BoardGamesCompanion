import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/widgets/common/shadow_box_widget.dart';
import 'package:board_games_companion/widgets/common/stack_ripple_effect.dart';
import 'package:board_games_companion/widgets/player/player_avatar.dart';
import 'package:board_games_companion/widgets/player/player_avatar_subtitle_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          child: ChangeNotifierProvider.value(
            value: player,
            child: Consumer<Player>(
              builder: (_, Player providerPlayer, __) {
                return Stack(
                  children: <Widget>[
                    Hero(
                      tag: '${AnimationTags.playerImageHeroTag}${providerPlayer?.id}',
                      child: PlayerAvatar(
                        imageUri: providerPlayer?.avatarImageUri,
                      ),
                    ),
                    PlayerAvatarSubtitle(
                      player: providerPlayer,
                    ),
                    if (topRightCornerActionWidget != null)
                      topRightCornerActionWidget,
                    Positioned.fill(
                      child: StackRippleEffect(
                        onTap: onTap,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
