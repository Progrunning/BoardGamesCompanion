import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'common/app_theme.dart';
import 'common/routes.dart';
import 'pages/home_page.dart';

class BoardGamesCompanionApp extends StatelessWidget {
  const BoardGamesCompanionApp(
    this._analyticsObserver, {
    Key key,
  }) : super(key: key);

  final FirebaseAnalyticsObserver _analyticsObserver;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Board Games Companion',
      theme: AppTheme.theme,
      navigatorObservers: [
        _analyticsObserver,
      ],
      routes: {
        Routes.home: (context) => const HomePage(),
      },
    );
  }
}
