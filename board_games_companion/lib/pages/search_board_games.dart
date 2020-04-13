import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/stores/search_board_games_store.dart';
import 'package:board_games_companion/widgets/common/page_container_widget.dart';
import 'package:board_games_companion/widgets/saerch_board_games/hot_board_games_header_widget.dart';
import 'package:board_games_companion/widgets/saerch_board_games/hot_board_games_results_widget.dart';
import 'package:board_games_companion/widgets/saerch_board_games/search_board_games_results_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class SearchBoardGamesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchBoardGamesPageState();
}

class _SearchBoardGamesPageState extends State<SearchBoardGamesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final searchBoardGamesStore = Provider.of<SearchBoardGamesStore>(
      context,
      listen: false,
    );

    return Scaffold(
      body: SafeArea(
        child: PageContainer(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                titleSpacing: 0,
                title: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: AppTheme.defaultTextColor,
                    ),
                    suffixIcon: Icon(
                      Icons.clear,
                      color: AppTheme.accentColor,
                    ),
                  ),
                  onSubmitted: (searchPhrase) {
                    searchBoardGamesStore.searchPhrase = searchPhrase;
                  },
                ),
              ),
              SaerchBoardGamesResults(),
              SliverPersistentHeader(
                pinned: true,
                delegate: HotBoardGamesHeader(),
              ),
              HotBoardGamesResults(),
            ],
          ),
        ),
      ),
    );
  }
}
