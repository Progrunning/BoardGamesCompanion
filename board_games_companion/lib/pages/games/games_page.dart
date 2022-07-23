import 'dart:async';

import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/models/navigation/board_game_details_page_arguments.dart';
import 'package:board_games_companion/pages/board_game_details/board_game_details_page.dart';
import 'package:board_games_companion/pages/games/games_view_model.dart';
import 'package:board_games_companion/widgets/common/slivers/bgc_sliver_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

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

typedef BoardGameResultTapped = void Function(BoardGameDetails boardGame);

class GamesPage extends StatefulWidget {
  const GamesPage(
    this.viewModel,
    this.userStore,
    this.analyticsService,
    this.rateAndReviewService, {
    Key? key,
  }) : super(key: key);

  final GamesViewModel viewModel;
  final UserStore userStore;
  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;

  @override
  GamesPageState createState() => GamesPageState();
}

class GamesPageState extends State<GamesPage> with SingleTickerProviderStateMixin {
  late TabController _topTabController;

  @override
  void initState() {
    _topTabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.viewModel.selectedTab.index,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.viewModel.loadDataState == LoadDataState.loaded) {
      if (!widget.viewModel.anyBoardGamesInCollections &&
          (widget.userStore.user?.name.isEmpty ?? true)) {
        return const _Empty();
      }

      return _Collection(
        viewModel: widget.viewModel,
        topTabController: _topTabController,
        analyticsService: widget.analyticsService,
        rateAndReviewService: widget.rateAndReviewService,
      );
    } else if (widget.viewModel.loadDataState == LoadDataState.error) {
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
    required this.viewModel,
    required this.topTabController,
    required this.analyticsService,
    required this.rateAndReviewService,
    Key? key,
  }) : super(key: key);

  final GamesViewModel viewModel;
  final TabController topTabController;
  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScrollView(
        slivers: <Widget>[
          _AppBar(
            viewModel: viewModel,
            topTabController: topTabController,
            analyticsService: analyticsService,
            rateAndReviewService: rateAndReviewService,
          ),
          if (viewModel.collectionSate == CollectionState.emptyCollection)
            _EmptyCollection(gamesViewModel: viewModel),
          if (viewModel.collectionSate == CollectionState.collection) ...[
            if (viewModel.hasAnyMainGameInSelectedCollection) ...[
              SliverPersistentHeader(
                delegate: BgcSliverHeaderDelegate(
                  title: sprintf(
                    AppText.gamesPageMainGamesSliverSectionTitleFormat,
                    [viewModel.totalMainGamesInCollections],
                  ),
                ),
              ),
              _Grid(
                boardGames: viewModel.mainGamesInCollections,
                analyticsService: analyticsService,
              ),
            ],
            if (viewModel.hasAnyExpansionsInSelectedCollection) ...[
              for (var expansionsMapEntry in viewModel.expansionGroupedByMainGame.entries) ...[
                SliverPersistentHeader(
                  delegate: BgcSliverHeaderDelegate(
                    title: sprintf(
                      AppText.gamesPageExpansionsSliverSectionTitleFormat,
                      [expansionsMapEntry.key.name, expansionsMapEntry.value.length],
                    ),
                  ),
                ),
                _Grid(
                  boardGames: expansionsMapEntry.value,
                  analyticsService: analyticsService,
                ),
              ]
            ]
          ],
          const SliverPadding(padding: EdgeInsets.all(8.0)),
        ],
      ),
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

  final GamesViewModel viewModel;
  final TabController topTabController;
  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;

  @override
  _AppBarState createState() => _AppBarState();
}

