import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../common/animation_tags.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';
import '../../models/hive/base_board_game.dart';
import '../common/rank_ribbon.dart';
import '../common/stack_ripple_effect.dart';

class BoardGameTile extends StatefulWidget {
  const BoardGameTile({
    Key key,
    this.boardGame,
    this.onTap,
    this.heroTag = AnimationTags.boardGameDetalsImageHeroTag,
  }) : super(key: key);

  final BaseBoardGame boardGame;
  final Future<void> Function() onTap;
  final String heroTag;

  @override
  State<StatefulWidget> createState() => _BoardGameSearchItemWidget();
}

class _BoardGameSearchItemWidget extends State<BoardGameTile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Hero(
          tag: '${widget.heroTag}${widget.boardGame.id}',
          child: CachedNetworkImage(
            imageUrl: widget.boardGame.thumbnailUrl ?? '',
            imageBuilder: (context, imageProvider) => Padding(
              padding: const EdgeInsets.only(
                right: Dimensions.halfStandardSpacing,
                bottom: Dimensions.halfStandardSpacing,
              ),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: const <BoxShadow>[
                    AppTheme.defaultBoxShadow,
                  ],
                  borderRadius: AppTheme.defaultBoxRadius,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            fit: BoxFit.fitWidth,
            placeholder: (context, url) => Container(
              color: AppTheme.primaryColor,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            // TODO Add shadow to the error state
            errorWidget: (context, url, error) => ClipRRect(
              borderRadius: AppTheme.defaultBoxRadius,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  image: DecorationImage(
                    alignment: Alignment.center,
                    image: AssetImage(
                      'assets/icons/logo.png',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              bottom: Dimensions.standardSpacing,
              left: Dimensions.halfStandardSpacing,
              right: Dimensions.standardSpacing),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor.withAlpha(Styles.opacity70Percent),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    Styles.defaultCornerRadius,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
                child: Text(
                  widget.boardGame.name ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppTheme.defaultTextColor, fontSize: Dimensions.smallFontSize),
                ),
              ),
            ),
          ),
        ),
        if (widget.boardGame.rank != null && widget.boardGame.rank < Constants.Top100)
          Positioned(
            top: 0,
            right: 12,
            child: RankRibbon(widget.boardGame.rank),
          ),
        Positioned.fill(
          child: StackRippleEffect(
            onTap: () async {
              if (widget.onTap == null) {
                return;
              }

              await widget.onTap();
            },
          ),
        )
      ],
    );
  }
}
