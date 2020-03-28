import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/pages/playthroughs.dart';
import 'package:board_games_companion/pages/start_new_playthrough.dart';
import 'package:board_games_companion/stores/board_game_playthroughs_store.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:board_games_companion/stores/start_playthrough_store.dart';
import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:board_games_companion/extensions/page_controller_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardGamePlaythroughsPage extends StatelessWidget {
  final BoardGameDetails _boardGameDetails;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  BoardGamePlaythroughsPage(this._boardGameDetails, {Key key})
      : super(key: key);

  static const int _playthroughsPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final boardGamePlaythoughsStore = Provider.of<BoardGamePlaythroughsStore>(
      context,
      listen: false,
    );
    final pageController = PageController(
        initialPage: boardGamePlaythoughsStore.boardGamePlaythroughPageIndex);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Playthroughs'),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) =>
            _onTabPageChanged(index, boardGamePlaythoughsStore),
        children: <Widget>[
          PlaythroughsPage(_boardGameDetails),
          StartNewPlaythroughPage(),
        ],
      ),
      floatingActionButton: Consumer2<BoardGamePlaythroughsStore, PlayersStore>(
        builder: (_, boardGamePlaythroughStore, playersStore, __) {
          final _showStartNewGameButton =
              boardGamePlaythroughStore.boardGamePlaythroughPageIndex !=
                      _playthroughsPageIndex &&
                  (playersStore.players?.isNotEmpty ?? false);
          return Opacity(
            opacity: _showStartNewGameButton
                ? Styles.opaqueOpacity
                : Styles.transparentOpacity,
            child: IconAndTextButton(
              title: 'Start New Game',
              icon: Icons.play_arrow,
              onPressed: () => _onStartNewGame(context, pageController),
            ),
          );
        },
      ),
      bottomNavigationBar: Consumer<BoardGamePlaythroughsStore>(
        builder: (_, store, __) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                title: Text('History'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.play_arrow),
                title: Text('New Game'),
              ),
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

  Future<void> _onStartNewGame(
      BuildContext context, PageController pageController) async {
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
