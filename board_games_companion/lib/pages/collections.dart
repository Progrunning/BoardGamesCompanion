import 'package:flutter/material.dart';

import '../common/enums/enums.dart';
import '../stores/board_games_store.dart';
import '../stores/user_store.dart';
import '../widgets/board_games/collection_empty_widget.dart';
import '../widgets/board_games/collection_widget.dart';
import '../widgets/common/generic_error_message_widget.dart';

class CollectionsPage extends StatefulWidget {
  final BoardGamesStore boardGamesStore;
  final UserStore userStore;

  const CollectionsPage(
    this.boardGamesStore,
    this.userStore, {
    Key key,
  }) : super(key: key);

  @override
  _CollectionsPageState createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.boardGamesStore.loadDataState == LoadDataState.Loaded) {
      if (!widget.boardGamesStore.hasBoardGames &&
          (widget.userStore.user?.name?.isEmpty ?? true)) {
        return CollectionEmpty();
      }

      return Collection(
        boardGamesStore: widget.boardGamesStore,
      );
    } else if (widget.boardGamesStore.loadDataState == LoadDataState.Error) {
      return Center(
        child: GenericErrorMessage(),
      );
    }

    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
