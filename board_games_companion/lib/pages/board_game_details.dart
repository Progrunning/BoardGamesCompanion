import 'package:async/async.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/stores/board_game_details_store.dart';
import 'package:board_games_companion/widgets/board_games/board_game_detail_floating_actions_widget.dart';
import 'package:board_games_companion/widgets/board_games/board_game_image_widget.dart';
import 'package:board_games_companion/widgets/board_games/star_rating_widget.dart';
import 'package:board_games_companion/widgets/common/custom_future_builder_widget.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:provider/provider.dart';

class BoardGamesDetailsPage extends StatelessWidget {
  final String _boardGameId;
  final String _boardGameName;
  final BoardGameDetailsStore _boardGameDetailsStore;

  final _loadBoardGameDetailsMemoizer = AsyncMemoizer<BoardGameDetails>();

  BoardGamesDetailsPage(
    this._boardGameDetailsStore,
    this._boardGameId,
    this._boardGameName,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BoardGameDetailsStore>.value(
      value: _boardGameDetailsStore,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_boardGameName ?? ''),
        ),
        body: ConsumerFutureBuilder<BoardGameDetails, BoardGameDetailsStore>(
          future: _loadBoardGameDetailsMemoizer.runOnce(
              () => _boardGameDetailsStore.loadBoardGameDetails(_boardGameId)),
          loading: (_) {
            return Center(
              child: LoadingIndicator(),
            );
          },
          success: (_, store) {
            if (store.boardGameDetails != null) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        BoardGameImage(
                          store.boardGameDetails,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.all(Dimensions.standardSpacing),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              height: Dimensions.boardGameDetailsHexagonSize,
                              width: Dimensions.boardGameDetailsHexagonSize,
                              child: ClipPolygon(
                                sides: Dimensions.edgeNumberOfHexagon,
                                child: Container(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withAlpha(Styles.opacity90Percent),
                                  child: Center(
                                    child: Text(
                                      (store.boardGameDetails.rating ?? 0)
                                          .toStringAsFixed(Constants
                                              .BoardGameRatingNumberOfDecimalPlaces),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimensions
                                              .doubleExtraLargeFontSize),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Dimensions.standardSpacing,
                    ),
                    StarRating(
                      rating: store.boardGameDetails.rating ?? 0,
                      color: Theme.of(context).accentColor,
                      size: 30,
                    ),
                    if (store.boardGameDetails.categories.isNotEmpty)
                      SizedBox(
                        height: Dimensions.standardSpacing,
                      ),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: Dimensions.standardSpacing,
                      alignment: WrapAlignment.spaceEvenly,
                      children: store.boardGameDetails.categories
                          .map<Widget>((category) {
                        return Chip(
                          padding: EdgeInsets.all(Dimensions.standardSpacing),
                          label: Text(
                            category.name,
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: Dimensions.standardSpacing,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: Dimensions.standardSpacing,
                        top: Dimensions.standardSpacing,
                        left: Dimensions.standardSpacing,
                        bottom: Dimensions.haldfloatingActionButtonBottomSpacing,
                      ),
                      child: Text(
                        store.boardGameDetails.description
                            .replaceAll('&#10;&#10;', "\n\n"),
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: Dimensions.mediumFontSize),
                      ),
                    )
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.standardSpacing),
                    child: Center(
                      child: Text(
                          'We couldn\'t retrieve any board games. Check your Internet connectivity and try again.'),
                    ),
                  ),
                  SizedBox(height: Dimensions.standardSpacing),
                  RaisedButton(
                    child: Text('Refresh'),
                    onPressed: () =>
                        _refreshBoardGameDetails(_boardGameId, store),
                  )
                ],
              ),
            );
          },
        ),
        floatingActionButton: BoardGameDetailFloatingActions(),
      ),
    );
  }

  Future<void> _refreshBoardGameDetails(
    String boardGameDetailsId,
    BoardGameDetailsStore boardGameDetailsStore,
  ) async {
    await boardGameDetailsStore.loadBoardGameDetails(boardGameDetailsId);
  }
}
