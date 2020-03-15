import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:flutter/material.dart';

class BoardGamesDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BoardGamesDetailsPage();
}

class _BoardGamesDetailsPage extends State<BoardGamesDetailsPage> {
  final BoardGamesGeekService _boardGamesGeekService = BoardGamesGeekService();

  ImageState heroImageState = ImageState.None;
  Image heroImage;

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
            future:
                _boardGamesGeekService.retrieveDetails(boardGameArgument?.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                _isRefreshing = false;

                final boardGameDetails = snapshot.data as BoardGameDetails;
                if (boardGameDetails != null) {
                  _handleHeroImageLoading(boardGameDetails);
                  final heroImageWidget =
                      _retrieveHeroImageWidget(boardGameDetails);

                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        FittedBox(
                          fit: BoxFit.fill,
                          child: heroImageWidget,
                        ),
                        SizedBox(
                          height: Dimensions.standardSpacing,
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
                            boardGameDetails.description,
                            textAlign: TextAlign.justify,
                            style:
                                TextStyle(fontSize: Dimensions.mediumFontSize),
                          ),
                        )
                      ],
                    ),
                  );
                }

                return Padding(
                  padding:
                      const EdgeInsets.all(Dimensions.doubleStandardSpacing),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.standardSpacing),
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
            }));
  }

  void _handleHeroImageLoading(BoardGameDetails boardGameDetails) {
    if (heroImage != null) {
      return;
    }

    // TODO MK This needs to go into a seprate widget as it's refreshing API call
    if (!(boardGameDetails.imageUrl?.isEmpty ?? true)) {
      heroImage = Image.network(boardGameDetails.imageUrl);
      heroImage.image.resolve(ImageConfiguration()).addListener(
              ImageStreamListener((ImageInfo image, bool synchronousCall) {
            heroImageState = ImageState.Loaded;
            if (mounted) {
              setState(() {});
            }
          }, onError: ((dynamic asd, StackTrace stackTrace) {
            heroImageState = ImageState.Error;
            if (mounted) {
              setState(() {});
            }
          })));
    }
  }

  Widget _retrieveHeroImageWidget(BoardGameDetails boardGameDetails) {
    Widget heroImageWidget;
    switch (heroImageState) {
      case ImageState.None:
      case ImageState.Loading:
        heroImageWidget = Placeholder();
        break;
      case ImageState.Loaded:
        heroImageWidget = heroImage;
        break;
      case ImageState.Error:
        heroImageWidget = Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: Center(
              child: Text(boardGameDetails?.name ?? '',
                  textAlign: TextAlign.center)),
        );
        break;
      default:
    }

    return heroImageWidget;
  }
}
