import 'package:board_games_companion/common/enums/enums.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/stores/user_store.dart';
import 'package:board_games_companion/widgets/board_games/collection_empty_widget.dart';
import 'package:board_games_companion/widgets/board_games/collection_widget.dart';
import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:flutter/material.dart';

class CollectionsPage extends StatelessWidget {
  final BoardGamesStore _boardGamesStore;
  final UserStore _userStore;

  CollectionsPage(
    this._boardGamesStore,
    this._userStore, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_boardGamesStore.loadDataState == LoadDataState.Loaded) {
      if (!_boardGamesStore.hasBoardGames &&
          (_userStore.user?.name?.isEmpty ?? true)) {
        return CollectionEmpty();
      }

      return Collection(
        boardGamesStore: _boardGamesStore,
      );
    } else if (_boardGamesStore.loadDataState == LoadDataState.Error) {
      return Center(
        child: GenericErrorMessage(),
      );
    }

    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
