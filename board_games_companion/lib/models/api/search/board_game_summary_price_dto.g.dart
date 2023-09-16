// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_summary_price_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BoardGameSummaryPriceDto _$$_BoardGameSummaryPriceDtoFromJson(
        Map<String, dynamic> json) =>
    _$_BoardGameSummaryPriceDto(
      region: json['region'] as String,
      websiteUrl: json['websiteUrl'] as String,
      lowestPrice: (json['lowestPrice'] as num?)?.toDouble(),
      lowestPriceStoreName: json['lowestPriceStoreName'] as String?,
    );

Map<String, dynamic> _$$_BoardGameSummaryPriceDtoToJson(
        _$_BoardGameSummaryPriceDto instance) =>
    <String, dynamic>{
      'region': instance.region,
      'websiteUrl': instance.websiteUrl,
      'lowestPrice': instance.lowestPrice,
      'lowestPriceStoreName': instance.lowestPriceStoreName,
    };
