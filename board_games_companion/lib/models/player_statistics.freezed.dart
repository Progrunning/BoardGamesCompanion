// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PlayerStatistics {
  Player get player => throw _privateConstructorUsedError;
  int get totalGamesPlayed => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Player player, int personalBestScore,
            num averageScore, int totalGamesPlayed)
        scoreGames,
    required TResult Function(
            Player player, int totalGamesPlayed, int totalWins, int totalLosses)
        noScoreGames,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Player player, int personalBestScore, num averageScore,
            int totalGamesPlayed)?
        scoreGames,
    TResult? Function(Player player, int totalGamesPlayed, int totalWins,
            int totalLosses)?
        noScoreGames,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Player player, int personalBestScore, num averageScore,
            int totalGamesPlayed)?
        scoreGames,
    TResult Function(Player player, int totalGamesPlayed, int totalWins,
            int totalLosses)?
        noScoreGames,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_scoreGames value) scoreGames,
    required TResult Function(_noScoreGames value) noScoreGames,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_scoreGames value)? scoreGames,
    TResult? Function(_noScoreGames value)? noScoreGames,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_scoreGames value)? scoreGames,
    TResult Function(_noScoreGames value)? noScoreGames,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlayerStatisticsCopyWith<PlayerStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerStatisticsCopyWith<$Res> {
  factory $PlayerStatisticsCopyWith(
          PlayerStatistics value, $Res Function(PlayerStatistics) then) =
      _$PlayerStatisticsCopyWithImpl<$Res, PlayerStatistics>;
  @useResult
  $Res call({Player player, int totalGamesPlayed});

  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class _$PlayerStatisticsCopyWithImpl<$Res, $Val extends PlayerStatistics>
    implements $PlayerStatisticsCopyWith<$Res> {
  _$PlayerStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? totalGamesPlayed = null,
  }) {
    return _then(_value.copyWith(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      totalGamesPlayed: null == totalGamesPlayed
          ? _value.totalGamesPlayed
          : totalGamesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$_scoreGamesCopyWith<$Res>
    implements $PlayerStatisticsCopyWith<$Res> {
  factory _$$_scoreGamesCopyWith(
          _$_scoreGames value, $Res Function(_$_scoreGames) then) =
      __$$_scoreGamesCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Player player,
      int personalBestScore,
      num averageScore,
      int totalGamesPlayed});

  @override
  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class __$$_scoreGamesCopyWithImpl<$Res>
    extends _$PlayerStatisticsCopyWithImpl<$Res, _$_scoreGames>
    implements _$$_scoreGamesCopyWith<$Res> {
  __$$_scoreGamesCopyWithImpl(
      _$_scoreGames _value, $Res Function(_$_scoreGames) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? personalBestScore = null,
    Object? averageScore = null,
    Object? totalGamesPlayed = null,
  }) {
    return _then(_$_scoreGames(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      personalBestScore: null == personalBestScore
          ? _value.personalBestScore
          : personalBestScore // ignore: cast_nullable_to_non_nullable
              as int,
      averageScore: null == averageScore
          ? _value.averageScore
          : averageScore // ignore: cast_nullable_to_non_nullable
              as num,
      totalGamesPlayed: null == totalGamesPlayed
          ? _value.totalGamesPlayed
          : totalGamesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_scoreGames implements _scoreGames {
  const _$_scoreGames(
      {required this.player,
      required this.personalBestScore,
      required this.averageScore,
      required this.totalGamesPlayed});

  @override
  final Player player;
  @override
  final int personalBestScore;
  @override
  final num averageScore;
  @override
  final int totalGamesPlayed;

  @override
  String toString() {
    return 'PlayerStatistics.scoreGames(player: $player, personalBestScore: $personalBestScore, averageScore: $averageScore, totalGamesPlayed: $totalGamesPlayed)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_scoreGames &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.personalBestScore, personalBestScore) ||
                other.personalBestScore == personalBestScore) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore) &&
            (identical(other.totalGamesPlayed, totalGamesPlayed) ||
                other.totalGamesPlayed == totalGamesPlayed));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, player, personalBestScore, averageScore, totalGamesPlayed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_scoreGamesCopyWith<_$_scoreGames> get copyWith =>
      __$$_scoreGamesCopyWithImpl<_$_scoreGames>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Player player, int personalBestScore,
            num averageScore, int totalGamesPlayed)
        scoreGames,
    required TResult Function(
            Player player, int totalGamesPlayed, int totalWins, int totalLosses)
        noScoreGames,
  }) {
    return scoreGames(
        player, personalBestScore, averageScore, totalGamesPlayed);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Player player, int personalBestScore, num averageScore,
            int totalGamesPlayed)?
        scoreGames,
    TResult? Function(Player player, int totalGamesPlayed, int totalWins,
            int totalLosses)?
        noScoreGames,
  }) {
    return scoreGames?.call(
        player, personalBestScore, averageScore, totalGamesPlayed);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Player player, int personalBestScore, num averageScore,
            int totalGamesPlayed)?
        scoreGames,
    TResult Function(Player player, int totalGamesPlayed, int totalWins,
            int totalLosses)?
        noScoreGames,
    required TResult orElse(),
  }) {
    if (scoreGames != null) {
      return scoreGames(
          player, personalBestScore, averageScore, totalGamesPlayed);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_scoreGames value) scoreGames,
    required TResult Function(_noScoreGames value) noScoreGames,
  }) {
    return scoreGames(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_scoreGames value)? scoreGames,
    TResult? Function(_noScoreGames value)? noScoreGames,
  }) {
    return scoreGames?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_scoreGames value)? scoreGames,
    TResult Function(_noScoreGames value)? noScoreGames,
    required TResult orElse(),
  }) {
    if (scoreGames != null) {
      return scoreGames(this);
    }
    return orElse();
  }
}

