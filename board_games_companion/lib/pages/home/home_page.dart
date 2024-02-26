import 'dart:async';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprintf/sprintf.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/dimensions.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/navigation/board_game_details_page_arguments.dart';
import '../../models/navigation/create_board_game_page_arguments.dart';
import '../../models/navigation/playthroughs_page_arguments.dart';
import '../../models/results/board_game_creation_result.dart';
import '../../widgets/bottom_tab_icon.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/search/bgg_search.dart';
import '../../widgets/search/collections_search.dart';
import '../base_page_state.dart';
import '../board_game_details/board_game_details_page.dart';
import '../collections/collections_page.dart';
import '../create_board_game/create_board_game_page.dart';
import '../hot_board_games/hot_board_games_page.dart';
import '../players/players_page.dart';
import '../plays/plays_page.dart';
import '../playthroughs/playthroughs_page.dart';
import 'home_page_drawer.dart';
import 'home_view_model.dart';

typedef SearchCallback = Future<List<BoardGameDetails>> Function(String query);

typedef BoardGameResultAction = void Function(
  BoardGameDetails boardGame,
  BoardGameResultActionType actionType,
);

class HomePage extends StatefulWidget {
  const HomePage({
    required this.viewModel,
    super.key,
  });

  static const String pageRoute = '/home';

  final HomeViewModel viewModel;

  static final GlobalKey<ScaffoldMessengerState> homePageGlobalKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends BasePageState<HomePage> with SingleTickerProviderStateMixin {
  late final TabController tabController;

  static const int _numberOfTabs = 4;
  static const int _collectionsTabIndex = 0;
  static const int _initialTabIndex = 0;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      initialIndex: _initialTabIndex,
      length: _numberOfTabs,
      vsync: this,
    );
    tabController.addListener(() {
      // MK Force redraw to update FOB
      setState(() {});
    });

    widget.viewModel.loadData();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaffoldMessenger(
        key: HomePage.homePageGlobalKey,
        child: Scaffold(
          drawer: const Drawer(child: HomePageDrawer()),
          body: SafeArea(
            child: PageContainer(
              child: TabBarView(
                controller: tabController,
                children: <Widget>[
                  CollectionsPage(
                    widget.viewModel.collectionsViewModel,
                    widget.viewModel.boardGamesFiltersStore,
                    widget.viewModel.analyticsService,
                    widget.viewModel.rateAndReviewService,
                  ),
                  PlaysPage(viewModel: widget.viewModel.playsViewModel),
                  PlayersPage(viewModel: widget.viewModel.playersViewModel),
                  HotBoardGamesPage(viewModel: widget.viewModel.hotBoardGamesViewModel),
                ],
              ),
            ),
          ),
          bottomNavigationBar: ConvexAppBar(
            controller: tabController,
            backgroundColor: AppColors.bottomTabBackgroundColor,
            top: -Dimensions.bottomTabTopHeight,
            items: const <TabItem<BottomTabIcon>>[
              TabItem<BottomTabIcon>(
                title: AppText.homePageCollectionsTabTitle,
                icon: BottomTabIcon(iconData: Icons.grid_on),
                activeIcon: BottomTabIcon(iconData: Icons.grid_on, isActive: true),
              ),
              TabItem<BottomTabIcon>(
                title: AppText.homePagePlaysTabTitle,
                icon: BottomTabIcon(iconData: Icons.video_library),
                activeIcon: BottomTabIcon(iconData: Icons.video_library, isActive: true),
              ),
              TabItem<BottomTabIcon>(
                title: AppText.homePageGamesPlayersTabTitle,
                icon: BottomTabIcon(iconData: Icons.group),
                activeIcon: BottomTabIcon(iconData: Icons.group, isActive: true),
              ),
              TabItem<BottomTabIcon>(
                title: AppText.homePageHotBoardGamesTabTitle,
                icon: BottomTabIcon(iconData: FontAwesomeIcons.fireFlameCurved),
                activeIcon: BottomTabIcon(
                  iconData: FontAwesomeIcons.fireFlameCurved,
                  isActive: true,
                ),
              ),
            ],
            initialActiveIndex: _initialTabIndex,
            activeColor: AppColors.accentColor,
            color: AppColors.inactiveBottomTabColor,
            onTap: (int tabIndex) => widget.viewModel.trackTabChange(tabIndex),
          ),
          floatingActionButton: tabController.index == _collectionsTabIndex
              ? Observer(
                  builder: (_) {
                    return SpeedDial(
                      icon: Icons.search,
                      overlayColor: AppColors.dialogBackgroundColor,
                      activeIcon: Icons.close,
                      openCloseDial: widget.viewModel.isSearchDialContextMenuOpen,
                      onPress: () => widget.viewModel.isSearchDialContextMenuOpen.value =
                          !widget.viewModel.isSearchDialContextMenuOpen.value,
                      children: [
                        if (widget.viewModel.anyBoardGamesInCollections)
                          SpeedDialChild(
                            child: const Icon(Icons.grid_on),
                            backgroundColor: AppColors.accentColor,
                            foregroundColor: Colors.white,
                            label: AppText.homePageSearchCollectionsDialOptionText,
                            labelBackgroundColor: AppColors.accentColor,
                            onTap: () => _searchCollections(),
                          ),
                        SpeedDialChild(
                          child: const FaIcon(FontAwesomeIcons.globe),
                          backgroundColor: AppColors.greenColor,
                          foregroundColor: Colors.white,
                          label: AppText.homePageSearchOnlineDialOptionText,
                          labelBackgroundColor: AppColors.greenColor,
                          onTap: () => _searchBgg(),
                        )
                      ],
                    );
                  },
                )
              : null,
        ),
      );

