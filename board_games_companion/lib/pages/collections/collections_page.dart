import 'dart:async';

import 'package:basics/basics.dart';
import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/injectable.dart';
import 'package:board_games_companion/models/hive/search_history_entry.dart';
import 'package:board_games_companion/pages/collections/collections_view_model.dart';
import 'package:board_games_companion/widgets/common/panel_container.dart';
import 'package:board_games_companion/widgets/common/slivers/bgc_sliver_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:sprintf/sprintf.dart';
import 'package:tuple/tuple.dart';

import '../../common/analytics.dart';
import '../../common/animation_tags.dart';
import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/enums/collection_type.dart';
import '../../common/enums/games_tab.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/navigation/board_game_details_page_arguments.dart';
import '../../models/navigation/playthroughs_page_arguments.dart';
import '../../services/analytics_service.dart';
import '../../services/rate_and_review_service.dart';
import '../../stores/board_games_filters_store.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/app_bar/app_bar_bottom_tab.dart';
import '../../widgets/common/bgg_community_member_text_widget.dart';
import '../../widgets/common/bgg_community_member_user_name_text_field_widget.dart';
import '../../widgets/common/board_game/board_game_property.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/import_collections_button.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/common/rating_hexagon.dart';
import '../board_game_details/board_game_details_page.dart';
import '../playthroughs/playthroughs_page.dart';
import 'collection_search_result_view_model.dart';
import 'collections_filter_panel.dart';
import 'search_suggestion.dart';

enum BoardGameResultActionType {
  details,
  playthroughs,
}

typedef BoardGameResultAction = void Function(
  BoardGameDetails boardGame,
  BoardGameResultActionType actionType,
);

typedef SearchCallback = Future<List<BoardGameDetails>> Function(String query);

class CollectionsPage extends StatefulWidget {
  const CollectionsPage(
    this.viewModel,
    this.boardGamesFiltersStore,
    this.analyticsService,
    this.rateAndReviewService, {
    Key? key,
  }) : super(key: key);

  final CollectionsViewModel viewModel;
  final BoardGamesFiltersStore boardGamesFiltersStore;
  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;

  @override
  CollectionsPageState createState() => CollectionsPageState();
}

class CollectionsPageState extends State<CollectionsPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _topTabController;

  @override
  void initState() {
    super.initState();

    _topTabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.viewModel.selectedTab.index,
    );
    widget.viewModel.loadBoardGames();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        switch (widget.viewModel.futureLoadBoardGames?.status ?? FutureStatus.pending) {
          case FutureStatus.pending:
            return const LoadingIndicator();
          case FutureStatus.rejected:
            return const Center(child: GenericErrorMessage());
          case FutureStatus.fulfilled:
            // TODO Use visual states instead
            if (!widget.viewModel.anyBoardGamesInCollections &&
                (widget.viewModel.isUserNameEmpty)) {
              return const _Empty();
            }

            return Observer(
              builder: (_) {
                return _Collection(
                  viewModel: widget.viewModel,
                  isCollectionEmpty: widget.viewModel.isCollectionEmpty,
                  hasMainGames: widget.viewModel.anyMainGamesInCollection,
                  mainGames: widget.viewModel.mainGamesInCollection,
                  totalMainGames: widget.viewModel.totalMainGamesInCollection,
                  hasExpansions: widget.viewModel.anyExpansionsInCollection,
                  expansionsMap: widget.viewModel.expansionsInCollectionMap,
                  selectedTab: widget.viewModel.selectedTab,
                  topTabController: _topTabController,
                  analyticsService: widget.analyticsService,
                  rateAndReviewService: widget.rateAndReviewService,
                );
              },
            );
        }
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    widget.viewModel.loadBoardGames();
  }

  @override
  void dispose() {
    _topTabController.dispose();
    super.dispose();
  }
}

