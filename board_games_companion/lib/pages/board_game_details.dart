import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BoardGamesDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BoardGamesDetailsPage();
}

class _BoardGamesDetailsPage extends State<BoardGamesDetailsPage> {
  final BoardGamesGeekService _boardGamesGeekService = BoardGamesGeekService();

  final double _minImageHeight = 300;

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

              final boardGameDetails = snapshot.data as BoardGameDetails;
              if (boardGameDetails != null) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: boardGameDetails.imageUrl,
                        imageBuilder: (context, imageProvider) =>
                            _wrapInShadowBox(Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fitWidth)))),
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) => _wrapInShadowBox(
                            Center(child: CircularProgressIndicator())),
                        errorWidget: (context, url, error) => _wrapInShadowBox(
                            Padding(
                                padding: const EdgeInsets.all(
                                    Dimensions.standardSpacing),
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    boardGameDetails?.name ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize:
                                            Dimensions.extraLargeFontSize),
                                  )),
                                ))),
                      ),
                      SizedBox(
                        height: Dimensions.doubleStandardSpacing,
                      ),
                      SizedBox(
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: boardGameDetails.categories.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: Dimensions.standardSpacing),
                              child: Chip(
                                  padding: EdgeInsets.all(
                                      Dimensions.standardSpacing),
                                  label: Text(
                                    boardGameDetails.categories[index].name,
                                  )),
                            );
                          },
                        ),
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
        onPressed: () {

          // TODO MK Save board game to users collection
          Navigator.popUntil(context, (dynamic route) {
            if (route is MaterialPageRoute &&
                route.settings.name == Routes.home) {
              return true;
            }

            return false;
          });
        },
        tooltip: 'Add a board game',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _wrapInShadowBox(Widget content) {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: _minImageHeight),
        child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Styles.defaultShadowColor,
                  blurRadius: Styles.defaultShadowRadius)
            ]),
            child: content));
  }
}
