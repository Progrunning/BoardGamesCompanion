import 'package:basics/basics.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../common/analytics.dart';
import '../models/navigation/board_game_details_page_arguments.dart';
import '../models/navigation/edit_playthrough_page_arguments.dart';
import '../models/navigation/playthroughs_page_arguments.dart';
import '../pages/board_game_details/board_game_details_page.dart';
import '../pages/edit_playthrough/edit_playthrough_page.dart';
import '../pages/playthroughs/playthroughs_page.dart';
import '../services/analytics_service.dart';

@injectable
class AnalyticsRouteObserver extends RouteObserver<PageRoute<Object>> {
  AnalyticsRouteObserver(this._analtyicsService);

  final AnalyticsService _analtyicsService;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    final String? routeName = route.settings.name;
    if (routeName?.isBlank ?? true) {
      return;
    }

    _analtyicsService.logEvent(
      name: Analytics.viewPage,
      parameters: <String, String>{Analytics.routeName: routeName!},
    );

    switch (routeName) {
      case BoardGamesDetailsPage.pageRoute:
        final arguments = route.settings.arguments as BoardGameDetailsPageArguments;
        _analtyicsService.logEvent(
          name: Analytics.viewGameDetails,
          parameters: <String, String>{Analytics.boardGameIdParameter: arguments.boardGameId},
        );
        break;
      case PlaythroughsPage.pageRoute:
        final arguments = route.settings.arguments as PlaythroughsPageArguments;
        _analtyicsService.logEvent(
          name: Analytics.viewGameStats,
          parameters: <String, String?>{
            Analytics.boardGameIdParameter: arguments.boardGameDetails.id,
            Analytics.boardGameNameParameter: arguments.boardGameDetails.name,
          },
        );
        break;
      case EditPlaythroughPage.pageRoute:
        final arguments = route.settings.arguments as EditPlaythroughPageArguments;
        _analtyicsService.logEvent(
          name: Analytics.editPlaythrough,
          parameters: <String, String>{
            Analytics.boardGameIdParameter: arguments.boardGameId,
          },
        );
        break;
    }
  }
}
