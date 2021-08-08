import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
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
import 'services/analytics_service.dart';
import 'services/board_games_filters_service.dart';
import 'services/board_games_geek_service.dart';
import 'services/board_games_service.dart';
import 'services/file_service.dart';
import 'services/player_service.dart';
import 'services/playthroughs_service.dart';
import 'services/preferences_service.dart';
import 'services/rate_and_review_service.dart';
import 'services/score_service.dart';
import 'services/user_service.dart';
import 'stores/board_game_playthroughs_store.dart';
import 'stores/board_games_filters_store.dart';
import 'stores/board_games_store.dart';
import 'stores/home_store.dart';
import 'stores/hot_board_games_store.dart';
import 'stores/players_store.dart';
import 'stores/playthrough_statistics_store.dart';
import 'stores/playthroughs_store.dart';
import 'stores/search_bar_board_games_store.dart';
import 'stores/search_board_games_store.dart';
import 'stores/start_playthrough_store.dart';
import 'stores/user_store.dart';
import 'utilities/custom_http_client_adapter.dart';

PreferencesService _preferencesService = PreferencesService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(BoardGameDetailsAdapter());
  Hive.registerAdapter(BoardGameCategoryAdapter());
  Hive.registerAdapter(PlayerAdapter());
  Hive.registerAdapter(PlaythroughAdapter());
  Hive.registerAdapter(PlaythroughStatusAdapter());
  Hive.registerAdapter(ScoreAdapter());
  Hive.registerAdapter(BoardGameDesignerAdapter());
  Hive.registerAdapter(BoardGamePublisherAdapter());
  Hive.registerAdapter(BoardGameArtistAdapter());
  Hive.registerAdapter(BoardGamesExpansionAdapter());
  Hive.registerAdapter(BoardGameRankAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(SortByAdapter());
  Hive.registerAdapter(SortByOptionAdapter());
  Hive.registerAdapter(OrderByAdapter());
  Hive.registerAdapter(CollectionFiltersAdapter());

  await _preferencesService.initialize();

  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runZoned(() {
    runApp(const App());
  }, onError: FirebaseCrashlytics.instance.recordError);
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  static final FirebaseAnalytics _analytics = FirebaseAnalytics();
  static final FirebaseAnalyticsObserver _analyticsObserver =
      FirebaseAnalyticsObserver(analytics: _analytics);
  static final RateAndReviewService _rateAndReviewService =
      RateAndReviewService(_preferencesService);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAnalyticsObserver>.value(value: _analyticsObserver),
        Provider<PreferencesService>.value(value: _preferencesService),
        Provider<RateAndReviewService>.value(value: _rateAndReviewService),
        Provider<AnalyticsService>(
          create: (context) {
            return AnalyticsService(
              _analytics,
              Provider.of<RateAndReviewService>(
                context,
                listen: false,
              ),
            );
          },
        ),
        Provider<CustomHttpClientAdapter>(
          create: (context) => CustomHttpClientAdapter(),
        ),
        Provider<BoardGamesGeekService>(
          create: (context) => BoardGamesGeekService(
            Provider.of<CustomHttpClientAdapter>(
              context,
              listen: false,
            ),
          ),
        ),
        Provider<BoardGamesService>(
          create: (context) => BoardGamesService(
            Provider.of<BoardGamesGeekService>(
              context,
              listen: false,
            ),
            _preferencesService,
          ),
        ),
        Provider<FileService>(
          create: (context) => FileService(),
        ),
        Provider<PlayerService>(
          create: (context) => PlayerService(
            Provider.of<FileService>(
              context,
              listen: false,
            ),
          ),
        ),
        Provider<ScoreService>(
          create: (context) => ScoreService(),
        ),
        Provider<UserService>(
          create: (context) => UserService(),
        ),
        Provider<PlaythroughService>(
          create: (context) => PlaythroughService(
            Provider.of<ScoreService>(
              context,
              listen: false,
            ),
          ),
        ),
        Provider<BoardGamesFiltersService>(
          create: (context) => BoardGamesFiltersService(),
        ),
        ChangeNotifierProvider<HomeStore>(
          create: (context) => HomeStore(),
        ),
        ChangeNotifierProvider<UserStore>(
          create: (context) {
            final userStore = UserStore(
              Provider.of<UserService>(
                context,
                listen: false,
              ),
              Provider.of<AnalyticsService>(
                context,
                listen: false,
              ),
            );
            _preferencesService.setAppLaunchDate();
            userStore.loadUser();
            return userStore;
          },
        ),
        ChangeNotifierProvider<HotBoardGamesStore>(
          create: (context) => HotBoardGamesStore(
            Provider.of<BoardGamesGeekService>(
              context,
              listen: false,
            ),
          ),
        ),
        ChangeNotifierProvider<SearchBarBoardGamesStore>(
          create: (context) => SearchBarBoardGamesStore(),
        ),
        ChangeNotifierProvider<SearchBoardGamesStore>(
          create: (context) => SearchBoardGamesStore(
            Provider.of<BoardGamesGeekService>(
              context,
              listen: false,
            ),
            Provider.of<SearchBarBoardGamesStore>(
              context,
              listen: false,
            ),
            Provider.of<AnalyticsService>(
              context,
              listen: false,
            ),
          ),
        ),
        ChangeNotifierProvider<PlayersStore>(
          create: (context) {
            return PlayersStore(
              Provider.of<PlayerService>(
                context,
                listen: false,
              ),
            );
          },
        ),
        ChangeNotifierProvider<PlaythroughsStore>(
          create: (context) {
            return PlaythroughsStore(
              Provider.of<PlaythroughService>(
                context,
                listen: false,
              ),
              Provider.of<AnalyticsService>(
                context,
                listen: false,
              ),
            );
          },
        ),
        ChangeNotifierProvider<BoardGamePlaythroughsStore>(
          create: (context) => BoardGamePlaythroughsStore(),
        ),
        ChangeNotifierProvider<BoardGamesFiltersStore>(
          create: (context) => BoardGamesFiltersStore(
            Provider.of<BoardGamesFiltersService>(
              context,
              listen: false,
            ),
            Provider.of<AnalyticsService>(
              context,
              listen: false,
            ),
          ),
        ),
        ChangeNotifierProvider<StartPlaythroughStore>(
          create: (context) => StartPlaythroughStore(
            Provider.of<PlayersStore>(
              context,
              listen: false,
            ),
          ),
        ),
        ChangeNotifierProxyProvider<BoardGamesFiltersStore, BoardGamesStore>(
          create: (context) {
            final boardGamesStore = BoardGamesStore(
              Provider.of<BoardGamesService>(
                context,
                listen: false,
              ),
              Provider.of<PlaythroughService>(
                context,
                listen: false,
              ),
              Provider.of<ScoreService>(
                context,
                listen: false,
              ),
              Provider.of<PlayerService>(
                context,
                listen: false,
              ),
              Provider.of<BoardGamesFiltersStore>(
                context,
                listen: false,
              ),
            );

            boardGamesStore.loadBoardGames();
            return boardGamesStore;
          },
          update: (_, filtersStore, boardGamesStore) {
            boardGamesStore.applyFilters();
            return boardGamesStore;
          },
        ),
        ChangeNotifierProxyProvider2<BoardGamesStore, PlaythroughsStore,
            PlaythroughStatisticsStore>(
          create: (context) {
            final boardGamesStore = PlaythroughStatisticsStore(
              Provider.of<PlayerService>(
                context,
                listen: false,
              ),
              Provider.of<ScoreService>(
                context,
                listen: false,
              ),
              Provider.of<PlaythroughService>(
                context,
                listen: false,
              ),
            );

            return boardGamesStore;
          },
          update: (_, boardGameStore, playthroughsStore, playthroughStatisticsStore) {
            playthroughStatisticsStore.loadBoardGamesStatistics(boardGameStore.filteredBoardGames);
            return playthroughStatisticsStore;
          },
        ),
      ],
      child: BoardGamesCompanionApp(_analyticsObserver),
    );
  }
}
