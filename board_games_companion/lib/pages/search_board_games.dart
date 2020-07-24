import 'package:board_games_companion/widgets/common/page_container_widget.dart';
import 'package:board_games_companion/widgets/saerch_board_games/hot_board_games_header_widget.dart';
import 'package:board_games_companion/widgets/saerch_board_games/hot_board_games_results_widget.dart';
import 'package:board_games_companion/widgets/saerch_board_games/search_bar_board_games_widget.dart';
import 'package:board_games_companion/widgets/saerch_board_games/search_board_games_results_widget.dart';
import 'package:flutter/material.dart';

class SearchBoardGamesPage extends StatelessWidget {
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
