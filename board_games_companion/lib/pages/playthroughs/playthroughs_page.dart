import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/stores/user_store.dart';
import 'package:board_games_companion/widgets/common/loading_overlay.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/enums/collection_type.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/navigation/board_game_details_page_arguments.dart';
import '../../widgets/bottom_tab_icon.dart';
import '../../widgets/common/page_container_widget.dart';
import '../base_page_state.dart';
import '../board_game_details/board_game_details_page.dart';
import 'playthroughs_history_page.dart';
import 'playthroughs_log_game_page.dart';
import 'playthroughs_log_game_view_model.dart';
import 'playthroughs_statistics_page.dart';

class PlaythroughsPage extends StatefulWidget {
  const PlaythroughsPage({
    required this.viewModel,
    required this.boardGameDetails,
    required this.collectionType,
    Key? key,
  }) : super(key: key);

  static const String pageRoute = '/playthroughs';

  final PlaythroughsLogGameViewModel viewModel;
  final BoardGameDetails boardGameDetails;
  final CollectionType collectionType;

  @override
  _PlaythroughsPageState createState() => _PlaythroughsPageState();
}

class _PlaythroughsPageState extends BasePageState<PlaythroughsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  static const int _initialTabIndex = 0;
  static const int _numberOfTabs = 3;

  bool _showImportGamesLoadingIndicator = false;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      initialIndex: _initialTabIndex,
      length: _numberOfTabs,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.boardGameDetails.name),
        actions: <Widget>[
          Consumer<UserStore>(
            builder: (_, store, ___) {
              if (store.user?.name.isEmpty ?? true) {
                return const SizedBox.shrink();
              }

              return IconButton(
                icon: const Icon(Icons.download, color: AppTheme.accentColor),
                onPressed: () => _importBggPlays(store.user!.name, widget.boardGameDetails.id),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info, color: AppTheme.accentColor),
            onPressed: () async => _navigateToBoardGameDetails(context, widget.boardGameDetails),
          ),
        ],
      ),
      body: SafeArea(
        child: PageContainer(
          child: TabBarView(
            controller: tabController,
            children: <Widget>[
              PlaythroughStatistcsPage(
                playthroughStatisticsStore: widget.viewModel.playthroughStatisticsStore,
                collectionType: widget.collectionType,
              ),
              PlaythroughsHistoryPage(playthroughsStore: widget.viewModel.playthroughsStore),
              PlaythroughsLogGamePage(
                boardGameDetails: widget.boardGameDetails,
                playthroughsLogGameViewModel: widget.viewModel,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        controller: tabController,
        backgroundColor: AppTheme.bottomTabBackgroundColor,
        top: -Dimensions.bottomTabTopHeight,
        items: const <TabItem>[
          TabItem<BottomTabIcon>(
            title: AppText.playthroughPageStatsBottomTabTitle,
            icon: BottomTabIcon(iconData: Icons.multiline_chart),
            activeIcon: BottomTabIcon(iconData: Icons.multiline_chart, isActive: true),
          ),
          TabItem<BottomTabIcon>(
            title: AppText.playthroughPageHistoryBottomTabTitle,
            icon: BottomTabIcon(iconData: Icons.history),
            activeIcon: BottomTabIcon(iconData: Icons.history, isActive: true),
          ),
          TabItem<BottomTabIcon>(
            title: AppText.playthroughPageLogGameBottomTabTitle,
            icon: BottomTabIcon(iconData: Icons.casino),
            activeIcon: BottomTabIcon(iconData: Icons.casino, isActive: true),
          ),
        ],
        initialActiveIndex: _initialTabIndex,
        activeColor: AppTheme.accentColor,
        color: AppTheme.inactiveBottomTabColor,
      ),
    );

    if (_showImportGamesLoadingIndicator) {
      return LoadingOverlay(child: scaffold, title: AppText.importPlaysLoadingIndicator);
    }

    return scaffold;
  }

  Future<void> _navigateToBoardGameDetails(
      BuildContext context, BoardGameDetails boardGameDetails) async {
    await Navigator.pushNamed(
      context,
      BoardGamesDetailsPage.pageRoute,
      arguments: BoardGameDetailsPageArguments(
        boardGameDetails.id,
        boardGameDetails.name,
        PlaythroughsPage,
      ),
    );
  }

  Future<void> _importBggPlays(String username, String boardGameId) async {
    try {
      setState(() {
        _showImportGamesLoadingIndicator = true;
      });
      await widget.viewModel.importPlays(username, boardGameId);
    } finally {
      setState(() {
        _showImportGamesLoadingIndicator = false;
      });
    }
  }
}
