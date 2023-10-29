// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_game_summary_price_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BoardGameSummaryPriceDto _$BoardGameSummaryPriceDtoFromJson(
    Map<String, dynamic> json) {
  return _BoardGameSummaryPriceDto.fromJson(json);
}

/// @nodoc
mixin _$BoardGameSummaryPriceDto {
  String get region => throw _privateConstructorUsedError;
  String get websiteUrl => throw _privateConstructorUsedError;
  double? get lowestPrice => throw _privateConstructorUsedError;
  String? get lowestPriceStoreName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BoardGameSummaryPriceDtoCopyWith<BoardGameSummaryPriceDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardGameSummaryPriceDtoCopyWith<$Res> {
  factory $BoardGameSummaryPriceDtoCopyWith(BoardGameSummaryPriceDto value,
          $Res Function(BoardGameSummaryPriceDto) then) =
      _$BoardGameSummaryPriceDtoCopyWithImpl<$Res, BoardGameSummaryPriceDto>;
  @useResult
  $Res call(
      {String region,
      String websiteUrl,
      double? lowestPrice,
      String? lowestPriceStoreName});
}

/// @nodoc
class _$BoardGameSummaryPriceDtoCopyWithImpl<$Res,
        $Val extends BoardGameSummaryPriceDto>
    implements $BoardGameSummaryPriceDtoCopyWith<$Res> {
  _$BoardGameSummaryPriceDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? region = null,
    Object? websiteUrl = null,
    Object? lowestPrice = freezed,
    Object? lowestPriceStoreName = freezed,
  }) {
    return _then(_value.copyWith(
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      websiteUrl: null == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String,
      lowestPrice: freezed == lowestPrice
          ? _value.lowestPrice
          : lowestPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      lowestPriceStoreName: freezed == lowestPriceStoreName
          ? _value.lowestPriceStoreName
          : lowestPriceStoreName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoardGameSummaryPriceDtoImplCopyWith<$Res>
    implements $BoardGameSummaryPriceDtoCopyWith<$Res> {
  factory _$$BoardGameSummaryPriceDtoImplCopyWith(
          _$BoardGameSummaryPriceDtoImpl value,
          $Res Function(_$BoardGameSummaryPriceDtoImpl) then) =
      __$$BoardGameSummaryPriceDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String region,
      String websiteUrl,
      double? lowestPrice,
      String? lowestPriceStoreName});
}

/// @nodoc
class __$$BoardGameSummaryPriceDtoImplCopyWithImpl<$Res>
    extends _$BoardGameSummaryPriceDtoCopyWithImpl<$Res,
        _$BoardGameSummaryPriceDtoImpl>
    implements _$$BoardGameSummaryPriceDtoImplCopyWith<$Res> {
  __$$BoardGameSummaryPriceDtoImplCopyWithImpl(
      _$BoardGameSummaryPriceDtoImpl _value,
      $Res Function(_$BoardGameSummaryPriceDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? region = null,
    Object? websiteUrl = null,
    Object? lowestPrice = freezed,
    Object? lowestPriceStoreName = freezed,
  }) {
    return _then(_$BoardGameSummaryPriceDtoImpl(
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      websiteUrl: null == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String,
      lowestPrice: freezed == lowestPrice
          ? _value.lowestPrice
          : lowestPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      lowestPriceStoreName: freezed == lowestPriceStoreName
          ? _value.lowestPriceStoreName
          : lowestPriceStoreName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoardGameSummaryPriceDtoImpl extends _BoardGameSummaryPriceDto {
  const _$BoardGameSummaryPriceDtoImpl(
      {required this.region,
      required this.websiteUrl,
      this.lowestPrice,
      this.lowestPriceStoreName})
      : super._();

  factory _$BoardGameSummaryPriceDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoardGameSummaryPriceDtoImplFromJson(json);

  @override
  final String region;
  @override
  final String websiteUrl;
  @override
  final double? lowestPrice;
  @override
  final String? lowestPriceStoreName;

  @override
  String toString() {
    return 'BoardGameSummaryPriceDto(region: $region, websiteUrl: $websiteUrl, lowestPrice: $lowestPrice, lowestPriceStoreName: $lowestPriceStoreName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardGameSummaryPriceDtoImpl &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.websiteUrl, websiteUrl) ||
                other.websiteUrl == websiteUrl) &&
            (identical(other.lowestPrice, lowestPrice) ||
                other.lowestPrice == lowestPrice) &&
            (identical(other.lowestPriceStoreName, lowestPriceStoreName) ||
                other.lowestPriceStoreName == lowestPriceStoreName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, region, websiteUrl, lowestPrice, lowestPriceStoreName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardGameSummaryPriceDtoImplCopyWith<_$BoardGameSummaryPriceDtoImpl>
      get copyWith => __$$BoardGameSummaryPriceDtoImplCopyWithImpl<
          _$BoardGameSummaryPriceDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoardGameSummaryPriceDtoImplToJson(
      this,
    );
  }
}

abstract class _BoardGameSummaryPriceDto extends BoardGameSummaryPriceDto {
  const factory _BoardGameSummaryPriceDto(
      {required final String region,
      required final String websiteUrl,
      final double? lowestPrice,
      final String? lowestPriceStoreName}) = _$BoardGameSummaryPriceDtoImpl;
  const _BoardGameSummaryPriceDto._() : super._();

  factory _BoardGameSummaryPriceDto.fromJson(Map<String, dynamic> json) =
      _$BoardGameSummaryPriceDtoImpl.fromJson;

  @override
  String get region;
  @override
  String get websiteUrl;
  @override
  double? get lowestPrice;
  @override
  String? get lowestPriceStoreName;
  @override
  @JsonKey(ignore: true)
  _$$BoardGameSummaryPriceDtoImplCopyWith<_$BoardGameSummaryPriceDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
