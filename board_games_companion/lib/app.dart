import 'package:board_games_companion/pages/games/games_view_model.dart';
import 'package:board_games_companion/pages/settings/settings_view_model.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'common/app_theme.dart';
import 'injectable.dart';
import 'models/navigation/board_game_details_page_arguments.dart';
import 'models/navigation/edit_playthrough_page_arguments.dart';
import 'models/navigation/player_page_arguments.dart';
import 'models/navigation/playthroughs_page_arguments.dart';
import 'pages/about/about_page.dart';
import 'pages/board_game_details/board_game_details_page.dart';
import 'pages/board_game_details/board_game_details_view_model.dart';
import 'pages/edit_playthrough/edit_playthrough_page.dart';
import 'pages/edit_playthrough/edit_playthrough_view_model.dart';
import 'pages/home/home_page.dart';
import 'pages/players/player_page.dart';
import 'pages/players/players_view_model.dart';
import 'pages/playthroughs/playthroughs_page.dart';
import 'pages/playthroughs/playthroughs_view_model.dart';
import 'pages/search_board_games/search_board_games_view_model.dart';
import 'pages/settings/settings_page.dart';
import 'services/analytics_service.dart';
import 'services/preferences_service.dart';
import 'services/rate_and_review_service.dart';
import 'stores/board_games_filters_store.dart';
import 'stores/playthroughs_store.dart';
import 'utilities/analytics_route_observer.dart';

class BoardGamesCompanionApp extends StatefulWidget {
  const BoardGamesCompanionApp({
    Key? key,
  }) : super(key: key);

  @override
  BoardGamesCompanionAppState createState() => BoardGamesCompanionAppState();
}

class BoardGamesCompanionAppState extends State<BoardGamesCompanionApp> {
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
      onGenerateRoute: (RouteSettings routeSettings) {
        switch (routeSettings.name) {
          case HomePage.pageRoute:
            final analyticsService = getIt<AnalyticsService>();
            final rateAndReviewService = getIt<RateAndReviewService>();
            final playersViewModel = getIt<PlayersViewModel>();
            final boardGamesFiltersStore = getIt<BoardGamesFiltersStore>();
            final gamesViewModel = getIt<GamesViewModel>();
            final searchViewModel = getIt<SearchBoardGamesViewModel>();

            return MaterialPageRoute<dynamic>(
              settings: routeSettings,
              builder: (_) => HomePage(
                analyticsService: analyticsService,
                rateAndReviewService: rateAndReviewService,
                gamesViewModel: gamesViewModel,
                playersViewModel: playersViewModel,
                searchViewModel: searchViewModel,
                boardGamesFiltersStore: boardGamesFiltersStore,
              ),
            );

          case BoardGamesDetailsPage.pageRoute:
            final arguments = routeSettings.arguments as BoardGameDetailsPageArguments;

            final preferencesService = getIt<PreferencesService>();
            final viewModel = getIt<BoardGameDetailsViewModel>();
            viewModel.setBoardGameId(arguments.boardGameId);
            viewModel.setBoardGameName(arguments.boardGameName);
            viewModel.setBoardGameImageUrl(arguments.boardGameImageUrl);

            return MaterialPageRoute<dynamic>(
              settings: routeSettings,
              builder: (BuildContext context) => BoardGamesDetailsPage(
                viewModel: viewModel,
                navigatingFromType: arguments.navigatingFromType,
                preferencesService: preferencesService,
              ),
            );

          case PlayerPage.pageRoute:
            final arguments = routeSettings.arguments as PlayerPageArguments;
            final playersViewModel = getIt<PlayersViewModel>();

            playersViewModel.setPlayer(player: arguments.player);

            return MaterialPageRoute<dynamic>(
              settings: routeSettings,
              builder: (BuildContext context) => PlayerPage(playersViewModel: playersViewModel),
            );

          case PlaythroughsPage.pageRoute:
            final arguments = routeSettings.arguments as PlaythroughsPageArguments;

            final viewModel = getIt<PlaythroughsViewModel>();
            viewModel.setBoardGame(arguments.boardGameDetails);

            return MaterialPageRoute<dynamic>(
              settings: routeSettings,
              builder: (BuildContext context) => PlaythroughsPage(viewModel: viewModel),
            );

          case EditPlaythoughPage.pageRoute:
            final arguments = routeSettings.arguments as EditPlaythroughPageArguments;

            // MK Need to create view model manually (i.e. without DI) because the passed in playthroughViewModel
            //    needs to be exactly the same as the one on the history page to ensure it's updated once navigated back
            final viewModel =
                EditPlaythoughViewModel(arguments.playthroughViewModel, getIt<PlaythroughsStore>());

            return MaterialPageRoute<dynamic>(
                settings: routeSettings,
                builder: (BuildContext context) => EditPlaythoughPage(viewModel: viewModel));

          case AboutPage.pageRoute:
            return MaterialPageRoute<dynamic>(
                settings: routeSettings, builder: (BuildContext context) => const AboutPage());

          case SettingsPage.pageRoute:
            final viewModel = getIt<SettingsViewModel>();

            return MaterialPageRoute<dynamic>(
              settings: routeSettings,
              builder: (BuildContext context) => SettingsPage(viewModel: viewModel),
            );

          default:
            return null;
        }
      },
    );
  }
}
