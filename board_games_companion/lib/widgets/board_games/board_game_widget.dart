import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/pages/board_game_playthroughs.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/utilities/navigator_helper.dart';
import 'package:board_games_companion/widgets/common/ripple_effect.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:provider/provider.dart';

class BoardGameWidget extends StatelessWidget {
  BoardGameWidget({Key key}) : super(key: key);

  static const double _infoIconSize = 32;

  @override
  Widget build(BuildContext context) {
    final _boardGamesStore = Provider.of<BoardGamesStore>(context);
    final _boardGameDetails = Provider.of<BoardGameDetails>(context);

    return Dismissible(
      key: Key(_boardGameDetails.id),
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
        await _boardGamesStore.removeBoardGame(_boardGameDetails.id);

        Scaffold.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 10),
            content: Text(
                '${_boardGameDetails.name} has been removed from your collection'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                await _boardGamesStore.addOrUpdateBoardGame(_boardGameDetails);
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
                            "${AnimationTags.boardGameImageHeroTag}${_boardGameDetails.id}",
                        child: CachedNetworkImage(
                          imageUrl: _boardGameDetails.imageUrl,
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
                                _boardGameDetails.name ?? '',
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
                                    (_boardGameDetails.rating ?? 0)
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
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.halfStandardSpacing,
                      horizontal: Dimensions.standardSpacing,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '${_boardGameDetails?.name ?? ''} (${_boardGameDetails.yearPublished})',
                                style: TextStyle(
                                    fontSize: Dimensions.largeFontSize),
                              ),
                            ),
                            // MK Imitate info icon
                            SizedBox(
                              width: _infoIconSize +
                                  2 * Dimensions.halfStandardSpacing,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dimensions.halfStandardSpacing,
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
                  await _navigateToGamePlaythroughsPage(
                      context, _boardGameDetails);
                },
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(
                    Dimensions.halfStandardSpacing,
                  ),
                  child: InkWell(
                    child: Icon(
                      Icons.info,
                      size: _infoIconSize,
                      color: Theme.of(context).accentColor,
                    ),
                    onTap: () => _navigateToBoardGameDetails(
                      context,
                      _boardGameDetails,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _navigateToGamePlaythroughsPage(
  BuildContext context,
  BoardGameDetails boardGameDetails,
) async {
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

void _navigateToBoardGameDetails(
    BuildContext context, BoardGameDetails boardGameDetails) {
  NavigatorHelper.navigateToBoardGameDetails(
    context,
    boardGameDetails,
  );
}
