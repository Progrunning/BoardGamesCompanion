import 'package:basics/basics.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../common/animation_tags.dart';
import '../../common/app_colors.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../common/rank_ribbon.dart';
import '../common/ripple_effect.dart';
import 'board_game_name.dart';

class BoardGameTile extends StatefulWidget {
  const BoardGameTile({
    Key? key,
    required this.id,
    required this.imageUrl,
    this.name,
    this.nameFontSize = Dimensions.smallFontSize,
    this.rank,
    this.onTap,
    this.heroTag = AnimationTags.boardGameHeroTag,
    this.elevation,
    this.borderRadius = AppTheme.defaultBorderRadius,
  }) : super(key: key);

  final String id;
  final String imageUrl;
  final String? name;
  final double nameFontSize;
  final int? rank;
  final Future<void> Function()? onTap;
  final String heroTag;
  final double? elevation;
  final BorderRadiusGeometry borderRadius;

  @override
  State<StatefulWidget> createState() => _BoardGameTileState();
}

class _BoardGameTileState extends State<BoardGameTile> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: widget.elevation ?? 0,
      borderRadius: widget.borderRadius,
      shadowColor: AppColors.primaryColor,
      child: Stack(
        children: <Widget>[
          if (widget.imageUrl.isNullOrBlank)
            _NoImage(borderRadius: widget.borderRadius)
          else
            Hero(
              tag: '${widget.heroTag}${widget.id}',
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: widget.borderRadius,
                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: widget.borderRadius,
                  ),
                ),
                errorWidget: (context, url, dynamic error) => _NoImage(
                  borderRadius: widget.borderRadius,
                ),
              ),
            ),
          if (widget.name.isNotNullOrBlank)
            Align(
              alignment: Alignment.bottomCenter,
              child: BoardGameName(name: widget.name!, fontSize: widget.nameFontSize),
            ),
          if (widget.rank != null && widget.rank! < Constants.top100)
            Positioned(top: 0, right: 12, child: RankRibbon(rank: widget.rank!)),
          Positioned.fill(
            child:
                RippleEffect(borderRadius: widget.borderRadius.resolve(null), onTap: widget.onTap),
          )
        ],
      ),
    );
  }
}

class _NoImage extends StatelessWidget {
  const _NoImage({
    Key? key,
    required this.borderRadius,
  }) : super(key: key);

  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: AppColors.primaryColor,
        image: const DecorationImage(
          alignment: Alignment.center,
          image: AssetImage('assets/icons/logo.png'),
        ),
      ),
    );
  }
}
