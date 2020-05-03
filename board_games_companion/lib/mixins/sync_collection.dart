import 'package:board_games_companion/models/hive/user.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin SyncCollection {
  Future<void> syncCollection(BuildContext context, String username) async {
    if (username?.isEmpty ?? true) {
      return;
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
    }
  }
}
