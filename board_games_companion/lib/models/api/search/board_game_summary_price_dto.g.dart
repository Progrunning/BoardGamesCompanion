// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_summary_price_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoardGameSummaryPriceDtoImpl _$$BoardGameSummaryPriceDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BoardGameSummaryPriceDtoImpl(
      region: json['region'] as String,
      websiteUrl: json['websiteUrl'] as String,
      lowestPrice: (json['lowestPrice'] as num?)?.toDouble(),
      lowestPriceStoreName: json['lowestPriceStoreName'] as String?,
    );

Map<String, dynamic> _$$BoardGameSummaryPriceDtoImplToJson(
        _$BoardGameSummaryPriceDtoImpl instance) =>
    <String, dynamic>{
      'region': instance.region,
      'websiteUrl': instance.websiteUrl,
      'lowestPrice': instance.lowestPrice,
      'lowestPriceStoreName': instance.lowestPriceStoreName,
    };
