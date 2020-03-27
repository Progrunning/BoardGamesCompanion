import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/pages/playthroughs.dart';
import 'package:board_games_companion/pages/start_new_playthrough.dart';
import 'package:board_games_companion/stores/board_game_playthroughs_store.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardGamePlaythroughsPage extends StatelessWidget {
  final BoardGameDetails boardGameDetails;

  BoardGamePlaythroughsPage(this.boardGameDetails, {Key key}) : super(key: key);

  static const int _playthroughsPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _store =
        Provider.of<BoardGamePlaythroughsStore>(context, listen: false);
    final _pageController = PageController(initialPage: _playthroughsPageIndex);
    return Scaffold(
      appBar: AppBar(
        title: Text('Playthroughs'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => _onTabPageChanged(index, _store),
        children: <Widget>[
          PlaythroughsPage(boardGameDetails),
          StartNewPlaythroughPage(),
        ],
      ),
      floatingActionButton: Consumer<BoardGamePlaythroughsStore>(
        builder: (_, store, __) {
          return Opacity(
            opacity:
                store.boardGamePlaythroughPageIndex == _playthroughsPageIndex
                    ? Styles.transparentOpacity
                    : Styles.opaqueOpacity,
            child: IconAndTextButton(
              title: 'Start New Game',
              icon: Icons.play_arrow,
              onPressed: _onStartNewGame,
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
              _onTabChanged(index, _pageController);
            },
            currentIndex: store.boardGamePlaythroughPageIndex,
          );
        },
      ),
    );
  }

  void _onTabChanged(int index, PageController pageController) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onTabPageChanged(int pageIndex, BoardGamePlaythroughsStore store) {
    store.boardGamePlaythroughPageIndex = pageIndex;
  }

  void _onStartNewGame() {}
}
