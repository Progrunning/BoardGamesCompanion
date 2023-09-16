// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_game_search_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BoardGameSearchResultDto _$BoardGameSearchResultDtoFromJson(Map<String, dynamic> json) {
  return _BoardGameSearchResultDto.fromJson(json);
}

/// @nodoc
mixin _$BoardGameSearchResultDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int? get yearPublished => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: BoardGameType.boardGame)
  BoardGameType get type => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int? get minNumberOfPlayers => throw _privateConstructorUsedError;
  int? get maxNumberOfPlayers => throw _privateConstructorUsedError;
  int? get minPlaytimeInMinutes => throw _privateConstructorUsedError;
  int? get maxPlaytimeInMinutes => throw _privateConstructorUsedError;
  double? get complexity => throw _privateConstructorUsedError;
  int? get rank => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  List<BoardGameSummaryPriceDto>? get prices => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BoardGameSearchResultDtoCopyWith<BoardGameSearchResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardGameSearchResultDtoCopyWith<$Res> {
  factory $BoardGameSearchResultDtoCopyWith(
          BoardGameSearchResultDto value, $Res Function(BoardGameSearchResultDto) then) =
      _$BoardGameSearchResultDtoCopyWithImpl<$Res, BoardGameSearchResultDto>;
  @useResult
  $Res call(
      {String id,
      String name,
      int? yearPublished,
      @JsonKey(unknownEnumValue: BoardGameType.boardGame) BoardGameType type,
      String? imageUrl,
      String? thumbnailUrl,
      String? description,
      int? minNumberOfPlayers,
      int? maxNumberOfPlayers,
      int? minPlaytimeInMinutes,
      int? maxPlaytimeInMinutes,
      double? complexity,
      int? rank,
      DateTime? lastUpdated,
      List<BoardGameSummaryPriceDto>? prices});
}

/// @nodoc
class _$BoardGameSearchResultDtoCopyWithImpl<$Res, $Val extends BoardGameSearchResultDto>
    implements $BoardGameSearchResultDtoCopyWith<$Res> {
  _$BoardGameSearchResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? yearPublished = freezed,
    Object? type = null,
    Object? imageUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? description = freezed,
    Object? minNumberOfPlayers = freezed,
    Object? maxNumberOfPlayers = freezed,
    Object? minPlaytimeInMinutes = freezed,
    Object? maxPlaytimeInMinutes = freezed,
    Object? complexity = freezed,
    Object? rank = freezed,
    Object? lastUpdated = freezed,
    Object? prices = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      yearPublished: freezed == yearPublished
          ? _value.yearPublished
          : yearPublished // ignore: cast_nullable_to_non_nullable
              as int?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BoardGameType,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      minNumberOfPlayers: freezed == minNumberOfPlayers
          ? _value.minNumberOfPlayers
          : minNumberOfPlayers // ignore: cast_nullable_to_non_nullable
              as int?,
      maxNumberOfPlayers: freezed == maxNumberOfPlayers
          ? _value.maxNumberOfPlayers
          : maxNumberOfPlayers // ignore: cast_nullable_to_non_nullable
              as int?,
      minPlaytimeInMinutes: freezed == minPlaytimeInMinutes
          ? _value.minPlaytimeInMinutes
          : minPlaytimeInMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      maxPlaytimeInMinutes: freezed == maxPlaytimeInMinutes
          ? _value.maxPlaytimeInMinutes
          : maxPlaytimeInMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      complexity: freezed == complexity
          ? _value.complexity
          : complexity // ignore: cast_nullable_to_non_nullable
              as double?,
      rank: freezed == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      prices: freezed == prices
          ? _value.prices
          : prices // ignore: cast_nullable_to_non_nullable
              as List<BoardGameSummaryPriceDto>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BoardGameSearchResultDtoCopyWith<$Res>
    implements $BoardGameSearchResultDtoCopyWith<$Res> {
  factory _$$_BoardGameSearchResultDtoCopyWith(
          _$_BoardGameSearchResultDto value, $Res Function(_$_BoardGameSearchResultDto) then) =
      __$$_BoardGameSearchResultDtoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int? yearPublished,
      @JsonKey(unknownEnumValue: BoardGameType.boardGame) BoardGameType type,
      String? imageUrl,
      String? thumbnailUrl,
      String? description,
      int? minNumberOfPlayers,
      int? maxNumberOfPlayers,
      int? minPlaytimeInMinutes,
      int? maxPlaytimeInMinutes,
      double? complexity,
      int? rank,
      DateTime? lastUpdated,
      List<BoardGameSummaryPriceDto>? prices});
}

