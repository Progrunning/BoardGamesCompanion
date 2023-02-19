import 'package:freezed_annotation/freezed_annotation.dart';

part 'bgg_search_result.freezed.dart';

@freezed
class BggSearchResult with _$BggSearchResult {
  const factory BggSearchResult.createGame({
    required String boardGameName,
  }) = _createGame;
}
