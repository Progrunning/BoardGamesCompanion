import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/utilities/navigator_helper.dart';
import 'package:board_games_companion/widgets/common/rank_ribbon.dart';
import 'package:board_games_companion/widgets/common/ripple_effect.dart';
import 'package:board_games_companion/widgets/common/shadow_box_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BoardGameSearchItemWidget extends StatefulWidget {
  final BoardGame boardGame;

  BoardGameSearchItemWidget({Key key, this.boardGame}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BoardGameSearchItemWidget();
}

class _BoardGameSearchItemWidget extends State<BoardGameSearchItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: widget.boardGame.thumbnailUrl,
          imageBuilder: (context, imageProvider) => Padding(
            padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [AppTheme.defaultBoxShadow],
                borderRadius: BorderRadius.all(
                    Radius.circular(Styles.boardGameTileImageCircularRadius)),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
          errorWidget: (context, url, error) => ShadowBox(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.standardSpacing),
              child: Container(
                child: Center(
                  child: Text(
                    widget.boardGame?.name ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              bottom: Dimensions.standardSpacing,
              left: Dimensions.standardSpacing,
              right: Dimensions.standardSpacing),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .accentColor
                    .withAlpha(Styles.opacity70Percent),
                borderRadius: BorderRadius.all(
                  Radius.circular(Styles.defaultCornerRadius),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
                child: Text(
                  widget.boardGame.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppTheme.defaultTextColor,
                      fontSize: Dimensions.smallFontSize),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: -1.5, // TODO MK Find out why there's a need for negative value
          right: Dimensions.halfStandardSpacing,
          child: RankRibbon(widget.boardGame.rank),
        ),
        Positioned.fill(child: StackRippleEffect(
          onTap: () {
            NavigatorHelper.navigateToBoardGameDetails(
              context,
              widget.boardGame,
            );
          },
        ))
      ],
    );
  }
}
