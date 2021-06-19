import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/analytics.dart';
import '../../common/dimensions.dart';
import '../../models/board_game.dart';
import '../../pages/search_board_games.dart';
import '../../services/analytics_service.dart';
import '../../stores/hot_board_games_store.dart';
import '../../utilities/navigator_helper.dart';
import '../board_games/board_game_collection_item_widget.dart';
import '../common/generic_error_message_widget.dart';
import '../common/icon_and_text_button.dart';
import '../common/loading_indicator_widget.dart';

class HotBoardGamesResults extends StatelessWidget {
  const HotBoardGamesResults({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _hotBoardGamesStore = Provider.of<HotBoardGamesStore>(
      context,
    );
    final _analytics = Provider.of<AnalyticsService>(
      context,
      listen: false,
    );

    return FutureBuilder(
      future: _hotBoardGamesStore.load(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data is List<BoardGame> &&
              (snapshot.data as List<BoardGame>).isNotEmpty) {
            return SliverPadding(
              padding: EdgeInsets.all(
                Dimensions.standardSpacing,
              ),
              sliver: SliverGrid.extent(
                crossAxisSpacing: Dimensions.standardSpacing,
                mainAxisSpacing: Dimensions.standardSpacing,
                maxCrossAxisExtent:
                    Dimensions.boardGameItemCollectionImageWidth,
                children: List.generate(
                  (snapshot.data as List<BoardGame>).length,
                  (int index) {
                    final BoardGame boardGame = snapshot.data[index];
                    return BoardGameCollectionItem(
                      boardGame: boardGame,
                      onTap: () async {
                        await _analytics.logEvent(
                          name: Analytics.ViewHotBoardGame,
                          parameters: {
                            Analytics.BoardGameIdParameter: boardGame.id,
                            Analytics.BoardGameNameParameter: boardGame.name,
                          },
                        );

                        await NavigatorHelper.navigateToBoardGameDetails(
                          context,
                          boardGame?.id,
                          boardGame?.name,
                          SearchBoardGamesPage,
                        );
                      },
                    );
                  },
                ),
              ),
            );
          }

          return SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(
                  Dimensions.doubleStandardSpacing,
                ),
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
                    SizedBox(
                      height: Dimensions.standardSpacing,
                    ),
                    IconAndTextButton(
                      icon: Icons.refresh,
                      title: 'Refresh',
                      onPressed: () async {
                        await _hotBoardGamesStore.refresh();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(
                Dimensions.doubleStandardSpacing,
              ),
              child: Center(
                child: GenericErrorMessage(),
              ),
            ),
          );
        }

        return SliverFillRemaining(
          child: LoadingIndicator(),
        );
      },
    );
  }
}
