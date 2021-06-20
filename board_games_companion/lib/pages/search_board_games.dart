import 'package:flutter/material.dart';

import '../widgets/common/page_container_widget.dart';
import '../widgets/saerch_board_games/hot_board_games_header_widget.dart';
import '../widgets/saerch_board_games/hot_board_games_results_widget.dart';
import '../widgets/saerch_board_games/search_bar_board_games_widget.dart';
import '../widgets/saerch_board_games/search_board_games_results_widget.dart';

class SearchBoardGamesPage extends StatefulWidget {
  const SearchBoardGamesPage({Key key}) : super(key: key);

  @override
  _SearchBoardGamesPageState createState() => _SearchBoardGamesPageState();
}

class _SearchBoardGamesPageState extends State<SearchBoardGamesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageContainer(
        child: CustomScrollView(
          slivers: <Widget>[
            SearchBarBoardGames(),
            SaerchBoardGamesResults(),
            SliverPersistentHeader(
              pinned: true,
              delegate: HotBoardGamesHeader(),
            ),
            HotBoardGamesResults(),
          ],
        ),
      ),
    );
  }
}
