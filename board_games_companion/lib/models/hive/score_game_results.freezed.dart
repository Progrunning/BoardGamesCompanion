// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_game_results.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ScoreGameResult {
  @HiveField(0)
  double? get points => throw _privateConstructorUsedError;
  @HiveField(1)
  int? get place => throw _privateConstructorUsedError;
  @HiveField(2)
  ScoreTiebreakerType? get tiebreakerType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScoreGameResultCopyWith<ScoreGameResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreGameResultCopyWith<$Res> {
  factory $ScoreGameResultCopyWith(
          ScoreGameResult value, $Res Function(ScoreGameResult) then) =
      _$ScoreGameResultCopyWithImpl<$Res, ScoreGameResult>;
  @useResult
  $Res call(
      {@HiveField(0) double? points,
      @HiveField(1) int? place,
      @HiveField(2) ScoreTiebreakerType? tiebreakerType});
}

/// @nodoc
class _$ScoreGameResultCopyWithImpl<$Res, $Val extends ScoreGameResult>
    implements $ScoreGameResultCopyWith<$Res> {
  _$ScoreGameResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = freezed,
    Object? place = freezed,
    Object? tiebreakerType = freezed,
  }) {
    return _then(_value.copyWith(
      points: freezed == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as double?,
      place: freezed == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as int?,
      tiebreakerType: freezed == tiebreakerType
          ? _value.tiebreakerType
          : tiebreakerType // ignore: cast_nullable_to_non_nullable
              as ScoreTiebreakerType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ScoreGameResultCopyWith<$Res>
    implements $ScoreGameResultCopyWith<$Res> {
  factory _$$_ScoreGameResultCopyWith(
          _$_ScoreGameResult value, $Res Function(_$_ScoreGameResult) then) =
      __$$_ScoreGameResultCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) double? points,
      @HiveField(1) int? place,
      @HiveField(2) ScoreTiebreakerType? tiebreakerType});
}

/// @nodoc
class __$$_ScoreGameResultCopyWithImpl<$Res>
    extends _$ScoreGameResultCopyWithImpl<$Res, _$_ScoreGameResult>
    implements _$$_ScoreGameResultCopyWith<$Res> {
  __$$_ScoreGameResultCopyWithImpl(
      _$_ScoreGameResult _value, $Res Function(_$_ScoreGameResult) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = freezed,
    Object? place = freezed,
    Object? tiebreakerType = freezed,
  }) {
    return _then(_$_ScoreGameResult(
      points: freezed == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as double?,
      place: freezed == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as int?,
      tiebreakerType: freezed == tiebreakerType
          ? _value.tiebreakerType
          : tiebreakerType // ignore: cast_nullable_to_non_nullable
              as ScoreTiebreakerType?,
    ));
  }
}

/// @nodoc

@HiveType(
    typeId: HiveBoxes.scoreGameResultTypeId,
    adapterName: 'ScoreGameResultAdapter')
class _$_ScoreGameResult extends _ScoreGameResult {
  const _$_ScoreGameResult(
      {@HiveField(0) this.points,
      @HiveField(1) this.place,
      @HiveField(2) this.tiebreakerType})
      : super._();

  @override
  @HiveField(0)
  final double? points;
  @override
  @HiveField(1)
  final int? place;
  @override
  @HiveField(2)
  final ScoreTiebreakerType? tiebreakerType;

  @override
  String toString() {
    return 'ScoreGameResult(points: $points, place: $place, tiebreakerType: $tiebreakerType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ScoreGameResult &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.place, place) || other.place == place) &&
            (identical(other.tiebreakerType, tiebreakerType) ||
                other.tiebreakerType == tiebreakerType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, points, place, tiebreakerType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ScoreGameResultCopyWith<_$_ScoreGameResult> get copyWith =>
      __$$_ScoreGameResultCopyWithImpl<_$_ScoreGameResult>(this, _$identity);
}

abstract class _ScoreGameResult extends ScoreGameResult {
  const factory _ScoreGameResult(
          {@HiveField(0) final double? points,
          @HiveField(1) final int? place,
          @HiveField(2) final ScoreTiebreakerType? tiebreakerType}) =
      _$_ScoreGameResult;
  const _ScoreGameResult._() : super._();

  @override
  @HiveField(0)
  double? get points;
  @override
  @HiveField(1)
  int? get place;
  @override
  @HiveField(2)
  ScoreTiebreakerType? get tiebreakerType;
  @override
  @JsonKey(ignore: true)
  _$$_ScoreGameResultCopyWith<_$_ScoreGameResult> get copyWith =>
      throw _privateConstructorUsedError;
}
