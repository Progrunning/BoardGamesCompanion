import 'package:board_games_companion/pages/add_board_games.dart';
import 'package:board_games_companion/pages/board_game_details.dart';
import 'package:board_games_companion/pages/create_edit_player.dart';
import 'package:board_games_companion/pages/home.dart';
import 'package:flutter/material.dart';

import 'common/routes.dart';

class BoardGamesCompanionApp extends StatelessWidget {
  const BoardGamesCompanionApp({Key key}) : super(key: key);

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
        Routes.home: (context) => HomePage(),
        Routes.addBoardGames: (context) => AddBoardGamesPage(),
        Routes.boardGameDetails: (context) => BoardGamesDetailsPage(),
        Routes.createEditPlayer: (context) => CreateEditPlayerPage(),
      },
    );
  }
}
