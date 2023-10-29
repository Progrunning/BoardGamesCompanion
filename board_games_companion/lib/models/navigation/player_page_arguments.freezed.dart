// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

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
      _$PlayerPageArgumentsCopyWithImpl<$Res, PlayerPageArguments>;
  @useResult
  $Res call({Player? player});

  $PlayerCopyWith<$Res>? get player;
}

/// @nodoc
class _$PlayerPageArgumentsCopyWithImpl<$Res, $Val extends PlayerPageArguments>
    implements $PlayerPageArgumentsCopyWith<$Res> {
  _$PlayerPageArgumentsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = freezed,
  }) {
    return _then(_value.copyWith(
      player: freezed == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player?,
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
}

/// @nodoc
abstract class _$$PlayerPageArgumentsImplCopyWith<$Res>
    implements $PlayerPageArgumentsCopyWith<$Res> {
  factory _$$PlayerPageArgumentsImplCopyWith(_$PlayerPageArgumentsImpl value,
          $Res Function(_$PlayerPageArgumentsImpl) then) =
      __$$PlayerPageArgumentsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Player? player});

  @override
  $PlayerCopyWith<$Res>? get player;
}

/// @nodoc
class __$$PlayerPageArgumentsImplCopyWithImpl<$Res>
    extends _$PlayerPageArgumentsCopyWithImpl<$Res, _$PlayerPageArgumentsImpl>
    implements _$$PlayerPageArgumentsImplCopyWith<$Res> {
  __$$PlayerPageArgumentsImplCopyWithImpl(_$PlayerPageArgumentsImpl _value,
      $Res Function(_$PlayerPageArgumentsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = freezed,
  }) {
    return _then(_$PlayerPageArgumentsImpl(
      player: freezed == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player?,
    ));
  }
}

/// @nodoc

class _$PlayerPageArgumentsImpl implements _PlayerPageArguments {
  const _$PlayerPageArgumentsImpl({this.player});

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
            other is _$PlayerPageArgumentsImpl &&
            (identical(other.player, player) || other.player == player));
  }

  @override
  int get hashCode => Object.hash(runtimeType, player);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerPageArgumentsImplCopyWith<_$PlayerPageArgumentsImpl> get copyWith =>
      __$$PlayerPageArgumentsImplCopyWithImpl<_$PlayerPageArgumentsImpl>(
          this, _$identity);
}

abstract class _PlayerPageArguments implements PlayerPageArguments {
  const factory _PlayerPageArguments({final Player? player}) =
      _$PlayerPageArgumentsImpl;

  @override
  Player? get player;
  @override
  @JsonKey(ignore: true)
  _$$PlayerPageArgumentsImplCopyWith<_$PlayerPageArgumentsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
