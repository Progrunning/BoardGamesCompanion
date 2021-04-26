import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'common/app_theme.dart';
import 'pages/home_page.dart';
import 'common/routes.dart';

class BoardGamesCompanionApp extends StatelessWidget {
  final FirebaseAnalyticsObserver _analyticsObserver;

  const BoardGamesCompanionApp(
    this._analyticsObserver, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Board Games Companion',
      theme: AppTheme.theme,
      navigatorObservers: [
        _analyticsObserver,
      ],
      routes: {
        Routes.home: (context) => HomePage(),
      },
    );
  }
}