/// @nodoc
class __$$_BoardGameSearchResultDtoCopyWithImpl<$Res>
    extends _$BoardGameSearchResultDtoCopyWithImpl<$Res, _$_BoardGameSearchResultDto>
    implements _$$_BoardGameSearchResultDtoCopyWith<$Res> {
  __$$_BoardGameSearchResultDtoCopyWithImpl(
      _$_BoardGameSearchResultDto _value, $Res Function(_$_BoardGameSearchResultDto) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? yearPublished = freezed,
    Object? type = null,
    Object? imageUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? description = freezed,
    Object? minNumberOfPlayers = freezed,
    Object? maxNumberOfPlayers = freezed,
    Object? minPlaytimeInMinutes = freezed,
    Object? maxPlaytimeInMinutes = freezed,
    Object? complexity = freezed,
    Object? rank = freezed,
    Object? lastUpdated = freezed,
    Object? prices = freezed,
  }) {
    return _then(_$_BoardGameSearchResultDto(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      yearPublished: freezed == yearPublished
          ? _value.yearPublished
          : yearPublished // ignore: cast_nullable_to_non_nullable
              as int?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BoardGameType,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      minNumberOfPlayers: freezed == minNumberOfPlayers
          ? _value.minNumberOfPlayers
          : minNumberOfPlayers // ignore: cast_nullable_to_non_nullable
              as int?,
      maxNumberOfPlayers: freezed == maxNumberOfPlayers
          ? _value.maxNumberOfPlayers
          : maxNumberOfPlayers // ignore: cast_nullable_to_non_nullable
              as int?,
      minPlaytimeInMinutes: freezed == minPlaytimeInMinutes
          ? _value.minPlaytimeInMinutes
          : minPlaytimeInMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      maxPlaytimeInMinutes: freezed == maxPlaytimeInMinutes
          ? _value.maxPlaytimeInMinutes
          : maxPlaytimeInMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      complexity: freezed == complexity
          ? _value.complexity
          : complexity // ignore: cast_nullable_to_non_nullable
              as double?,
      rank: freezed == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      prices: freezed == prices
          ? _value._prices
          : prices // ignore: cast_nullable_to_non_nullable
              as List<BoardGameSummaryPriceDto>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BoardGameSearchResultDto extends _BoardGameSearchResultDto {
  const _$_BoardGameSearchResultDto(
      {required this.id,
      required this.name,
      this.yearPublished,
      @JsonKey(unknownEnumValue: BoardGameType.boardGame) this.type = BoardGameType.boardGame,
      this.imageUrl,
      this.thumbnailUrl,
      this.description,
      this.minNumberOfPlayers,
      this.maxNumberOfPlayers,
      this.minPlaytimeInMinutes,
      this.maxPlaytimeInMinutes,
      this.complexity,
      this.rank,
      this.lastUpdated,
      final List<BoardGameSummaryPriceDto>? prices})
      : _prices = prices,
        super._();

  factory _$_BoardGameSearchResultDto.fromJson(Map<String, dynamic> json) =>
      _$$_BoardGameSearchResultDtoFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int? yearPublished;
  @override
  @JsonKey(unknownEnumValue: BoardGameType.boardGame)
  final BoardGameType type;
  @override
  final String? imageUrl;
  @override
  final String? thumbnailUrl;
  @override
  final String? description;
  @override
  final int? minNumberOfPlayers;
  @override
  final int? maxNumberOfPlayers;
  @override
  final int? minPlaytimeInMinutes;
  @override
  final int? maxPlaytimeInMinutes;
  @override
  final double? complexity;
  @override
  final int? rank;
  @override
  final DateTime? lastUpdated;
  final List<BoardGameSummaryPriceDto>? _prices;
  @override
  List<BoardGameSummaryPriceDto>? get prices {
    final value = _prices;
    if (value == null) return null;
    if (_prices is EqualUnmodifiableListView) return _prices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'BoardGameSearchResultDto(id: $id, name: $name, yearPublished: $yearPublished, type: $type, imageUrl: $imageUrl, thumbnailUrl: $thumbnailUrl, description: $description, minNumberOfPlayers: $minNumberOfPlayers, maxNumberOfPlayers: $maxNumberOfPlayers, minPlaytimeInMinutes: $minPlaytimeInMinutes, maxPlaytimeInMinutes: $maxPlaytimeInMinutes, complexity: $complexity, rank: $rank, lastUpdated: $lastUpdated, prices: $prices)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BoardGameSearchResultDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.yearPublished, yearPublished) ||
                other.yearPublished == yearPublished) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.description, description) || other.description == description) &&
            (identical(other.minNumberOfPlayers, minNumberOfPlayers) ||
                other.minNumberOfPlayers == minNumberOfPlayers) &&
            (identical(other.maxNumberOfPlayers, maxNumberOfPlayers) ||
                other.maxNumberOfPlayers == maxNumberOfPlayers) &&
            (identical(other.minPlaytimeInMinutes, minPlaytimeInMinutes) ||
                other.minPlaytimeInMinutes == minPlaytimeInMinutes) &&
            (identical(other.maxPlaytimeInMinutes, maxPlaytimeInMinutes) ||
                other.maxPlaytimeInMinutes == maxPlaytimeInMinutes) &&
            (identical(other.complexity, complexity) || other.complexity == complexity) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated) &&
            const DeepCollectionEquality().equals(other._prices, _prices));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      yearPublished,
      type,
      imageUrl,
      thumbnailUrl,
      description,
      minNumberOfPlayers,
      maxNumberOfPlayers,
      minPlaytimeInMinutes,
      maxPlaytimeInMinutes,
      complexity,
      rank,
      lastUpdated,
      const DeepCollectionEquality().hash(_prices));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BoardGameSearchResultDtoCopyWith<_$_BoardGameSearchResultDto> get copyWith =>
      __$$_BoardGameSearchResultDtoCopyWithImpl<_$_BoardGameSearchResultDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BoardGameSearchResultDtoToJson(
      this,
    );
  }
}