class _AppBarState extends State<_AppBar> {
  @override
  Widget build(BuildContext context) => SliverAppBar(
        pinned: false,
        floating: true,
        elevation: 0,
        titleSpacing: Dimensions.standardSpacing,
        foregroundColor: AppTheme.accentColor,
        title: const Text(
          AppText.collectionsPageTitle,
          style: TextStyle(color: AppTheme.whiteColor),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                await widget.rateAndReviewService.increaseNumberOfSignificantActions();
                await showSearch(
                  context: context,
                  delegate: _CollectionsSearch(
                    boardGames: widget.viewModel.allBoardGames,
                    onResultTap: (BoardGameDetails selectedBoardGame) {},
                  ),
                );
              },
              icon: const Icon(Icons.search)),
          Consumer<BoardGamesFiltersStore>(
            builder: (_, boardGamesFiltersStore, __) {
              return IconButton(
                icon: boardGamesFiltersStore.anyFiltersApplied
                    ? const Icon(Icons.filter_alt_rounded, color: AppTheme.accentColor)
                    : const Icon(Icons.filter_alt_outlined, color: AppTheme.accentColor),
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
          child: TabBar(
            onTap: (int index) {
              widget.viewModel.selectedTab = index.toGamesTab();
            },
            controller: widget.topTabController,
            tabs: <Widget>[
              _TopTab(
                'Owned',
                Icons.grid_on,
                isSelected: widget.viewModel.selectedTab == GamesTab.owned,
              ),
              _TopTab(
                'Friends',
                Icons.group,
                isSelected: widget.viewModel.selectedTab == GamesTab.friends,
              ),
              _TopTab(
                'Wishlist',
                Icons.card_giftcard,
                isSelected: widget.viewModel.selectedTab == GamesTab.wishlist,
              ),
            ],
            indicatorColor: AppTheme.accentColor,
          ),
        ),
      );

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
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    Key? key,
    required this.boardGames,
    required this.analyticsService,
  }) : super(key: key);

  final List<BoardGameDetails> boardGames;
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
          for (var boardGame in boardGames)
            BoardGameTile(
              id: boardGame.id,
              name: boardGame.name,
              imageUrl: boardGame.thumbnailUrl ?? '',
              rank: boardGame.rank,
              onTap: () => Navigator.pushNamed(
                context,
                PlaythroughsPage.pageRoute,
                arguments: PlaythroughsPageArguments(boardGame),
              ),
              heroTag: AnimationTags.boardGamePlaythroughImageHeroTag,
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
        const SliverAppBar(pinned: true, floating: true, foregroundColor: AppTheme.accentColor),
        SliverPadding(
          padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
          sliver: SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                SizedBox(height: 40),
                Center(
                  child: Text(
                    'Your games collection is empty',
                    style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
                  ),
                ),
                SizedBox(height: Dimensions.doubleStandardSpacing),
                Icon(
                  Icons.sentiment_dissatisfied_sharp,
                  size: 80,
                  color: AppTheme.primaryColor,
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
    required this.gamesViewModel,
  }) : super(key: key);

  final GamesViewModel gamesViewModel;

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
                            text: gamesViewModel.selectedTab
                                .toCollectionType()
                                .toHumandReadableText(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' collection yet.'),
                          if (gamesViewModel.selectedTab == GamesTab.wishlist &&
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
                    if (gamesViewModel.selectedTab == GamesTab.wishlist &&
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

class _CollectionsSearch extends SearchDelegate<BoardGameDetails?> {
  _CollectionsSearch({
    required this.boardGames,
    required this.onResultTap,
  });

  final List<BoardGameDetails> boardGames;
  final BoardGameResultTapped onResultTap;

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
      return ListView();
    }

    final filteredGames = _filterGames(query);
    if (filteredGames.isEmpty) {
      return _NoSearchResults(query: query, onClear: () => query = '');
    }

    return _SearchResults(filteredGames: filteredGames);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView();
    }

    final filteredGames = _filterGames(query);
    if (filteredGames.isEmpty) {
      return ListView();
    }

    return ListView.builder(
      itemCount: filteredGames.length,
      itemBuilder: (_, index) {
        final boardGame = filteredGames[index];
        return ListTile(
          title: Text(boardGame.name),
          onTap: () {
            query = boardGame.name;
            showResults(context);
          },
        );
      },
    );
  }

  List<BoardGameDetails> _filterGames(String query) {
    final queryLowercased = query.toLowerCase();
    return boardGames
        .where(
            (BoardGameDetails boardGame) => boardGame.name.toLowerCase().contains(queryLowercased))
        .toList();
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    Key? key,
    required this.filteredGames,
  }) : super(key: key);

  final List<BoardGameDetails> filteredGames;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: filteredGames.length,
      separatorBuilder: (_, index) => const SizedBox(height: Dimensions.doubleStandardSpacing),
      itemBuilder: (_, index) {
        return _SearchResultGame(
          filteredGames: filteredGames,
          boardGame: filteredGames[index],
          isFirstItem: index == 0,
          isLastItem: index == filteredGames.length - 1,
        );
      },
    );
  }
}

