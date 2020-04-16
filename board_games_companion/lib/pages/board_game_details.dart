import 'package:board_games_companion/stores/board_game_details_store.dart';
import 'package:board_games_companion/widgets/board_games/board_game_detail_floating_actions_widget.dart';
import 'package:board_games_companion/widgets/board_games/details/board_game_details_header_widget.dart';
import 'package:board_games_companion/widgets/board_games/details/board_games_details_body_widget.dart';
import 'package:board_games_companion/widgets/common/page_container_widget.dart';
import 'package:flutter/material.dart';

class BoardGamesDetailsPage extends StatelessWidget {
  final String _boardGameId;
  final String _boardGameName;
  final BoardGameDetailsStore _boardGameDetailsStore;

  BoardGamesDetailsPage(
    this._boardGameDetailsStore,
    this._boardGameId,
    this._boardGameName,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageContainer(
          child: CustomScrollView(
            slivers: <Widget>[
              BoardGamesDetailsHeader(
                boardGameDetailsStore: _boardGameDetailsStore,
                boardGameName: _boardGameName,
              ),
              BoardGamesDetailsBody(
                boardGameId: _boardGameId,
                boardGameDetailsStore: _boardGameDetailsStore,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: BoardGameDetailFloatingActions(
        boardGameDetailsStore: _boardGameDetailsStore,
      ),
    );
  }
}
