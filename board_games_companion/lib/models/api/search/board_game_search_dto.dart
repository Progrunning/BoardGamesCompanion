import 'package:freezed_annotation/freezed_annotation.dart';

import '../board_game_type.dart';

part 'board_game_search_dto.freezed.dart';
part 'board_game_search_dto.g.dart';

@freezed
class BoardGameSearchResultDto with _$BoardGameSearchResultDto {
  const factory BoardGameSearchResultDto({
    required String id,
    required String name,
    required int yearPublished,
    @Default(BoardGameType.boardGame) BoardGameType type,
    String? imageUrl,
    String? thumbnailUrl,
    String? description,
    int? minNumberOfPlayers,
    int? maxNumberOfPlayers,
    int? minPlaytimeInMinutes,
    int? maxPlaytimeInMinutes,
    double? complexity,
    int? rank,
  }) = _BoardGameSearchResultDto;

  const BoardGameSearchResultDto._();

  factory BoardGameSearchResultDto.fromJson(Map<String, dynamic> json) =>
      _$BoardGameSearchResultDtoFromJson(json);
}
