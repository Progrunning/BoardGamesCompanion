import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'filters/collection_filter_panel_widget.dart';
import '../../common/analytics.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';
import '../../stores/board_games_store.dart';

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
  FirebaseAnalytics _analytics;

  @override
  void initState() {
    super.initState();
    _analytics = Provider.of<FirebaseAnalytics>(
      context,
      listen: false,
    );

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
        style: AppTheme.defaultTextFieldStyle,
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
          icon: Icon(
            Icons.filter_list,
            color: AppTheme.accentColor,
          ),
          onPressed: () async {
            await _analytics.logEvent(
              name: Analytics.FilterCollection,
            );

            await _createBottomSheetFilterPanel(context);
          },
        )
      ],
    );
  }

  Future<void> _createBottomSheetFilterPanel(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: AppTheme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Styles.defaultBottomSheetCornerRadius),
          topRight: Radius.circular(Styles.defaultBottomSheetCornerRadius),
        ),
      ),
      context: context,
      builder: (_) {
        return CollectionFilterPanel();
      },
    );
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

  @override
  void dispose() {
    _searchController.removeListener(_handleSearchChanged);
    _searchController?.dispose();
    _debounce?.cancel();

    super.dispose();
  }
}
