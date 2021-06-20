import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../common/app_theme.dart';
import '../common/dimensions.dart';
import '../common/routes.dart';
import '../stores/board_game_details_in_collection_store.dart';
import '../stores/board_game_details_store.dart';
import '../stores/board_games_store.dart';
import '../widgets/board_games/board_game_detail_floating_actions_widget.dart';
import '../widgets/board_games/details/board_game_details_header_widget.dart';
import '../widgets/board_games/details/board_games_details_body_widget.dart';
import '../widgets/common/page_container_widget.dart';
import 'base_page_state.dart';
import 'board_game_playthroughs.dart';

class BoardGamesDetailsPage extends StatefulWidget {
  final String boardGameId;
  final String boardGameName;
  final BoardGameDetailsStore boardGameDetailsStore;
  final Type navigatingFromType;

  const BoardGamesDetailsPage({
    Key key,
    @required boardGameDetailsStore,
    @required boardGameId,
    @required boardGameName,
    @required navigatingFromType,
  })  : boardGameDetailsStore = boardGameDetailsStore,
        boardGameId = boardGameId,
        boardGameName = boardGameName,
        navigatingFromType = navigatingFromType,
        super(key: key);

  @override
  _BoardGamesDetailsPageState createState() => _BoardGamesDetailsPageState();
}

class _BoardGamesDetailsPageState extends BasePageState<BoardGamesDetailsPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppTheme.primaryColor,
    ));

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
                  boardGameDetailsStore: widget.boardGameDetailsStore,
                  boardGameName: widget.boardGameName,
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: Dimensions.halfFloatingActionButtonBottomSpacing,
                  ),
                  sliver: BoardGamesDetailsBody(
                    boardGameId: widget.boardGameId,
                    boardGameName: widget.boardGameName,
                    boardGameDetailsStore: widget.boardGameDetailsStore,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: BoardGameDetailFloatingActions(
          boardGameDetailsStore: widget.boardGameDetailsStore,
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
      widget.boardGameDetailsStore?.boardGameDetails,
    );

    if (!boardGameDetailsInCollectionStore.isInCollection &&
        widget.navigatingFromType == BoardGamePlaythroughsPage) {
      Navigator.popUntil(context, ModalRoute.withName(Routes.home));
      return false;
    }

    return true;
  }
}
