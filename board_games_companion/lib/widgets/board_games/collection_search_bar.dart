import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/analytics.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';
import '../../services/analytics_service.dart';
import '../../services/rate_and_review_service.dart';
import '../../stores/board_games_store.dart';
import 'filters/collection_filter_panel_widget.dart';

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
  AnalyticsService _analyticsService;
  RateAndReviewService _rateAndReviewService;

  @override
  void initState() {
    super.initState();
    _analyticsService = Provider.of<AnalyticsService>(
      context,
      listen: false,
    );
    _rateAndReviewService = Provider.of<RateAndReviewService>(
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
        onSubmitted: (searchPhrase) async {
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
            await _createBottomSheetFilterPanel(context);

            await _analyticsService.logEvent(
              name: Analytics.FilterCollection,
            );
            await _rateAndReviewService.increaseNumberOfSignificantActions();
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
      () async {
        widget._boardGamesStore.updateSearchResults(_searchController.text);

        await _rateAndReviewService.increaseNumberOfSignificantActions();
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
