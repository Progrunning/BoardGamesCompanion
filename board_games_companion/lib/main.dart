import 'dart:async';
import 'package:board_games_companion/app.dart';
import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/models/hive/board_game_category.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:board_games_companion/services/board_games_service.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/services/playthroughs_service.dart';
import 'package:board_games_companion/services/score_service.dart';
import 'package:board_games_companion/stores/board_game_playthroughs_store.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/stores/home_store.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:board_games_companion/stores/start_playthrough_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(BoardGameDetailsAdapter());
  Hive.registerAdapter(BoardGameCategoryAdapter());
  Hive.registerAdapter(PlayerAdapter());
  Hive.registerAdapter(PlaythroughAdapter());
  Hive.registerAdapter(PlaythroughStatusAdapter());
  Hive.registerAdapter(ScoreAdapter());

  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned(() {
    runApp(App());
  }, onError: Crashlytics.instance.recordError);
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BoardGamesGeekService>(
          create: (context) => BoardGamesGeekService(),
        ),
        Provider<BoardGamesService>(
          create: (context) => BoardGamesService(),
        ),
        Provider<PlayerService>(
          create: (context) => PlayerService(),
        ),
        Provider<PlaythroughService>(
          create: (context) => PlaythroughService(),
        ),
        Provider<ScoreService>(
          create: (context) => ScoreService(),
        ),
        ChangeNotifierProvider<HomeStore>(
          create: (context) => HomeStore(),
        ),
        ChangeNotifierProvider<BoardGamesStore>(
          create: (context) {
            return BoardGamesStore(
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
            );
          },
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
            );
          },
        ),
        ChangeNotifierProvider<BoardGamePlaythroughsStore>(
          create: (context) => BoardGamePlaythroughsStore(),
        ),
        ChangeNotifierProvider<StartPlaythroughStore>(
          create: (context) => StartPlaythroughStore(
            Provider.of<PlayersStore>(
              context,
              listen: false,
            ),
          ),
        ),
      ],
      child: BoardGamesCompanionApp(),
    );
  }
}
