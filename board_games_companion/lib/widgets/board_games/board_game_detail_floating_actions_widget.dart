import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../stores/board_game_details_in_collection_store.dart';
import '../../stores/board_game_details_store.dart';
import '../../stores/board_games_store.dart';
import '../common/default_icon.dart';
import '../common/icon_and_text_button.dart';

class BoardGameDetailFloatingActions extends StatelessWidget {
  const BoardGameDetailFloatingActions({
    @required this.boardGameDetailsStore,
    Key key,
  }) : super(key: key);

  final BoardGameDetailsStore boardGameDetailsStore;

  @override
  Widget build(BuildContext context) {
    final boardGamesStore = Provider.of<BoardGamesStore>(
      context,
      listen: false,
    );

    return ChangeNotifierProvider.value(
      value: boardGameDetailsStore,
      child: ChangeNotifierProxyProvider<BoardGameDetailsStore, BoardGameDetailsInCollectionStore>(
        create: (_) {
          return BoardGameDetailsInCollectionStore(
            boardGamesStore,
            boardGameDetailsStore?.boardGameDetails,
          );
        },
        update: (_, boardGameDetailsStore, boardGameDetailsInCollectionStore) {
          boardGameDetailsInCollectionStore.updateIsInCollectionStatus(
            boardGameDetailsStore.boardGameDetails,
          );
          return boardGameDetailsInCollectionStore;
        },
        child: Consumer2<BoardGameDetailsInCollectionStore, BoardGameDetailsStore>(
          builder: (
            _,
            boardGameDetailsInCollectionStore,
            boardGameDetailsStore,
            __,
          ) {
            if (boardGameDetailsStore.boardGameDetails == null) {
              return Container();
            }
            if (boardGameDetailsInCollectionStore.isInCollection) {
              return IconAndTextButton(
                onPressed: () => _removeBoardGameFromCollection(
                  context,
                  boardGameDetailsInCollectionStore,
                  boardGamesStore,
                ),
                icon: const DefaultIcon(Icons.remove_circle_outline),
                color: Colors.red,
              );
            } else {
              return IconAndTextButton(
                onPressed: () => _addBoardGameToCollection(
                  boardGameDetailsInCollectionStore,
                  boardGamesStore,
                  context,
                ),
                icon: const DefaultIcon(Icons.add),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _addBoardGameToCollection(
    BoardGameDetailsInCollectionStore boardGameDetailsInCollectionStore,
    BoardGamesStore boardGamesStore,
    BuildContext context,
  ) async {
    await boardGamesStore.addOrUpdateBoardGame(boardGameDetailsStore.boardGameDetails);
    boardGameDetailsInCollectionStore.updateIsInCollectionStatus();

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${boardGameDetailsStore.boardGameDetails.name} has been added to your collection'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () async {
            Scaffold.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  Future<void> _removeBoardGameFromCollection(
    BuildContext context,
    BoardGameDetailsInCollectionStore boardGameDetailsInCollectionStore,
    BoardGamesStore boardGamesStore,
  ) async {
    await boardGamesStore.removeBoardGame(boardGameDetailsStore.boardGameDetails.id);
    boardGameDetailsInCollectionStore.updateIsInCollectionStatus();

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        content: Text(
            '${boardGameDetailsStore.boardGameDetails.name} has been removed from your collection'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            await boardGamesStore.addOrUpdateBoardGame(boardGameDetailsStore.boardGameDetails);
            boardGameDetailsInCollectionStore.updateIsInCollectionStatus();
          },
        ),
      ),
    );
  }
}
