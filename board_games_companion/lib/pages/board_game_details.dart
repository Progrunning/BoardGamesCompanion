import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/board_games/board_game_image_widget.dart';
import 'package:board_games_companion/widgets/board_games/star_rating_widget.dart';
import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:provider/provider.dart';

class BoardGamesDetailsPage extends StatelessWidget {
  final String _boardGameId;
  final String _boardGameName;

  BoardGamesDetailsPage(this._boardGameId, this._boardGameName);

  @override
  Widget build(BuildContext context) {
    bool _isRefreshing;
    final _boardGamesGeekService = Provider.of<BoardGamesGeekService>(context);
    final _boardGamesStore = Provider.of<BoardGamesStore>(context);

    if (_boardGameId?.isEmpty ?? true) {
      return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
          child: Center(
            child: Text(
                'Oops, something went wrong. Sorry, we couldn\'t show the details of selected board game'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_boardGameName ?? ''),
      ),
      body: FutureBuilder(
          future: _boardGamesGeekService.retrieveDetails(_boardGameId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _isRefreshing = false;

              final boardGameDetails = snapshot.data as BoardGameDetails;
              if (boardGameDetails != null) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          BoardGameImage(
                            boardGameDetails: boardGameDetails,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.standardSpacing),
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
                                        (boardGameDetails.rating ?? 0)
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
                        rating: boardGameDetails.rating ?? 0,
                        color: Theme.of(context).accentColor,
                        size: 30,
                      ),
                      if (boardGameDetails.categories.isNotEmpty)
                        SizedBox(
                          height: Dimensions.standardSpacing,
                        ),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: Dimensions.standardSpacing,
                        alignment: WrapAlignment.spaceEvenly,
                        children: boardGameDetails.categories
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
                        padding:
                            const EdgeInsets.all(Dimensions.standardSpacing),
                        child: Text(
                          boardGameDetails.description
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
                      onPressed: () {
                        // TODO MK Use provider to handle state of this page
                        _isRefreshing = true;
                      },
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError && !_isRefreshing) {
              return Center(child: Text('Oops, something went wrong'));
            }

            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // TOOD MK Fix it
          // await _boardGamesStore.addOrUpdateBoardGame(boardGameDetails);
          Navigator.popUntil(context, ModalRoute.withName(Routes.home));
        },
        tooltip: 'Add a board game',
        child: Icon(Icons.add),
      ),
    );
  }
}
