// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

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
  int? get place => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlayerScoreCopyWith<PlayerScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerScoreCopyWith<$Res> {
  factory $PlayerScoreCopyWith(
          PlayerScore value, $Res Function(PlayerScore) then) =
      _$PlayerScoreCopyWithImpl<$Res>;
  $Res call({Player? player, Score score, int? place});

  $PlayerCopyWith<$Res>? get player;
  $ScoreCopyWith<$Res> get score;
}

/// @nodoc
class _$PlayerScoreCopyWithImpl<$Res> implements $PlayerScoreCopyWith<$Res> {
  _$PlayerScoreCopyWithImpl(this._value, this._then);

  final PlayerScore _value;
  // ignore: unused_field
  final $Res Function(PlayerScore) _then;

  @override
  $Res call({
    Object? player = freezed,
    Object? score = freezed,
    Object? place = freezed,
  }) {
    return _then(_value.copyWith(
      player: player == freezed
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player?,
      score: score == freezed
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as Score,
      place: place == freezed
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  @override
  $PlayerCopyWith<$Res>? get player {
    if (_value.player == null) {
      return null;
    }

    return $PlayerCopyWith<$Res>(_value.player!, (value) {
      return _then(_value.copyWith(player: value));
    });
  }

  @override
  $ScoreCopyWith<$Res> get score {
    return $ScoreCopyWith<$Res>(_value.score, (value) {
      return _then(_value.copyWith(score: value));
    });
  }
}

/// @nodoc
abstract class _$$_PlayerScoreCopyWith<$Res>
    implements $PlayerScoreCopyWith<$Res> {
  factory _$$_PlayerScoreCopyWith(
          _$_PlayerScore value, $Res Function(_$_PlayerScore) then) =
      __$$_PlayerScoreCopyWithImpl<$Res>;
  @override
  $Res call({Player? player, Score score, int? place});

  @override
  $PlayerCopyWith<$Res>? get player;
  @override
  $ScoreCopyWith<$Res> get score;
}

/// @nodoc
class __$$_PlayerScoreCopyWithImpl<$Res> extends _$PlayerScoreCopyWithImpl<$Res>
    implements _$$_PlayerScoreCopyWith<$Res> {
  __$$_PlayerScoreCopyWithImpl(
      _$_PlayerScore _value, $Res Function(_$_PlayerScore) _then)
      : super(_value, (v) => _then(v as _$_PlayerScore));

  @override
  _$_PlayerScore get _value => super._value as _$_PlayerScore;

  @override
  $Res call({
    Object? player = freezed,
    Object? score = freezed,
    Object? place = freezed,
  }) {
    return _then(_$_PlayerScore(
      player: player == freezed
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player?,
      score: score == freezed
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as Score,
      place: place == freezed
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$_PlayerScore extends _PlayerScore {
  const _$_PlayerScore({required this.player, required this.score, this.place})
      : super._();

  @override
  final Player? player;
  @override
  final Score score;
  @override
  final int? place;

  @override
  String toString() {
    return 'PlayerScore(player: $player, score: $score, place: $place)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PlayerScore &&
            const DeepCollectionEquality().equals(other.player, player) &&
            const DeepCollectionEquality().equals(other.score, score) &&
            const DeepCollectionEquality().equals(other.place, place));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(player),
      const DeepCollectionEquality().hash(score),
      const DeepCollectionEquality().hash(place));

  @JsonKey(ignore: true)
  @override
  _$$_PlayerScoreCopyWith<_$_PlayerScore> get copyWith =>
      __$$_PlayerScoreCopyWithImpl<_$_PlayerScore>(this, _$identity);
}

abstract class _PlayerScore extends PlayerScore {
  const factory _PlayerScore(
      {required final Player? player,
      required final Score score,
      final int? place}) = _$_PlayerScore;
  const _PlayerScore._() : super._();

  @override
  Player? get player;
  @override
  Score get score;
  @override
  int? get place;
  @override
  @JsonKey(ignore: true)
  _$$_PlayerScoreCopyWith<_$_PlayerScore> get copyWith =>
      throw _privateConstructorUsedError;
}
