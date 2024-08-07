import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:screenshot/screenshot.dart';

import 'app.dart';
import 'common/enums/game_classification.dart';
import 'common/enums/game_family.dart';
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
import 'models/hive/board_game_prices.dart';
import 'models/hive/board_game_publisher.dart';
import 'models/hive/board_game_rank.dart';
import 'models/hive/board_game_settings.dart';
import 'models/hive/no_score_game_result.dart';
import 'models/hive/player.dart';
import 'models/hive/playthrough.dart';
import 'models/hive/playthrough_note.dart';
import 'models/hive/score.dart';
import 'models/hive/score_game_results.dart';
import 'models/hive/search_history_entry.dart';
import 'models/hive/user.dart';
import 'models/sort_by.dart';
import 'services/preferences_service.dart';

Future<void> main() async {
  Fimber.plantTree(DebugTree(
    useColors: true,
  ));

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

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
      ..registerAdapter(GameFamilyAdapter())
      ..registerAdapter(GameClassificationAdapter())
      ..registerAdapter(BoardGameSettingsAdapter())
      ..registerAdapter(PlaythroughNoteAdapter())
      ..registerAdapter(SearchHistoryEntryAdapter())
      ..registerAdapter(NoScoreGameResultAdapter())
      ..registerAdapter(ScoreGameResultAdapter())
      ..registerAdapter(ScoreTiebreakerTypeAdapter())
      ..registerAdapter(CooperativeGameResultAdapter())
      ..registerAdapter(BoardGamePricesAdapter());

    getIt.registerSingleton<ScreenshotController>(ScreenshotController());

    configureDependencies();

    final preferencesService = getIt<PreferencesService>();
    await preferencesService.initialize();

    LicenseRegistry.addLicense(() async* {
      final license = await rootBundle.loadString('google_fonts/OFL.txt');
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    });

    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }

    runApp(App(preferencesService: preferencesService));
  }, (error, stackTrace) {
    Fimber.e('Error caught in the guard zone', ex: error, stacktrace: stackTrace);
    if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  });
}

class App extends StatelessWidget {
  const App({
    required this.preferencesService,
    super.key,
  });

  final PreferencesService preferencesService;

  @override
  Widget build(BuildContext context) {
    preferencesService.setAppLaunchDate();
    return const BoardGamesCompanionApp();
  }
}
