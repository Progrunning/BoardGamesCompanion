import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/pages/paythrough_statistcs_page.dart';
import 'package:board_games_companion/pages/playthroughs.dart';
import 'package:board_games_companion/pages/start_new_playthrough.dart';
import 'package:board_games_companion/stores/board_game_playthroughs_store.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:board_games_companion/stores/start_playthrough_store.dart';
import 'package:board_games_companion/utilities/navigator_helper.dart';
import 'package:board_games_companion/widgets/common/bottom_tabs/custom_bottom_navigation_bar_item_widget.dart';
import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:board_games_companion/extensions/page_controller_extensions.dart';
import 'package:board_games_companion/widgets/common/page_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardGamePlaythroughsPage extends StatelessWidget {
  final BoardGameDetails _boardGameDetails;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  BoardGamePlaythroughsPage(
    this._boardGameDetails, {
    Key key,
  }) : super(key: key);

  static const int _playthroughsPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final boardGamePlaythoughsStore = Provider.of<BoardGamePlaythroughsStore>(
      context,
      listen: false,
    );
    final pageController = PageController(
        initialPage: boardGamePlaythoughsStore.boardGamePlaythroughPageIndex);

    final playthroughsStore = Provider.of<PlaythroughsStore>(
      context,
      listen: false,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_boardGameDetails.name ?? ''),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info,
              color: AppTheme.accentColor,
            ),
            onPressed: () async {
              await _navigateToBoardGameDetails(context, _boardGameDetails);
            },
          )
        ],
      ),
      body: SafeArea(
        child: PageContainer(
          child: PageView(
            controller: pageController,
            onPageChanged: (index) =>
                _onTabPageChanged(index, boardGamePlaythoughsStore),
            children: <Widget>[
              PlaythroughStatistcsPage(
                boardGameDetails: _boardGameDetails,
              ),
              PlaythroughsPage(
                _boardGameDetails,
                playthroughsStore,
              ),
              Consumer<PlayersStore>(
                builder: (_, __, ___) {
                  return StartNewPlaythroughPage();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Consumer2<BoardGamePlaythroughsStore, PlayersStore>(
        builder: (_, boardGamePlaythroughStore, playersStore, __) {
          final _showStartNewGameButton =
              boardGamePlaythroughStore.boardGamePlaythroughPageIndex !=
                      _playthroughsPageIndex &&
                  (playersStore.players?.isNotEmpty ?? false);
          // TODO MK Move floating button to the tabbed page, instead of keeping it in the parent
          return _showStartNewGameButton
              ? IconAndTextButton(
                  title: 'Start New Game',
                  icon: Icons.play_arrow,
                  onPressed: () => _onStartNewGame(context, pageController),
                )
              : Container();
        },
      ),
      bottomNavigationBar: Consumer<BoardGamePlaythroughsStore>(
        builder: (_, store, __) {
          return BottomNavigationBar(
            backgroundColor: AppTheme.bottomTabBackgroundColor,
            items: <BottomNavigationBarItem>[
              CustomBottomNavigationBarItem('Stats', Icons.multiline_chart),
              CustomBottomNavigationBarItem('History', Icons.history),
              CustomBottomNavigationBarItem('New Game', Icons.play_arrow),
            ],
            onTap: (index) {
              _onTabChanged(index, pageController);
            },
            currentIndex: store.boardGamePlaythroughPageIndex,
          );
        },
      ),
    );
  }

  void _onTabChanged(int index, PageController pageController) {
    pageController.animateToTab(index);
  }

  void _onTabPageChanged(
      int pageIndex, BoardGamePlaythroughsStore boardGamePlaythroughsStore) {
    boardGamePlaythroughsStore.boardGamePlaythroughPageIndex = pageIndex;
  }

  Future<void> _navigateToBoardGameDetails(
    BuildContext context,
    BoardGameDetails boardGameDetails,
  ) async {
    await NavigatorHelper.navigateToBoardGameDetails(
      context,
      boardGameDetails,
    );
  }

  Future<void> _onStartNewGame(
    BuildContext context,
    PageController pageController,
  ) async {
    final startPlaythroughStore = Provider.of<StartPlaythroughStore>(
      context,
      listen: false,
    );

    final selectedPlaythoughPlayers = startPlaythroughStore.playthroughPlayers
        ?.where((pp) => pp.isChecked)
        ?.toList();

    if (selectedPlaythoughPlayers?.isEmpty ?? true) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content:
              Text('You need to select at least one player to start a game'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              _scaffoldKey.currentState.hideCurrentSnackBar();
            },
          ),
        ),
      );
      return;
    }

    final playthroughsStore = Provider.of<PlaythroughsStore>(
      context,
      listen: false,
    );

    final newPlaythrough = await playthroughsStore.createPlaythrough(
        _boardGameDetails.id, selectedPlaythoughPlayers);
    if (newPlaythrough == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: GenericErrorMessage(),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              _scaffoldKey.currentState.hideCurrentSnackBar();
            },
          ),
        ),
      );
      return;
    }

    pageController.animateToTab(_playthroughsPageIndex);
  }
}