class _Collection extends StatelessWidget {
  const _Collection({
    required this.viewModel,
    required this.isCollectionEmpty,
    required this.hasMainGames,
    required this.mainGames,
    required this.totalMainGames,
    required this.hasExpansions,
    required this.expansionsMap,
    required this.selectedTab,
    required this.topTabController,
    required this.analyticsService,
    required this.rateAndReviewService,
    Key? key,
  }) : super(key: key);

  final CollectionsViewModel viewModel;
  final bool isCollectionEmpty;
  final bool hasMainGames;
  final List<BoardGameDetails> mainGames;
  final int totalMainGames;
  final bool hasExpansions;
  final Map<Tuple2<String, String>, List<BoardGameDetails>> expansionsMap;
  final GamesTab selectedTab;
  final TabController topTabController;
  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        _AppBar(
          viewModel: viewModel,
          topTabController: topTabController,
          analyticsService: analyticsService,
          rateAndReviewService: rateAndReviewService,
        ),
        if (isCollectionEmpty)
          Observer(
            builder: (_) {
              return _EmptyCollection(
                selectedTab: selectedTab,
                userName: viewModel.userName,
              );
            },
          ),
        if (!isCollectionEmpty) ...[
          if (hasMainGames) ...[
            SliverPersistentHeader(
              delegate: BgcSliverHeaderDelegate(
                primaryTitle: sprintf(
                  AppText.gamesPageMainGamesSliverSectionTitleFormat,
                  [totalMainGames],
                ),
              ),
            ),
            _Grid(boardGamesDetails: mainGames, analyticsService: analyticsService),
          ],
          if (hasExpansions) ...[
            for (var expansionsMapEntry in expansionsMap.entries) ...[
              SliverPersistentHeader(
                delegate: BgcSliverHeaderDelegate(
                  primaryTitle: sprintf(
                    AppText.gamesPageExpansionsSliverSectionTitleFormat,
                    [expansionsMapEntry.key.item2, expansionsMapEntry.value.length],
                  ),
                ),
              ),
              _Grid(
                boardGamesDetails: expansionsMapEntry.value,
                analyticsService: analyticsService,
              ),
            ]
          ]
        ],
        const SliverPadding(padding: EdgeInsets.all(8.0)),
      ],
    );
  }
}

class _AppBar extends StatefulWidget {
  const _AppBar({
    required this.viewModel,
    required this.topTabController,
    required this.analyticsService,
    required this.rateAndReviewService,
    Key? key,
  }) : super(key: key);

  final CollectionsViewModel viewModel;
  final TabController topTabController;
  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;

  @override
  _AppBarState createState() => _AppBarState();
}

