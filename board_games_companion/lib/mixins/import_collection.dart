import 'package:board_games_companion/common/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/dimensions.dart';
import '../models/collection_import_result.dart';
import '../models/hive/user.dart';
import '../pages/home_page.dart';
import '../stores/board_games_store.dart';
import '../stores/user_store.dart';

mixin ImportCollection {
  Future<CollectionImportResult> importCollections(BuildContext context, String username) async {
    final userStore = Provider.of<UserStore>(
      context,
      listen: false,
    );

    if (username.isEmpty) {
      return CollectionImportResult();
    }

    final boardGamesStore = Provider.of<BoardGamesStore>(context, listen: false);
    final syncResult = await boardGamesStore.importCollections(username);
    if (syncResult.isSuccess) {
      final user = User(name: username);
      await userStore.addOrUpdateUser(user);

      _showSuccessSnackBar();
    } else {
      _showFailureSnackBar();
    }

    return syncResult;
  }
}

void _showSuccessSnackBar() {
  HomePage.homePageGlobalKey.currentState!.showSnackBar(
    const SnackBar(
      margin: Dimensions.snackbarMargin,
      behavior: SnackBarBehavior.floating,
      content: Text(AppText.importCollectionsSucceeded),
    ),
  );
}

void _showFailureSnackBar() {
  HomePage.homePageGlobalKey.currentState!.showSnackBar(
    const SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: Dimensions.snackbarMargin,
      content: Text(
        "Sorry, we've run into some problems with importing your collections from BGG. Please try again.",
      ),
      duration: Duration(seconds: 8),
    ),
  );
}
