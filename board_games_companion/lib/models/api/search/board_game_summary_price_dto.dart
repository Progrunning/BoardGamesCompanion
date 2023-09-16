import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_game_summary_price_dto.freezed.dart';
part 'board_game_summary_price_dto.g.dart';

@freezed
class BoardGameSummaryPriceDto with _$BoardGameSummaryPriceDto {
  const factory BoardGameSummaryPriceDto({
    required String region,
    required String websiteUrl,
    double? lowestPrice,
    String? lowestPriceStoreName,
  }) = _BoardGameSummaryPriceDto;

  const BoardGameSummaryPriceDto._();

  factory BoardGameSummaryPriceDto.fromJson(Map<String, dynamic> json) =>
      _$BoardGameSummaryPriceDtoFromJson(json);
}
