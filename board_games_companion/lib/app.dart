import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'common/app_theme.dart';
import 'common/routes.dart';
import 'injectable.dart';
import 'pages/home_page.dart';
import 'services/analytics_service.dart';
import 'services/rate_and_review_service.dart';

class BoardGamesCompanionApp extends StatefulWidget {
  const BoardGamesCompanionApp({
    Key? key,
  }) : super(key: key);

  @override
  _BoardGamesCompanionAppState createState() => _BoardGamesCompanionAppState();
}

class _BoardGamesCompanionAppState extends State<BoardGamesCompanionApp> {
  late FirebaseAnalyticsObserver _analyticsObserver;

  @override
  void initState() {
    super.initState();
    _analyticsObserver = getIt<FirebaseAnalyticsObserver>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Board Games Companion',
      theme: AppTheme.theme,
      navigatorObservers: [
        _analyticsObserver,
      ],
      routes: {
        Routes.home: (context) {
          final AnalyticsService analyticsService = getIt<AnalyticsService>();
          final RateAndReviewService rateAndReviewService = getIt<RateAndReviewService>();

          return HomePage(
            analyticsService: analyticsService,
            rateAndReviewService: rateAndReviewService,
          );
        },
      },
    );
  }
}
