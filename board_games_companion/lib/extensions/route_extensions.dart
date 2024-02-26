import 'package:board_games_companion/pages/enter_score/enter_score_dialog.dart';
import 'package:flutter/widgets.dart';

import '../pages/about/about_page.dart';
import '../pages/board_game_details/board_game_details_page.dart';
import '../pages/create_board_game/create_board_game_page.dart';
import '../pages/edit_playthrough/edit_playthrough_page.dart';
import '../pages/edit_playthrough/playthrough_note_page.dart';
import '../pages/home/home_page.dart';
import '../pages/player/player_page.dart';
import '../pages/plays/game_spinner_game_selected_dialog.dart';
import '../pages/playthroughs/bgg_plays_import_report_dialog.dart';
import '../pages/playthroughs/playthrough_migration_page.dart';
import '../pages/playthroughs/playthrough_players_selection_page.dart';
import '../pages/playthroughs/playthroughs_page.dart';
import '../pages/settings/settings_page.dart';

extension RouteExtensions on Route<dynamic> {
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
      case CreateBoardGamePage.pageRoute:
        return 'Create Board Game';
      case PlaythroughMigrationPage.pageRoute:
        return 'Playthrough Migration';
      case PlahtyroughPlayersSelectionPage.pageRoute:
        return 'Playthrough Player Selection';
      case EnterScoreDialog.pageRoute:
        return 'Enter Score';
      case GameSpinnerGameSelectedDialog.pageRoute:
        return 'Game Spinner Selected Game';
      case BggPlaysImportReportDialog.pageRoute:
        return 'BGG Plays Import';
      default:
        return settings.name ?? 'Undefined';
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
      case CreateBoardGamePage.pageRoute:
        return 'CreateBoardGamePage';
      case PlaythroughMigrationPage.pageRoute:
        return 'PlaythroughMigrationPage';
      case PlahtyroughPlayersSelectionPage.pageRoute:
        return 'PlahtyroughPlayersSelectionPage';
      default:
        return settings.name ?? 'Undefined';
    }
  }
}
