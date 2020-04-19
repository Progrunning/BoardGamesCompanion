import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/board_games/collection_empty_widget.dart';
import 'package:board_games_companion/widgets/board_games/collection_widget.dart';
import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:flutter/material.dart';

class CollectionsPage extends StatelessWidget {
  final BoardGamesStore _boardGamesStore;

  CollectionsPage(
    this._boardGamesStore, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_boardGamesStore.loadDataState == LoadDataState.Loaded) {
      if (_boardGamesStore.boardGames?.isEmpty ?? true) {
        return CollectionEmpty(
          boardGamesStore: _boardGamesStore,
        );
      }

      _boardGamesStore.boardGames.sort((a, b) => a.name?.compareTo(b.name));

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
