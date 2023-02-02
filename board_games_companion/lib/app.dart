import 'package:board_games_companion/pages/edit_playthrough/playthrough_note_page.dart';
import 'package:board_games_companion/pages/settings/settings_view_model.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'common/app_theme.dart';
import 'injectable.dart';
import 'models/navigation/board_game_details_page_arguments.dart';
import 'models/navigation/edit_playthrough_page_arguments.dart';
import 'models/navigation/player_page_arguments.dart';
import 'models/navigation/playthough_note_page_arguments.dart';
import 'models/navigation/playthroughs_page_arguments.dart';
import 'pages/about/about_page.dart';
import 'pages/board_game_details/board_game_details_page.dart';
import 'pages/board_game_details/board_game_details_view_model.dart';
import 'pages/create_board_game/create_board_game_page.dart';
import 'pages/create_board_game/create_board_game_view_model.dart';
import 'pages/edit_playthrough/edit_playthrough_page.dart';
import 'pages/edit_playthrough/edit_playthrough_view_model.dart';
import 'pages/edit_playthrough/playthrough_note_view_model.dart';
import 'pages/home/home_page.dart';
import 'pages/home/home_view_model.dart';
import 'pages/player/player_page.dart';
import 'pages/player/player_view_model.dart';
import 'pages/playthroughs/playthroughs_page.dart';
import 'pages/playthroughs/playthroughs_view_model.dart';
import 'pages/settings/settings_page.dart';
import 'services/preferences_service.dart';
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
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      navigatorObservers: [_analyticsObserver, _analyticsRouteObserver],
      initialRoute: HomePage.pageRoute,
      onGenerateRoute: (RouteSettings routeSettings) {
        switch (routeSettings.name) {
          case HomePage.pageRoute:
            final viewModel = getIt<HomeViewModel>();

            return MaterialPageRoute<dynamic>(
              settings: routeSettings,
              builder: (_) => HomePage(viewModel: viewModel),
            );

          case BoardGamesDetailsPage.pageRoute:
            final arguments = routeSettings.arguments as BoardGameDetailsPageArguments;

            final preferencesService = getIt<PreferencesService>();
            final viewModel = getIt<BoardGameDetailsViewModel>();
            viewModel.setBoardGameId(arguments.boardGameId);
            viewModel.setBoardGameName(arguments.boardGameName);
            viewModel.setBoardGameImageUrl(arguments.boardGameImageUrl);
            viewModel.setBoardGameImageHeroId(arguments.boardGameImageHeroId);

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
            final playersViewModel = getIt<PlayerViewModel>();

            playersViewModel.setPlayer(arguments.player);

            return MaterialPageRoute<dynamic>(
              settings: routeSettings,
              builder: (BuildContext context) => PlayerPage(viewModel: playersViewModel),
            );

          case PlaythroughsPage.pageRoute:
            final arguments = routeSettings.arguments as PlaythroughsPageArguments;

            final viewModel = getIt<PlaythroughsViewModel>();
            viewModel.setBoardGame(arguments.boardGameDetails);
            viewModel.setBoardGameImageHeroId(arguments.boardGameImageHeroId);

            return MaterialPageRoute<dynamic>(
              settings: routeSettings,
              builder: (BuildContext context) => PlaythroughsPage(viewModel: viewModel),
            );

          case EditPlaythroughPage.pageRoute:
            final arguments = routeSettings.arguments as EditPlaythroughPageArguments;
            final viewModel = getIt<EditPlaythoughViewModel>();
            viewModel.setBoardGameId(arguments.boardGameId);
            viewModel.setPlaythroughId(arguments.playthroughId);

            return MaterialPageRoute<dynamic>(
              settings: routeSettings,
              builder: (BuildContext context) => EditPlaythroughPage(
                viewModel: viewModel,
                goBackPageRoute: arguments.goBackPageRoute,
              ),
            );

          case AboutPage.pageRoute:
            return MaterialPageRoute<dynamic>(
                settings: routeSettings, builder: (BuildContext context) => const AboutPage());

          case SettingsPage.pageRoute:
            final viewModel = getIt<SettingsViewModel>();

            return MaterialPageRoute<dynamic>(
              settings: routeSettings,
              builder: (BuildContext context) => SettingsPage(viewModel: viewModel),
            );

          case PlaythroughNotePage.pageRoute:
            final arguments = routeSettings.arguments as PlaythroughNotePageArguments;
            final viewModel = getIt<PlaythroughNoteViewModel>();
            viewModel.setPlaythrough(arguments.playthrough);
            viewModel.setNoteId(arguments.noteId);

            return MaterialPageRoute<dynamic>(
              settings: routeSettings,
              builder: (BuildContext context) => PlaythroughNotePage(viewModel: viewModel),
            );

          case CreateBoardGamePage.pageRoute:
            final viewModel = getIt<CreateBoardGameViewModel>();

            return MaterialPageRoute<dynamic>(
              settings: routeSettings,
              builder: (BuildContext context) => CreateBoardGamePage(viewModel: viewModel),
            );
          default:
            return null;
        }
      },
    );
  }
}
