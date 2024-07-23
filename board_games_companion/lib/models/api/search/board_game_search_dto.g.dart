// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_search_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoardGameSearchResultDtoImpl _$$BoardGameSearchResultDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BoardGameSearchResultDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      yearPublished: (json['yearPublished'] as num?)?.toInt(),
      type: $enumDecodeNullable(_$BoardGameTypeEnumMap, json['type'],
              unknownValue: BoardGameType.boardGame) ??
          BoardGameType.boardGame,
      imageUrl: json['imageUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      description: json['description'] as String?,
      minNumberOfPlayers: (json['minNumberOfPlayers'] as num?)?.toInt(),
      maxNumberOfPlayers: (json['maxNumberOfPlayers'] as num?)?.toInt(),
      minPlaytimeInMinutes: (json['minPlaytimeInMinutes'] as num?)?.toInt(),
      maxPlaytimeInMinutes: (json['maxPlaytimeInMinutes'] as num?)?.toInt(),
      complexity: (json['complexity'] as num?)?.toDouble(),
      rank: (json['rank'] as num?)?.toInt(),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      prices: (json['prices'] as List<dynamic>?)
          ?.map((e) =>
              BoardGameSummaryPriceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BoardGameSearchResultDtoImplToJson(
        _$BoardGameSearchResultDtoImpl instance) =>
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
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'prices': instance.prices,
    };

const _$BoardGameTypeEnumMap = {
  BoardGameType.boardGame: 'BoardGame',
  BoardGameType.expansion: 'Expansion',
};
