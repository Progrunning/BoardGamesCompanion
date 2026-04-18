import 'package:flutter/material.dart';

import '../../common/animation_tags.dart';
import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../models/hive/player.dart';
import '../common/ripple_effect.dart';
import '../elevated_container.dart';
import 'player_avatar_subtitle_widget.dart';
import 'player_image.dart';
import 'player_initials.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    required this.player,
    this.onTap,
    this.onLongPress,
    this.playerHeroIdSuffix = '',
    super.key,
  });

  final Player player;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String playerHeroIdSuffix;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      elevation: AppStyles.defaultElevation,
      child: Stack(
        children: <Widget>[
          Hero(
            tag: '${AnimationTags.playerImageHeroTag}${player.id}$playerHeroIdSuffix',
            child: Positioned.fill(
              child: player.hasAvatarImage == true
                  ? PlayerImage(imageUri: player.avatarImageUri!)
                  : Material(
                      color: Color(
                        player.avatarColor ?? AppColors.defaultPlayerAvatarColorHexidecimal,
                      ),
                      borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
                      child: PlayerInitials(initials: player.initials ?? ''),
                    ),
            ),
          ),
          if (player.hasName) PlayerAvatarSubtitle(player: player),
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
