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
        child:
            Consumer2<BoardGameDetailsInCollectionStore, BoardGameDetailsStore>(
          builder: (
            _,
            boardGameDetailsInCollectionStore,
            boardGameDetailsStore,
            __,
          ) {
            if(boardGameDetailsStore.boardGameDetails == null) {
              return Container();
            }
            if (boardGameDetailsInCollectionStore.isInCollection) {
              return IconAndTextButton(
                // TODO When navigated from the playthroughs, and going back after removing from collection user should be taken to the home page
                onPressed: () => _removeBoardGameFromCollection(
                  context,
                  boardGameDetailsInCollectionStore,
                  boardGamesStore,
                ),
                icon: Icons.remove_circle_outline,
                backgroundColor: Colors.red,
              );
            } else {
              return IconAndTextButton(
                onPressed: () => _addBoardGameToCollection(
                  boardGameDetailsInCollectionStore,
                  boardGamesStore,
                  context,
                ),
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

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${_boardGameDetailsStore.boardGameDetails.name} has been added to your collection'),
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
    await boardGamesStore
        .removeBoardGame(_boardGameDetailsStore.boardGameDetails.id);
    boardGameDetailsInCollectionStore.updateIsInCollectionStatus();

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 10),
        content: Text(
            '${_boardGameDetailsStore.boardGameDetails.name} has been removed from your collection'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            await boardGamesStore
                .addOrUpdateBoardGame(_boardGameDetailsStore.boardGameDetails);
            boardGameDetailsInCollectionStore.updateIsInCollectionStatus();
          },
        ),
      ),
    );
  }
}