class _AppBarState extends State<_AppBar> {
  @override
  Widget build(BuildContext context) => SliverAppBar(
        pinned: true,
        floating: true,
        forceElevated: true,
        elevation: Dimensions.defaultElevation,
        titleSpacing: Dimensions.standardSpacing,
        foregroundColor: AppColors.accentColor,
        title: const Text(
          AppText.collectionsPageTitle,
          style: TextStyle(color: AppColors.whiteColor),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                await widget.rateAndReviewService.increaseNumberOfSignificantActions();
                await showSearch(
                  context: context,
                  delegate: _CollectionsSearch(
                    viewModel: widget.viewModel,
                    onResultAction: (boardGame, actionType) async =>
                        _handleSearchResultAction(boardGame, actionType),
                    onSearch: (query) => widget.viewModel.search(query),
                  ),
                );
              },
              icon: const Icon(Icons.search)),
          Observer(
            builder: (_) {
              return IconButton(
                icon: widget.viewModel.anyFiltersApplied
                    ? const Icon(Icons.filter_alt_rounded, color: AppColors.accentColor)
                    : const Icon(Icons.filter_alt_outlined, color: AppColors.accentColor),
                onPressed: widget.viewModel.anyBoardGames
                    ? () async {
                        await _openFiltersPanel(context);
                        await widget.analyticsService.logEvent(name: Analytics.filterCollection);
                        await widget.rateAndReviewService.increaseNumberOfSignificantActions();
                      }
                    : null,
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(74),
          child: Observer(builder: (_) {
            return TabBar(
              onTap: (int index) => widget.viewModel.selectedTab = index.toCollectionsTab(),
              controller: widget.topTabController,
              tabs: <Widget>[
                AppBarBottomTab(
                  'Owned',
                  Icons.grid_on,
                  isSelected: widget.viewModel.selectedTab == GamesTab.owned,
                ),
                AppBarBottomTab(
                  'Friends',
                  Icons.group,
                  isSelected: widget.viewModel.selectedTab == GamesTab.friends,
                ),
                AppBarBottomTab(
                  'Wishlist',
                  Icons.card_giftcard,
                  isSelected: widget.viewModel.selectedTab == GamesTab.wishlist,
                ),
              ],
              indicatorColor: AppColors.accentColor,
            );
          }),
        ),
      );

  Future<void> _openFiltersPanel(BuildContext context) async {
    await showModalBottomSheet<Widget>(
      backgroundColor: AppColors.primaryColor,
      elevation: Dimensions.defaultElevation,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppStyles.defaultBottomSheetCornerRadius),
          topRight: Radius.circular(AppStyles.defaultBottomSheetCornerRadius),
        ),
      ),
      context: context,
      builder: (_) {
        return CollectionsFilterPanel(viewModel: widget.viewModel);
      },
    );
  }

  Future<void> _handleSearchResultAction(
    BoardGameDetails boardGameDetails,
    BoardGameResultActionType actionType,
  ) async {
    switch (actionType) {
      case BoardGameResultActionType.details:
        unawaited(Navigator.pushNamed(
          context,
          BoardGamesDetailsPage.pageRoute,
          arguments: BoardGameDetailsPageArguments(
            boardGameId: boardGameDetails.id,
            boardGameName: boardGameDetails.name,
            boardGameImageHeroId: boardGameDetails.id,
            navigatingFromType: CollectionsPage,
            boardGameImageUrl: boardGameDetails.imageUrl,
          ),
        ));
        break;
      case BoardGameResultActionType.playthroughs:
        unawaited(Navigator.pushNamed(
          context,
          PlaythroughsPage.pageRoute,
          arguments: PlaythroughsPageArguments(
            boardGameDetails: boardGameDetails,
            boardGameImageHeroId: boardGameDetails.id,
          ),
        ));
        break;
    }
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    Key? key,
    required this.boardGamesDetails,
    required this.analyticsService,
  }) : super(key: key);

  final List<BoardGameDetails> boardGamesDetails;
  final AnalyticsService analyticsService;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      sliver: SliverGrid.extent(
        crossAxisSpacing: Dimensions.standardSpacing,
        mainAxisSpacing: Dimensions.standardSpacing,
        maxCrossAxisExtent: Dimensions.boardGameItemCollectionImageWidth,
        children: [
          for (var boardGameDetails in boardGamesDetails)
            BoardGameTile(
              id: boardGameDetails.id,
              name: boardGameDetails.name,
              imageUrl: boardGameDetails.thumbnailUrl ?? '',
              rank: boardGameDetails.rank,
              elevation: AppStyles.defaultElevation,
              onTap: () => Navigator.pushNamed(
                context,
                PlaythroughsPage.pageRoute,
                arguments: PlaythroughsPageArguments(
                  boardGameDetails: boardGameDetails,
                  boardGameImageHeroId: boardGameDetails.id,
                ),
              ),
              heroTag: AnimationTags.boardGameHeroTag,
            )
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(pinned: true, floating: true, foregroundColor: AppColors.accentColor),
        SliverPadding(
          padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
          sliver: SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                SizedBox(height: Dimensions.emptyPageTitleTopSpacing),
                Center(
                  child: Text(
                    'Your games collection is empty',
                    style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
                  ),
                ),
                SizedBox(height: Dimensions.doubleStandardSpacing),
                Icon(
                  Icons.sentiment_dissatisfied_sharp,
                  size: Dimensions.emptyPageTitleIconSize,
                  color: AppColors.primaryColor,
                ),
                SizedBox(height: Dimensions.doubleStandardSpacing),
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
                      TextSpan(text: 'Search', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text:
                            ' tab to check out current TOP 50 hot board games or look up any title and start adding them to your collections.\n',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: Dimensions.mediumFontSize),
                ),
                BggCommunityMemberText(),
                _ImportDataFromBggSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ImportDataFromBggSection extends StatefulWidget {
  const _ImportDataFromBggSection({Key? key}) : super(key: key);

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
          onSubmit: () => setState(() {
            _triggerImport = true;
          }),
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

class _EmptyCollection extends StatelessWidget {
  const _EmptyCollection({
    Key? key,
    required this.selectedTab,
    required this.userName,
  }) : super(key: key);

  final GamesTab selectedTab;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.doubleStandardSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Observer(
              builder: (_) {
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
                            text: selectedTab.toCollectionType().toHumandReadableText(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' collection yet.'),
                          if (selectedTab == GamesTab.wishlist && (userName.isNotNullOrBlank)) ...[
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
                    if (selectedTab == GamesTab.wishlist && (userName.isNotNullOrBlank)) ...[
                      const SizedBox(height: Dimensions.doubleStandardSpacing),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ImportCollectionsButton(usernameCallback: () => userName!),
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

class _CollectionsSearch extends SearchDelegate<BoardGameDetails?> {
  _CollectionsSearch({
    required this.viewModel,
    required this.onResultAction,
    required this.onSearch,
  });

  static const int _maxSearchHistoryEntriesToShow = 10;

  final CollectionsViewModel viewModel;
  final BoardGameResultAction onResultAction;
  final SearchCallback onSearch;

  @override
  ThemeData appBarTheme(BuildContext context) => AppTheme.theme.copyWith(
        textTheme: const TextTheme(headline6: AppTheme.defaultTextFieldStyle),
      );

  @override
  String? get searchFieldLabel => AppText.collectionsSearchHintText;

  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.isEmpty) {
      return [const SizedBox()];
    }

    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return PageContainer(child: ListView());
    }

    return FutureBuilder(
      future: onSearch(query),
      builder: (context, AsyncSnapshot<List<BoardGameDetails>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            final filteredGames = snapshot.data;
            if (filteredGames?.isEmpty ?? true) {
              return PageContainer(
                child: _NoSearchResults(
                  query: query,
                  onClear: () => query = '',
                ),
              );
            }

            return PageContainer(
              child: _SearchResults(filteredGames: filteredGames!, onResultAction: onResultAction),
            );
        }

        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView();
    }

    final suggestions = _findSuggestions(query);
    if (suggestions.isEmpty) {
      return ListView();
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (_, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: Icon(
            suggestion.type == SuggestionType.boardGame ? Icons.search : Icons.history,
            color: AppColors.whiteColor,
          ),
          title: Text(suggestion.suggestion),
          onTap: () {
            query = suggestion.suggestion;
            showResults(context);
          },
        );
      },
    );
  }

  List<SearchSuggestion> _findSuggestions(String query) {
    final suggestions = <SearchSuggestion>[];
    final queryLowercased = query.toLowerCase();

    suggestions.addAll(
      viewModel.searchHistory
          .where((SearchHistoryEntry entry) => entry.query.toLowerCase().contains(queryLowercased))
          .take(_maxSearchHistoryEntriesToShow)
          .map((SearchHistoryEntry entry) => SearchSuggestion(
                suggestion: entry.query,
                type: SuggestionType.historicalSearch,
              ))
          .toList(),
    );
    suggestions.addAll(
      viewModel.allBoardGames
          .where((BoardGameDetails boardGame) =>
              boardGame.name.toLowerCase().contains(queryLowercased))
          .map((BoardGameDetails boardGame) => SearchSuggestion(
                suggestion: boardGame.name,
                type: SuggestionType.boardGame,
              ))
          .toList(),
    );

    return suggestions;
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    Key? key,
    required this.filteredGames,
    required this.onResultAction,
  }) : super(key: key);

  final List<BoardGameDetails> filteredGames;
  final BoardGameResultAction onResultAction;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: filteredGames.length,
      separatorBuilder: (_, index) => const SizedBox(height: Dimensions.standardSpacing),
      itemBuilder: (_, index) {
        final boardGame = filteredGames[index];
        final viewModel = getIt<CollectionSearchResultViewModel>();
        viewModel.setBoardGameId(boardGame.id);

        return Observer(
          builder: (_) {
            return _SearchResultGame(
              boardGame: viewModel.boardGame!,
              expansions: viewModel.expansions,
              hasIncompleteDetails: viewModel.boardGame!.hasIncompleteDetails,
              isFirstItem: index == 0,
              isLastItem: index == filteredGames.length - 1,
              onResultAction: onResultAction,
              onRefresh: () => viewModel.refreshBoardGameDetails(),
            );
          },
        );
      },
    );
  }
}

class _SearchResultGame extends StatelessWidget {
  const _SearchResultGame({
    Key? key,
    required this.boardGame,
    required this.expansions,
    required this.hasIncompleteDetails,
    required this.isFirstItem,
    required this.isLastItem,
    required this.onResultAction,
    required this.onRefresh,
  }) : super(key: key);

  final BoardGameDetails boardGame;
  final List<BoardGameDetails>? expansions;
  final bool hasIncompleteDetails;
  final bool isFirstItem;
  final bool isLastItem;
  final BoardGameResultAction onResultAction;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: isFirstItem ? Dimensions.standardSpacing : 0,
        bottom: isLastItem ? Dimensions.standardSpacing : 0,
        left: Dimensions.standardSpacing,
        right: Dimensions.standardSpacing,
      ),
      child: PanelContainer(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Dimensions.collectionSearchResultBoardGameImageHeight,
                      width: Dimensions.collectionSearchResultBoardGameImageWidth,
                      child: BoardGameTile(
                        id: boardGame.id,
                        imageUrl: boardGame.thumbnailUrl ?? '',
                      ),
                    ),
                    const SizedBox(width: Dimensions.standardSpacing),
                    Expanded(child: _SearchResultGameDetails(boardGame: boardGame)),
                    _SearchResultGameActions(boardGame: boardGame, onResultAction: onResultAction),
                  ],
                ),
              ),
              if (boardGame.hasIncompleteDetails)
                _SearchResultGameRefreshData(
                  boardGame: boardGame,
                  onRefresh: onRefresh,
                ),
              if (expansions?.isNotEmpty ?? false)
                _SearchResultGameExpansions(
                  expansions: expansions!,
                  onResultAction: onResultAction,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchResultGameExpansions extends StatelessWidget {
  const _SearchResultGameExpansions({
    required this.expansions,
    required this.onResultAction,
    Key? key,
  }) : super(key: key);

  final List<BoardGameDetails> expansions;
  final BoardGameResultAction onResultAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimensions.doubleStandardSpacing),
        const Divider(),
        const SizedBox(height: Dimensions.standardSpacing),
        Text(
          sprintf(AppText.gamesPageSearchResultExpansionsSectionTitleFormat, [expansions.length]),
          style: AppTheme.theme.textTheme.subtitle1,
        ),
        const SizedBox(height: Dimensions.standardSpacing),
        SizedBox(
          height: Dimensions.collectionSearchResultExpansionsImageHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: expansions.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: Dimensions.doubleStandardSpacing),
            itemBuilder: (context, index) {
              final BoardGameDetails expansion = expansions[index];
              return SizedBox(
                height: Dimensions.collectionSearchResultExpansionsImageHeight,
                width: Dimensions.collectionSearchResultExpansionsImageWidth,
                // TODO MK Need to fix hero animation if the expansion is shown in the main game results and as well as a regular search result
                child: BoardGameTile(
                  id: '${expansion.id}-exp',
                  name: expansion.name,
                  nameFontSize: Dimensions.extraSmallFontSize,
                  imageUrl: expansion.thumbnailUrl ?? '',
                  elevation: AppStyles.defaultElevation,
                  onTap: () async => onResultAction(expansion, BoardGameResultActionType.details),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchResultGameRefreshData extends StatefulWidget {
  const _SearchResultGameRefreshData({
    required this.boardGame,
    required this.onRefresh,
    Key? key,
  }) : super(key: key);

  final BoardGameDetails boardGame;
  final VoidCallback onRefresh;

  @override
  State<_SearchResultGameRefreshData> createState() => _SearchResultGameRefreshDataState();
}

class _SearchResultGameRefreshDataState extends State<_SearchResultGameRefreshData>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Dimensions.doubleStandardSpacing),
        const Divider(),
        const SizedBox(height: Dimensions.standardSpacing),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outlined, size: Dimensions.smallButtonIconSize),
            const SizedBox(width: Dimensions.standardSpacing),
            Expanded(
              child: Text(
                AppText.gamesPageSearchResultRefreshDetails,
                style: AppTheme.theme.textTheme.subtitle1,
              ),
            ),
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  _controller.repeat();
                  widget.onRefresh();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SearchResultGameDetails extends StatelessWidget {
  const _SearchResultGameDetails({
    Key? key,
    required this.boardGame,
  }) : super(key: key);

  final BoardGameDetails boardGame;

  static const double _gameStatIconSize = 16;
  static const double _gamePropertyIconSize = 20;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          boardGame.name,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: Dimensions.standardSpacing),
        BoardGameProperty(
          icon: const Icon(Icons.people, size: _gameStatIconSize),
          iconWidth: _gamePropertyIconSize,
          propertyName: boardGame.playersFormatted,
        ),
        const SizedBox(height: Dimensions.standardSpacing),
        BoardGameProperty(
          icon: const Icon(Icons.hourglass_bottom, size: _gameStatIconSize),
          iconWidth: _gamePropertyIconSize,
          propertyName: boardGame.playtimeFormatted,
        ),
        if (boardGame.avgWeight != null) ...[
          const SizedBox(height: Dimensions.standardSpacing),
          BoardGameProperty(
            icon: const FaIcon(FontAwesomeIcons.scaleUnbalanced, size: _gameStatIconSize),
            iconWidth: _gamePropertyIconSize,
            propertyName: sprintf(
              AppText.gamesPageSearchResultComplexityGameStatFormat,
              [boardGame.avgWeight!.toStringAsFixed(2)],
            ),
          ),
        ],
        if (boardGame.rating != null) ...[
          const SizedBox(height: Dimensions.standardSpacing),
          BoardGameProperty(
            icon: const RatingHexagon(width: _gameStatIconSize, height: _gameStatIconSize),
            iconWidth: _gamePropertyIconSize,
            propertyName:
                boardGame.rating!.toStringAsFixed(Constants.boardGameRatingNumberOfDecimalPlaces),
          ),
        ]
      ],
    );
  }
}

class _SearchResultGameActions extends StatelessWidget {
  const _SearchResultGameActions({
    Key? key,
    required this.boardGame,
    required this.onResultAction,
  }) : super(key: key);

  final BoardGameDetails boardGame;
  final BoardGameResultAction onResultAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => onResultAction(boardGame, BoardGameResultActionType.details),
        ),
        const Expanded(child: SizedBox.shrink()),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.dice),
          onPressed: () => onResultAction(boardGame, BoardGameResultActionType.playthroughs),
        ),
      ],
    );
  }
}

class _NoSearchResults extends StatelessWidget {
  const _NoSearchResults({
    Key? key,
    required this.query,
    required this.onClear,
  }) : super(key: key);

  final String query;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.doubleStandardSpacing),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: AppText.gamesPageSearchNoSearchResults),
                TextSpan(
                  text: query,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: Dimensions.standardSpacing),
          Center(
            child: ElevatedIconButton(
              title: AppText.gamesPageSearchClearSaerch,
              icon: const DefaultIcon(Icons.clear),
              onPressed: onClear,
            ),
          ),
        ],
      ),
    );
  }
}
