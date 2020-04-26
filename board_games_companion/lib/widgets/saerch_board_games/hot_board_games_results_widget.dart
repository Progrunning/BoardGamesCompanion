import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/board_game.dart';
import 'package:board_games_companion/stores/hot_board_games_store.dart';
import 'package:board_games_companion/utilities/navigator_helper.dart';
import 'package:board_games_companion/widgets/board_games/board_game_collection_item_widget.dart';
import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HotBoardGamesResults extends StatelessWidget {
  const HotBoardGamesResults({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hotBoardGamesStore = Provider.of<HotBoardGamesStore>(
      context,
    );

    return FutureBuilder(
      future: hotBoardGamesStore.load(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data is List<BoardGame>) {
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
                    return BoardGameCollectionItem(
                      boardGame: snapshot.data[index],
                      onTap: () async {
                        await NavigatorHelper.navigateToBoardGameDetails(
                          context,
                          snapshot.data[index],
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
                    SizedBox(
                      height: Dimensions.standardSpacing,
                    ),
                    IconAndTextButton(
                      icon: Icons.refresh,
                      title: 'Refresh',
                      onPressed: () async {
                        await hotBoardGamesStore.refresh();
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
