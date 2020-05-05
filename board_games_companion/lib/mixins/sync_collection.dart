import 'package:board_games_companion/models/collection_sync_result.dart';
import 'package:board_games_companion/models/hive/user.dart';
import 'package:board_games_companion/pages/home.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin SyncCollection {
  Future<CollectionSyncResult> syncCollection(
    BuildContext context,
    String username,
  ) async {
    if (username?.isEmpty ?? true) {
      return CollectionSyncResult();
    }

    final boardGamesStore = Provider.of<BoardGamesStore>(
      context,
      listen: false,
    );
    final userStore = Provider.of<UserStore>(
      context,
      listen: false,
    );

    final syncResult = await boardGamesStore.syncCollection(username);
    if (syncResult?.isSuccess ?? false) {
      final user = User();
      user.name = username;
      await userStore?.addOrUpdateUser(user);
    } else {
      HomePage.homePageGlobalKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
              'Sorry, we ran into an issue when syncing your user, please try again.'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              HomePage.homePageGlobalKey.currentState.hideCurrentSnackBar();
            },
          ),
        ),
      );
    }

    return syncResult;
  }
}
