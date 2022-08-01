import 'dart:async';

import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/injectable.dart';
import 'package:board_games_companion/pages/games/games_view_model.dart';
import 'package:board_games_companion/widgets/common/slivers/bgc_sliver_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

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
import '../../stores/user_store.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/bgg_community_member_text_widget.dart';
import '../../widgets/common/bgg_community_member_user_name_text_field_widget.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/import_collections_button.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/rating_hexagon.dart';
import '../../widgets/elevated_container.dart';
import '../board_game_details/board_game_details_page.dart';
import '../playthroughs/playthroughs_page.dart';
import 'collection_search_result_view_model.dart';
import 'games_filter_panel.dart';

enum BoardGameResultActionType {
  details,
  playthroughs,
}

typedef BoardGameResultAction = void Function(
  BoardGameDetails boardGame,
  BoardGameResultActionType actionType,
);

class GamesPage extends StatefulWidget {
  const GamesPage(
    this.viewModel,
    this.userStore,
    this.boardGamesFiltersStore,
    this.analyticsService,
    this.rateAndReviewService, {
    Key? key,
  }) : super(key: key);

  final GamesViewModel viewModel;
  final UserStore userStore;
  final BoardGamesFiltersStore boardGamesFiltersStore;
  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;

  @override
  GamesPageState createState() => GamesPageState();
}

class GamesPageState extends State<GamesPage>
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
      child: Observer(builder: (_) {
        return CustomScrollView(
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
                for (var expansionsMapEntry
                    in viewModel.expansionsInSelectedCollectionGroupedByMainGame.entries) ...[
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
        );
      }),
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
            indicatorColor: AppColors.accentColor,
          ),
        ),
      );

  Future<void> _openFiltersPanel(BuildContext context) async {
    await showModalBottomSheet<Widget>(
      backgroundColor: AppColors.primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppStyles.defaultBottomSheetCornerRadius),
          topRight: Radius.circular(AppStyles.defaultBottomSheetCornerRadius),
        ),
      ),
      context: context,
      builder: (_) {
        return GamesFilterPanel(gamesViewModel: widget.viewModel);
      },
    );
  }

  Future<void> _handleSearchResultAction(
      BoardGameDetails boardGame, BoardGameResultActionType actionType) async {
    switch (actionType) {
      case BoardGameResultActionType.details:
        unawaited(Navigator.pushNamed(
          context,
          BoardGamesDetailsPage.pageRoute,
          arguments: BoardGameDetailsPageArguments(boardGame.id, boardGame.name, GamesPage),
        ));
        break;
      case BoardGameResultActionType.playthroughs:
        unawaited(Navigator.pushNamed(
          context,
          PlaythroughsPage.pageRoute,
          arguments: PlaythroughsPageArguments(boardGame),
        ));
        break;
    }
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
              elevation: AppStyles.defaultElevation,
              onTap: () => Navigator.pushNamed(
                context,
                PlaythroughsPage.pageRoute,
                arguments: PlaythroughsPageArguments(boardGame),
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
    required this.gamesViewModel,
  }) : super(key: key);

  final GamesViewModel gamesViewModel;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.doubleStandardSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<UserStore>(
              builder: (_, userStore, __) {
                return Observer(
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
                                text: gamesViewModel.selectedTab
                                    .toCollectionType()
                                    .toHumandReadableText(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: ' collection yet.'),
                              if (gamesViewModel.selectedTab == GamesTab.wishlist &&
                                  (userStore.user?.name.isNotEmpty ?? false)) ...[
                                const TextSpan(
                                    text: "\n\nIf you want to see board games from BGG's  "),
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
                            child: ImportCollectionsButton(
                                usernameCallback: () => userStore.user!.name),
                          ),
                        ]
                      ],
                    );
                  },
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
            color: isSelected ? AppColors.selectedTabIconColor : AppColors.deselectedTabIconColor,
          ),
          iconMargin: const EdgeInsets.only(
            bottom: Dimensions.halfStandardSpacing,
          ),
          child: Text(
            title,
            style: AppTheme.titleTextStyle.copyWith(
              fontSize: Dimensions.standardFontSize,
              color: isSelected ? AppColors.defaultTextColor : AppColors.deselectedTabIconColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _CollectionsSearch extends SearchDelegate<BoardGameDetails?> {
  _CollectionsSearch({
    required this.viewModel,
    required this.onResultAction,
  });

  final GamesViewModel viewModel;
  final BoardGameResultAction onResultAction;

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

    return _SearchResults(filteredGames: filteredGames, onResultAction: onResultAction);
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
    return viewModel.allBoardGames
        .where(
            (BoardGameDetails boardGame) => boardGame.name.toLowerCase().contains(queryLowercased))
        .toList();
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
    required this.isFirstItem,
    required this.isLastItem,
    required this.onResultAction,
    required this.onRefresh,
  }) : super(key: key);

  final BoardGameDetails boardGame;
  final List<BoardGameDetails>? expansions;
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
      child: ElevatedContainer(
        backgroundColor: AppColors.primaryColor,
        elevation: AppStyles.defaultElevation,
        borderRadius: const BorderRadius.all(Radius.circular(AppStyles.defaultCornerRadius)),
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
                        heroTag: AnimationTags.boardGameHeroTag,
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
        _SearchResultGameGeneralStats(
          icon: const Icon(Icons.people, size: _gameStatIconSize),
          statistic: sprintf(
            AppText.gamesPageSearchResultPlayersNumberGameStatFormat,
            [boardGame.minPlayers, boardGame.maxPlayers],
          ),
        ),
        const SizedBox(height: Dimensions.standardSpacing),
        _SearchResultGameGeneralStats(
          icon: const Icon(Icons.hourglass_bottom, size: _gameStatIconSize),
          statistic: sprintf(
            AppText.gamesPageSearchResultPlaytimeGameStatFormat,
            [boardGame.playtimeFormatted],
          ),
        ),
        if (boardGame.avgWeight != null) ...[
          const SizedBox(height: Dimensions.standardSpacing),
          _SearchResultGameGeneralStats(
            icon: const FaIcon(FontAwesomeIcons.scaleUnbalanced, size: _gameStatIconSize),
            statistic: sprintf(
              AppText.gamesPageSearchResultComplexityGameStatFormat,
              [boardGame.avgWeight!.toStringAsFixed(2)],
            ),
          ),
        ],
        if (boardGame.rating != null) ...[
          const SizedBox(height: Dimensions.standardSpacing),
          _SearchResultGameGeneralStats(
            icon: const RatingHexagon(width: _gameStatIconSize, height: _gameStatIconSize),
            statistic:
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

class _SearchResultGameGeneralStats extends StatelessWidget {
  const _SearchResultGameGeneralStats({
    Key? key,
    required this.icon,
    required this.statistic,
  }) : super(key: key);

  final Widget icon;
  final String statistic;

  static const double _uniformedIconSize = 20;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: _uniformedIconSize, child: Center(child: icon)),
        const SizedBox(width: Dimensions.standardSpacing),
        Text(
          statistic,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.subTitleTextStyle,
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
