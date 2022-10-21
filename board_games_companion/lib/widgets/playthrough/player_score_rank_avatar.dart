import 'package:flutter/material.dart';

import '../../common/dimensions.dart';
import '../../models/hive/player.dart';
import '../common/tile_positioned_rank_ribbon.dart';
import '../player/player_avatar.dart';

class PlayerScoreRankAvatar extends StatelessWidget {
  const PlayerScoreRankAvatar({
    required this.player,
    this.playerHeroIdSuffix = '',
    this.rank,
    this.score,
    this.useHeroAnimation = true,
    Key? key,
  }) : super(key: key);

  final Player? player;
  final String playerHeroIdSuffix;
  final num? rank;
  final String? score;
  final bool useHeroAnimation;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: Dimensions.smallPlayerAvatarSize,
          width: Dimensions.smallPlayerAvatarSize,
          child: Stack(
            children: [
              PlayerAvatar(
                player,
                playerHeroIdSuffix: playerHeroIdSuffix,
                useHeroAnimation: useHeroAnimation,
              ),
              if (rank != null) PositionedTileRankRibbon(rank: rank!),
            ],
          ),
        ),
        const SizedBox(height: Dimensions.standardSpacing),
        Text(
          score ?? '-',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Dimensions.doubleExtraLargeFontSize,
          ),
        ),
      ],
    );
  }
}
