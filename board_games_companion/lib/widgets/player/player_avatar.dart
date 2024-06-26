import 'package:flutter/material.dart';

import '../../common/animation_tags.dart';
import '../../common/app_styles.dart';
import '../../models/hive/player.dart';
import '../common/ripple_effect.dart';
import '../elevated_container.dart';
import 'player_avatar_subtitle_widget.dart';
import 'player_image.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    required this.player,
    required this.avatarImageSize,
    this.onTap,
    this.useHeroAnimation = true,
    this.playerHeroIdSuffix = '',
    super.key,
  });

  final Player? player;
  final VoidCallback? onTap;
  final bool useHeroAnimation;
  final String playerHeroIdSuffix;

  final Size avatarImageSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      elevation: AppStyles.defaultElevation,
      child: Stack(
        children: <Widget>[
          if (useHeroAnimation)
            Hero(
              tag: '${AnimationTags.playerImageHeroTag}${player?.id}$playerHeroIdSuffix',
              child: PlayerImage(
                imageUri: player?.avatarImageUri,
                avatarImageSize: avatarImageSize,
              ),
            )
          else
            PlayerImage(
              imageUri: player?.avatarImageUri,
              avatarImageSize: avatarImageSize,
            ),
          if (player?.name?.isNotEmpty ?? false) PlayerAvatarSubtitle(player: player!),
          Positioned.fill(
            child: RippleEffect(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
            ),
          ),
        ],
      ),
    );
  }
}
