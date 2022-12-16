import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_suggestion.freezed.dart';

@freezed
class SearchSuggestion with _$SearchSuggestion {
  const factory SearchSuggestion({
    required String suggestion,
    required SuggestionType type,
  }) = _SearchSuggestion;
}

enum SuggestionType {
  boardGame,
  historicalSearch,
}