abstract class _scoreGames implements PlayerStatistics {
  const factory _scoreGames(
      {required final Player player,
      required final int personalBestScore,
      required final num averageScore,
      required final int totalGamesPlayed}) = _$_scoreGames;

  @override
  Player get player;
  int get personalBestScore;
  num get averageScore;
  @override
  int get totalGamesPlayed;
  @override
  @JsonKey(ignore: true)
  _$$_scoreGamesCopyWith<_$_scoreGames> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_noScoreGamesCopyWith<$Res>
    implements $PlayerStatisticsCopyWith<$Res> {
  factory _$$_noScoreGamesCopyWith(
          _$_noScoreGames value, $Res Function(_$_noScoreGames) then) =
      __$$_noScoreGamesCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Player player, int totalGamesPlayed, int totalWins, int totalLosses});

  @override
  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class __$$_noScoreGamesCopyWithImpl<$Res>
    extends _$PlayerStatisticsCopyWithImpl<$Res, _$_noScoreGames>
    implements _$$_noScoreGamesCopyWith<$Res> {
  __$$_noScoreGamesCopyWithImpl(
      _$_noScoreGames _value, $Res Function(_$_noScoreGames) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? totalGamesPlayed = null,
    Object? totalWins = null,
    Object? totalLosses = null,
  }) {
    return _then(_$_noScoreGames(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      totalGamesPlayed: null == totalGamesPlayed
          ? _value.totalGamesPlayed
          : totalGamesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      totalWins: null == totalWins
          ? _value.totalWins
          : totalWins // ignore: cast_nullable_to_non_nullable
              as int,
      totalLosses: null == totalLosses
          ? _value.totalLosses
          : totalLosses // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_noScoreGames implements _noScoreGames {
  const _$_noScoreGames(
      {required this.player,
      required this.totalGamesPlayed,
      required this.totalWins,
      required this.totalLosses});

  @override
  final Player player;
  @override
  final int totalGamesPlayed;
  @override
  final int totalWins;
  @override
  final int totalLosses;

  @override
  String toString() {
    return 'PlayerStatistics.noScoreGames(player: $player, totalGamesPlayed: $totalGamesPlayed, totalWins: $totalWins, totalLosses: $totalLosses)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_noScoreGames &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.totalGamesPlayed, totalGamesPlayed) ||
                other.totalGamesPlayed == totalGamesPlayed) &&
            (identical(other.totalWins, totalWins) ||
                other.totalWins == totalWins) &&
            (identical(other.totalLosses, totalLosses) ||
                other.totalLosses == totalLosses));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, player, totalGamesPlayed, totalWins, totalLosses);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_noScoreGamesCopyWith<_$_noScoreGames> get copyWith =>
      __$$_noScoreGamesCopyWithImpl<_$_noScoreGames>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Player player, int personalBestScore,
            num averageScore, int totalGamesPlayed)
        scoreGames,
    required TResult Function(
            Player player, int totalGamesPlayed, int totalWins, int totalLosses)
        noScoreGames,
  }) {
    return noScoreGames(player, totalGamesPlayed, totalWins, totalLosses);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Player player, int personalBestScore, num averageScore,
            int totalGamesPlayed)?
        scoreGames,
    TResult? Function(Player player, int totalGamesPlayed, int totalWins,
            int totalLosses)?
        noScoreGames,
  }) {
    return noScoreGames?.call(player, totalGamesPlayed, totalWins, totalLosses);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Player player, int personalBestScore, num averageScore,
            int totalGamesPlayed)?
        scoreGames,
    TResult Function(Player player, int totalGamesPlayed, int totalWins,
            int totalLosses)?
        noScoreGames,
    required TResult orElse(),
  }) {
    if (noScoreGames != null) {
      return noScoreGames(player, totalGamesPlayed, totalWins, totalLosses);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_scoreGames value) scoreGames,
    required TResult Function(_noScoreGames value) noScoreGames,
  }) {
    return noScoreGames(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_scoreGames value)? scoreGames,
    TResult? Function(_noScoreGames value)? noScoreGames,
  }) {
    return noScoreGames?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_scoreGames value)? scoreGames,
    TResult Function(_noScoreGames value)? noScoreGames,
    required TResult orElse(),
  }) {
    if (noScoreGames != null) {
      return noScoreGames(this);
    }
    return orElse();
  }
}

abstract class _noScoreGames implements PlayerStatistics {
  const factory _noScoreGames(
      {required final Player player,
      required final int totalGamesPlayed,
      required final int totalWins,
      required final int totalLosses}) = _$_noScoreGames;

  @override
  Player get player;
  @override
  int get totalGamesPlayed;
  int get totalWins;
  int get totalLosses;
  @override
  @JsonKey(ignore: true)
  _$$_noScoreGamesCopyWith<_$_noScoreGames> get copyWith =>
      throw _privateConstructorUsedError;
}
