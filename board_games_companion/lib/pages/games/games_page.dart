import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/analytics.dart';
import '../../common/animation_tags.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/enums/collection_type.dart';
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
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/bgg_community_member_text_widget.dart';
import '../../widgets/common/bgg_community_member_user_name_text_field_widget.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/page_container_widget.dart';
import '../../widgets/common/sync_collection_button.dart';
import '../playthroughs/playthroughs_page.dart';
import 'games_filter_panel.dart';

class GamesPage extends StatefulWidget {
  const GamesPage(
    this.boardGamesStore,
    this.userStore,
    this.analyticsService,
    this.rateAndReviewService, {
    Key? key,
  }) : super(key: key);

  final BoardGamesStore boardGamesStore;
  final UserStore userStore;
  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> with SingleTickerProviderStateMixin {
  late TabController _topTabController;

  @override
  void initState() {
    _topTabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.boardGamesStore.selectedTab.index,
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
        analyticsService: widget.analyticsService,
        rateAndReviewService: widget.rateAndReviewService,
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
    required this.boardGamesStore,
    required this.topTabController,
    required this.analyticsService,
    required this.rateAndReviewService,
    Key? key,
  }) : super(key: key);

  final BoardGamesStore boardGamesStore;
  final TabController topTabController;
  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageContainer(
        child: CustomScrollView(
          slivers: <Widget>[
            _AppBar(
              boardGamesStore: boardGamesStore,
              topTabController: topTabController,
              analyticsService: analyticsService,
              rateAndReviewService: rateAndReviewService,
            ),
            Builder(
              builder: (_) {
                final List<BoardGameDetails> boardGames = [];
                switch (boardGamesStore.selectedTab) {
                  case GamesTab.Owned:
                    boardGames.addAll(boardGamesStore.filteredBoardGamesOwned);
                    break;
                  case GamesTab.Friends:
                    boardGames.addAll(boardGamesStore.filteredBoardGamesFriends);
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
                  analyticsService: analyticsService,
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
    required this.boardGamesStore,
    required this.topTabController,
    required this.analyticsService,
    required this.rateAndReviewService,
    Key? key,
  }) : super(key: key);

  final BoardGamesStore boardGamesStore;
  final TabController topTabController;
  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;

  @override
  _AppBarState createState() => _AppBarState();
}

class _AppBarState extends State<_AppBar> {
  final _searchController = TextEditingController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_handleSearchChanged);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.boardGamesStore.searchPhrase?.isEmpty ?? true) {
      _searchController.text = '';
    }

    return SliverAppBar(
      pinned: true,
      floating: true,
      titleSpacing: Dimensions.standardSpacing,
      title: TextField(
        controller: _searchController,
        textAlignVertical: TextAlignVertical.center,
        style: AppTheme.defaultTextFieldStyle,
        decoration: InputDecoration(
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

            await widget.analyticsService.logEvent(
              name: Analytics.FilterCollection,
            );
            await widget.rateAndReviewService.increaseNumberOfSignificantActions();
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
              'Owned',
              Icons.grid_on,
              isSelected: widget.boardGamesStore.selectedTab == GamesTab.Owned,
            ),
            _TopTab(
              'Friends',
              Icons.group,
              isSelected: widget.boardGamesStore.selectedTab == GamesTab.Friends,
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
      _debounce!.cancel();
    }

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () async {
        widget.boardGamesStore.updateSearchResults(_searchController.text);

        await widget.rateAndReviewService.increaseNumberOfSignificantActions();
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
    Key? key,
    required this.boardGames,
    required this.collectionFlag,
    required this.analyticsService,
  }) : super(key: key);

  final List<BoardGameDetails> boardGames;
  final CollectionType collectionFlag;
  final AnalyticsService analyticsService;

  @override
  Widget build(BuildContext context) {
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

            return BoardGameTile(
              boardGame: boardGame,
              onTap: () async {
                await analyticsService.logEvent(
                  name: Analytics.ViewGameStats,
                  parameters: <String, String?>{
                    Analytics.BoardGameIdParameter: boardGame.id,
                    Analytics.BoardGameNameParameter: boardGame.name,
                  },
                );

                await Navigator.push<PlaythroughsPage>(
                  context,
                  NavigatorTransitions.fadeThrough(
                    (_, __, ___) {
                      return PlaythroughsPage(
                        boardGameDetails: boardGames[index],
                        collectionType: collectionFlag,
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

class _Empty extends StatefulWidget with SyncCollection {
  _Empty({
    Key? key,
  }) : super(key: key);

  @override
  _EmptyState createState() => _EmptyState();
}

class _EmptyState extends State<_Empty> with SyncCollection {
  late TextEditingController _bggUserNameController;

  @override
  void initState() {
    super.initState();
    _bggUserNameController = TextEditingController();
  }

  @override
  void dispose() {
    _bggUserNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            Dimensions.doubleStandardSpacing,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 60,
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
                controller: _bggUserNameController,
                onSubmit: () async => syncCollection(context, _bggUserNameController.text),
              ),
              const SizedBox(
                height: Dimensions.standardSpacing,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SyncButton(usernameCallback: () => _bggUserNameController.text),
              ),
              const SizedBox(
                height: Dimensions.standardSpacing,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySearchResult extends StatelessWidget {
  const _EmptySearchResult({
    Key? key,
    required BoardGamesStore boardGamesStore,
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
                icon: const DefaultIcon(Icons.clear),
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
    Key? key,
    required this.boardGamesStore,
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
            Consumer<UserStore>(
              builder: (_, userStore, __) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "It looks like you don't have any board games in your ",
                          ),
                          TextSpan(
                            text: boardGamesStore.selectedTab
                                .toCollectionFlag()
                                .toHumandReadableText(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: ' collection yet.',
                          ),
                          if (boardGamesStore.selectedTab == GamesTab.Wishlist &&
                              (userStore.user?.name?.isNotEmpty ?? false)) ...[
                            const TextSpan(
                              text: "\n\nIf you want to see board games from BGG's  ",
                            ),
                            const TextSpan(
                              text: 'Wishlist ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: 'or ',
                            ),
                            const TextSpan(
                              text: 'Want to Buy ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: 'collection, then tap the below  ',
                            ),
                            const TextSpan(
                              text: 'Sync ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: 'button.'),
                          ]
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    if (boardGamesStore.selectedTab == GamesTab.Wishlist &&
                        (userStore.user?.name.isNotEmpty ?? false)) ...[
                      const SizedBox(
                        height: Dimensions.doubleStandardSpacing,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SyncButton(
                          usernameCallback: () => userStore.user!.name,
                        ),
                      ),
                    ]
                  ],
                );
              },
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
    Key? key,
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
