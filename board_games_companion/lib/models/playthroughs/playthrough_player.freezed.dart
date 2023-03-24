// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'playthrough_player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PlaythroughPlayer {
  Player get player => throw _privateConstructorUsedError;
  bool get isChecked => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlaythroughPlayerCopyWith<PlaythroughPlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaythroughPlayerCopyWith<$Res> {
  factory $PlaythroughPlayerCopyWith(
          PlaythroughPlayer value, $Res Function(PlaythroughPlayer) then) =
      _$PlaythroughPlayerCopyWithImpl<$Res>;
  $Res call({Player player, bool isChecked});

  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class _$PlaythroughPlayerCopyWithImpl<$Res>
    implements $PlaythroughPlayerCopyWith<$Res> {
  _$PlaythroughPlayerCopyWithImpl(this._value, this._then);

  final PlaythroughPlayer _value;
  // ignore: unused_field
  final $Res Function(PlaythroughPlayer) _then;

  @override
  $Res call({
    Object? player = freezed,
    Object? isChecked = freezed,
  }) {
    return _then(_value.copyWith(
      player: player == freezed
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      isChecked: isChecked == freezed
          ? _value.isChecked
          : isChecked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $PlayerCopyWith<$Res> get player {
    return $PlayerCopyWith<$Res>(_value.player, (value) {
      return _then(_value.copyWith(player: value));
    });
  }
}

/// @nodoc
abstract class _$$_PlaythroughPlayerCopyWith<$Res>
    implements $PlaythroughPlayerCopyWith<$Res> {
  factory _$$_PlaythroughPlayerCopyWith(_$_PlaythroughPlayer value,
          $Res Function(_$_PlaythroughPlayer) then) =
      __$$_PlaythroughPlayerCopyWithImpl<$Res>;
  @override
  $Res call({Player player, bool isChecked});

  @override
  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class __$$_PlaythroughPlayerCopyWithImpl<$Res>
    extends _$PlaythroughPlayerCopyWithImpl<$Res>
    implements _$$_PlaythroughPlayerCopyWith<$Res> {
  __$$_PlaythroughPlayerCopyWithImpl(
      _$_PlaythroughPlayer _value, $Res Function(_$_PlaythroughPlayer) _then)
      : super(_value, (v) => _then(v as _$_PlaythroughPlayer));

  @override
  _$_PlaythroughPlayer get _value => super._value as _$_PlaythroughPlayer;

  @override
  $Res call({
    Object? player = freezed,
    Object? isChecked = freezed,
  }) {
    return _then(_$_PlaythroughPlayer(
      player: player == freezed
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      isChecked: isChecked == freezed
          ? _value.isChecked
          : isChecked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_PlaythroughPlayer implements _PlaythroughPlayer {
  const _$_PlaythroughPlayer({required this.player, this.isChecked = false});

  @override
  final Player player;
  @override
  @JsonKey()
  final bool isChecked;

  @override
  String toString() {
    return 'PlaythroughPlayer(player: $player, isChecked: $isChecked)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PlaythroughPlayer &&
            const DeepCollectionEquality().equals(other.player, player) &&
            const DeepCollectionEquality().equals(other.isChecked, isChecked));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(player),
      const DeepCollectionEquality().hash(isChecked));

  @JsonKey(ignore: true)
  @override
  _$$_PlaythroughPlayerCopyWith<_$_PlaythroughPlayer> get copyWith =>
      __$$_PlaythroughPlayerCopyWithImpl<_$_PlaythroughPlayer>(
          this, _$identity);
}

abstract class _PlaythroughPlayer implements PlaythroughPlayer {
  const factory _PlaythroughPlayer(
      {required final Player player,
      final bool isChecked}) = _$_PlaythroughPlayer;

  @override
  Player get player;
  @override
  bool get isChecked;
  @override
  @JsonKey(ignore: true)
  _$$_PlaythroughPlayerCopyWith<_$_PlaythroughPlayer> get copyWith =>
      throw _privateConstructorUsedError;
}
