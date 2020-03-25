import 'dart:async';
import 'package:board_games_companion/app.dart';
import 'package:board_games_companion/models/board_game_category.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/models/player.dart';
import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:board_games_companion/services/board_games_service.dart';
import 'package:board_games_companion/services/player_service.dart';
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
      ],
      child: BoardGamesCompanionApp(),
    );
  }
}
