import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/board_game.dart';
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
    return CachedNetworkImage(
      imageUrl: widget.boardGame.thumbnailUrl,
      imageBuilder: (context, imageProvider) => _wrapInShadowBox(Padding(
        padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: imageProvider, fit: BoxFit.fitHeight))),
      )),
      fit: BoxFit.fitWidth,
      placeholder: (context, url) => _wrapInShadowBox(Placeholder()),
      errorWidget: (context, url, error) => _wrapInShadowBox(Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: Container(
            child: Center(
                child: Text(
              widget.boardGame?.name ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
            )),
          ))),
    );

    // return Card(child: searchItemWidget);
  }

  Widget _wrapInShadowBox(Widget content) {
    return Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Styles.defaultShadowColor,
              blurRadius: Styles.defaultShadowRadius)
        ]),
        child: content);
  }
}
