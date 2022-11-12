import 'package:flutter/widgets.dart';

import '../pages/about/about_page.dart';
import '../pages/board_game_details/board_game_details_page.dart';
import '../pages/edit_playthrough/edit_playthrough_page.dart';
import '../pages/edit_playthrough/playthrough_note_page.dart';
import '../pages/home/home_page.dart';
import '../pages/player/player_page.dart';
import '../pages/playthroughs/playthroughs_page.dart';
import '../pages/settings/settings_page.dart';

extension RouteExtensions on Route {
  String toScreenName() {
    switch (settings.name) {
      case AboutPage.pageRoute:
        return 'About';
      case BoardGamesDetailsPage.pageRoute:
        return 'Board Games Details';
      case EditPlaythroughPage.pageRoute:
        return 'Edit Playthrough';
      case HomePage.pageRoute:
        return 'Home';
      case PlaythroughsPage.pageRoute:
        return 'Playthroughs';
      case PlaythroughNotePage.pageRoute:
        return 'Playthrough Note';
      case PlayerPage.pageRoute:
        return 'Player';
      case SettingsPage.pageRoute:
        return 'Settings';
      default:
        return 'Undefined';
    }
  }

  String toScreenClassName() {
    switch (settings.name) {
      case AboutPage.pageRoute:
        return 'AboutPage';
      case BoardGamesDetailsPage.pageRoute:
        return 'BoardGamesDetailsPage';
      case EditPlaythroughPage.pageRoute:
        return 'EditPlaythroughPage';
      case HomePage.pageRoute:
        return 'HomePage';
      case PlaythroughsPage.pageRoute:
        return 'PlaythroughsPage';
      case PlaythroughNotePage.pageRoute:
        return 'PlaythroughNotePage';
      case PlayerPage.pageRoute:
        return 'PlayerPage';
      case SettingsPage.pageRoute:
        return 'SettingsPage';
      default:
        return 'Undefined';
    }
  }
}
