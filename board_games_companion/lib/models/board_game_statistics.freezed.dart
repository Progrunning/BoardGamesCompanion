// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'board_game_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PlayerWinsStatistics {
  Player get player => throw _privateConstructorUsedError;
  int get numberOfWins => throw _privateConstructorUsedError;
  double get winsPercentage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlayerWinsStatisticsCopyWith<PlayerWinsStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerWinsStatisticsCopyWith<$Res> {
  factory $PlayerWinsStatisticsCopyWith(PlayerWinsStatistics value,
          $Res Function(PlayerWinsStatistics) then) =
      _$PlayerWinsStatisticsCopyWithImpl<$Res>;
  $Res call({Player player, int numberOfWins, double winsPercentage});
}

/// @nodoc
class _$PlayerWinsStatisticsCopyWithImpl<$Res>
    implements $PlayerWinsStatisticsCopyWith<$Res> {
  _$PlayerWinsStatisticsCopyWithImpl(this._value, this._then);

  final PlayerWinsStatistics _value;
  // ignore: unused_field
  final $Res Function(PlayerWinsStatistics) _then;

  @override
  $Res call({
    Object? player = freezed,
    Object? numberOfWins = freezed,
    Object? winsPercentage = freezed,
  }) {
    return _then(_value.copyWith(
      player: player == freezed
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      numberOfWins: numberOfWins == freezed
          ? _value.numberOfWins
          : numberOfWins // ignore: cast_nullable_to_non_nullable
              as int,
      winsPercentage: winsPercentage == freezed
          ? _value.winsPercentage
          : winsPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$$_PlayerWinsStatisticsCopyWith<$Res>
    implements $PlayerWinsStatisticsCopyWith<$Res> {
  factory _$$_PlayerWinsStatisticsCopyWith(_$_PlayerWinsStatistics value,
          $Res Function(_$_PlayerWinsStatistics) then) =
      __$$_PlayerWinsStatisticsCopyWithImpl<$Res>;
  @override
  $Res call({Player player, int numberOfWins, double winsPercentage});
}

/// @nodoc
class __$$_PlayerWinsStatisticsCopyWithImpl<$Res>
    extends _$PlayerWinsStatisticsCopyWithImpl<$Res>
    implements _$$_PlayerWinsStatisticsCopyWith<$Res> {
  __$$_PlayerWinsStatisticsCopyWithImpl(_$_PlayerWinsStatistics _value,
      $Res Function(_$_PlayerWinsStatistics) _then)
      : super(_value, (v) => _then(v as _$_PlayerWinsStatistics));

  @override
  _$_PlayerWinsStatistics get _value => super._value as _$_PlayerWinsStatistics;

  @override
  $Res call({
    Object? player = freezed,
    Object? numberOfWins = freezed,
    Object? winsPercentage = freezed,
  }) {
    return _then(_$_PlayerWinsStatistics(
      player: player == freezed
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      numberOfWins: numberOfWins == freezed
          ? _value.numberOfWins
          : numberOfWins // ignore: cast_nullable_to_non_nullable
              as int,
      winsPercentage: winsPercentage == freezed
          ? _value.winsPercentage
          : winsPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_PlayerWinsStatistics implements _PlayerWinsStatistics {
  const _$_PlayerWinsStatistics(
      {required this.player,
      required this.numberOfWins,
      required this.winsPercentage});

  @override
  final Player player;
  @override
  final int numberOfWins;
  @override
  final double winsPercentage;

  @override
  String toString() {
    return 'PlayerWinsStatistics(player: $player, numberOfWins: $numberOfWins, winsPercentage: $winsPercentage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PlayerWinsStatistics &&
            const DeepCollectionEquality().equals(other.player, player) &&
            const DeepCollectionEquality()
                .equals(other.numberOfWins, numberOfWins) &&
            const DeepCollectionEquality()
                .equals(other.winsPercentage, winsPercentage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(player),
      const DeepCollectionEquality().hash(numberOfWins),
      const DeepCollectionEquality().hash(winsPercentage));

  @JsonKey(ignore: true)
  @override
  _$$_PlayerWinsStatisticsCopyWith<_$_PlayerWinsStatistics> get copyWith =>
      __$$_PlayerWinsStatisticsCopyWithImpl<_$_PlayerWinsStatistics>(
          this, _$identity);
}

abstract class _PlayerWinsStatistics implements PlayerWinsStatistics {
  const factory _PlayerWinsStatistics(
      {required final Player player,
      required final int numberOfWins,
      required final double winsPercentage}) = _$_PlayerWinsStatistics;

  @override
  Player get player;
  @override
  int get numberOfWins;
  @override
  double get winsPercentage;
  @override
  @JsonKey(ignore: true)
  _$$_PlayerWinsStatisticsCopyWith<_$_PlayerWinsStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PlayerCountStatistics {
  int get numberOfPlayers => throw _privateConstructorUsedError;
  int get numberOfGamesPlayed => throw _privateConstructorUsedError;
  double get gamesPlayedPercentage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlayerCountStatisticsCopyWith<PlayerCountStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerCountStatisticsCopyWith<$Res> {
  factory $PlayerCountStatisticsCopyWith(PlayerCountStatistics value,
          $Res Function(PlayerCountStatistics) then) =
      _$PlayerCountStatisticsCopyWithImpl<$Res>;
  $Res call(
      {int numberOfPlayers,
      int numberOfGamesPlayed,
      double gamesPlayedPercentage});
}

/// @nodoc
class _$PlayerCountStatisticsCopyWithImpl<$Res>
    implements $PlayerCountStatisticsCopyWith<$Res> {
  _$PlayerCountStatisticsCopyWithImpl(this._value, this._then);

  final PlayerCountStatistics _value;
  // ignore: unused_field
  final $Res Function(PlayerCountStatistics) _then;

  @override
  $Res call({
    Object? numberOfPlayers = freezed,
    Object? numberOfGamesPlayed = freezed,
    Object? gamesPlayedPercentage = freezed,
  }) {
    return _then(_value.copyWith(
      numberOfPlayers: numberOfPlayers == freezed
          ? _value.numberOfPlayers
          : numberOfPlayers // ignore: cast_nullable_to_non_nullable
              as int,
      numberOfGamesPlayed: numberOfGamesPlayed == freezed
          ? _value.numberOfGamesPlayed
          : numberOfGamesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      gamesPlayedPercentage: gamesPlayedPercentage == freezed
          ? _value.gamesPlayedPercentage
          : gamesPlayedPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$$_PlayerCountStatisticsCopyWith<$Res>
    implements $PlayerCountStatisticsCopyWith<$Res> {
  factory _$$_PlayerCountStatisticsCopyWith(_$_PlayerCountStatistics value,
          $Res Function(_$_PlayerCountStatistics) then) =
      __$$_PlayerCountStatisticsCopyWithImpl<$Res>;
  @override
  $Res call(
      {int numberOfPlayers,
      int numberOfGamesPlayed,
      double gamesPlayedPercentage});
}

/// @nodoc
class __$$_PlayerCountStatisticsCopyWithImpl<$Res>
    extends _$PlayerCountStatisticsCopyWithImpl<$Res>
    implements _$$_PlayerCountStatisticsCopyWith<$Res> {
  __$$_PlayerCountStatisticsCopyWithImpl(_$_PlayerCountStatistics _value,
      $Res Function(_$_PlayerCountStatistics) _then)
      : super(_value, (v) => _then(v as _$_PlayerCountStatistics));

  @override
  _$_PlayerCountStatistics get _value =>
      super._value as _$_PlayerCountStatistics;

  @override
  $Res call({
    Object? numberOfPlayers = freezed,
    Object? numberOfGamesPlayed = freezed,
    Object? gamesPlayedPercentage = freezed,
  }) {
    return _then(_$_PlayerCountStatistics(
      numberOfPlayers: numberOfPlayers == freezed
          ? _value.numberOfPlayers
          : numberOfPlayers // ignore: cast_nullable_to_non_nullable
              as int,
      numberOfGamesPlayed: numberOfGamesPlayed == freezed
          ? _value.numberOfGamesPlayed
          : numberOfGamesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      gamesPlayedPercentage: gamesPlayedPercentage == freezed
          ? _value.gamesPlayedPercentage
          : gamesPlayedPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_PlayerCountStatistics implements _PlayerCountStatistics {
  const _$_PlayerCountStatistics(
      {required this.numberOfPlayers,
      required this.numberOfGamesPlayed,
      required this.gamesPlayedPercentage});

  @override
  final int numberOfPlayers;
  @override
  final int numberOfGamesPlayed;
  @override
  final double gamesPlayedPercentage;

  @override
  String toString() {
    return 'PlayerCountStatistics(numberOfPlayers: $numberOfPlayers, numberOfGamesPlayed: $numberOfGamesPlayed, gamesPlayedPercentage: $gamesPlayedPercentage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PlayerCountStatistics &&
            const DeepCollectionEquality()
                .equals(other.numberOfPlayers, numberOfPlayers) &&
            const DeepCollectionEquality()
                .equals(other.numberOfGamesPlayed, numberOfGamesPlayed) &&
            const DeepCollectionEquality()
                .equals(other.gamesPlayedPercentage, gamesPlayedPercentage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(numberOfPlayers),
      const DeepCollectionEquality().hash(numberOfGamesPlayed),
      const DeepCollectionEquality().hash(gamesPlayedPercentage));

  @JsonKey(ignore: true)
  @override
  _$$_PlayerCountStatisticsCopyWith<_$_PlayerCountStatistics> get copyWith =>
      __$$_PlayerCountStatisticsCopyWithImpl<_$_PlayerCountStatistics>(
          this, _$identity);
}

abstract class _PlayerCountStatistics implements PlayerCountStatistics {
  const factory _PlayerCountStatistics(
      {required final int numberOfPlayers,
      required final int numberOfGamesPlayed,
      required final double gamesPlayedPercentage}) = _$_PlayerCountStatistics;

  @override
  int get numberOfPlayers;
  @override
  int get numberOfGamesPlayed;
  @override
  double get gamesPlayedPercentage;
  @override
  @JsonKey(ignore: true)
  _$$_PlayerCountStatisticsCopyWith<_$_PlayerCountStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}
