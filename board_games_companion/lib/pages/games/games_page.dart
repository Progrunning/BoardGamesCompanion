import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/analytics.dart';
import '../../common/animation_tags.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/enums/collection_flag.dart';
import '../../common/enums/enums.dart';
import '../../common/enums/games_tab.dart';
import '../../common/styles.dart';
import '../../mixins/sync_collection.dart';
import '../../models/hive/board_game_details.dart';
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
import 'games_filter_panel.dart';

class GamesPage extends StatefulWidget {
  const GamesPage(
    this.boardGamesStore,
    this.userStore, {
    Key key,
  }) : super(key: key);

  final BoardGamesStore boardGamesStore;
  final UserStore userStore;

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> with SingleTickerProviderStateMixin {
  TabController _topTabController;

  @override
  void initState() {
    _topTabController = TabController(
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.boardGamesStore.loadDataState == LoadDataState.Loaded) {
      if (!widget.boardGamesStore.hasBoardGames && (widget.userStore.user?.name?.isEmpty ?? true)) {
        return _Empty();
      }

      return _Collection(
        boardGamesStore: widget.boardGamesStore,
        topTabController: _topTabController,
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

  @override
  void dispose() {
    _topTabController.dispose();
    super.dispose();
  }
}

class _Collection extends StatelessWidget {
  const _Collection({
    @required this.boardGamesStore,
    @required this.topTabController,
    Key key,
  }) : super(key: key);

  final BoardGamesStore boardGamesStore;
  final TabController topTabController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageContainer(
        child: CustomScrollView(
          slivers: <Widget>[
            _AppBar(
              boardGamesStore: boardGamesStore,
              topTabController: topTabController,
            ),
            Builder(
              builder: (_) {
                final List<BoardGameDetails> boardGames = [];
                switch (boardGamesStore.selectedTab) {
                  case GamesTab.Colleciton:
                    boardGames.addAll(boardGamesStore.filteredBoardGamesInCollection);
                    break;
                  case GamesTab.Played:
                    boardGames.addAll(boardGamesStore.filteredBoardGamesPlayed);
                    break;
                  case GamesTab.Wishlist:
                    boardGames.addAll(boardGamesStore.filteredBoardGamesOnWishlist);
                    break;
                }

                if (boardGames.isEmpty) {
                  if (boardGamesStore.searchPhrase?.isNotEmpty ?? false) {
                    return _EmptySearchResult(boardGamesStore: boardGamesStore);
                  }

                  return _EmptyCollection(
                    boardGamesStore: boardGamesStore,
                  );
                }

                return _Grid(
                  boardGames: boardGames,
                  collectionFlag: boardGamesStore.selectedTab.toCollectionFlag(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatefulWidget {
  const _AppBar({
    @required this.boardGamesStore,
    @required this.topTabController,
    Key key,
  }) : super(key: key);

  final BoardGamesStore boardGamesStore;
  final TabController topTabController;

  @override
  _AppBarState createState() => _AppBarState();
}

class _AppBarState extends State<_AppBar> {
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
      floating: true,
      titleSpacing: Dimensions.standardSpacing,
      title: TextField(
        controller: _searchController,
        textAlignVertical: TextAlignVertical.center,
        style: AppTheme.defaultTextFieldStyle,
        decoration: AppTheme.defaultTextFieldInputDecoration.copyWith(
          hintText: 'Search for a game...',
          suffixIcon: _retrieveSearchBarSuffixIcon(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColorLight),
          ),
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
            await _openFiltersPanel(context);

            await _analyticsService.logEvent(
              name: Analytics.FilterCollection,
            );
            await _rateAndReviewService.increaseNumberOfSignificantActions();
          },
        )
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: TabBar(
          onTap: (int index) {
            widget.boardGamesStore.selectedTab = index.toGamesTab();
          },
          controller: widget.topTabController,
          tabs: <Widget>[
            _TopTab(
              'Collection',
              Icons.grid_on,
              isSelected: widget.boardGamesStore.selectedTab == GamesTab.Colleciton,
            ),
            _TopTab(
              'Played',
              Icons.sports_esports,
              isSelected: widget.boardGamesStore.selectedTab == GamesTab.Played,
            ),
            _TopTab(
              'Wishlist',
              Icons.card_giftcard,
              isSelected: widget.boardGamesStore.selectedTab == GamesTab.Wishlist,
            ),
          ],
          indicatorColor: AppTheme.accentColor,
        ),
      ),
    );
  }

  Future<void> _openFiltersPanel(BuildContext context) async {
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
        return const GamesFilterPanel();
      },
    );

    // TODO MK After updating to Flutter 2.x see https://stackoverflow.com/questions/44991968/how-can-i-dismiss-the-on-screen-keyboard/56946311#56946311 for solution
    FocusScope.of(context).requestFocus(FocusNode());
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
    @required this.boardGames,
    @required this.collectionFlag,
  }) : super(key: key);

  final List<BoardGameDetails> boardGames;
  final CollectionFlag collectionFlag;

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
          boardGames.length,
          (int index) {
            final boardGame = boardGames[index];

            return BoardGameCollectionItem(
              boardGame: boardGame,
              onTap: () async {
                await _analytics.logEvent(
                  name: Analytics.ViewGameStats,
                  parameters: <String, String>{
                    Analytics.BoardGameIdParameter: boardGame.id,
                    Analytics.BoardGameNameParameter: boardGame.name,
                  },
                );

                await Navigator.push<BoardGamePlaythroughsPage>(
                  context,
                  NavigatorTransitions.fadeThrough(
                    (_, __, ___) {
                      return BoardGamePlaythroughsPage(
                        boardGames[index],
                        collectionFlag,
                      );
                    },
                  ),
                );
              },
              heroTag: '${AnimationTags.boardGamePlaythroughImageHeroTag}_$collectionFlag',
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
              child: SizedBox.shrink(),
            ),
            const Center(
              child: Text(
                'Your games collection is empty',
                style: TextStyle(
                  fontSize: Dimensions.extraLargeFontSize,
                ),
              ),
            ),
            const SizedBox(
              height: Dimensions.doubleStandardSpacing,
            ),
            const Icon(
              Icons.sentiment_dissatisfied_sharp,
              size: 80,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(
              height: Dimensions.doubleStandardSpacing,
            ),
            const Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: 'Nothing to worry about though! ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Follow the below instructions to fill up this screen with board games.\n\n',
                  ),
                  TextSpan(
                    text: 'Use the bottom ',
                  ),
                  TextSpan(
                    text: 'Search',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),                  
                  TextSpan(
                    text:
                        ' tab to check out current TOP 50 hot board games or look up any title.\n',
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: Dimensions.mediumFontSize,
              ),
            ),
            const BggCommunityMemberText(),
            BggCommunityMemberUserNameTextField(
              controller: _syncController,
              onSubmit: () async {
                await syncCollection(
                  context,
                  _syncController.text,
                );
              },
            ),
            const SizedBox(
              height: Dimensions.standardSpacing,
            ),
            Align(
              alignment: Alignment.centerRight,
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
            const Expanded(child: SizedBox.shrink()),
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

class _EmptyCollection extends StatelessWidget {
  const _EmptyCollection({
    Key key,
    @required this.boardGamesStore,
  }) : super(key: key);

  final BoardGamesStore boardGamesStore;

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
                    text: "It looks like you don't have any board games in your ",
                  ),
                  TextSpan(
                    text: boardGamesStore.selectedTab.toCollectionFlag().toHumandReadableText(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ' collection yet.\n\nTo add a game to a collection, first find a game by using the ',
                  ),
                  const TextSpan(
                    text: 'Search',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " bottom tab or tap on the below button to go to that screen. On the details screen of a game, tap on the desired collection's icon - this will automatically add the game to the specific collection.",
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
                title: 'Find games',
                icon: Icons.search,
                onPressed: () {
                  // TODO
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab(
    this.title,
    this.icon, {
    this.isSelected = true,
    Key key,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Tab(
          icon: Icon(
            icon,
            color: isSelected ? AppTheme.selectedTabIconColor : AppTheme.deselectedTabIconColor,
          ),
          iconMargin: const EdgeInsets.only(
            bottom: Dimensions.halfStandardSpacing,
          ),
          child: Text(
            title,
            style: AppTheme.titleTextStyle.copyWith(
              fontSize: Dimensions.standardFontSize,
              color: isSelected ? AppTheme.defaultTextColor : AppTheme.deselectedTabIconColor,
            ),
          ),
        ),
      ],
    );
  }
}