abstract class _BoardGameSearchResultDto extends BoardGameSearchResultDto {
  const factory _BoardGameSearchResultDto(
      {required final String id,
      required final String name,
      final int? yearPublished,
      @JsonKey(unknownEnumValue: BoardGameType.boardGame) final BoardGameType type,
      final String? imageUrl,
      final String? thumbnailUrl,
      final String? description,
      final int? minNumberOfPlayers,
      final int? maxNumberOfPlayers,
      final int? minPlaytimeInMinutes,
      final int? maxPlaytimeInMinutes,
      final double? complexity,
      final int? rank,
      final DateTime? lastUpdated,
      final List<BoardGameSummaryPriceDto>? prices}) = _$_BoardGameSearchResultDto;
  const _BoardGameSearchResultDto._() : super._();

  factory _BoardGameSearchResultDto.fromJson(Map<String, dynamic> json) =
      _$_BoardGameSearchResultDto.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int? get yearPublished;
  @override
  @JsonKey(unknownEnumValue: BoardGameType.boardGame)
  BoardGameType get type;
  @override
  String? get imageUrl;
  @override
  String? get thumbnailUrl;
  @override
  String? get description;
  @override
  int? get minNumberOfPlayers;
  @override
  int? get maxNumberOfPlayers;
  @override
  int? get minPlaytimeInMinutes;
  @override
  int? get maxPlaytimeInMinutes;
  @override
  double? get complexity;
  @override
  int? get rank;
  @override
  DateTime? get lastUpdated;
  @override
  List<BoardGameSummaryPriceDto>? get prices;
  @override
  @JsonKey(ignore: true)
  _$$_BoardGameSearchResultDtoCopyWith<_$_BoardGameSearchResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}
