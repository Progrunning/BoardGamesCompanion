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
      name: Analytics.ViewPage,
      parameters: <String, String>{Analytics.RouteName: routeName!},
    );

    switch (routeName) {
      case BoardGamesDetailsPage.pageRoute:
        final _arguments = route.settings.arguments as BoardGameDetailsPageArguments;
        _analtyicsService.logEvent(
          name: Analytics.ViewGameDetails,
          parameters: <String, String>{
            Analytics.BoardGameIdParameter: _arguments.boardGameId,
            Analytics.BoardGameNameParameter: _arguments.boardGameName,
          },
        );
        break;
      case PlaythroughsPage.pageRoute:
        final _arguments = route.settings.arguments as PlaythroughsPageArguments;
        _analtyicsService.logEvent(
          name: Analytics.ViewGameStats,
          parameters: <String, String?>{
            Analytics.BoardGameIdParameter: _arguments.boardGameDetails.id,
            Analytics.BoardGameNameParameter: _arguments.boardGameDetails.name,
          },
        );
        break;
      case EditPlaythoughPage.pageRoute:
        final _arguments = route.settings.arguments as EditPlaythroughPageArguments;
        _analtyicsService.logEvent(
          name: Analytics.EditPlaythrough,
          parameters: <String, String>{
            Analytics.BoardGameIdParameter: _arguments.playthroughStore.playthrough.boardGameId,
          },
        );
        break;
    }
  }
}
