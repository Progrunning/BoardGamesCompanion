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
  List<PlayerScore> get playerScores => throw _privateConstructorUsedError;

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
  $Res call({Playthrough playthrough, List<PlayerScore> playerScores});

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
abstract class _$$PlaythroughDetailsImplCopyWith<$Res>
    implements $PlaythroughDetailsCopyWith<$Res> {
  factory _$$PlaythroughDetailsImplCopyWith(_$PlaythroughDetailsImpl value,
          $Res Function(_$PlaythroughDetailsImpl) then) =
      __$$PlaythroughDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Playthrough playthrough, List<PlayerScore> playerScores});

  @override
  $PlaythroughCopyWith<$Res> get playthrough;
}

/// @nodoc
class __$$PlaythroughDetailsImplCopyWithImpl<$Res>
    extends _$PlaythroughDetailsCopyWithImpl<$Res, _$PlaythroughDetailsImpl>
    implements _$$PlaythroughDetailsImplCopyWith<$Res> {
  __$$PlaythroughDetailsImplCopyWithImpl(_$PlaythroughDetailsImpl _value,
      $Res Function(_$PlaythroughDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playthrough = null,
    Object? playerScores = null,
  }) {
    return _then(_$PlaythroughDetailsImpl(
      playthrough: null == playthrough
          ? _value.playthrough
          : playthrough // ignore: cast_nullable_to_non_nullable
              as Playthrough,
      playerScores: null == playerScores
          ? _value._playerScores
          : playerScores // ignore: cast_nullable_to_non_nullable
              as List<PlayerScore>,
    ));
  }
}

/// @nodoc

class _$PlaythroughDetailsImpl extends _PlaythroughDetails {
  const _$PlaythroughDetailsImpl(
      {required this.playthrough,
      required final List<PlayerScore> playerScores})
      : _playerScores = playerScores,
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

  @override
  String toString() {
    return 'PlaythroughDetails(playthrough: $playthrough, playerScores: $playerScores)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaythroughDetailsImpl &&
            (identical(other.playthrough, playthrough) ||
                other.playthrough == playthrough) &&
            const DeepCollectionEquality()
                .equals(other._playerScores, _playerScores));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playthrough,
      const DeepCollectionEquality().hash(_playerScores));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaythroughDetailsImplCopyWith<_$PlaythroughDetailsImpl> get copyWith =>
      __$$PlaythroughDetailsImplCopyWithImpl<_$PlaythroughDetailsImpl>(
          this, _$identity);
}

abstract class _PlaythroughDetails extends PlaythroughDetails {
  const factory _PlaythroughDetails(
          {required final Playthrough playthrough,
          required final List<PlayerScore> playerScores}) =
      _$PlaythroughDetailsImpl;
  const _PlaythroughDetails._() : super._();

  @override
  Playthrough get playthrough;
  @override
  List<PlayerScore> get playerScores;
  @override
  @JsonKey(ignore: true)
  _$$PlaythroughDetailsImplCopyWith<_$PlaythroughDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
