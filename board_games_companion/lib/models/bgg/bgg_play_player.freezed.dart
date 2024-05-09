// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bgg_play_player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BggPlayPlayer {
  String get playerName => throw _privateConstructorUsedError;
  String? get playerBggName => throw _privateConstructorUsedError;
  int? get playerBggUserId => throw _privateConstructorUsedError;
  int? get playerScore => throw _privateConstructorUsedError;
  bool? get playerWin => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BggPlayPlayerCopyWith<BggPlayPlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BggPlayPlayerCopyWith<$Res> {
  factory $BggPlayPlayerCopyWith(
          BggPlayPlayer value, $Res Function(BggPlayPlayer) then) =
      _$BggPlayPlayerCopyWithImpl<$Res, BggPlayPlayer>;
  @useResult
  $Res call(
      {String playerName,
      String? playerBggName,
      int? playerBggUserId,
      int? playerScore,
      bool? playerWin});
}

/// @nodoc
class _$BggPlayPlayerCopyWithImpl<$Res, $Val extends BggPlayPlayer>
    implements $BggPlayPlayerCopyWith<$Res> {
  _$BggPlayPlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerName = null,
    Object? playerBggName = freezed,
    Object? playerBggUserId = freezed,
    Object? playerScore = freezed,
    Object? playerWin = freezed,
  }) {
    return _then(_value.copyWith(
      playerName: null == playerName
          ? _value.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String,
      playerBggName: freezed == playerBggName
          ? _value.playerBggName
          : playerBggName // ignore: cast_nullable_to_non_nullable
              as String?,
      playerBggUserId: freezed == playerBggUserId
          ? _value.playerBggUserId
          : playerBggUserId // ignore: cast_nullable_to_non_nullable
              as int?,
      playerScore: freezed == playerScore
          ? _value.playerScore
          : playerScore // ignore: cast_nullable_to_non_nullable
              as int?,
      playerWin: freezed == playerWin
          ? _value.playerWin
          : playerWin // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BggPlayPlayerImplCopyWith<$Res>
    implements $BggPlayPlayerCopyWith<$Res> {
  factory _$$BggPlayPlayerImplCopyWith(
          _$BggPlayPlayerImpl value, $Res Function(_$BggPlayPlayerImpl) then) =
      __$$BggPlayPlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String playerName,
      String? playerBggName,
      int? playerBggUserId,
      int? playerScore,
      bool? playerWin});
}

/// @nodoc
class __$$BggPlayPlayerImplCopyWithImpl<$Res>
    extends _$BggPlayPlayerCopyWithImpl<$Res, _$BggPlayPlayerImpl>
    implements _$$BggPlayPlayerImplCopyWith<$Res> {
  __$$BggPlayPlayerImplCopyWithImpl(
      _$BggPlayPlayerImpl _value, $Res Function(_$BggPlayPlayerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerName = null,
    Object? playerBggName = freezed,
    Object? playerBggUserId = freezed,
    Object? playerScore = freezed,
    Object? playerWin = freezed,
  }) {
    return _then(_$BggPlayPlayerImpl(
      playerName: null == playerName
          ? _value.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String,
      playerBggName: freezed == playerBggName
          ? _value.playerBggName
          : playerBggName // ignore: cast_nullable_to_non_nullable
              as String?,
      playerBggUserId: freezed == playerBggUserId
          ? _value.playerBggUserId
          : playerBggUserId // ignore: cast_nullable_to_non_nullable
              as int?,
      playerScore: freezed == playerScore
          ? _value.playerScore
          : playerScore // ignore: cast_nullable_to_non_nullable
              as int?,
      playerWin: freezed == playerWin
          ? _value.playerWin
          : playerWin // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$BggPlayPlayerImpl extends _BggPlayPlayer {
  const _$BggPlayPlayerImpl(
      {required this.playerName,
      required this.playerBggName,
      required this.playerBggUserId,
      this.playerScore,
      this.playerWin})
      : super._();

  @override
  final String playerName;
  @override
  final String? playerBggName;
  @override
  final int? playerBggUserId;
  @override
  final int? playerScore;
  @override
  final bool? playerWin;

  @override
  String toString() {
    return 'BggPlayPlayer(playerName: $playerName, playerBggName: $playerBggName, playerBggUserId: $playerBggUserId, playerScore: $playerScore, playerWin: $playerWin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BggPlayPlayerImpl &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.playerBggName, playerBggName) ||
                other.playerBggName == playerBggName) &&
            (identical(other.playerBggUserId, playerBggUserId) ||
                other.playerBggUserId == playerBggUserId) &&
            (identical(other.playerScore, playerScore) ||
                other.playerScore == playerScore) &&
            (identical(other.playerWin, playerWin) ||
                other.playerWin == playerWin));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerName, playerBggName,
      playerBggUserId, playerScore, playerWin);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BggPlayPlayerImplCopyWith<_$BggPlayPlayerImpl> get copyWith =>
      __$$BggPlayPlayerImplCopyWithImpl<_$BggPlayPlayerImpl>(this, _$identity);
}

abstract class _BggPlayPlayer extends BggPlayPlayer {
  const factory _BggPlayPlayer(
      {required final String playerName,
      required final String? playerBggName,
      required final int? playerBggUserId,
      final int? playerScore,
      final bool? playerWin}) = _$BggPlayPlayerImpl;
  const _BggPlayPlayer._() : super._();

  @override
  String get playerName;
  @override
  String? get playerBggName;
  @override
  int? get playerBggUserId;
  @override
  int? get playerScore;
  @override
  bool? get playerWin;
  @override
  @JsonKey(ignore: true)
  _$$BggPlayPlayerImplCopyWith<_$BggPlayPlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