  Future<void> _searchBgg() async {
    final navigatorState = Navigator.of(context);
    await widget.viewModel.rateAndReviewService.increaseNumberOfSignificantActions();
    if (!navigatorState.mounted) {
      return;
    }

    final boardGameResult = await showSearch(
      context: navigatorState.context,
      delegate: BggSearch(
        searchHistory: widget.viewModel.searchHistory,
        sortByOptions: widget.viewModel.searchSortByOptions,
        searchResultsStream: widget.viewModel.searchResultsStream,
        onResultAction: (boardGame, actionType) async =>
            _handleBggSearchResultAction(boardGame, actionType),
        onSortyByUpdate: (sortBy) => widget.viewModel.updateBggSearchSortByOption(sortBy),
        onQueryChanged: (query) => widget.viewModel.updateBggSearchQuery(query),
      ),
    );

    boardGameResult?.when(
      createGame: (boardGameName) => _navigateToCreateNewGame(
        navigatorState,
        boardGameName,
      ),
    );
  }

  Future<void> _searchCollections() async {
    final navigatorState = Navigator.of(context);
    await widget.viewModel.rateAndReviewService.increaseNumberOfSignificantActions();
    if (!navigatorState.mounted) {
      return;
    }

    await showSearch(
      context: navigatorState.context,
      delegate: CollectionsSearch(
        allBoardGames: widget.viewModel.allBoardGames,
        searchHistory: widget.viewModel.searchHistory,
        onResultAction: (boardGame, actionType) async =>
            _handleSearchCollectionsResultAction(boardGame, actionType),
        onSearch: (query) => widget.viewModel.searchCollections(query),
      ),
    );
  }

  Future<void> _handleSearchCollectionsResultAction(
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
            boardGameImageHeroId: boardGameDetails.id,
            navigatingFromType: CollectionsPage,
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

  Future<void> _handleBggSearchResultAction(
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
            boardGameImageHeroId: boardGameDetails.id,
            navigatingFromType: CollectionsPage,
          ),
        ));
        break;
      case BoardGameResultActionType.playthroughs:
        break;
    }
  }

  Future<void> _navigateToCreateNewGame(
    NavigatorState navigatorState,
    String boardGameNameNotFound,
  ) async {
    final gameCreationResult = await navigatorState.pushNamed<GameCreationResult>(
      CreateBoardGamePage.pageRoute,
      arguments: CreateBoardGamePageArguments(boardGameName: boardGameNameNotFound),
    );

    gameCreationResult?.maybeWhen(
      saveSuccess: (boardGameId, boardGameName) => _showGameCreatedSnackbar(
        navigatorState,
        boardGameId,
        boardGameName,
      ),
      orElse: () {},
    );
  }

  Future<void> _showGameCreatedSnackbar(
    NavigatorState navigatorState,
    String boardGameId,
    String boardGameName,
  ) async {
    HomePage.homePageGlobalKey.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: Dimensions.snackbarMargin,
        content: Text(sprintf(AppText.createNewGameSuccessFormat, [boardGameName])),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: AppText.createNewGameSuccessDetailsActionText,
          onPressed: () => navigatorState.pushNamed(
            BoardGamesDetailsPage.pageRoute,
            arguments: BoardGameDetailsPageArguments(
              boardGameId: boardGameId,
              navigatingFromType: CollectionsPage,
              boardGameImageHeroId: boardGameId,
            ),
          ),
        ),
      ),
    );
  }
}
