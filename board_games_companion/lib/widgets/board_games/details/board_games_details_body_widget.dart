import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/stores/board_game_details_store.dart';
import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardGamesDetailsBody extends StatelessWidget {
  const BoardGamesDetailsBody({
    @required boardGameId,
    @required boardGameDetailsStore,
    Key key,
  })  : _boardGameId = boardGameId,
        _boardGameDetailsStore = boardGameDetailsStore,
        super(key: key);

  final String _boardGameId;
  final BoardGameDetailsStore _boardGameDetailsStore;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _boardGameDetailsStore.loadBoardGameDetails(_boardGameId),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return SliverFillRemaining(
              child: GenericErrorMessage(),
            );
          }

          return ChangeNotifierProvider<BoardGameDetailsStore>.value(
            value: _boardGameDetailsStore,
            child: Consumer<BoardGameDetailsStore>(
              builder: (_, store, __) {
                return SliverPadding(
                  padding: EdgeInsets.all(
                    Dimensions.standardSpacing,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed(
                      <Widget>[
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: Dimensions.standardSpacing,
                          alignment: WrapAlignment.spaceEvenly,
                          children: _boardGameDetailsStore
                              .boardGameDetails.categories
                              .map<Widget>((category) {
                            return Chip(
                              padding:
                                  EdgeInsets.all(Dimensions.standardSpacing),
                              label: Text(
                                category.name,
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: Dimensions.standardSpacing,
                        ),
                        Text(
                          store.boardGameDetails.description
                              .replaceAll('&#10;&#10;', "\n\n"),
                          textAlign: TextAlign.justify,
                          style:
                              TextStyle(fontSize: Dimensions.mediumFontSize),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return SliverFillRemaining(
            child: GenericErrorMessage(),
          );
        }

        return SliverFillRemaining(
          child: LoadingIndicator(),
        );
      },
    );
  }

  Future<void> _refreshBoardGameDetails(
    String boardGameDetailsId,
    BoardGameDetailsStore boardGameDetailsStore,
  ) async {
    await boardGameDetailsStore.loadBoardGameDetails(boardGameDetailsId);
  }
}
