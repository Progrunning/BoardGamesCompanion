import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/stores/board_game_details_in_collection_store.dart';
import 'package:board_games_companion/stores/board_game_details_store.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/board_games/board_game_detail_floating_actions_widget.dart';
import 'package:board_games_companion/widgets/board_games/details/board_game_details_header_widget.dart';
import 'package:board_games_companion/widgets/board_games/details/board_games_details_body_widget.dart';
import 'package:board_games_companion/widgets/common/page_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return WillPopScope(
      onWillPop: () async {
        return _handleOnWillPop(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: PageContainer(
            child: CustomScrollView(
              slivers: <Widget>[
                BoardGamesDetailsHeader(
                  boardGameDetailsStore: _boardGameDetailsStore,
                  boardGameName: _boardGameName,
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: Dimensions.halfFloatingActionButtonBottomSpacing,
                  ),
                  sliver: BoardGamesDetailsBody(
                    boardGameId: _boardGameId,
                    boardGameName: _boardGameName,
                    boardGameDetailsStore: _boardGameDetailsStore,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: BoardGameDetailFloatingActions(
          boardGameDetailsStore: _boardGameDetailsStore,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Future<bool> _handleOnWillPop(BuildContext context) async {
    final boardGamesStore = Provider.of<BoardGamesStore>(
      context,
      listen: false,
    );
    final boardGameDetailsInCollectionStore = BoardGameDetailsInCollectionStore(
      boardGamesStore,
      _boardGameDetailsStore?.boardGameDetails,
    );

    if (!boardGameDetailsInCollectionStore.isInCollection) {
      Navigator.popUntil(context, ModalRoute.withName(Routes.home));
      return false;
    }

    return true;
  }
}
