import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/services/board_games_service.dart';
import 'package:board_games_companion/widgets/star_rating_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BoardGameWidget extends StatefulWidget {
  final BoardGameDetails boardGameDetails;

  BoardGameWidget({Key key, this.boardGameDetails}) : super(key: key);

  @override
  _BoardGameWidgetState createState() => _BoardGameWidgetState();
}

class _BoardGameWidgetState extends State<BoardGameWidget> {
  final BoardGamesService _boardGamesService = BoardGamesService();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.boardGameDetails.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: Dimensions.standardSpacing),
        color: Colors.red,
        child: Icon(
          Icons.delete,
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
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: Dimensions.boardGameItemCollectionImageHeight,
              width: Dimensions.boardGameItemCollectionImageWidth,
              child: CachedNetworkImage(
                imageUrl: widget.boardGameDetails.imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image:
                        DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  ),
                ),
                fit: BoxFit.fitWidth,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Container(
                  child: Center(
                    child: Text(
                      widget.boardGameDetails?.name ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
                    ),
                  ),
                ),
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
                      '${(widget.boardGameDetails.rating ?? 0).toStringAsFixed(
                          Constants.BoardGameRatingNumberOfDecimalPlaces)} / ${widget.boardGameDetails.votes ?? 0}',
                      style: TextStyle(fontSize: Dimensions.smallFontSize),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
