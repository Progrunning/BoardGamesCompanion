import 'dart:async';

import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:flutter/material.dart';

class CollectionSearchBar extends StatefulWidget {
  CollectionSearchBar({
    @required boardGamesStore,
    Key key,
  })  : _boardGamesStore = boardGamesStore,
        super(key: key);

  final BoardGamesStore _boardGamesStore;

  @override
  _CollectionSearchBarState createState() => _CollectionSearchBarState();
}

class _CollectionSearchBarState extends State<CollectionSearchBar> {
  final _searchController = TextEditingController();
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  Widget build(BuildContext context) {
    if (widget._boardGamesStore.searchPhrase?.isEmpty ?? true) {
      _searchController.text = '';
    }

    return SliverAppBar(
      titleSpacing: Dimensions.standardSpacing,
      title: TextField(
        controller: _searchController,
        textAlignVertical: TextAlignVertical.center,
        decoration: AppTheme.defaultTextFieldInputDecoration.copyWith(
          hintText: 'Search...',
          suffixIcon: _retrieveSearchBarSuffixIcon(),
        ),
        onSubmitted: (searchPhrase) {
          FocusScope.of(context).unfocus();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (_) {
                return Container(
                  height: MediaQuery.of(Scaffold.of(context).context).size.height * 0.65,
                );
              },
            );
          },
        )
      ],
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_handleSearchChanged);
    _searchController.dispose();
    _debounce.cancel();

    super.dispose();
  }

  void _handleSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        widget._boardGamesStore.updateSearchResults(_searchController.text);
      },
    );
  }

  Widget _retrieveSearchBarSuffixIcon() {
    if (widget._boardGamesStore.searchPhrase?.isNotEmpty ?? false) {
      return IconButton(
        icon: Icon(
          Icons.clear,
        ),
        color: AppTheme.accentColor,
        onPressed: () {
          _searchController.text = '';
          widget._boardGamesStore.updateSearchResults('');
        },
      );
    }

    return Icon(
      Icons.search,
      color: AppTheme.accentColor,
    );
  }
}
