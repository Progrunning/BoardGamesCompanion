import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/animation_tags.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';
import '../../models/hive/player.dart';
import '../common/shadow_box_widget.dart';
import '../common/stack_ripple_effect.dart';
import 'player_avatar.dart';
import 'player_avatar_subtitle_widget.dart';

class PlayerGridItem extends StatelessWidget {
  const PlayerGridItem(
    this.player, {
    this.topRightCornerActionWidget,
    this.onTap,
    Key key,
  }) : super(key: key);

  final Player player;
  final Widget topRightCornerActionWidget;
  final GestureTapCallback onTap;

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
                    if (topRightCornerActionWidget != null) topRightCornerActionWidget,
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
