import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/dimensions.dart';
import '../models/collection_sync_result.dart';
import '../models/hive/user.dart';
import '../pages/home_page.dart';
import '../stores/board_games_store.dart';
import '../stores/user_store.dart';

mixin SyncCollection {
  Future<CollectionSyncResult> syncCollection(BuildContext context, String username) async {
    final userStore = Provider.of<UserStore>(
      context,
      listen: false,
    );

    try {
      userStore.isSyncing = true;

      if (username.isEmpty) {
        return CollectionSyncResult();
      }

      final boardGamesStore = Provider.of<BoardGamesStore>(context, listen: false);
      final syncResult = await boardGamesStore.syncCollection(username);
      if (syncResult.isSuccess) {
        final user = User(name: username);
        await userStore.addOrUpdateUser(user);

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
  HomePage.homePageGlobalKey.currentState!.showSnackBar(
    const SnackBar(
      margin: Dimensions.snackbarMargin,
      behavior: SnackBarBehavior.floating,
      content: Text('Your collection is now in sync with BGG!'),
    ),
  );
}

void _showFailureSnackBar() {
  HomePage.homePageGlobalKey.currentState!.showSnackBar(
    const SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: Dimensions.snackbarMargin,
      content: Text(
        "Sorry, we've run into some problems with syncing your collection with BGG, please try again or contact support.",
      ),
      duration: Duration(seconds: 10),
    ),
  );
}
