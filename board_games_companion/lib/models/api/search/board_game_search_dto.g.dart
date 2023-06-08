// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_search_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BoardGameSearchResultDto _$$_BoardGameSearchResultDtoFromJson(
        Map<String, dynamic> json) =>
    _$_BoardGameSearchResultDto(
      id: json['id'] as String,
      name: json['name'] as String,
      yearPublished: json['yearPublished'] as int,
      type: $enumDecodeNullable(_$BoardGameTypeEnumMap, json['type']) ??
          BoardGameType.boardGame,
      imageUrl: json['imageUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      description: json['description'] as String?,
      minNumberOfPlayers: json['minNumberOfPlayers'] as int?,
      maxNumberOfPlayers: json['maxNumberOfPlayers'] as int?,
      minPlaytimeInMinutes: json['minPlaytimeInMinutes'] as int?,
      maxPlaytimeInMinutes: json['maxPlaytimeInMinutes'] as int?,
      complexity: (json['complexity'] as num?)?.toDouble(),
      rank: json['rank'] as int?,
    );

Map<String, dynamic> _$$_BoardGameSearchResultDtoToJson(
        _$_BoardGameSearchResultDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'yearPublished': instance.yearPublished,
      'type': _$BoardGameTypeEnumMap[instance.type]!,
      'imageUrl': instance.imageUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'description': instance.description,
      'minNumberOfPlayers': instance.minNumberOfPlayers,
      'maxNumberOfPlayers': instance.maxNumberOfPlayers,
      'minPlaytimeInMinutes': instance.minPlaytimeInMinutes,
      'maxPlaytimeInMinutes': instance.maxPlaytimeInMinutes,
      'complexity': instance.complexity,
      'rank': instance.rank,
    };

const _$BoardGameTypeEnumMap = {
  BoardGameType.boardGame: 'BoardGame',
  BoardGameType.expansion: 'Expansion',
};