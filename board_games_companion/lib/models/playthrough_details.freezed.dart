// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'playthrough_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PlaythroughDetails {
  Playthrough get playthrough => throw _privateConstructorUsedError;
  List<Score> get scores => throw _privateConstructorUsedError;
  List<Player> get players => throw _privateConstructorUsedError;
  List<PlayerScore> get playerScores => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlaythroughDetailsCopyWith<PlaythroughDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaythroughDetailsCopyWith<$Res> {
  factory $PlaythroughDetailsCopyWith(
          PlaythroughDetails value, $Res Function(PlaythroughDetails) then) =
      _$PlaythroughDetailsCopyWithImpl<$Res>;
  $Res call(
      {Playthrough playthrough,
      List<Score> scores,
      List<Player> players,
      List<PlayerScore> playerScores});

  $PlaythroughCopyWith<$Res> get playthrough;
}

/// @nodoc
class _$PlaythroughDetailsCopyWithImpl<$Res>
    implements $PlaythroughDetailsCopyWith<$Res> {
  _$PlaythroughDetailsCopyWithImpl(this._value, this._then);

  final PlaythroughDetails _value;
  // ignore: unused_field
  final $Res Function(PlaythroughDetails) _then;

  @override
  $Res call({
    Object? playthrough = freezed,
    Object? scores = freezed,
    Object? players = freezed,
    Object? playerScores = freezed,
  }) {
    return _then(_value.copyWith(
      playthrough: playthrough == freezed
          ? _value.playthrough
          : playthrough // ignore: cast_nullable_to_non_nullable
              as Playthrough,
      scores: scores == freezed
          ? _value.scores
          : scores // ignore: cast_nullable_to_non_nullable
              as List<Score>,
      players: players == freezed
          ? _value.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<Player>,
      playerScores: playerScores == freezed
          ? _value.playerScores
          : playerScores // ignore: cast_nullable_to_non_nullable
              as List<PlayerScore>,
    ));
  }

  @override
  $PlaythroughCopyWith<$Res> get playthrough {
    return $PlaythroughCopyWith<$Res>(_value.playthrough, (value) {
      return _then(_value.copyWith(playthrough: value));
    });
  }
}

/// @nodoc
abstract class _$$_PlaythroughDetailsCopyWith<$Res>
    implements $PlaythroughDetailsCopyWith<$Res> {
  factory _$$_PlaythroughDetailsCopyWith(_$_PlaythroughDetails value,
          $Res Function(_$_PlaythroughDetails) then) =
      __$$_PlaythroughDetailsCopyWithImpl<$Res>;
  @override
  $Res call(
      {Playthrough playthrough,
      List<Score> scores,
      List<Player> players,
      List<PlayerScore> playerScores});

  @override
  $PlaythroughCopyWith<$Res> get playthrough;
}

/// @nodoc
class __$$_PlaythroughDetailsCopyWithImpl<$Res>
    extends _$PlaythroughDetailsCopyWithImpl<$Res>
    implements _$$_PlaythroughDetailsCopyWith<$Res> {
  __$$_PlaythroughDetailsCopyWithImpl(
      _$_PlaythroughDetails _value, $Res Function(_$_PlaythroughDetails) _then)
      : super(_value, (v) => _then(v as _$_PlaythroughDetails));

  @override
  _$_PlaythroughDetails get _value => super._value as _$_PlaythroughDetails;

  @override
  $Res call({
    Object? playthrough = freezed,
    Object? scores = freezed,
    Object? players = freezed,
    Object? playerScores = freezed,
  }) {
    return _then(_$_PlaythroughDetails(
      playthrough: playthrough == freezed
          ? _value.playthrough
          : playthrough // ignore: cast_nullable_to_non_nullable
              as Playthrough,
      scores: scores == freezed
          ? _value._scores
          : scores // ignore: cast_nullable_to_non_nullable
              as List<Score>,
      players: players == freezed
          ? _value._players
          : players // ignore: cast_nullable_to_non_nullable
              as List<Player>,
      playerScores: playerScores == freezed
          ? _value._playerScores
          : playerScores // ignore: cast_nullable_to_non_nullable
              as List<PlayerScore>,
    ));
  }
}

/// @nodoc

class _$_PlaythroughDetails extends _PlaythroughDetails {
  const _$_PlaythroughDetails(
      {required this.playthrough,
      required final List<Score> scores,
      required final List<Player> players,
      required final List<PlayerScore> playerScores})
      : _scores = scores,
        _players = players,
        _playerScores = playerScores,
        super._();

  @override
  final Playthrough playthrough;
  final List<Score> _scores;
  @override
  List<Score> get scores {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scores);
  }

  final List<Player> _players;
  @override
  List<Player> get players {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  final List<PlayerScore> _playerScores;
  @override
  List<PlayerScore> get playerScores {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playerScores);
  }

  @override
  String toString() {
    return 'PlaythroughDetails(playthrough: $playthrough, scores: $scores, players: $players, playerScores: $playerScores)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PlaythroughDetails &&
            const DeepCollectionEquality()
                .equals(other.playthrough, playthrough) &&
            const DeepCollectionEquality().equals(other._scores, _scores) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            const DeepCollectionEquality()
                .equals(other._playerScores, _playerScores));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(playthrough),
      const DeepCollectionEquality().hash(_scores),
      const DeepCollectionEquality().hash(_players),
      const DeepCollectionEquality().hash(_playerScores));

  @JsonKey(ignore: true)
  @override
  _$$_PlaythroughDetailsCopyWith<_$_PlaythroughDetails> get copyWith =>
      __$$_PlaythroughDetailsCopyWithImpl<_$_PlaythroughDetails>(
          this, _$identity);
}

abstract class _PlaythroughDetails extends PlaythroughDetails {
  const factory _PlaythroughDetails(
      {required final Playthrough playthrough,
      required final List<Score> scores,
      required final List<Player> players,
      required final List<PlayerScore> playerScores}) = _$_PlaythroughDetails;
  const _PlaythroughDetails._() : super._();

  @override
  Playthrough get playthrough;
  @override
  List<Score> get scores;
  @override
  List<Player> get players;
  @override
  List<PlayerScore> get playerScores;
  @override
  @JsonKey(ignore: true)
  _$$_PlaythroughDetailsCopyWith<_$_PlaythroughDetails> get copyWith =>
      throw _privateConstructorUsedError;
}
