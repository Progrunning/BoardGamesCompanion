import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/stores/board_game_details_store.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardGameDetailFloatingActions extends StatelessWidget {
  const BoardGameDetailFloatingActions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconAndTextButton(
      onPressed: () => _addBoardGameToCollection(context),
      title: 'Add Game',
      icon: Icons.add,
    );
  }
}

Future<void> _addBoardGameToCollection(
  BuildContext context,
) async {
  final boardGamesStore = Provider.of<BoardGamesStore>(context, listen: false);
  final boardGameDetailsStore =
      Provider.of<BoardGameDetailsStore>(context, listen: false);
  await boardGamesStore
      .addOrUpdateBoardGame(boardGameDetailsStore.boardGameDetails);
  Navigator.popUntil(context, ModalRoute.withName(Routes.home));
}
