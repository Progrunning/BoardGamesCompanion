// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'player_page_arguments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PlayerPageArguments {
  Player? get player => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlayerPageArgumentsCopyWith<PlayerPageArguments> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerPageArgumentsCopyWith<$Res> {
  factory $PlayerPageArgumentsCopyWith(
          PlayerPageArguments value, $Res Function(PlayerPageArguments) then) =
      _$PlayerPageArgumentsCopyWithImpl<$Res>;
  $Res call({Player? player});

  $PlayerCopyWith<$Res>? get player;
}

/// @nodoc
class _$PlayerPageArgumentsCopyWithImpl<$Res>
    implements $PlayerPageArgumentsCopyWith<$Res> {
  _$PlayerPageArgumentsCopyWithImpl(this._value, this._then);

  final PlayerPageArguments _value;
  // ignore: unused_field
  final $Res Function(PlayerPageArguments) _then;

  @override
  $Res call({
    Object? player = freezed,
  }) {
    return _then(_value.copyWith(
      player: player == freezed
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player?,
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
}

/// @nodoc
abstract class _$$_PlayerPageArgumentsCopyWith<$Res>
    implements $PlayerPageArgumentsCopyWith<$Res> {
  factory _$$_PlayerPageArgumentsCopyWith(_$_PlayerPageArguments value,
          $Res Function(_$_PlayerPageArguments) then) =
      __$$_PlayerPageArgumentsCopyWithImpl<$Res>;
  @override
  $Res call({Player? player});

  @override
  $PlayerCopyWith<$Res>? get player;
}

/// @nodoc
class __$$_PlayerPageArgumentsCopyWithImpl<$Res>
    extends _$PlayerPageArgumentsCopyWithImpl<$Res>
    implements _$$_PlayerPageArgumentsCopyWith<$Res> {
  __$$_PlayerPageArgumentsCopyWithImpl(_$_PlayerPageArguments _value,
      $Res Function(_$_PlayerPageArguments) _then)
      : super(_value, (v) => _then(v as _$_PlayerPageArguments));

  @override
  _$_PlayerPageArguments get _value => super._value as _$_PlayerPageArguments;

  @override
  $Res call({
    Object? player = freezed,
  }) {
    return _then(_$_PlayerPageArguments(
      player: player == freezed
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player?,
    ));
  }
}

/// @nodoc

class _$_PlayerPageArguments implements _PlayerPageArguments {
  const _$_PlayerPageArguments({this.player});

  @override
  final Player? player;

  @override
  String toString() {
    return 'PlayerPageArguments(player: $player)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PlayerPageArguments &&
            const DeepCollectionEquality().equals(other.player, player));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(player));

  @JsonKey(ignore: true)
  @override
  _$$_PlayerPageArgumentsCopyWith<_$_PlayerPageArguments> get copyWith =>
      __$$_PlayerPageArgumentsCopyWithImpl<_$_PlayerPageArguments>(
          this, _$identity);
}

abstract class _PlayerPageArguments implements PlayerPageArguments {
  const factory _PlayerPageArguments({final Player? player}) =
      _$_PlayerPageArguments;

  @override
  Player? get player;
  @override
  @JsonKey(ignore: true)
  _$$_PlayerPageArgumentsCopyWith<_$_PlayerPageArguments> get copyWith =>
      throw _privateConstructorUsedError;
}