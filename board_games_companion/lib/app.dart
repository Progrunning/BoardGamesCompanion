import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/app_theme.dart';
import 'injectable.dart';
import 'models/navigation/board_game_details_page_arguments.dart';
import 'models/navigation/edit_playthrough_page_arguments.dart';
import 'models/navigation/player_page_arguments.dart';
import 'models/navigation/playthroughs_page_arguments.dart';
import 'pages/about_page.dart';
import 'pages/board_game_details/board_game_details_page.dart';
import 'pages/board_game_details/board_game_details_view_model.dart';
import 'pages/edit_playthrough/edit_playthrough_page.dart';
import 'pages/edit_playthrough/edit_playthrouhg_view_model.dart';
import 'pages/home_page.dart';
import 'pages/players/player_page.dart';
import 'pages/players/players_view_model.dart';
import 'pages/playthroughs/playthroughs_page.dart';
import 'pages/playthroughs/playthroughs_view_model.dart';
import 'services/analytics_service.dart';
import 'services/board_games_geek_service.dart';
import 'services/preferences_service.dart';
import 'services/rate_and_review_service.dart';
import 'stores/board_games_store.dart';
import 'stores/playthroughs_store.dart';
import 'utilities/analytics_route_observer.dart';

class BoardGamesCompanionApp extends StatefulWidget {
  const BoardGamesCompanionApp({
    Key? key,
  }) : super(key: key);

  @override
  _BoardGamesCompanionAppState createState() => _BoardGamesCompanionAppState();
}

class _BoardGamesCompanionAppState extends State<BoardGamesCompanionApp> {
  late FirebaseAnalyticsObserver _analyticsObserver;
  late AnalyticsRouteObserver _analyticsRouteObserver;

  @override
  void initState() {
    super.initState();
    _analyticsObserver = getIt<FirebaseAnalyticsObserver>();
    _analyticsRouteObserver = getIt<AnalyticsRouteObserver>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Board Games Companion',
      theme: AppTheme.theme,
      navigatorObservers: [_analyticsObserver, _analyticsRouteObserver],
      initialRoute: HomePage.pageRoute,
      routes: {
        HomePage.pageRoute: (BuildContext _) {
          final analyticsService = getIt<AnalyticsService>();
          final rateAndReviewService = getIt<RateAndReviewService>();
          final playersViewModel = getIt<PlayersViewModel>();

          return HomePage(
            analyticsService: analyticsService,
            rateAndReviewService: rateAndReviewService,
            playersViewModel: playersViewModel,
          );
        },
        BoardGamesDetailsPage.pageRoute: (BuildContext context) {
          final _arguments =
              ModalRoute.of(context)!.settings.arguments as BoardGameDetailsPageArguments;

          final _analytics = getIt<AnalyticsService>();
          final _boardGamesGeekService = getIt<BoardGamesGeekService>();
          final _preferencesService = getIt<PreferencesService>();
          final _boardGamesStore = Provider.of<BoardGamesStore>(
            context,
            listen: false,
          );
          final _boardGameDetailsStore = BoardGameDetailsViewModel(
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
          final playersStore = getIt<PlayersViewModel>();

          playersStore.setPlayer(player: _arguments.player);

          return PlayerPage(playersStore: playersStore);
        },
        PlaythroughsPage.pageRoute: (BuildContext context) {
          final _arguments =
              ModalRoute.of(context)!.settings.arguments as PlaythroughsPageArguments;

          final viewModel = getIt<PlaythroughsViewModel>();
          viewModel.setBoardGame(_arguments.boardGameDetails);

          return PlaythroughsPage(
            viewModel: viewModel,
            boardGameDetails: _arguments.boardGameDetails,
            collectionType: _arguments.collectionType,
          );
        },
        EditPlaythoughPage.pageRoute: (BuildContext context) {
          final _arguments =
              ModalRoute.of(context)!.settings.arguments as EditPlaythroughPageArguments;

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
