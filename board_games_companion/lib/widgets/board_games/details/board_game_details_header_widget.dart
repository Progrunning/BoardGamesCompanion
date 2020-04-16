import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/stores/board_game_details_store.dart';
import 'package:board_games_companion/widgets/board_games/board_game_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:provider/provider.dart';

class BoardGamesDetailsHeader extends StatelessWidget {
  const BoardGamesDetailsHeader({
    Key key,
    @required BoardGameDetailsStore boardGameDetailsStore,
    @required String boardGameName,
  })  : _boardGameDetailsStore = boardGameDetailsStore,
        _boardGameName = boardGameName,
        super(key: key);

  final String _boardGameName;
  final BoardGameDetailsStore _boardGameDetailsStore;

  static const double _headerHeight = 300;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      expandedHeight: _headerHeight,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withAlpha(Styles.opacity70Percent),
            borderRadius: BorderRadius.all(
              Radius.circular(Styles.defaultCornerRadius),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
            child: Text(
              _boardGameName ?? '',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: AppTheme.defaultTextColor,
                  fontSize: Dimensions.largeFontSize),
            ),
          ),
        ),
        background: ChangeNotifierProvider<BoardGameDetailsStore>.value(
          value: _boardGameDetailsStore,
          child: Consumer<BoardGameDetailsStore>(
            builder: (_, store, __) {
              return Stack(
                children: <Widget>[
                  BoardGameImage(
                    _boardGameDetailsStore.boardGameDetails,
                    minImageHeight: _headerHeight,
                  ),
                  if (_boardGameDetailsStore.boardGameDetails != null)
                    Padding(
                      padding: const EdgeInsets.all(Dimensions.standardSpacing),
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
                                  (_boardGameDetailsStore
                                              .boardGameDetails.rating ??
                                          0)
                                      .toStringAsFixed(Constants
                                          .BoardGameRatingNumberOfDecimalPlaces),
                                  style: TextStyle(
                                      color: AppTheme.defaultTextColor,
                                      fontSize:
                                          Dimensions.doubleExtraLargeFontSize),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
