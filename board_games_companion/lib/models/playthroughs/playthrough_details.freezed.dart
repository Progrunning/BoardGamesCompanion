// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

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
  List<PlayerScore> get playerScores =>
      throw _privateConstructorUsedError; // TODO Perhaps this is not needed?
  List<ScoreTiebreaker>? get scoreTiebreakers =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlaythroughDetailsCopyWith<PlaythroughDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaythroughDetailsCopyWith<$Res> {
  factory $PlaythroughDetailsCopyWith(
          PlaythroughDetails value, $Res Function(PlaythroughDetails) then) =
      _$PlaythroughDetailsCopyWithImpl<$Res, PlaythroughDetails>;
  @useResult
  $Res call(
      {Playthrough playthrough,
      List<PlayerScore> playerScores,
      List<ScoreTiebreaker>? scoreTiebreakers});

  $PlaythroughCopyWith<$Res> get playthrough;
}

/// @nodoc
class _$PlaythroughDetailsCopyWithImpl<$Res, $Val extends PlaythroughDetails>
    implements $PlaythroughDetailsCopyWith<$Res> {
  _$PlaythroughDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playthrough = null,
    Object? playerScores = null,
    Object? scoreTiebreakers = freezed,
  }) {
    return _then(_value.copyWith(
      playthrough: null == playthrough
          ? _value.playthrough
          : playthrough // ignore: cast_nullable_to_non_nullable
              as Playthrough,
      playerScores: null == playerScores
          ? _value.playerScores
          : playerScores // ignore: cast_nullable_to_non_nullable
              as List<PlayerScore>,
      scoreTiebreakers: freezed == scoreTiebreakers
          ? _value.scoreTiebreakers
          : scoreTiebreakers // ignore: cast_nullable_to_non_nullable
              as List<ScoreTiebreaker>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlaythroughCopyWith<$Res> get playthrough {
    return $PlaythroughCopyWith<$Res>(_value.playthrough, (value) {
      return _then(_value.copyWith(playthrough: value) as $Val);
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
  @useResult
  $Res call(
      {Playthrough playthrough,
      List<PlayerScore> playerScores,
      List<ScoreTiebreaker>? scoreTiebreakers});

  @override
  $PlaythroughCopyWith<$Res> get playthrough;
}

/// @nodoc
class __$$_PlaythroughDetailsCopyWithImpl<$Res>
    extends _$PlaythroughDetailsCopyWithImpl<$Res, _$_PlaythroughDetails>
    implements _$$_PlaythroughDetailsCopyWith<$Res> {
  __$$_PlaythroughDetailsCopyWithImpl(
      _$_PlaythroughDetails _value, $Res Function(_$_PlaythroughDetails) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playthrough = null,
    Object? playerScores = null,
    Object? scoreTiebreakers = freezed,
  }) {
    return _then(_$_PlaythroughDetails(
      playthrough: null == playthrough
          ? _value.playthrough
          : playthrough // ignore: cast_nullable_to_non_nullable
              as Playthrough,
      playerScores: null == playerScores
          ? _value._playerScores
          : playerScores // ignore: cast_nullable_to_non_nullable
              as List<PlayerScore>,
      scoreTiebreakers: freezed == scoreTiebreakers
          ? _value._scoreTiebreakers
          : scoreTiebreakers // ignore: cast_nullable_to_non_nullable
              as List<ScoreTiebreaker>?,
    ));
  }
}

/// @nodoc

class _$_PlaythroughDetails extends _PlaythroughDetails {
  const _$_PlaythroughDetails(
      {required this.playthrough,
      required final List<PlayerScore> playerScores,
      final List<ScoreTiebreaker>? scoreTiebreakers})
      : _playerScores = playerScores,
        _scoreTiebreakers = scoreTiebreakers,
        super._();

  @override
  final Playthrough playthrough;
  final List<PlayerScore> _playerScores;
  @override
  List<PlayerScore> get playerScores {
    if (_playerScores is EqualUnmodifiableListView) return _playerScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playerScores);
  }

// TODO Perhaps this is not needed?
  final List<ScoreTiebreaker>? _scoreTiebreakers;
// TODO Perhaps this is not needed?
  @override
  List<ScoreTiebreaker>? get scoreTiebreakers {
    final value = _scoreTiebreakers;
    if (value == null) return null;
    if (_scoreTiebreakers is EqualUnmodifiableListView)
      return _scoreTiebreakers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PlaythroughDetails(playthrough: $playthrough, playerScores: $playerScores, scoreTiebreakers: $scoreTiebreakers)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PlaythroughDetails &&
            (identical(other.playthrough, playthrough) ||
                other.playthrough == playthrough) &&
            const DeepCollectionEquality()
                .equals(other._playerScores, _playerScores) &&
            const DeepCollectionEquality()
                .equals(other._scoreTiebreakers, _scoreTiebreakers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      playthrough,
      const DeepCollectionEquality().hash(_playerScores),
      const DeepCollectionEquality().hash(_scoreTiebreakers));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PlaythroughDetailsCopyWith<_$_PlaythroughDetails> get copyWith =>
      __$$_PlaythroughDetailsCopyWithImpl<_$_PlaythroughDetails>(
          this, _$identity);
}

abstract class _PlaythroughDetails extends PlaythroughDetails {
  const factory _PlaythroughDetails(
      {required final Playthrough playthrough,
      required final List<PlayerScore> playerScores,
      final List<ScoreTiebreaker>? scoreTiebreakers}) = _$_PlaythroughDetails;
  const _PlaythroughDetails._() : super._();

  @override
  Playthrough get playthrough;
  @override
  List<PlayerScore> get playerScores;
  @override // TODO Perhaps this is not needed?
  List<ScoreTiebreaker>? get scoreTiebreakers;
  @override
  @JsonKey(ignore: true)
  _$$_PlaythroughDetailsCopyWith<_$_PlaythroughDetails> get copyWith =>
      throw _privateConstructorUsedError;
}
