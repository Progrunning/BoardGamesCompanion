// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PlayerScore {
  Player? get player => throw _privateConstructorUsedError;
  Score get score => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlayerScoreCopyWith<PlayerScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerScoreCopyWith<$Res> {
  factory $PlayerScoreCopyWith(
          PlayerScore value, $Res Function(PlayerScore) then) =
      _$PlayerScoreCopyWithImpl<$Res, PlayerScore>;
  @useResult
  $Res call({Player? player, Score score});

  $PlayerCopyWith<$Res>? get player;
  $ScoreCopyWith<$Res> get score;
}

/// @nodoc
class _$PlayerScoreCopyWithImpl<$Res, $Val extends PlayerScore>
    implements $PlayerScoreCopyWith<$Res> {
  _$PlayerScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = freezed,
    Object? score = null,
  }) {
    return _then(_value.copyWith(
      player: freezed == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player?,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as Score,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res>? get player {
    if (_value.player == null) {
      return null;
    }

    return $PlayerCopyWith<$Res>(_value.player!, (value) {
      return _then(_value.copyWith(player: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ScoreCopyWith<$Res> get score {
    return $ScoreCopyWith<$Res>(_value.score, (value) {
      return _then(_value.copyWith(score: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerScoreImplCopyWith<$Res>
    implements $PlayerScoreCopyWith<$Res> {
  factory _$$PlayerScoreImplCopyWith(
          _$PlayerScoreImpl value, $Res Function(_$PlayerScoreImpl) then) =
      __$$PlayerScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Player? player, Score score});

  @override
  $PlayerCopyWith<$Res>? get player;
  @override
  $ScoreCopyWith<$Res> get score;
}

/// @nodoc
class __$$PlayerScoreImplCopyWithImpl<$Res>
    extends _$PlayerScoreCopyWithImpl<$Res, _$PlayerScoreImpl>
    implements _$$PlayerScoreImplCopyWith<$Res> {
  __$$PlayerScoreImplCopyWithImpl(
      _$PlayerScoreImpl _value, $Res Function(_$PlayerScoreImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = freezed,
    Object? score = null,
  }) {
    return _then(_$PlayerScoreImpl(
      player: freezed == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player?,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as Score,
    ));
  }
}

/// @nodoc

class _$PlayerScoreImpl extends _PlayerScore {
  const _$PlayerScoreImpl({required this.player, required this.score})
      : super._();

  @override
  final Player? player;
  @override
  final Score score;

  @override
  String toString() {
    return 'PlayerScore(player: $player, score: $score)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerScoreImpl &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.score, score) || other.score == score));
  }

  @override
  int get hashCode => Object.hash(runtimeType, player, score);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerScoreImplCopyWith<_$PlayerScoreImpl> get copyWith =>
      __$$PlayerScoreImplCopyWithImpl<_$PlayerScoreImpl>(this, _$identity);
}

abstract class _PlayerScore extends PlayerScore {
  const factory _PlayerScore(
      {required final Player? player,
      required final Score score}) = _$PlayerScoreImpl;
  const _PlayerScore._() : super._();

  @override
  Player? get player;
  @override
  Score get score;
  @override
  @JsonKey(ignore: true)
  _$$PlayerScoreImplCopyWith<_$PlayerScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
