import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/pages/board_game_details.dart';
import 'package:board_games_companion/pages/create_edit_player.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:board_games_companion/stores/board_game_details_store.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:board_games_companion/utilities/navigator_transitions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
