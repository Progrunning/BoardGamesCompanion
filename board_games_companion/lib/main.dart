import 'dart:async';

import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/models/board_game_category.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/pages/add_board_games.dart';
import 'package:board_games_companion/pages/board_game_details.dart';
import 'package:board_games_companion/pages/board_games.dart';
import 'package:board_games_companion/pages/games_played.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(BoardGameDetailsAdapter());
  Hive.registerAdapter(BoardGameCategoryAdapter());

  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned(() {
    runApp(BoardGamesCompanionApp());
  }, onError: Crashlytics.instance.recordError);
}

class BoardGamesCompanionApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Board Games Companion',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      initialRoute: Routes.home,
      routes: {
        Routes.home: (context) =>
            BoardGamesPage(title: 'Board Games Companion'),
        Routes.addBoardGames: (context) => AddBoardGames(),
        Routes.boardGameDetails: (context) => BoardGamesDetailsPage(),
        // Routes.gamesPlayed: (context) => GamesPlayed()
      },
    );
  }
}
