import 'dart:async';

import 'package:board_games_companion/common/app_text.dart';
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
import '../../models/hive/board_game_details.dart';
import '../../models/navigation/playthroughs_page_arguments.dart';
import '../../services/analytics_service.dart';
import '../../services/rate_and_review_service.dart';
import '../../stores/board_games_filters_store.dart';
import '../../stores/board_games_store.dart';
import '../../stores/user_store.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/bgg_community_member_text_widget.dart';
import '../../widgets/common/bgg_community_member_user_name_text_field_widget.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/import_collections_button.dart';
import '../../widgets/common/loading_indicator_widget.dart';
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
    if (widget.boardGamesStore.loadDataState == LoadDataState.loaded) {
      if (!widget.boardGamesStore.anyBoardGamesInCollections &&
          (widget.userStore.user?.name.isEmpty ?? true)) {
        return const _Empty();
      }

      return _Collection(
        boardGamesStore: widget.boardGamesStore,
        topTabController: _topTabController,
        analyticsService: widget.analyticsService,
        rateAndReviewService: widget.rateAndReviewService,
      );
    } else if (widget.boardGamesStore.loadDataState == LoadDataState.error) {
      return const Center(
        child: GenericErrorMessage(),
      );
    }

    return const LoadingIndicator();
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
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: CustomScrollView(
          slivers: <Widget>[
            _AppBar(
              boardGamesStore: boardGamesStore,
              topTabController: topTabController,
              analyticsService: analyticsService,
              rateAndReviewService: rateAndReviewService,
              updateSearchResults: (String searchPhrase) => _updateSearchResults(searchPhrase),
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
                    return _EmptySearchResult(
                      boardGamesStore: boardGamesStore,
                      onClearSearch: () => _updateSearchResults(''),
                    );
                  }

                  return _EmptyCollection(
                    boardGamesStore: boardGamesStore,
                  );
                }

                return _Grid(
                  boardGames: boardGames,
                  collectionType: boardGamesStore.selectedTab.toCollectionType(),
                  analyticsService: analyticsService,
                );
              },
            ),
            const SliverPadding(padding: EdgeInsets.all(8.0)),
          ],
        ),
      ),
    );
  }

  Future<void> _updateSearchResults(String searchPhrase) async {
    boardGamesStore.updateSearchResults(searchPhrase);

    await rateAndReviewService.increaseNumberOfSignificantActions();
  }
}

class _AppBar extends StatefulWidget {
  const _AppBar({
    required this.boardGamesStore,
    required this.topTabController,
    required this.analyticsService,
    required this.rateAndReviewService,
    required this.updateSearchResults,
    Key? key,
  }) : super(key: key);

  final BoardGamesStore boardGamesStore;
  final TabController topTabController;
  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;
  final Future Function(String) updateSearchResults;

  @override
  _AppBarState createState() => _AppBarState();
}

