import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/stores/search_board_games_store.dart';
import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:board_games_companion/widgets/saerch_board_games/search_board_games_instructions_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaerchBoardGamesResults extends StatelessWidget {
  const SaerchBoardGamesResults({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchBoardGamesStore = Provider.of<SearchBoardGamesStore>(context);
    return FutureBuilder(
      future: searchBoardGamesStore.search(searchBoardGamesStore.searchPhrase),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final searchResults = snapshot.data as List<BoardGame>;
          if (searchResults?.isNotEmpty ?? false) {
            return SliverFixedExtentList(
              itemExtent: 50,
              delegate: SliverChildListDelegate(
                List.generate(
                  searchResults.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: Dimensions.halfStandardSpacing,
                        left: Dimensions.standardSpacing,
                        right: Dimensions.standardSpacing,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            searchResults[index].name,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.titleTextStyle,
                          ),
                          if (searchResults[index].yearPublished != null)
                            Text(
                              searchResults[index].yearPublished.toString(),
                              style: AppTheme.subTitleTextStyle,
                            ),
                          SizedBox(
                            height: Dimensions.halfStandardSpacing,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }

          return SliverPersistentHeader(
            delegate: SearchBoardGamesState(
              child: Text(
                  'To search for board games, please type a board game title in the above field.'),
            ),
          );
        } else if (snapshot.hasError) {
          return SliverPersistentHeader(
            delegate: SearchBoardGamesState(
              child: Padding(
                padding: const EdgeInsets.all(
                  Dimensions.doubleStandardSpacing,
                ),
                child: Center(
                  child: GenericErrorMessage(),
                ),
              ),
            ),
          );
        }

        return SliverPersistentHeader(
          delegate: SearchBoardGamesState(
            child: LoadingIndicator(),
          ),
        );
      },
    );
  }
}
