import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_game_search_error.freezed.dart';

@freezed
class BoardGameSearchError with _$BoardGameSearchError{
  const factory BoardGameSearchError.timout() = _timout;
  const factory BoardGameSearchError.generic() = _generic;
}