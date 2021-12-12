import 'package:board_games_companion/models/navigation/playthroughs_page_arguments.dart';
import 'package:board_games_companion/pages/edit_playthrough/edit_playthrough_page.dart';
import 'package:board_games_companion/pages/edit_playthrough/edit_playthrouhg_view_model.dart';
import 'package:board_games_companion/pages/playthroughs/playthroughs_page.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/analytics.dart';
import 'common/app_theme.dart';
import 'injectable.dart';
import 'models/navigation/board_game_details_page_arguments.dart';
import 'models/navigation/edit_playthrough_page_arguments.dart';
import 'models/navigation/player_page_arguments.dart';
import 'pages/about_page.dart';
import 'pages/board_game_details/board_game_details_page.dart';
import 'pages/home_page.dart';
import 'pages/players/player_page.dart';
import 'services/analytics_service.dart';
import 'services/board_games_geek_service.dart';
import 'services/preferences_service.dart';
import 'services/rate_and_review_service.dart';
import 'stores/board_game_details_store.dart';
import 'stores/board_games_store.dart';
import 'stores/players_store.dart';
import 'stores/playthroughs_store.dart';

class BoardGamesCompanionApp extends StatefulWidget {
  const BoardGamesCompanionApp({
    Key? key,
  }) : super(key: key);

  @override
  _BoardGamesCompanionAppState createState() => _BoardGamesCompanionAppState();
}

class _BoardGamesCompanionAppState extends State<BoardGamesCompanionApp> {
  late FirebaseAnalyticsObserver _analyticsObserver;

  @override
  void initState() {
    super.initState();
    _analyticsObserver = getIt<FirebaseAnalyticsObserver>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Board Games Companion',
      theme: AppTheme.theme,
      navigatorObservers: [
        _analyticsObserver,
      ],
      initialRoute: HomePage.pageRoute,
      routes: {
        HomePage.pageRoute: (BuildContext _) {
          final AnalyticsService analyticsService = getIt<AnalyticsService>();
          final RateAndReviewService rateAndReviewService = getIt<RateAndReviewService>();

          return HomePage(
            analyticsService: analyticsService,
            rateAndReviewService: rateAndReviewService,
          );
        },
        BoardGamesDetailsPage.pageRoute: (BuildContext context) {
          final _arguments =
              ModalRoute.of(context)!.settings.arguments as BoardGameDetailsPageArguments;

          // TODO MK Consider capturing analtyics of pages in a more generic way
          final _analytics = getIt<AnalyticsService>();
          _analytics.logEvent(
            name: Analytics.ViewGameDetails,
            parameters: <String, String>{
              Analytics.BoardGameIdParameter: _arguments.boardGameId,
              Analytics.BoardGameNameParameter: _arguments.boardGameName,
            },
          );
          final _boardGamesGeekService = getIt<BoardGamesGeekService>();
          final _preferencesService = getIt<PreferencesService>();
          final _boardGamesStore = Provider.of<BoardGamesStore>(
            context,
            listen: false,
          );
          final _boardGameDetailsStore = BoardGameDetailsStore(
            _boardGamesGeekService,
            _boardGamesStore,
            _analytics,
          );

          return BoardGamesDetailsPage(
            boardGameId: _arguments.boardGameId,
            boardGameName: _arguments.boardGameName,
            boardGameDetailsStore: _boardGameDetailsStore,
            navigatingFromType: _arguments.navigatingFromType,
            preferencesService: _preferencesService,
          );
        },
        PlayerPage.pageRoute: (BuildContext context) {
          final _arguments = ModalRoute.of(context)!.settings.arguments as PlayerPageArguments;
          final playersStore = getIt<PlayersStore>();

          playersStore.setPlayer(player: _arguments.player);

          return PlayerPage(playersStore: playersStore);
        },
        PlaythroughsPage.pageRoute: (BuildContext context) {
          final _arguments =
              ModalRoute.of(context)!.settings.arguments as PlaythroughsPageArguments;

          // TODO MK Consider capturing analtyics of pages in a more generic way
          final _analytics = getIt<AnalyticsService>();
          _analytics.logEvent(
            name: Analytics.ViewGameStats,
            parameters: <String, String?>{
              Analytics.BoardGameIdParameter: _arguments.boardGameDetails.id,
              Analytics.BoardGameNameParameter: _arguments.boardGameDetails.name,
            },
          );

          return PlaythroughsPage(
            boardGameDetails: _arguments.boardGameDetails,
            collectionType: _arguments.collectionType,
          );
        },
        EditPlaythoughPage.pageRoute: (BuildContext context) {
          final _arguments =
              ModalRoute.of(context)!.settings.arguments as EditPlaythroughPageArguments;

          final analytics = getIt<AnalyticsService>();
          analytics.logEvent(
            name: Analytics.EditPlaythrough,
            parameters: <String, String>{
              Analytics.BoardGameIdParameter: _arguments.playthroughStore.playthrough.boardGameId,
            },
          );
          final PlaythroughsStore playthroughsStore = getIt<PlaythroughsStore>();

          return EditPlaythoughPage(
            viewModel: EditPlaythoughViewModel(_arguments.playthroughStore, playthroughsStore),
          );
        },
        AboutPage.pageRoute: (BuildContext _) {
          return const AboutPage();
        },
      },
    );
  }
}
