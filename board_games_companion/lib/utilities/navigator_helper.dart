import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/analytics.dart';
import '../injectable.dart';
import '../models/hive/player.dart';
import '../pages/board_game_details/board_game_details_page.dart';
import '../pages/players/player_page.dart';
import '../pages/edit_playthrough/edit_playthrough_page.dart';
import '../pages/edit_playthrough/edit_playthrouhg_view_model.dart';
import '../services/analytics_service.dart';
import '../services/board_games_geek_service.dart';
import '../services/preferences_service.dart';
import '../stores/board_game_details_store.dart';
import '../stores/board_games_store.dart';
import '../stores/players_store.dart';
import '../stores/playthrough_store.dart';
import '../stores/playthroughs_store.dart';
import 'navigator_transitions.dart';

class NavigatorHelper {
  static Future<T> navigateToCreatePlayerPage<T extends Object>(
    BuildContext context, {
    Player player,
  }) async {
    return Navigator.push(
      context,
      NavigatorTransitions.fadeThrough(
        (_, __, ___) {
          final playersStore = getIt<PlayersStore>();
          playersStore.setPlayerToCreateOrEdit(player: player);

          return PlayerPage(playersStore: playersStore);
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
    final _analytics = getIt<AnalyticsService>();

    _analytics.logEvent(
      name: Analytics.ViewGameDetails,
      parameters: <String, String>{
        Analytics.BoardGameIdParameter: boardGameId,
        Analytics.BoardGameNameParameter: boardGameName,
      },
    );

    return Navigator.push(
      context,
      NavigatorTransitions.fadeScale(
        (_, __, ___) {
          final _boardGamesGeekService = getIt<BoardGamesGeekService>();
          final _preferencesService = getIt<PreferencesService>();
          final _boardGamesStore = Provider.of<BoardGamesStore>(
            context,
            listen: false,
          );
          final _boardGameDetailsStore = BoardGameDetailsStore(
            _boardGamesGeekService,
            _boardGamesStore,
            _analytics,
          );
          return BoardGamesDetailsPage(
            boardGameId: boardGameId,
            boardGameName: boardGameName,
            boardGameDetailsStore: _boardGameDetailsStore,
            navigatingFromType: navigatingFromType,
            preferencesService: _preferencesService,
          );
        },
      ),
    );
  }

  static Future<T> navigateToEditPlaythrough<T extends Object>(
    BuildContext context,
    PlaythroughStore playthroughStore,
  ) async {
    final analytics = getIt<AnalyticsService>();
    final playthroughsStore = getIt<PlaythroughsStore>();

    analytics.logEvent(
      name: Analytics.EditPlaythrough,
      parameters: <String, String>{
        Analytics.BoardGameIdParameter: playthroughStore.playthrough.boardGameId,
      },
    );

    return Navigator.push(
      context,
      NavigatorTransitions.fadeScale(
        (_, __, ___) {
          return EditPlaythoughPage(
            viewModel: EditPlaythoughViewModel(playthroughStore, playthroughsStore),
          );
        },
      ),
    );
  }
}
