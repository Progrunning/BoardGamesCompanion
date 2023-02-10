import 'dart:async';

import 'package:board_games_companion/utilities/launcher_helper.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/bgg/bgg_plays_import_raport.dart';
import '../../models/navigation/board_game_details_page_arguments.dart';
import '../../widgets/bottom_tab_icon.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/common/page_container.dart';
import '../base_page_state.dart';
import '../board_game_details/board_game_details_page.dart';
import 'bgg_plays_import_report_dialog.dart';
import 'playthroughs_game_settings_page.dart';
import 'playthroughs_history_page.dart';
import 'playthroughs_log_game_page.dart';
import 'playthroughs_statistics_page.dart';
import 'playthroughs_view_model.dart';

class PlaythroughsPage extends StatefulWidget {
  const PlaythroughsPage({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  static const String pageRoute = '/playthroughs';

  final PlaythroughsViewModel viewModel;

  @override
  PlaythroughsPageState createState() => PlaythroughsPageState();
}

class PlaythroughsPageState extends BasePageState<PlaythroughsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  static const int _initialTabIndex = 0;
  static const int _numberOfTabs = 4;

  bool _showImportGamesLoadingIndicator = false;

  static final GlobalKey<ScaffoldMessengerState> playthroughsPageGlobalKey =
      GlobalKey<ScaffoldMessengerState>();

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
    final scaffold = ScaffoldMessenger(
      key: playthroughsPageGlobalKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.viewModel.boardGameName, style: AppTheme.titleTextStyle),
          actions: <Widget>[
            if (!widget.viewModel.isCreatedByUser)
              IconButton(
                icon: const Icon(Icons.music_note, color: AppColors.accentColor),
                onPressed: () async => _openGamesMusicPlaylist(context),
              ),
            Observer(
              builder: (BuildContext context) {
                if (!widget.viewModel.hasUser) {
                  return const SizedBox.shrink();
                }

                return IconButton(
                  icon: const Icon(Icons.download, color: AppColors.accentColor),
                  onPressed: () => _importBggPlays(context),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.info, color: AppColors.accentColor),
              onPressed: () => _navigateToBoardGameDetails(context),
            ),
          ],
        ),
        body: SafeArea(
          child: PageContainer(
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                PlaythroughStatistcsPage(
                  boardGameImageHeroId: widget.viewModel.boardGameImageHeroId,
                ),
                const PlaythroughsHistoryPage(),
                const PlaythroughsLogGamePage(),
                const PlaythroughsGameSettingsPage()
              ],
            ),
          ),
        ),
        bottomNavigationBar: ConvexAppBar(
          controller: tabController,
          backgroundColor: AppColors.bottomTabBackgroundColor,
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
            TabItem<BottomTabIcon>(
              title: AppText.playthroughPageGameSettingsLogGameBottomTabTitle,
              icon: BottomTabIcon(iconData: Icons.settings_applications_sharp),
              activeIcon:
                  BottomTabIcon(iconData: Icons.settings_applications_sharp, isActive: true),
            ),
          ],
          initialActiveIndex: _initialTabIndex,
          activeColor: AppColors.accentColor,
          color: AppColors.inactiveBottomTabColor,
          onTap: (int tabIndex) => widget.viewModel.trackTabChange(tabIndex),
        ),
      ),
    );

    if (_showImportGamesLoadingIndicator) {
      return LoadingOverlay(title: AppText.importPlaysLoadingIndicator, child: scaffold);
    }

    return scaffold;
  }

  Future<void> _navigateToBoardGameDetails(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      BoardGamesDetailsPage.pageRoute,
      arguments: BoardGameDetailsPageArguments(
        boardGameId: widget.viewModel.boardGameId,
        boardGameImageHeroId: widget.viewModel.boardGameId,
        boardGameName: widget.viewModel.boardGameName,
        navigatingFromType: PlaythroughsPage,
      ),
    );
  }

  Future<void> _openGamesMusicPlaylist(BuildContext context) async {
    unawaited(widget.viewModel.trackOpenGamesPlaylist());
    await LauncherHelper.launchUri(
      context,
      widget.viewModel.gamePlaylistUrl,
      launchMode: LaunchMode.externalApplication,
    );
  }

  Future<void> _importBggPlays(BuildContext context) async {
    try {
      setState(() {
        _showImportGamesLoadingIndicator = true;
      });
      await widget.viewModel.importPlays(widget.viewModel.userName!, widget.viewModel.boardGameId);
      if (widget.viewModel.bggPlaysImportRaport!.playsToImportTotal > 0) {
        if (!mounted) {
          return;
        }

        await _showImportPlaysReportDialog(
          context,
          widget.viewModel.userName!,
          widget.viewModel.boardGameId,
          widget.viewModel.bggPlaysImportRaport!,
        );
      } else {
        if (mounted) {
          _showNoPlaysToImportDialog(context);
        }
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    } finally {
      setState(() {
        _showImportGamesLoadingIndicator = false;
      });
    }
  }

  void _showNoPlaysToImportDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: Dimensions.snackbarMargin,
        content: const Text(AppText.importPlaysReportNoPlaysToImportError),
        action: SnackBarAction(
          label: AppText.ok,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
          },
        ),
      ),
    );
  }

  Future<void> _showImportPlaysReportDialog(
    BuildContext context,
    String username,
    String boardGameId,
    BggPlaysImportRaport bggPlaysImportRaport,
  ) async {
    await showGeneralDialog<void>(
      context: context,
      pageBuilder: (_, __, ___) {
        return BggPlaysImportReportDialog(
          username: username,
          boardGameId: boardGameId,
          report: bggPlaysImportRaport,
        );
      },
    );
  }
}
