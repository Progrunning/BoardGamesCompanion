import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/pages/create_edit_player.dart';
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
}
