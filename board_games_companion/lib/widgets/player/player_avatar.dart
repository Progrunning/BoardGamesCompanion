import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/animation_tags.dart';
import '../../models/hive/player.dart';
import '../common/shadow_box.dart';
import '../common/stack_ripple_effect.dart';
import 'player_avatar_subtitle_widget.dart';
import 'player_image.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar(
    this.player, {
    this.topRightCornerActionWidget,
    this.onTap,
    Key key,
  }) : super(key: key);

  final Player player;
  final Widget topRightCornerActionWidget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: player,
      child: Consumer<Player>(
        builder: (_, Player providerPlayer, __) {
          return ShadowBox(
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: '${AnimationTags.playerImageHeroTag}${providerPlayer?.id}',
                  child: PlayerImage(
                    imageUri: providerPlayer?.avatarImageUri,
                  ),
                ),
                if (providerPlayer?.name?.isNotEmpty ?? false)
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
            ),
          );
        },
      ),
    );
  }
}
