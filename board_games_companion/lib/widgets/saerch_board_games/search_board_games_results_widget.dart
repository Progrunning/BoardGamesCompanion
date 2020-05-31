import 'dart:math' as math;

import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/pages/search_board_games.dart';
import 'package:board_games_companion/stores/search_bar_board_games_store.dart';
import 'package:board_games_companion/stores/search_board_games_store.dart';
import 'package:board_games_companion/utilities/navigator_helper.dart';
import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:board_games_companion/widgets/common/rippler_effect.dart';
import 'package:board_games_companion/widgets/saerch_board_games/search_board_game_no_results_widget.dart';
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
    final searchBarBoardGamesStore = Provider.of<SearchBarBoardGamesStore>(
      context,
      listen: false,
    );
    return FutureBuilder(
      future: searchBoardGamesStore.search(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final searchResults = snapshot.data as List<BoardGame>;
          if (searchResults?.isNotEmpty ?? false) {
            return SliverPadding(
              padding: EdgeInsets.all(
                Dimensions.standardSpacing,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    final int itemIndex = index ~/ 2;
                    if (index.isEven) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(
                            Styles.defaultCornerRadius,
                          ),
                          boxShadow: [
                            AppTheme.defaultBoxShadow,
                          ],
                        ),
                        child: RippleEffect(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              Dimensions.standardSpacing,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  searchResults[itemIndex].name,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.titleTextStyle,
                                ),
                                if (searchResults[itemIndex].yearPublished !=
                                    null)
                                  Text(
                                    searchResults[itemIndex]
                                        .yearPublished
                                        .toString(),
                                    style: AppTheme.subTitleTextStyle,
                                  ),
                                SizedBox(
                                  height: Dimensions.halfStandardSpacing,
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            final boardGame = searchResults[itemIndex];
                            await NavigatorHelper.navigateToBoardGameDetails(
                              context,
                              boardGame?.id,
                              boardGame?.name,
                              SearchBoardGamesPage
                            );
                          },
                        ),
                      );
                    }

                    return Divider(
                      height: Dimensions.standardSpacing,
                    );
                  },
                  childCount: math.max(0, searchResults.length * 2 - 1),
                ),
              ),
            );
          }

          if (searchBarBoardGamesStore.searchPhrase?.isNotEmpty ?? false) {
            return SearchBoardGamesNoResults(
              searchBarBoardGamesStore: searchBarBoardGamesStore,
              searchBoardGamesStore: searchBoardGamesStore,
            );
          }

          return SliverPersistentHeader(
            delegate: SearchBoardGamesState(
              child: Text(
                'To search for board games, please type a board game title in the above search bar.',
              ),
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
