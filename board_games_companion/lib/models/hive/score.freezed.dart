// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Score {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(2)
  String get playerId => throw _privateConstructorUsedError;
  @HiveField(3)
  String get boardGameId => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get value => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get playthroughId => throw _privateConstructorUsedError;
  @HiveField(5, defaultValue: null)
  NoScoreGameResult? get noScoreGameResult =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScoreCopyWith<Score> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreCopyWith<$Res> {
  factory $ScoreCopyWith(Score value, $Res Function(Score) then) =
      _$ScoreCopyWithImpl<$Res, Score>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(2) String playerId,
      @HiveField(3) String boardGameId,
      @HiveField(4) String? value,
      @HiveField(1) String? playthroughId,
      @HiveField(5, defaultValue: null) NoScoreGameResult? noScoreGameResult});

  $NoScoreGameResultCopyWith<$Res>? get noScoreGameResult;
}

/// @nodoc
class _$ScoreCopyWithImpl<$Res, $Val extends Score>
    implements $ScoreCopyWith<$Res> {
  _$ScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? boardGameId = null,
    Object? value = freezed,
    Object? playthroughId = freezed,
    Object? noScoreGameResult = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameId: null == boardGameId
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      playthroughId: freezed == playthroughId
          ? _value.playthroughId
          : playthroughId // ignore: cast_nullable_to_non_nullable
              as String?,
      noScoreGameResult: freezed == noScoreGameResult
          ? _value.noScoreGameResult
          : noScoreGameResult // ignore: cast_nullable_to_non_nullable
              as NoScoreGameResult?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NoScoreGameResultCopyWith<$Res>? get noScoreGameResult {
    if (_value.noScoreGameResult == null) {
      return null;
    }

    return $NoScoreGameResultCopyWith<$Res>(_value.noScoreGameResult!, (value) {
      return _then(_value.copyWith(noScoreGameResult: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ScoreCopyWith<$Res> implements $ScoreCopyWith<$Res> {
  factory _$$_ScoreCopyWith(_$_Score value, $Res Function(_$_Score) then) =
      __$$_ScoreCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(2) String playerId,
      @HiveField(3) String boardGameId,
      @HiveField(4) String? value,
      @HiveField(1) String? playthroughId,
      @HiveField(5, defaultValue: null) NoScoreGameResult? noScoreGameResult});

  @override
  $NoScoreGameResultCopyWith<$Res>? get noScoreGameResult;
}

/// @nodoc
class __$$_ScoreCopyWithImpl<$Res> extends _$ScoreCopyWithImpl<$Res, _$_Score>
    implements _$$_ScoreCopyWith<$Res> {
  __$$_ScoreCopyWithImpl(_$_Score _value, $Res Function(_$_Score) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? boardGameId = null,
    Object? value = freezed,
    Object? playthroughId = freezed,
    Object? noScoreGameResult = freezed,
  }) {
    return _then(_$_Score(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameId: null == boardGameId
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      playthroughId: freezed == playthroughId
          ? _value.playthroughId
          : playthroughId // ignore: cast_nullable_to_non_nullable
              as String?,
      noScoreGameResult: freezed == noScoreGameResult
          ? _value.noScoreGameResult
          : noScoreGameResult // ignore: cast_nullable_to_non_nullable
              as NoScoreGameResult?,
    ));
  }
}

/// @nodoc

@HiveType(typeId: HiveBoxes.scoreTypeId, adapterName: 'ScoreAdapter')
class _$_Score extends _Score {
  const _$_Score(
      {@HiveField(0) required this.id,
      @HiveField(2) required this.playerId,
      @HiveField(3) required this.boardGameId,
      @HiveField(4) this.value,
      @HiveField(1) this.playthroughId,
      @HiveField(5, defaultValue: null) this.noScoreGameResult})
      : super._();

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(2)
  final String playerId;
  @override
  @HiveField(3)
  final String boardGameId;
  @override
  @HiveField(4)
  final String? value;
  @override
  @HiveField(1)
  final String? playthroughId;
  @override
  @HiveField(5, defaultValue: null)
  final NoScoreGameResult? noScoreGameResult;

  @override
  String toString() {
    return 'Score(id: $id, playerId: $playerId, boardGameId: $boardGameId, value: $value, playthroughId: $playthroughId, noScoreGameResult: $noScoreGameResult)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Score &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.boardGameId, boardGameId) ||
                other.boardGameId == boardGameId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.playthroughId, playthroughId) ||
                other.playthroughId == playthroughId) &&
            (identical(other.noScoreGameResult, noScoreGameResult) ||
                other.noScoreGameResult == noScoreGameResult));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, playerId, boardGameId, value,
      playthroughId, noScoreGameResult);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ScoreCopyWith<_$_Score> get copyWith =>
      __$$_ScoreCopyWithImpl<_$_Score>(this, _$identity);
}

abstract class _Score extends Score {
  const factory _Score(
      {@HiveField(0)
          required final String id,
      @HiveField(2)
          required final String playerId,
      @HiveField(3)
          required final String boardGameId,
      @HiveField(4)
          final String? value,
      @HiveField(1)
          final String? playthroughId,
      @HiveField(5, defaultValue: null)
          final NoScoreGameResult? noScoreGameResult}) = _$_Score;
  const _Score._() : super._();

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(2)
  String get playerId;
  @override
  @HiveField(3)
  String get boardGameId;
  @override
  @HiveField(4)
  String? get value;
  @override
  @HiveField(1)
  String? get playthroughId;
  @override
  @HiveField(5, defaultValue: null)
  NoScoreGameResult? get noScoreGameResult;
  @override
  @JsonKey(ignore: true)
  _$$_ScoreCopyWith<_$_Score> get copyWith =>
      throw _privateConstructorUsedError;
}
