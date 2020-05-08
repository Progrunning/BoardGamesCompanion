import 'package:board_games_companion/stores/board_game_details_in_collection_store.dart';
import 'package:board_games_companion/stores/board_game_details_store.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardGameDetailFloatingActions extends StatelessWidget {
  const BoardGameDetailFloatingActions({
    @required boardGameDetailsStore,
    Key key,
  })  : _boardGameDetailsStore = boardGameDetailsStore,
        super(key: key);

  final BoardGameDetailsStore _boardGameDetailsStore;

  @override
  Widget build(BuildContext context) {
    final boardGamesStore = Provider.of<BoardGamesStore>(
      context,
      listen: false,
    );

    return ChangeNotifierProvider.value(
      value: _boardGameDetailsStore,
      child: ChangeNotifierProxyProvider<BoardGameDetailsStore,
          BoardGameDetailsInCollectionStore>(
        create: (_) {
          return BoardGameDetailsInCollectionStore(
            boardGamesStore,
            _boardGameDetailsStore?.boardGameDetails,
          );
        },
        update: (_, boardGameDetailsStore, boardGameDetailsInCollectionStore) {
          boardGameDetailsInCollectionStore.updateIsInCollectionStatus(
              boardGameDetailsStore.boardGameDetails);
          return boardGameDetailsInCollectionStore;
        },
        child: Consumer<BoardGameDetailsInCollectionStore>(
          builder: (_, boardGameDetailsInCollectionStore, __) {
            if (boardGameDetailsInCollectionStore.isInCollection) {
              return IconAndTextButton(
                // TODO When navigated from the playthroughs, and going back after removing from collection user should be taken to the home page
                onPressed: () => _removeBoardGameFromCollection(
                  boardGameDetailsInCollectionStore,
                  boardGamesStore,
                  context,
                ),
                // TODO Add confirmation when removing from collection
                title: 'Remove',
                icon: Icons.remove_circle,
                backgroundColor: Colors.red,
              );
            } else {
              return IconAndTextButton(
                onPressed: () => _addBoardGameToCollection(
                  boardGameDetailsInCollectionStore,
                  boardGamesStore,
                  context,
                ),
                title: 'Add to Collection',
                icon: Icons.add,
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
    await boardGamesStore
        .addOrUpdateBoardGame(_boardGameDetailsStore.boardGameDetails);
    boardGameDetailsInCollectionStore.updateIsInCollectionStatus();
  }

  Future<void> _removeBoardGameFromCollection(
    BoardGameDetailsInCollectionStore boardGameDetailsInCollectionStore,
    BoardGamesStore boardGamesStore,
    BuildContext context,
  ) async {
    await boardGamesStore.removeBoardGame(
      _boardGameDetailsStore.boardGameDetails.id,
    );
    boardGameDetailsInCollectionStore.updateIsInCollectionStatus();
  }
}
