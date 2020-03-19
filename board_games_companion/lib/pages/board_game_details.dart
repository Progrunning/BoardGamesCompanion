import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:board_games_companion/services/board_games_service.dart';
import 'package:board_games_companion/widgets/shadow_box_widget.dart';
import 'package:board_games_companion/widgets/star_rating_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class BoardGamesDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BoardGamesDetailsPage();
}

class _BoardGamesDetailsPage extends State<BoardGamesDetailsPage> {
  final BoardGamesGeekService _boardGamesGeekService = BoardGamesGeekService();
  final BoardGamesService _boardGamesService = BoardGamesService();

  final double _minImageHeight = 300;

  BoardGameDetails _boardGameDetails;
  bool _isRefreshing;

  @override
  Widget build(BuildContext context) {
    final BoardGame boardGameArgument =
        ModalRoute.of(context).settings.arguments;

    if (boardGameArgument?.name?.isEmpty ?? true) {
      return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
          child: Center(
              child: Text(
                  'Oops, something went wrong. Sorry, we couldn\'t show the details of selected board game')),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(boardGameArgument?.name ?? ''),
      ),
      body: FutureBuilder(
          future: _boardGamesGeekService.retrieveDetails(boardGameArgument?.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _isRefreshing = false;

              _boardGameDetails = snapshot.data as BoardGameDetails;
              if (_boardGameDetails != null) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: _boardGameDetails.imageUrl,
                            imageBuilder: (context, imageProvider) =>
                                _wrapInShadowBox(
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) => _wrapInShadowBox(
                                Center(child: CircularProgressIndicator())),
                            errorWidget: (context, url, error) =>
                                _wrapInShadowBox(
                              Padding(
                                padding: const EdgeInsets.all(
                                    Dimensions.standardSpacing),
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    _boardGameDetails?.name ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize:
                                            Dimensions.extraLargeFontSize),
                                  )),
                                ),
                              ),
                            ),
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
                                        (_boardGameDetails.rating ?? 0)
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
                        rating: _boardGameDetails.rating ?? 0,
                        color: Theme.of(context).accentColor,
                        size: 30,
                      ),
                      // TODO MK In case there's no categories this spacing shouldn't be applied
                      SizedBox(
                        height: Dimensions.standardSpacing,
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: Dimensions.standardSpacing,
                        alignment: WrapAlignment.spaceEvenly,
                        children: _boardGameDetails.categories
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
                          _boardGameDetails.description
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
                        setState(() {
                          _isRefreshing = true;
                        });
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
          await _boardGamesService.addOrUpdateBoardGame(_boardGameDetails);
          Navigator.popUntil(context, ModalRoute.withName(Routes.home));
        },
        tooltip: 'Add a board game',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _wrapInShadowBox(Widget content) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: _minImageHeight),
      child: ShadowBox(content),
    );
  }
}
