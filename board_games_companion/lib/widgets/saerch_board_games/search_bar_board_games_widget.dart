import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/stores/search_bar_board_games_store.dart';
import 'package:board_games_companion/stores/search_board_games_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBarBoardGames extends StatelessWidget {
  final _searchController = TextEditingController();

  SearchBarBoardGames({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchBoardGamesStore = Provider.of<SearchBoardGamesStore>(
      context,
      listen: false,
    );

    return SliverAppBar(
      titleSpacing: 0,
      title: Consumer<SearchBarBoardGamesStore>(
        builder: (_, store, __) {
          return TextField(
            controller: _searchController,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: 'Search...',
              focusColor: AppTheme.accentColor,
              hintStyle: TextStyle(
                color: AppTheme.defaultTextColor,
              ),
              suffixIcon: retrieveSearchBarSuffixIcon(
                store,
                searchBoardGamesStore,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppTheme.primaryColor,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppTheme.accentColor,
                ),
              ),
            ),
            onChanged: (searchPhrase) {
              store.searchPhrase = searchPhrase;
            },
            onSubmitted: (searchPhrase) {
              searchBoardGamesStore.updateSearchResults();
            },
          );
        },
      ),
    );
  }

  retrieveSearchBarSuffixIcon(
    SearchBarBoardGamesStore searchBarBoardGamesStore,
    SearchBoardGamesStore searchBoardGamesStore,
  ) {
    if (searchBarBoardGamesStore.searchPhrase?.isNotEmpty ?? false) {
      return IconButton(
        icon: Icon(
          Icons.clear,
        ),
        color: AppTheme.accentColor,
        onPressed: () {
          _searchController.text = '';
          searchBarBoardGamesStore.searchPhrase = null;
          searchBoardGamesStore.updateSearchResults();
        },
      );
    }

    return Icon(
      Icons.search,
      color: AppTheme.accentColor,
    );
  }
}