class _SearchResultGame extends StatelessWidget {
  const _SearchResultGame({
    Key? key,
    required this.filteredGames,
    required this.boardGame,
    required this.isFirstItem,
    required this.isLastItem,
  }) : super(key: key);

  final List<BoardGameDetails> filteredGames;
  final BoardGameDetails boardGame;
  final bool isFirstItem;
  final bool isLastItem;

  static const double _gameStatIconSize = 16;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: isFirstItem ? Dimensions.standardSpacing : 0,
        bottom: isLastItem ? Dimensions.standardSpacing : 0,
        left: Dimensions.standardSpacing,
        right: Dimensions.standardSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Dimensions.collectionSearchResultBoardGameImageHeight,
            width: Dimensions.collectionSearchResultBoardGameImageWidth,
            child: BoardGameTile(
              id: boardGame.id,
              imageUrl: boardGame.thumbnailUrl ?? '',
              heroTag: AnimationTags.boardGamePlaythroughImageHeroTag,
            ),
          ),
          const SizedBox(width: Dimensions.standardSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  boardGame.name,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.titleTextStyle,
                ),
                const SizedBox(height: Dimensions.halfStandardSpacing),
                _SearchResultGameGeneralStat(
                  icon: const Icon(Icons.people, size: _gameStatIconSize),
                  statistic: sprintf(
                    AppText.gamesPageSearchResultPlayersNumberGameStatFormat,
                    [boardGame.minPlayers, boardGame.maxPlayers],
                  ),
                ),
                const SizedBox(height: Dimensions.halfStandardSpacing),
                _SearchResultGameGeneralStat(
                  icon: const Icon(Icons.hourglass_bottom, size: _gameStatIconSize),
                  statistic: sprintf(
                    AppText.gamesPageSearchResultPlaytimeGameStatFormat,
                    [boardGame.playtimeFormatted],
                  ),
                ),
                if (boardGame.avgWeight != null) ...[
                  const SizedBox(height: Dimensions.halfStandardSpacing),
                  _SearchResultGameGeneralStat(
                    icon: const Icon(Icons.scale, size: _gameStatIconSize),
                    statistic: sprintf(
                      AppText.gamesPageSearchResultComplexityGameStatFormat,
                      [boardGame.avgWeight!.toStringAsFixed(2)],
                    ),
                  ),
                ]
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.info),
                onPressed: () => Navigator.pushNamed(
                  context,
                  BoardGamesDetailsPage.pageRoute,
                  arguments: BoardGameDetailsPageArguments(boardGame.id, boardGame.name, GamesPage),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.casino),
                onPressed: () => Navigator.pushNamed(
                  context,
                  PlaythroughsPage.pageRoute,
                  arguments: PlaythroughsPageArguments(boardGame),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _SearchResultGameGeneralStat extends StatelessWidget {
  const _SearchResultGameGeneralStat({
    Key? key,
    required this.icon,
    required this.statistic,
  }) : super(key: key);

  final Icon icon;
  final String statistic;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        const SizedBox(width: Dimensions.halfStandardSpacing),
        Text(
          statistic,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.subTitleTextStyle.copyWith(color: AppTheme.whiteColor),
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
    return Column(
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
    );
  }
}
