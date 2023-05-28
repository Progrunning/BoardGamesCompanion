import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_game_search_dto.freezed.dart';
part 'board_game_search_dto.g.dart';

@freezed
class BoardGameSearchDto with _$BoardGameSearchDto {
  const factory BoardGameSearchDto({
    required String id,
    required String name,
  }) = _BoardGameSearchDto;

  const BoardGameSearchDto._();

  factory BoardGameSearchDto.fromJson(Map<String, dynamic> json) =>
      _$BoardGameSearchDtoFromJson(json);
}
