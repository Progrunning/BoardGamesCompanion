import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/pages/home.dart';
import 'package:board_games_companion/pages/search_board_games.dart';
import 'package:flutter/material.dart';

import 'common/routes.dart';

class BoardGamesCompanionApp extends StatelessWidget {
  const BoardGamesCompanionApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Board Games Companion',
      theme: AppTheme.theme,
      routes: {
        Routes.home: (context) => HomePage(),
        Routes.addBoardGames: (context) => SearchBoardGamesPage(),
      },
    );
  }
}
