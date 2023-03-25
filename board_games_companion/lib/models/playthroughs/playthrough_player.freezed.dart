// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

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
      _$PlaythroughPlayerCopyWithImpl<$Res, PlaythroughPlayer>;
  @useResult
  $Res call({Player player, bool isChecked});

  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class _$PlaythroughPlayerCopyWithImpl<$Res, $Val extends PlaythroughPlayer>
    implements $PlaythroughPlayerCopyWith<$Res> {
  _$PlaythroughPlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? isChecked = null,
  }) {
    return _then(_value.copyWith(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      isChecked: null == isChecked
          ? _value.isChecked
          : isChecked // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res> get player {
    return $PlayerCopyWith<$Res>(_value.player, (value) {
      return _then(_value.copyWith(player: value) as $Val);
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
  @useResult
  $Res call({Player player, bool isChecked});

  @override
  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class __$$_PlaythroughPlayerCopyWithImpl<$Res>
    extends _$PlaythroughPlayerCopyWithImpl<$Res, _$_PlaythroughPlayer>
    implements _$$_PlaythroughPlayerCopyWith<$Res> {
  __$$_PlaythroughPlayerCopyWithImpl(
      _$_PlaythroughPlayer _value, $Res Function(_$_PlaythroughPlayer) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? isChecked = null,
  }) {
    return _then(_$_PlaythroughPlayer(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      isChecked: null == isChecked
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
            (identical(other.player, player) || other.player == player) &&
            (identical(other.isChecked, isChecked) ||
                other.isChecked == isChecked));
  }

  @override
  int get hashCode => Object.hash(runtimeType, player, isChecked);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
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
