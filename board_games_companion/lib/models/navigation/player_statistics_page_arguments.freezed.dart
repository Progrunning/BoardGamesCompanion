// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_statistics_page_arguments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlayerStatisticsPageArguments {
  Player get player => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlayerStatisticsPageArgumentsCopyWith<PlayerStatisticsPageArguments>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerStatisticsPageArgumentsCopyWith<$Res> {
  factory $PlayerStatisticsPageArgumentsCopyWith(
          PlayerStatisticsPageArguments value,
          $Res Function(PlayerStatisticsPageArguments) then) =
      _$PlayerStatisticsPageArgumentsCopyWithImpl<$Res,
          PlayerStatisticsPageArguments>;
  @useResult
  $Res call({Player player});

  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class _$PlayerStatisticsPageArgumentsCopyWithImpl<$Res,
        $Val extends PlayerStatisticsPageArguments>
    implements $PlayerStatisticsPageArgumentsCopyWith<$Res> {
  _$PlayerStatisticsPageArgumentsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
  }) {
    return _then(_value.copyWith(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
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
abstract class _$$PlayerStatisticsPageArgumentsImplCopyWith<$Res>
    implements $PlayerStatisticsPageArgumentsCopyWith<$Res> {
  factory _$$PlayerStatisticsPageArgumentsImplCopyWith(
          _$PlayerStatisticsPageArgumentsImpl value,
          $Res Function(_$PlayerStatisticsPageArgumentsImpl) then) =
      __$$PlayerStatisticsPageArgumentsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Player player});

  @override
  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class __$$PlayerStatisticsPageArgumentsImplCopyWithImpl<$Res>
    extends _$PlayerStatisticsPageArgumentsCopyWithImpl<$Res,
        _$PlayerStatisticsPageArgumentsImpl>
    implements _$$PlayerStatisticsPageArgumentsImplCopyWith<$Res> {
  __$$PlayerStatisticsPageArgumentsImplCopyWithImpl(
      _$PlayerStatisticsPageArgumentsImpl _value,
      $Res Function(_$PlayerStatisticsPageArgumentsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
  }) {
    return _then(_$PlayerStatisticsPageArgumentsImpl(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
    ));
  }
}

/// @nodoc

class _$PlayerStatisticsPageArgumentsImpl
    implements _PlayerStatisticsPageArguments {
  const _$PlayerStatisticsPageArgumentsImpl({required this.player});

  @override
  final Player player;

  @override
  String toString() {
    return 'PlayerStatisticsPageArguments(player: $player)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerStatisticsPageArgumentsImpl &&
            (identical(other.player, player) || other.player == player));
  }

  @override
  int get hashCode => Object.hash(runtimeType, player);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerStatisticsPageArgumentsImplCopyWith<
          _$PlayerStatisticsPageArgumentsImpl>
      get copyWith => __$$PlayerStatisticsPageArgumentsImplCopyWithImpl<
          _$PlayerStatisticsPageArgumentsImpl>(this, _$identity);
}

abstract class _PlayerStatisticsPageArguments
    implements PlayerStatisticsPageArguments {
  const factory _PlayerStatisticsPageArguments({required final Player player}) =
      _$PlayerStatisticsPageArgumentsImpl;

  @override
  Player get player;
  @override
  @JsonKey(ignore: true)
  _$$PlayerStatisticsPageArgumentsImplCopyWith<
          _$PlayerStatisticsPageArgumentsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
