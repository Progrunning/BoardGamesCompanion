import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/pages/add_board_games.dart';
import 'package:board_games_companion/pages/board_games.dart';
import 'package:flutter/material.dart';

void main() => runApp(BoardGamesCompanionApp());

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
        Routes.home: (context) => BoardGamesPage(title: 'Board Games Companion'),
        Routes.addBoardGames: (context) => AddBoardGames()
      },
    );
  }
}
