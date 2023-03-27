// ignore_for_file: avoid_classes_with_only_static_members

import 'package:board_games_companion/services/board_games_service.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/services/score_service.dart';
import 'package:board_games_companion/services/search_service.dart';
import 'package:board_games_companion/services/user_service.dart';

import '../services/board_games_filters_service.dart';
import '../services/playthroughs_service.dart';
import '../services/preferences_service.dart';

class HiveBoxes {
  static Map<Type, String> boxesNamesMap = {
    BoardGamesService: boardGames,
    PlayerService: players,
    UserService: user,
    PlaythroughService: playthroughs,
    ScoreService: scores,
    BoardGamesFiltersService: collectionFilters,
    PreferencesService: preferences,
    SearchService: search,
  };

  static const boardGames = 'boardGames';
  static const players = 'players';
  static const user = 'user';
  static const playthroughs = 'playthroughs';
  static const scores = 'scores';
  static const collectionFilters = 'collectionFilters';
  static const preferences = 'preferences';
  static const search = 'search';
  static const dioCache = 'dioCache';

  static const boardGamesDetailsTypeId = 0;
  static const boardGamesCategoryTypeId = 1;
  static const playersTypeId = 2;
  static const playthroughTypeId = 3;
  static const scoreTypeId = 4;
  static const playthroughStatusTypeId = 5;
  static const boardGamesPublisherTypeId = 6;
  static const boardGamesArtistTypeId = 7;
  static const boardGamesDesignerTypeId = 8;
  static const boardGamesrankTypeId = 9;
  static const userTypeId = 10;
  static const sortByTypeId = 11;
  static const sortByOptionTypeId = 12;
  static const orderByTypeId = 13;
  static const collectionFiltersId = 14;
  static const boardGamesExpansionId = 15;
  static const gameFamilyTypeId = 16;
  static const boardGameSettingsTypeId = 17;
  static const playthroughNoteId = 18;
  static const searchHistoryEntryId = 19;
  static const gameClassificationTypeId = 20;
  static const noScoreGameResultTypeId = 21;
  static const cooperativeGameResultTypeId = 22;
}
