import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/app_text.dart';
import '../common/dimensions.dart';
import '../models/collection_import_result.dart';
import '../models/hive/user.dart';
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

    final messenger = ScaffoldMessenger.of(context);
    final boardGamesStore = Provider.of<BoardGamesStore>(context, listen: false);
    final importResult = await boardGamesStore.importCollections(username);
    if (importResult.isSuccess) {
      final user = User(name: username);
      await userStore.addOrUpdateUser(user);

      _showSuccessSnackBar(messenger);
    } else {
      _showFailureSnackBar(messenger);
    }

    return importResult;
  }
}

void _showSuccessSnackBar(ScaffoldMessengerState messenger) {
  // TODO MK Consider using a "global context" to show a snackbar in case a user switches between pages
  // https://stackoverflow.com/a/65607336/510627
  messenger.showSnackBar(
    const SnackBar(
      margin: Dimensions.snackbarMargin,
      behavior: SnackBarBehavior.floating,
      content: Text(AppText.importCollectionsSucceeded),
    ),
  );
}

void _showFailureSnackBar(ScaffoldMessengerState messenger) {
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: Dimensions.snackbarMargin,
      content: const Text(AppText.importCollectionsFailureMessage),
      duration: const Duration(seconds: 8),
      action: SnackBarAction(
        label: AppText.ok,
        onPressed: () {
          messenger.hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
        },
      ),
    ),
  );
}