class _AppBarState extends State<_AppBar> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchController.addListener(_handleSearchChanged);

    _searchFocusNode = FocusNode();
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
      foregroundColor: AppTheme.accentColor,
      title: TextField(
        autofocus: false,
        focusNode: _searchFocusNode,
        controller: _searchController,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        style: AppTheme.defaultTextFieldStyle,
        decoration: InputDecoration(
          hintText: 'Search for a game...',
          suffixIcon: (widget.boardGamesStore.searchPhrase?.isNotEmpty ?? false)
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                  ),
                  color: AppTheme.accentColor,
                  onPressed: () async {
                    _searchController.text = '';
                    await widget.updateSearchResults('');
                  },
                )
              : const Icon(Icons.search, color: AppTheme.accentColor),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColorLight),
          ),
        ),
        onSubmitted: (searchPhrase) async {
          _debounce?.cancel();
          if (widget.boardGamesStore.searchPhrase != _searchController.text) {
            await widget.updateSearchResults(_searchController.text);
          }
          _searchFocusNode.unfocus();
        },
      ),
      actions: <Widget>[
        Consumer<BoardGamesFiltersStore>(
          builder: (_, boardGamesFiltersStore, __) {
            return IconButton(
              icon: boardGamesFiltersStore.anyFiltersApplied
                  ? const Icon(Icons.filter_alt_rounded, color: AppTheme.accentColor)
                  : const Icon(Icons.filter_alt_outlined, color: AppTheme.accentColor),
              onPressed: widget.boardGamesStore.allboardGames.isNotEmpty
                  ? () async {
                      await _openFiltersPanel(context);
                      await widget.analyticsService.logEvent(name: Analytics.FilterCollection);
                      await widget.rateAndReviewService.increaseNumberOfSignificantActions();
                    }
                  : null,
            );
          },
        ),
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

    _searchFocusNode.unfocus();
  }

  void _handleSearchChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => widget.updateSearchResults(_searchController.text),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_handleSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();

    super.dispose();
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    Key? key,
    required this.boardGames,
    required this.collectionType,
    required this.analyticsService,
  }) : super(key: key);

  final List<BoardGameDetails> boardGames;
  final CollectionType collectionType;
  final AnalyticsService analyticsService;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
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
                await Navigator.pushNamed(
                  context,
                  PlaythroughsPage.pageRoute,
                  arguments: PlaythroughsPageArguments(boardGames[index], collectionType),
                );
              },
              heroTag: '${AnimationTags.boardGamePlaythroughImageHeroTag}_$collectionType',
            );
          },
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({
    Key? key,
  }) : super(key: key);

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
            children: const <Widget>[
              SizedBox(
                height: 60,
              ),
              Center(
                child: Text(
                  'Your games collection is empty',
                  style: TextStyle(
                    fontSize: Dimensions.extraLargeFontSize,
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.doubleStandardSpacing,
              ),
              Icon(
                Icons.sentiment_dissatisfied_sharp,
                size: 80,
                color: AppTheme.primaryColor,
              ),
              SizedBox(
                height: Dimensions.doubleStandardSpacing,
              ),
              Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: 'Nothing to worry about though! ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'Follow the below instructions to fill up this screen with board games.\n\n',
                    ),
                    TextSpan(text: 'Use the bottom '),
                    TextSpan(
                      text: 'Search',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          ' tab to check out current TOP 50 hot board games or look up any title.\n',
                    ),
                  ],
                ),
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: Dimensions.mediumFontSize),
              ),
              BggCommunityMemberText(),
              _ImportDataFromBggSection(),
              SizedBox(height: Dimensions.standardSpacing),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImportDataFromBggSection extends StatefulWidget {
  const _ImportDataFromBggSection({
    Key? key,
  }) : super(key: key);

  @override
  State<_ImportDataFromBggSection> createState() => _ImportDataFromBggSectionState();
}

class _ImportDataFromBggSectionState extends State<_ImportDataFromBggSection> {
  late TextEditingController _bggUserNameController;

  bool? _triggerImport;

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
    return Column(
      children: [
        BggCommunityMemberUserNameTextField(
          controller: _bggUserNameController,
          onSubmit: () {
            setState(() {
              _triggerImport = true;
            });
          },
        ),
        const SizedBox(height: Dimensions.standardSpacing),
        Align(
          alignment: Alignment.centerRight,
          child: ImportCollectionsButton(
            usernameCallback: () => _bggUserNameController.text,
            triggerImport: _triggerImport ?? false,
          ),
        ),
      ],
    );
  }
}

class _EmptySearchResult extends StatelessWidget {
  const _EmptySearchResult({
    required this.boardGamesStore,
    required this.onClearSearch,
    Key? key,
  }) : super(key: key);

  final BoardGamesStore boardGamesStore;
  final VoidCallback onClearSearch;

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
                    text: boardGamesStore.searchPhrase,
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
              child: ElevatedIconButton(
                title: 'Clear search',
                icon: const DefaultIcon(Icons.clear),
                onPressed: onClearSearch,
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
                                .toCollectionType()
                                .toHumandReadableText(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' collection yet.'),
                          if (boardGamesStore.selectedTab == GamesTab.Wishlist &&
                              (userStore.user?.name.isNotEmpty ?? false)) ...[
                            const TextSpan(text: "\n\nIf you want to see board games from BGG's  "),
                            const TextSpan(
                              text: 'Wishlist ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: 'or '),
                            const TextSpan(
                              text: 'Want to Buy ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: 'collections then tap the below  '),
                            const TextSpan(
                              text: '${AppText.importCollectionsButtonText} ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: 'button.'),
                          ]
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    if (boardGamesStore.selectedTab == GamesTab.Wishlist &&
                        (userStore.user?.name.isNotEmpty ?? false)) ...[
                      const SizedBox(height: Dimensions.doubleStandardSpacing),
                      Align(
                        alignment: Alignment.centerRight,
                        child:
                            ImportCollectionsButton(usernameCallback: () => userStore.user!.name),
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
