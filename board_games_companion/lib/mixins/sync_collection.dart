import 'package:board_games_companion/models/collection_sync_result.dart';
import 'package:board_games_companion/models/hive/user.dart';
import 'package:board_games_companion/pages/home_page.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin SyncCollection {
  Future<CollectionSyncResult> syncCollection(
    BuildContext context,
    String username,
  ) async {
    final userStore = Provider.of<UserStore>(
      context,
      listen: false,
    );

    try {
      userStore.isSyncing = true;

      if (username?.isEmpty ?? true) {
        return CollectionSyncResult();
      }

      final boardGamesStore = Provider.of<BoardGamesStore>(
        context,
        listen: false,
      );

      final syncResult = await boardGamesStore.syncCollection(username);
      if (syncResult?.isSuccess ?? false) {
        final user = User();
        user.name = username;
        await userStore?.addOrUpdateUser(user);

        _showSuccessSnackBar();
      } else {
        _showFailureSnackBar();
      }

      return syncResult;
    } finally {
      userStore.isSyncing = false;
    }
  }
}

void _showSuccessSnackBar() {
  HomePage.homePageGlobalKey.currentState.showSnackBar(
    SnackBar(
      content: const Text(
        'Your collection is now in sync with BGG!',
      ),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          HomePage.homePageGlobalKey.currentState.hideCurrentSnackBar();
        },
      ),
    ),
  );
}

void _showFailureSnackBar() {
  HomePage.homePageGlobalKey.currentState.showSnackBar(
    SnackBar(
      content: const Text(
        "Sorry, we've run into some problems with syncing your collection with BGG, please try again or contact support.",
      ),
      duration: const Duration(seconds: 10),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          HomePage.homePageGlobalKey.currentState.hideCurrentSnackBar();
        },
      ),
    ),
  );
}
