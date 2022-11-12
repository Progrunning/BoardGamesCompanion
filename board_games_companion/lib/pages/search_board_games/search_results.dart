import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/board_game.dart';

part 'search_results.freezed.dart';

@freezed
abstract class SearchResults with _$SearchResults {
  const factory SearchResults.results(List<BoardGame> boardGames) = _Results;
  const factory SearchResults.searching(String searchPhrase) = _Searching;
  const factory SearchResults.failure() = _Failure;
  const factory SearchResults.init() = _Init;
}
