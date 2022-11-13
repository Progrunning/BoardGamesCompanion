import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/hive/board_game_details.dart';

part 'search_results.freezed.dart';

@freezed
class SearchResults with _$SearchResults {
  const factory SearchResults.results(List<BoardGameDetails> boardGames) = _Results;
  const factory SearchResults.searching(String searchPhrase) = _Searching;
  const factory SearchResults.failure() = _Failure;
  const factory SearchResults.init() = _Init;
}
