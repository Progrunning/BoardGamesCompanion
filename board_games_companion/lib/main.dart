import 'dart:async';

import 'package:board_games_companion/common/enums/game_winning_condition.dart';
import 'package:board_games_companion/models/hive/board_game_settings.dart';
import 'package:board_games_companion/pages/games/games_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

import 'app.dart';
import 'common/enums/order_by.dart';
import 'common/enums/playthrough_status.dart';
import 'common/enums/sort_by_option.dart';
import 'injectable.dart';
import 'models/collection_filters.dart';
import 'models/hive/board_game_artist.dart';
import 'models/hive/board_game_category.dart';
import 'models/hive/board_game_designer.dart';
import 'models/hive/board_game_details.dart';
import 'models/hive/board_game_expansion.dart';
import 'models/hive/board_game_publisher.dart';
import 'models/hive/board_game_rank.dart';
import 'models/hive/player.dart';
import 'models/hive/playthrough.dart';
import 'models/hive/score.dart';
import 'models/hive/user.dart';
import 'models/sort_by.dart';
import 'pages/players/players_view_model.dart';
import 'services/analytics_service.dart';
import 'services/board_games_geek_service.dart';
import 'services/board_games_service.dart';
import 'services/player_service.dart';
import 'services/playthroughs_service.dart';
import 'services/preferences_service.dart';
import 'services/score_service.dart';
import 'services/user_service.dart';
import 'stores/board_games_filters_store.dart';
import 'stores/board_games_store.dart';
import 'stores/hot_board_games_store.dart';
import 'stores/playthrough_statistics_store.dart';
import 'stores/playthroughs_store.dart';
import 'stores/search_bar_board_games_store.dart';
import 'stores/search_board_games_store.dart';
import 'stores/user_store.dart';

Future<void> main() async {
  configureDependencies();

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
    Hive
      ..init(appDocumentDirectory.path)
      ..registerAdapter(BoardGameDetailsAdapter())
      ..registerAdapter(BoardGameCategoryAdapter())
      ..registerAdapter(PlayerAdapter())
      ..registerAdapter(PlaythroughAdapter())
      ..registerAdapter(PlaythroughStatusAdapter())
      ..registerAdapter(ScoreAdapter())
      ..registerAdapter(BoardGameDesignerAdapter())
      ..registerAdapter(BoardGamePublisherAdapter())
      ..registerAdapter(BoardGameArtistAdapter())
      ..registerAdapter(BoardGamesExpansionAdapter())
      ..registerAdapter(BoardGameRankAdapter())
      ..registerAdapter(UserAdapter())
      ..registerAdapter(SortByAdapter())
      ..registerAdapter(SortByOptionAdapter())
      ..registerAdapter(OrderByAdapter())
      ..registerAdapter(CollectionFiltersAdapter())
      ..registerAdapter(GameWinningConditionAdapter())
      ..registerAdapter(BoardGameSettingsAdapter());

    final PreferencesService preferencesService = getIt<PreferencesService>();
    await preferencesService.initialize();

    LicenseRegistry.addLicense(() async* {
      final license = await rootBundle.loadString('google_fonts/OFL.txt');
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    });

    await Firebase.initializeApp();

    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }

    runApp(App(preferencesService: preferencesService));
  }, (error, stackTrace) {
    if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  });
}

class App extends StatelessWidget {
  const App({
    required this.preferencesService,
    Key? key,
  }) : super(key: key);

  final PreferencesService preferencesService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserStore>(
          create: (context) {
            final UserService userService = getIt<UserService>();
            final userStore = UserStore(userService);

            preferencesService.setAppLaunchDate();
            userStore.loadUser();
            return userStore;
          },
        ),
        ChangeNotifierProvider<HotBoardGamesStore>(
          create: (context) {
            final BoardGamesGeekService boardGamesGeekService = getIt<BoardGamesGeekService>();
            return HotBoardGamesStore(boardGamesGeekService);
          },
        ),
        ChangeNotifierProvider<SearchBarBoardGamesStore>(
          create: (context) => SearchBarBoardGamesStore(),
        ),
        ChangeNotifierProvider<SearchBoardGamesStore>(
          create: (context) {
            final BoardGamesGeekService boardGamesGeekService = getIt<BoardGamesGeekService>();
            final AnalyticsService analyticsService = getIt<AnalyticsService>();
            return SearchBoardGamesStore(
              boardGamesGeekService,
              Provider.of<SearchBarBoardGamesStore>(
                context,
                listen: false,
              ),
              analyticsService,
            );
          },
        ),
        ChangeNotifierProvider<PlayersViewModel>(
          create: (context) => getIt<PlayersViewModel>(),
        ),
        ChangeNotifierProvider<PlaythroughsStore>(
          create: (context) => getIt<PlaythroughsStore>(),
        ),
        ChangeNotifierProvider<BoardGamesFiltersStore>(
          create: (context) => getIt<BoardGamesFiltersStore>(),
        ),
        ChangeNotifierProvider<BoardGamesStore>(
          create: (context) {
            final BoardGamesService boardGamesService = getIt<BoardGamesService>();
            final PlaythroughService playthroughService = getIt<PlaythroughService>();
            final ScoreService scoreService = getIt<ScoreService>();
            final PlayerService playerService = getIt<PlayerService>();
            return BoardGamesStore(
              boardGamesService,
              playthroughService,
              scoreService,
              playerService,
            );
          },
        ),
        ChangeNotifierProxyProvider2<BoardGamesStore, PlaythroughsStore,
            PlaythroughStatisticsStore>(
          create: (context) => getIt<PlaythroughStatisticsStore>(),
          update: (_, boardGameStore, playthroughsStore, playthroughStatisticsStore) {
            return playthroughStatisticsStore!;
          },
        ),
        ChangeNotifierProxyProvider2<BoardGamesFiltersStore, BoardGamesStore, GamesViewModel>(
          create: (context) {
            final boardGamesFiltersStore = getIt<BoardGamesFiltersStore>();
            final boardGamesStore = Provider.of<BoardGamesStore>(
              context,
              listen: false,
            );
            final gamesViewModel = GamesViewModel(boardGamesStore, boardGamesFiltersStore);
            gamesViewModel.loadBoardGames();

            return gamesViewModel;
          },
          update: (_, filtersStore, boardGamesStore, gamesViewModel) {
            gamesViewModel!.applyFilters();
            return gamesViewModel;
          },
        ),
      ],
      child: const BoardGamesCompanionApp(),
    );
  }
}
