import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/pages/board_game_playthroughs.dart';
import 'package:board_games_companion/services/board_games_service.dart';
import 'package:board_games_companion/widgets/ripple_effect.dart';
import 'package:board_games_companion/widgets/star_rating_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:provider/provider.dart';

class BoardGameWidget extends StatefulWidget {
  final BoardGameDetails boardGameDetails;

  BoardGameWidget(this.boardGameDetails, {Key key}) : super(key: key);

  @override
  _BoardGameWidgetState createState() => _BoardGameWidgetState();
}

class _BoardGameWidgetState extends State<BoardGameWidget> {
  @override
  Widget build(BuildContext context) {
    final _boardGamesService = Provider.of<BoardGamesService>(context);

    return Dismissible(
      key: Key(widget.boardGameDetails.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: Dimensions.doubleStandardSpacing),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: Dimensions.boardGameRemoveIconSize,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) async {
        await _boardGamesService.removeBoardGame(widget.boardGameDetails.id);

        Scaffold.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 10),
            content: Text(
                "${widget.boardGameDetails.name} has been removed from your collection"),
            action: SnackBarAction(
              label: "Undo",
              onPressed: () async {
                // TODO MK Handle refresh of the board game collection
                await _boardGamesService
                    .addOrUpdateBoardGame(widget.boardGameDetails);
              },
            ),
          ),
        );
      },
      child: Card(
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: Dimensions.boardGameItemCollectionImageHeight,
                  width: Dimensions.boardGameItemCollectionImageWidth,
                  child: Stack(
                    children: <Widget>[
                      Hero(
                        tag:
                            "${AnimationTags.boardGameImageHeroTag}${widget.boardGameDetails.id}",
                        child: CachedNetworkImage(
                          imageUrl: widget.boardGameDetails.imageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                            child: Center(
                              child: Text(
                                widget.boardGameDetails?.name ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: Dimensions.extraLargeFontSize),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(
                            Dimensions.halfStandardSpacing),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: SizedBox(
                            height: Dimensions.boardGameHexagonSize,
                            width: Dimensions.boardGameHexagonSize,
                            child: ClipPolygon(
                              sides: Dimensions.edgeNumberOfHexagon,
                              child: Container(
                                color: Theme.of(context)
                                    .accentColor
                                    .withAlpha(Styles.opacity90Percent),
                                child: Center(
                                  child: Text(
                                    (widget.boardGameDetails.rating ?? 0)
                                        .toStringAsFixed(Constants
                                            .BoardGameRatingNumberOfDecimalPlaces),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Dimensions.smallFontSize),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.standardSpacing),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          widget.boardGameDetails?.name ?? '',
                          style: TextStyle(fontSize: Dimensions.largeFontSize),
                        ),
                        SizedBox(
                          height: Dimensions.halfStandardSpacing,
                        ),
                        StarRating(
                          rating: widget.boardGameDetails.rating ?? 0,
                          color: Theme.of(context).accentColor,
                        ),
                        SizedBox(
                          height: Dimensions.halfStandardSpacing,
                        ),
                        Text(
                          '${(widget.boardGameDetails.rating ?? 0).toStringAsFixed(Constants.BoardGameRatingNumberOfDecimalPlaces)} / ${widget.boardGameDetails.votes ?? 0}',
                          style: TextStyle(fontSize: Dimensions.smallFontSize),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned.fill(
              child: StackRippleEffect(
                onTap: () async {
                  await _navigateToGamesPlayedPage(widget.boardGameDetails);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToGamesPlayedPage(
      BoardGameDetails boardGameDetails) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return BoardGamePlaythroughsPage(boardGameDetails);
        },
      ),
    );
  }
}
