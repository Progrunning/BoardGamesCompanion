import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/base_board_game.dart';
import 'package:board_games_companion/widgets/common/rank_ribbon.dart';
import 'package:board_games_companion/widgets/common/stack_ripple_effect.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BoardGameCollectionItem extends StatefulWidget {
  final BaseBoardGame boardGame;
  final Future<void> Function() onTap;
  final String heroTag;

  BoardGameCollectionItem({
    Key key,
    this.boardGame,
    this.onTap,
    this.heroTag = AnimationTags.boardGameDetalsImageHeroTag,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BoardGameSearchItemWidget();
}

class _BoardGameSearchItemWidget extends State<BoardGameCollectionItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Hero(
          tag: "${widget.heroTag}${widget.boardGame.id}",
          child: CachedNetworkImage(
            imageUrl: widget.boardGame.thumbnailUrl ?? '',
            imageBuilder: (context, imageProvider) => Padding(
              padding: const EdgeInsets.only(
                right: Dimensions.halfStandardSpacing,
                bottom: Dimensions.halfStandardSpacing,
              ),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
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
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            // TODO Add shadow to the error state
            errorWidget: (context, url, error) => ClipRRect(
              borderRadius: AppTheme.defaultBoxRadius,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  image: DecorationImage(
                    alignment: Alignment.center,
                    image: AssetImage(
                      'assets/icons/logo.jpg',
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
                color: Theme.of(context)
                    .accentColor
                    .withAlpha(Styles.opacity70Percent),
                borderRadius: BorderRadius.all(
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
                  style: TextStyle(
                      color: AppTheme.defaultTextColor,
                      fontSize: Dimensions.smallFontSize),
                ),
              ),
            ),
          ),
        ),
        if (widget.boardGame.rank != null &&
            widget.boardGame.rank < Constants.Top100)
          Positioned(
            top: -Dimensions.halfStandardSpacing - 1,
            right: Dimensions.halfStandardSpacing,
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
