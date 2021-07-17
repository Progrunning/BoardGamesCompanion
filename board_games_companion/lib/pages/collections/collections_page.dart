import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/analytics.dart';
import '../../common/animation_tags.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/enums/enums.dart';
import '../../common/styles.dart';
import '../../mixins/sync_collection.dart';
import '../../services/analytics_service.dart';
import '../../services/rate_and_review_service.dart';
import '../../stores/board_games_store.dart';
import '../../stores/user_store.dart';
import '../../utilities/navigator_transitions.dart';
import '../../widgets/board_games/board_game_collection_item_widget.dart';
import '../../widgets/common/bgg_community_member_text_widget.dart';
import '../../widgets/common/bgg_community_member_user_name_text_field_widget.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/page_container_widget.dart';
import '../board_game_playthroughs.dart';
import 'collection_filter_panel.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage(
    this.boardGamesStore,
    this.userStore, {
    Key key,
  }) : super(key: key);

  final BoardGamesStore boardGamesStore;
  final UserStore userStore;

  @override
  _CollectionsPageState createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.boardGamesStore.loadDataState == LoadDataState.Loaded) {
      if (!widget.boardGamesStore.hasBoardGames && (widget.userStore.user?.name?.isEmpty ?? true)) {
        return _Empty();
      }

      return _Collection(
        boardGamesStore: widget.boardGamesStore,
      );
    } else if (widget.boardGamesStore.loadDataState == LoadDataState.Error) {
      return const Center(
        child: GenericErrorMessage(),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _Collection extends StatelessWidget {
  const _Collection({
    Key key,
    @required BoardGamesStore boardGamesStore,
  })  : _boardGamesStore = boardGamesStore,
        super(key: key);

  final BoardGamesStore _boardGamesStore;

  @override
  Widget build(BuildContext context) {
    final hasNoSearchResults = _boardGamesStore.filteredBoardGames.isEmpty &&
        (_boardGamesStore.searchPhrase?.isNotEmpty ?? false);

    return SafeArea(
      child: PageContainer(
        child: CustomScrollView(
          slivers: <Widget>[
            _SearchBar(boardGamesStore: _boardGamesStore),
            if (hasNoSearchResults)
              _EmptySearchResult(boardGamesStore: _boardGamesStore)
            else
              _Grid(boardGamesStore: _boardGamesStore),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    @required this.boardGamesStore,
    Key key,
  }) : super(key: key);

  final BoardGamesStore boardGamesStore;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
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
    if (widget.boardGamesStore.searchPhrase?.isEmpty ?? true) {
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
          icon: const Icon(
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
    await showModalBottomSheet<Widget>(
      backgroundColor: AppTheme.primaryColor,
      shape: const RoundedRectangleBorder(
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
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () async {
        widget.boardGamesStore.updateSearchResults(_searchController.text);

        await _rateAndReviewService.increaseNumberOfSignificantActions();
      },
    );
  }

  Widget _retrieveSearchBarSuffixIcon() {
    if (widget.boardGamesStore.searchPhrase?.isNotEmpty ?? false) {
      return IconButton(
        icon: const Icon(
          Icons.clear,
        ),
        color: AppTheme.accentColor,
        onPressed: () {
          _searchController.text = '';
          widget.boardGamesStore.updateSearchResults('');
        },
      );
    }

    return const Icon(
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

class _Grid extends StatelessWidget {
  const _Grid({
    Key key,
    @required BoardGamesStore boardGamesStore,
  })  : _boardGamesStore = boardGamesStore,
        super(key: key);

  final BoardGamesStore _boardGamesStore;

  @override
  Widget build(BuildContext context) {
    final _analytics = Provider.of<AnalyticsService>(
      context,
      listen: false,
    );

    return SliverPadding(
      padding: const EdgeInsets.all(
        Dimensions.standardSpacing,
      ),
      sliver: SliverGrid.extent(
        crossAxisSpacing: Dimensions.standardSpacing,
        mainAxisSpacing: Dimensions.standardSpacing,
        maxCrossAxisExtent: Dimensions.boardGameItemCollectionImageWidth,
        children: List.generate(
          _boardGamesStore.filteredBoardGames.length,
          (int index) {
            final boardGameDetails = _boardGamesStore.filteredBoardGames[index];

            return BoardGameCollectionItem(
              boardGame: boardGameDetails,
              onTap: () async {
                await _analytics.logEvent(
                  name: Analytics.ViewGameStats,
                  parameters: <String, String>{
                    Analytics.BoardGameIdParameter: boardGameDetails.id,
                    Analytics.BoardGameNameParameter: boardGameDetails.name,
                  },
                );

                await Navigator.push<BoardGamePlaythroughsPage>(
                  context,
                  NavigatorTransitions.fadeThrough(
                    (_, __, ___) {
                      return BoardGamePlaythroughsPage(
                        _boardGamesStore.filteredBoardGames[index],
                      );
                    },
                  ),
                );
              },
              heroTag: AnimationTags.boardGamePlaythroughImageHeroTag,
            );
          },
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget with SyncCollection {
  _Empty({
    Key key,
  }) : super(key: key);

  final _syncController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(
          Dimensions.doubleStandardSpacing,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  '''It looks like you don't have any games in your collection yet.''',
                ),
              ),
            ),
            const SizedBox(
              height: Dimensions.standardSpacing,
            ),
            const BggCommunityMemberText(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.doubleStandardSpacing * 2,
              ),
              child: BggCommunityMemberUserNameTextField(
                controller: _syncController,
                onSubmit: () async {
                  await syncCollection(
                    context,
                    _syncController.text,
                  );
                },
              ),
            ),
            const SizedBox(
              height: Dimensions.standardSpacing,
            ),
            Center(
              child: IconAndTextButton(
                title: 'Sync',
                icon: Icons.sync,
                onPressed: () async {
                  await syncCollection(
                    context,
                    _syncController.text,
                  );
                },
              ),
            ),
            const SizedBox(
              height: Dimensions.standardSpacing,
            ),
            const Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                    'Otherwise, use the bottom navigation search option, where you can check out currently TOP 50 hot board games and look up any title.'),
              ),
            ),
            const SizedBox(
              height: Dimensions.standardSpacing,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchResult extends StatelessWidget {
  const _EmptySearchResult({
    Key key,
    @required BoardGamesStore boardGamesStore,
  })  : _boardGamesStore = boardGamesStore,
        super(key: key);

  final BoardGamesStore _boardGamesStore;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.doubleStandardSpacing,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text:
                        '''It looks like you don't have any board games in your collection that match the search phrase ''',
                  ),
                  TextSpan(
                    text: _boardGamesStore.searchPhrase,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: Dimensions.standardSpacing,
            ),
            Center(
              child: IconAndTextButton(
                title: 'Clear search',
                icon: Icons.clear,
                onPressed: () {
                  _boardGamesStore.updateSearchResults('');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
