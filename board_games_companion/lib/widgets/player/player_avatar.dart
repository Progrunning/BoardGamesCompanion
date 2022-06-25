import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/animation_tags.dart';
import '../../common/styles.dart';
import '../../models/hive/player.dart';
import '../common/ripple_effect.dart';
import '../common/shadow_box.dart';
import 'player_avatar_subtitle_widget.dart';
import 'player_image.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar(
    this.player, {
    this.topRightCornerActionWidget,
    this.onTap,
    this.useHeroAnimation = true,
    this.playerHeroIdSuffix = '',
    Key? key,
  }) : super(key: key);

  final Player? player;
  final Widget? topRightCornerActionWidget;
  final VoidCallback? onTap;
  final bool useHeroAnimation;
  final String playerHeroIdSuffix;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: player,
      child: Consumer<Player?>(
        builder: (_, Player? player, __) {
          return ShadowBox(
            child: Stack(
              children: <Widget>[
                if (useHeroAnimation)
                  Hero(
                    tag: '${AnimationTags.playerImageHeroTag}${player?.id}$playerHeroIdSuffix',
                    child: PlayerImage(imageUri: player?.avatarImageUri),
                  )
                else
                  PlayerImage(imageUri: player?.avatarImageUri),
                if (player?.name?.isNotEmpty ?? false) PlayerAvatarSubtitle(player: player!),
                if (topRightCornerActionWidget != null)
                  Align(alignment: Alignment.topRight, child: topRightCornerActionWidget),
                Positioned.fill(
                  child: RippleEffect(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(Styles.defaultCornerRadius),
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
