import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/analytics.dart';
import '../../common/animation_tags.dart';
import '../../common/dimensions.dart';
import '../../pages/board_game_playthroughs.dart';
import '../../services/analytics_service.dart';
import '../../stores/board_games_store.dart';
import '../../utilities/navigator_transitions.dart';
import 'board_game_collection_item_widget.dart';

class CollectionGrid extends StatelessWidget {
  const CollectionGrid({
    Key key,
    @required BoardGamesStore boardGamesStore,
  })  : _boardGamesStore = boardGamesStore,
        super(key: key);

  final BoardGamesStore _boardGamesStore;

  @override
  Widget build(BuildContext context) {
    final _analytics = Provider.of<AnalyticsService>(
      context,
      listen: false,
    );

    return SliverPadding(
      padding: EdgeInsets.all(
        Dimensions.standardSpacing,
      ),
      sliver: SliverGrid.extent(
        crossAxisSpacing: Dimensions.standardSpacing,
        mainAxisSpacing: Dimensions.standardSpacing,
        maxCrossAxisExtent: Dimensions.boardGameItemCollectionImageWidth,
        children: List.generate(
          _boardGamesStore.boardGames.length,
          (int index) {
            final boardGameDetails = _boardGamesStore.boardGames[index];

            return BoardGameCollectionItem(
              boardGame: boardGameDetails,
              onTap: () async {
                await _analytics.logEvent(
                  name: Analytics.ViewGameStats,
                  parameters: {
                    Analytics.BoardGameIdParameter: boardGameDetails.id,
                    Analytics.BoardGameNameParameter: boardGameDetails.name,
                  },
                );

                await Navigator.push(
                  context,
                  NavigatorTransitions.fadeThrough(
                    (_, __, ___) {
                      return BoardGamePlaythroughsPage(
                        _boardGamesStore.boardGames[index],
                      );
                    },
                  ),
                );
              },
              heroTag: AnimationTags.boardGamePlaythroughImageHeroTag,
            );
          },
        ),
      ),
    );
  }
}
