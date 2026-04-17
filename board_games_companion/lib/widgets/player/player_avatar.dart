import 'package:flutter/material.dart';

import '../../common/animation_tags.dart';
import '../../common/app_colors.dart';
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
    this.onLongPress,
    this.useHeroAnimation = true,
    this.playerHeroIdSuffix = '',
    super.key,
  });

  final Player? player;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
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
              child: Positioned.fill(
                child: player?.hasAvatarImage == true
                    ? PlayerImage(
                        imageUri: player?.avatarImageUri,
                        avatarImageSize: avatarImageSize,
                      )
                    : PlayerInitials(initials: player?.initials ?? ''),
              ),
            )
          else
            PlayerImage(
              imageUri: player?.avatarImageUri,
              avatarImageSize: avatarImageSize,
            ),
          if (player?.hasName ?? false) PlayerAvatarSubtitle(player: player!),
          Positioned.fill(
            child: GestureDetector(
              onLongPress: onLongPress,
              child: RippleEffect(
                onTap: onTap,
                borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerInitials extends StatelessWidget {
  const PlayerInitials({
    super.key,
    required this.initials,
  });

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Material(
      // TODO pick color at the moment of creating player and save it in the player object
      // TODO add color picker to player edit screen and allow changing it there, also add option to remove color (i.e. set it to null) and in that case show default avatar image instead of initials
      // TODO for users without color use default avatar image (i.e. make color nullable and if it's null show default avatar image instead of initials)
      color: Colors.blue,
      borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
      child: Center(
        child: Text(
          initials,
          // TODO Use a predefined text style
          style: const TextStyle(fontSize: 24, color: AppColors.defaultTextColor),
        ),
      ),
    );
  }
}
