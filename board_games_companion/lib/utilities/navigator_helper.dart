import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/analytics.dart';
import '../models/hive/player.dart';
import '../pages/board_game_details/board_game_details_page.dart';
import '../pages/create_edit_player.dart';
import '../services/analytics_service.dart';
import '../services/board_games_geek_service.dart';
import '../stores/board_game_details_store.dart';
import '../stores/board_games_store.dart';
import '../stores/players_store.dart';
import 'navigator_transitions.dart';

class NavigatorHelper {
  static Future<T> navigateToCreatePlayerPage<T extends Object>(
    BuildContext context, {
    Player player,
  }) async {
    return await Navigator.push(
      context,
      NavigatorTransitions.fadeThrough(
        (_, __, ___) {
          final playerStore = Provider.of<PlayersStore>(
            context,
            listen: false,
          );
          playerStore.setPlayerToCreateOrEdit(player: player);

          return CreateEditPlayerPage(playerStore);
        },
      ),
    );
  }

  static Future<T> navigateToBoardGameDetails<T extends Object>(
    BuildContext context,
    String boardGameId,
    String boardGameName,
    Type navigatingFromType,
  ) async {
    final _analytics = Provider.of<AnalyticsService>(
      context,
      listen: false,
    );

    _analytics.logEvent(
      name: Analytics.ViewGameDetails,
      parameters: {
        Analytics.BoardGameIdParameter: boardGameId,
        Analytics.BoardGameNameParameter: boardGameName,
      },
    );

    return await Navigator.push(
      context,
      NavigatorTransitions.fadeScale(
        (_, __, ___) {
          final _boardGamesGeekService = Provider.of<BoardGamesGeekService>(
            context,
            listen: false,
          );
          final _boardGamesStore = Provider.of<BoardGamesStore>(
            context,
            listen: false,
          );
          final _boardGameDetailsStore =
              BoardGameDetailsStore(_boardGamesGeekService, _boardGamesStore);
          return BoardGamesDetailsPage(
            boardGameId: boardGameId,
            boardGameName: boardGameName,
            boardGameDetailsStore: _boardGameDetailsStore,
            navigatingFromType: navigatingFromType,
          );
        },
      ),
    );
  }
}
