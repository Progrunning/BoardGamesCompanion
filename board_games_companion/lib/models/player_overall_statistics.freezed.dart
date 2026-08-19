// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_overall_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlayerOverallStatistics {
  Player get player => throw _privateConstructorUsedError;
  int get totalPlays => throw _privateConstructorUsedError;
  int get totalWins => throw _privateConstructorUsedError;
  double? get competitiveWinRate => throw _privateConstructorUsedError;
  double? get coopWinRate => throw _privateConstructorUsedError;
  List<GamePlaysCount> get gamesByPlays => throw _privateConstructorUsedError;
  HeadToHeadRecord? get rival => throw _privateConstructorUsedError;
  HeadToHeadRecord? get nemesis => throw _privateConstructorUsedError;
  List<BuddyRecord> get buddies => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlayerOverallStatisticsCopyWith<PlayerOverallStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerOverallStatisticsCopyWith<$Res> {
  factory $PlayerOverallStatisticsCopyWith(PlayerOverallStatistics value,
          $Res Function(PlayerOverallStatistics) then) =
      _$PlayerOverallStatisticsCopyWithImpl<$Res, PlayerOverallStatistics>;
  @useResult
  $Res call(
      {Player player,
      int totalPlays,
      int totalWins,
      double? competitiveWinRate,
      double? coopWinRate,
      List<GamePlaysCount> gamesByPlays,
      HeadToHeadRecord? rival,
      HeadToHeadRecord? nemesis,
      List<BuddyRecord> buddies});

  $PlayerCopyWith<$Res> get player;
  $HeadToHeadRecordCopyWith<$Res>? get rival;
  $HeadToHeadRecordCopyWith<$Res>? get nemesis;
}

/// @nodoc
class _$PlayerOverallStatisticsCopyWithImpl<$Res,
        $Val extends PlayerOverallStatistics>
    implements $PlayerOverallStatisticsCopyWith<$Res> {
  _$PlayerOverallStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? totalPlays = null,
    Object? totalWins = null,
    Object? competitiveWinRate = freezed,
    Object? coopWinRate = freezed,
    Object? gamesByPlays = null,
    Object? rival = freezed,
    Object? nemesis = freezed,
    Object? buddies = null,
  }) {
    return _then(_value.copyWith(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      totalPlays: null == totalPlays
          ? _value.totalPlays
          : totalPlays // ignore: cast_nullable_to_non_nullable
              as int,
      totalWins: null == totalWins
          ? _value.totalWins
          : totalWins // ignore: cast_nullable_to_non_nullable
              as int,
      competitiveWinRate: freezed == competitiveWinRate
          ? _value.competitiveWinRate
          : competitiveWinRate // ignore: cast_nullable_to_non_nullable
              as double?,
      coopWinRate: freezed == coopWinRate
          ? _value.coopWinRate
          : coopWinRate // ignore: cast_nullable_to_non_nullable
              as double?,
      gamesByPlays: null == gamesByPlays
          ? _value.gamesByPlays
          : gamesByPlays // ignore: cast_nullable_to_non_nullable
              as List<GamePlaysCount>,
      rival: freezed == rival
          ? _value.rival
          : rival // ignore: cast_nullable_to_non_nullable
              as HeadToHeadRecord?,
      nemesis: freezed == nemesis
          ? _value.nemesis
          : nemesis // ignore: cast_nullable_to_non_nullable
              as HeadToHeadRecord?,
      buddies: null == buddies
          ? _value.buddies
          : buddies // ignore: cast_nullable_to_non_nullable
              as List<BuddyRecord>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res> get player {
    return $PlayerCopyWith<$Res>(_value.player, (value) {
      return _then(_value.copyWith(player: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $HeadToHeadRecordCopyWith<$Res>? get rival {
    if (_value.rival == null) {
      return null;
    }

    return $HeadToHeadRecordCopyWith<$Res>(_value.rival!, (value) {
      return _then(_value.copyWith(rival: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $HeadToHeadRecordCopyWith<$Res>? get nemesis {
    if (_value.nemesis == null) {
      return null;
    }

    return $HeadToHeadRecordCopyWith<$Res>(_value.nemesis!, (value) {
      return _then(_value.copyWith(nemesis: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerOverallStatisticsImplCopyWith<$Res>
    implements $PlayerOverallStatisticsCopyWith<$Res> {
  factory _$$PlayerOverallStatisticsImplCopyWith(
          _$PlayerOverallStatisticsImpl value,
          $Res Function(_$PlayerOverallStatisticsImpl) then) =
      __$$PlayerOverallStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Player player,
      int totalPlays,
      int totalWins,
      double? competitiveWinRate,
      double? coopWinRate,
      List<GamePlaysCount> gamesByPlays,
      HeadToHeadRecord? rival,
      HeadToHeadRecord? nemesis,
      List<BuddyRecord> buddies});

  @override
  $PlayerCopyWith<$Res> get player;
  @override
  $HeadToHeadRecordCopyWith<$Res>? get rival;
  @override
  $HeadToHeadRecordCopyWith<$Res>? get nemesis;
}

/// @nodoc
class __$$PlayerOverallStatisticsImplCopyWithImpl<$Res>
    extends _$PlayerOverallStatisticsCopyWithImpl<$Res,
        _$PlayerOverallStatisticsImpl>
    implements _$$PlayerOverallStatisticsImplCopyWith<$Res> {
  __$$PlayerOverallStatisticsImplCopyWithImpl(
      _$PlayerOverallStatisticsImpl _value,
      $Res Function(_$PlayerOverallStatisticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? totalPlays = null,
    Object? totalWins = null,
    Object? competitiveWinRate = freezed,
    Object? coopWinRate = freezed,
    Object? gamesByPlays = null,
    Object? rival = freezed,
    Object? nemesis = freezed,
    Object? buddies = null,
  }) {
    return _then(_$PlayerOverallStatisticsImpl(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      totalPlays: null == totalPlays
          ? _value.totalPlays
          : totalPlays // ignore: cast_nullable_to_non_nullable
              as int,
      totalWins: null == totalWins
          ? _value.totalWins
          : totalWins // ignore: cast_nullable_to_non_nullable
              as int,
      competitiveWinRate: freezed == competitiveWinRate
          ? _value.competitiveWinRate
          : competitiveWinRate // ignore: cast_nullable_to_non_nullable
              as double?,
      coopWinRate: freezed == coopWinRate
          ? _value.coopWinRate
          : coopWinRate // ignore: cast_nullable_to_non_nullable
              as double?,
      gamesByPlays: null == gamesByPlays
          ? _value._gamesByPlays
          : gamesByPlays // ignore: cast_nullable_to_non_nullable
              as List<GamePlaysCount>,
      rival: freezed == rival
          ? _value.rival
          : rival // ignore: cast_nullable_to_non_nullable
              as HeadToHeadRecord?,
      nemesis: freezed == nemesis
          ? _value.nemesis
          : nemesis // ignore: cast_nullable_to_non_nullable
              as HeadToHeadRecord?,
      buddies: null == buddies
          ? _value._buddies
          : buddies // ignore: cast_nullable_to_non_nullable
              as List<BuddyRecord>,
    ));
  }
}

/// @nodoc

class _$PlayerOverallStatisticsImpl extends _PlayerOverallStatistics {
  const _$PlayerOverallStatisticsImpl(
      {required this.player,
      required this.totalPlays,
      required this.totalWins,
      this.competitiveWinRate,
      this.coopWinRate,
      final List<GamePlaysCount> gamesByPlays = const <GamePlaysCount>[],
      this.rival,
      this.nemesis,
      final List<BuddyRecord> buddies = const <BuddyRecord>[]})
      : _gamesByPlays = gamesByPlays,
        _buddies = buddies,
        super._();

  @override
  final Player player;
  @override
  final int totalPlays;
  @override
  final int totalWins;
  @override
  final double? competitiveWinRate;
  @override
  final double? coopWinRate;
  final List<GamePlaysCount> _gamesByPlays;
  @override
  @JsonKey()
  List<GamePlaysCount> get gamesByPlays {
    if (_gamesByPlays is EqualUnmodifiableListView) return _gamesByPlays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gamesByPlays);
  }

  @override
  final HeadToHeadRecord? rival;
  @override
  final HeadToHeadRecord? nemesis;
  final List<BuddyRecord> _buddies;
  @override
  @JsonKey()
  List<BuddyRecord> get buddies {
    if (_buddies is EqualUnmodifiableListView) return _buddies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_buddies);
  }

  @override
  String toString() {
    return 'PlayerOverallStatistics(player: $player, totalPlays: $totalPlays, totalWins: $totalWins, competitiveWinRate: $competitiveWinRate, coopWinRate: $coopWinRate, gamesByPlays: $gamesByPlays, rival: $rival, nemesis: $nemesis, buddies: $buddies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerOverallStatisticsImpl &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.totalPlays, totalPlays) ||
                other.totalPlays == totalPlays) &&
            (identical(other.totalWins, totalWins) ||
                other.totalWins == totalWins) &&
            (identical(other.competitiveWinRate, competitiveWinRate) ||
                other.competitiveWinRate == competitiveWinRate) &&
            (identical(other.coopWinRate, coopWinRate) ||
                other.coopWinRate == coopWinRate) &&
            const DeepCollectionEquality()
                .equals(other._gamesByPlays, _gamesByPlays) &&
            (identical(other.rival, rival) || other.rival == rival) &&
            (identical(other.nemesis, nemesis) || other.nemesis == nemesis) &&
            const DeepCollectionEquality().equals(other._buddies, _buddies));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      player,
      totalPlays,
      totalWins,
      competitiveWinRate,
      coopWinRate,
      const DeepCollectionEquality().hash(_gamesByPlays),
      rival,
      nemesis,
      const DeepCollectionEquality().hash(_buddies));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerOverallStatisticsImplCopyWith<_$PlayerOverallStatisticsImpl>
      get copyWith => __$$PlayerOverallStatisticsImplCopyWithImpl<
          _$PlayerOverallStatisticsImpl>(this, _$identity);
}

abstract class _PlayerOverallStatistics extends PlayerOverallStatistics {
  const factory _PlayerOverallStatistics(
      {required final Player player,
      required final int totalPlays,
      required final int totalWins,
      final double? competitiveWinRate,
      final double? coopWinRate,
      final List<GamePlaysCount> gamesByPlays,
      final HeadToHeadRecord? rival,
      final HeadToHeadRecord? nemesis,
      final List<BuddyRecord> buddies}) = _$PlayerOverallStatisticsImpl;
  const _PlayerOverallStatistics._() : super._();

  @override
  Player get player;
  @override
  int get totalPlays;
  @override
  int get totalWins;
  @override
  double? get competitiveWinRate;
  @override
  double? get coopWinRate;
  @override
  List<GamePlaysCount> get gamesByPlays;
  @override
  HeadToHeadRecord? get rival;
  @override
  HeadToHeadRecord? get nemesis;
  @override
  List<BuddyRecord> get buddies;
  @override
  @JsonKey(ignore: true)
  _$$PlayerOverallStatisticsImplCopyWith<_$PlayerOverallStatisticsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GamePlaysCount {
  String get boardGameId => throw _privateConstructorUsedError;
  String get boardGameName => throw _privateConstructorUsedError;
  String? get boardGameImageUrl => throw _privateConstructorUsedError;
  int get playCount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GamePlaysCountCopyWith<GamePlaysCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GamePlaysCountCopyWith<$Res> {
  factory $GamePlaysCountCopyWith(
          GamePlaysCount value, $Res Function(GamePlaysCount) then) =
      _$GamePlaysCountCopyWithImpl<$Res, GamePlaysCount>;
  @useResult
  $Res call(
      {String boardGameId,
      String boardGameName,
      String? boardGameImageUrl,
      int playCount});
}

/// @nodoc
class _$GamePlaysCountCopyWithImpl<$Res, $Val extends GamePlaysCount>
    implements $GamePlaysCountCopyWith<$Res> {
  _$GamePlaysCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGameId = null,
    Object? boardGameName = null,
    Object? boardGameImageUrl = freezed,
    Object? playCount = null,
  }) {
    return _then(_value.copyWith(
      boardGameId: null == boardGameId
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameName: null == boardGameName
          ? _value.boardGameName
          : boardGameName // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameImageUrl: freezed == boardGameImageUrl
          ? _value.boardGameImageUrl
          : boardGameImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      playCount: null == playCount
          ? _value.playCount
          : playCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GamePlaysCountImplCopyWith<$Res>
    implements $GamePlaysCountCopyWith<$Res> {
  factory _$$GamePlaysCountImplCopyWith(_$GamePlaysCountImpl value,
          $Res Function(_$GamePlaysCountImpl) then) =
      __$$GamePlaysCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String boardGameId,
      String boardGameName,
      String? boardGameImageUrl,
      int playCount});
}

/// @nodoc
class __$$GamePlaysCountImplCopyWithImpl<$Res>
    extends _$GamePlaysCountCopyWithImpl<$Res, _$GamePlaysCountImpl>
    implements _$$GamePlaysCountImplCopyWith<$Res> {
  __$$GamePlaysCountImplCopyWithImpl(
      _$GamePlaysCountImpl _value, $Res Function(_$GamePlaysCountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGameId = null,
    Object? boardGameName = null,
    Object? boardGameImageUrl = freezed,
    Object? playCount = null,
  }) {
    return _then(_$GamePlaysCountImpl(
      boardGameId: null == boardGameId
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameName: null == boardGameName
          ? _value.boardGameName
          : boardGameName // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameImageUrl: freezed == boardGameImageUrl
          ? _value.boardGameImageUrl
          : boardGameImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      playCount: null == playCount
          ? _value.playCount
          : playCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$GamePlaysCountImpl implements _GamePlaysCount {
  const _$GamePlaysCountImpl(
      {required this.boardGameId,
      required this.boardGameName,
      this.boardGameImageUrl,
      required this.playCount});

  @override
  final String boardGameId;
  @override
  final String boardGameName;
  @override
  final String? boardGameImageUrl;
  @override
  final int playCount;

  @override
  String toString() {
    return 'GamePlaysCount(boardGameId: $boardGameId, boardGameName: $boardGameName, boardGameImageUrl: $boardGameImageUrl, playCount: $playCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GamePlaysCountImpl &&
            (identical(other.boardGameId, boardGameId) ||
                other.boardGameId == boardGameId) &&
            (identical(other.boardGameName, boardGameName) ||
                other.boardGameName == boardGameName) &&
            (identical(other.boardGameImageUrl, boardGameImageUrl) ||
                other.boardGameImageUrl == boardGameImageUrl) &&
            (identical(other.playCount, playCount) ||
                other.playCount == playCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, boardGameId, boardGameName, boardGameImageUrl, playCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GamePlaysCountImplCopyWith<_$GamePlaysCountImpl> get copyWith =>
      __$$GamePlaysCountImplCopyWithImpl<_$GamePlaysCountImpl>(
          this, _$identity);
}

abstract class _GamePlaysCount implements GamePlaysCount {
  const factory _GamePlaysCount(
      {required final String boardGameId,
      required final String boardGameName,
      final String? boardGameImageUrl,
      required final int playCount}) = _$GamePlaysCountImpl;

  @override
  String get boardGameId;
  @override
  String get boardGameName;
  @override
  String? get boardGameImageUrl;
  @override
  int get playCount;
  @override
  @JsonKey(ignore: true)
  _$$GamePlaysCountImplCopyWith<_$GamePlaysCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HeadToHeadRecord {
  Player get opponent => throw _privateConstructorUsedError;
  int get wins => throw _privateConstructorUsedError;
  int get losses => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HeadToHeadRecordCopyWith<HeadToHeadRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeadToHeadRecordCopyWith<$Res> {
  factory $HeadToHeadRecordCopyWith(
          HeadToHeadRecord value, $Res Function(HeadToHeadRecord) then) =
      _$HeadToHeadRecordCopyWithImpl<$Res, HeadToHeadRecord>;
  @useResult
  $Res call({Player opponent, int wins, int losses});

  $PlayerCopyWith<$Res> get opponent;
}

/// @nodoc
class _$HeadToHeadRecordCopyWithImpl<$Res, $Val extends HeadToHeadRecord>
    implements $HeadToHeadRecordCopyWith<$Res> {
  _$HeadToHeadRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? opponent = null,
    Object? wins = null,
    Object? losses = null,
  }) {
    return _then(_value.copyWith(
      opponent: null == opponent
          ? _value.opponent
          : opponent // ignore: cast_nullable_to_non_nullable
              as Player,
      wins: null == wins
          ? _value.wins
          : wins // ignore: cast_nullable_to_non_nullable
              as int,
      losses: null == losses
          ? _value.losses
          : losses // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res> get opponent {
    return $PlayerCopyWith<$Res>(_value.opponent, (value) {
      return _then(_value.copyWith(opponent: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HeadToHeadRecordImplCopyWith<$Res>
    implements $HeadToHeadRecordCopyWith<$Res> {
  factory _$$HeadToHeadRecordImplCopyWith(_$HeadToHeadRecordImpl value,
          $Res Function(_$HeadToHeadRecordImpl) then) =
      __$$HeadToHeadRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Player opponent, int wins, int losses});

  @override
  $PlayerCopyWith<$Res> get opponent;
}

/// @nodoc
class __$$HeadToHeadRecordImplCopyWithImpl<$Res>
    extends _$HeadToHeadRecordCopyWithImpl<$Res, _$HeadToHeadRecordImpl>
    implements _$$HeadToHeadRecordImplCopyWith<$Res> {
  __$$HeadToHeadRecordImplCopyWithImpl(_$HeadToHeadRecordImpl _value,
      $Res Function(_$HeadToHeadRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? opponent = null,
    Object? wins = null,
    Object? losses = null,
  }) {
    return _then(_$HeadToHeadRecordImpl(
      opponent: null == opponent
          ? _value.opponent
          : opponent // ignore: cast_nullable_to_non_nullable
              as Player,
      wins: null == wins
          ? _value.wins
          : wins // ignore: cast_nullable_to_non_nullable
              as int,
      losses: null == losses
          ? _value.losses
          : losses // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$HeadToHeadRecordImpl implements _HeadToHeadRecord {
  const _$HeadToHeadRecordImpl(
      {required this.opponent, required this.wins, required this.losses});

  @override
  final Player opponent;
  @override
  final int wins;
  @override
  final int losses;

  @override
  String toString() {
    return 'HeadToHeadRecord(opponent: $opponent, wins: $wins, losses: $losses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeadToHeadRecordImpl &&
            (identical(other.opponent, opponent) ||
                other.opponent == opponent) &&
            (identical(other.wins, wins) || other.wins == wins) &&
            (identical(other.losses, losses) || other.losses == losses));
  }

  @override
  int get hashCode => Object.hash(runtimeType, opponent, wins, losses);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HeadToHeadRecordImplCopyWith<_$HeadToHeadRecordImpl> get copyWith =>
      __$$HeadToHeadRecordImplCopyWithImpl<_$HeadToHeadRecordImpl>(
          this, _$identity);
}

abstract class _HeadToHeadRecord implements HeadToHeadRecord {
  const factory _HeadToHeadRecord(
      {required final Player opponent,
      required final int wins,
      required final int losses}) = _$HeadToHeadRecordImpl;

  @override
  Player get opponent;
  @override
  int get wins;
  @override
  int get losses;
  @override
  @JsonKey(ignore: true)
  _$$HeadToHeadRecordImplCopyWith<_$HeadToHeadRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BuddyRecord {
  Player get buddy => throw _privateConstructorUsedError;
  int get sharedPlaysCount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BuddyRecordCopyWith<BuddyRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuddyRecordCopyWith<$Res> {
  factory $BuddyRecordCopyWith(
          BuddyRecord value, $Res Function(BuddyRecord) then) =
      _$BuddyRecordCopyWithImpl<$Res, BuddyRecord>;
  @useResult
  $Res call({Player buddy, int sharedPlaysCount});

  $PlayerCopyWith<$Res> get buddy;
}

/// @nodoc
class _$BuddyRecordCopyWithImpl<$Res, $Val extends BuddyRecord>
    implements $BuddyRecordCopyWith<$Res> {
  _$BuddyRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? buddy = null,
    Object? sharedPlaysCount = null,
  }) {
    return _then(_value.copyWith(
      buddy: null == buddy
          ? _value.buddy
          : buddy // ignore: cast_nullable_to_non_nullable
              as Player,
      sharedPlaysCount: null == sharedPlaysCount
          ? _value.sharedPlaysCount
          : sharedPlaysCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res> get buddy {
    return $PlayerCopyWith<$Res>(_value.buddy, (value) {
      return _then(_value.copyWith(buddy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BuddyRecordImplCopyWith<$Res>
    implements $BuddyRecordCopyWith<$Res> {
  factory _$$BuddyRecordImplCopyWith(
          _$BuddyRecordImpl value, $Res Function(_$BuddyRecordImpl) then) =
      __$$BuddyRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Player buddy, int sharedPlaysCount});

  @override
  $PlayerCopyWith<$Res> get buddy;
}

/// @nodoc
class __$$BuddyRecordImplCopyWithImpl<$Res>
    extends _$BuddyRecordCopyWithImpl<$Res, _$BuddyRecordImpl>
    implements _$$BuddyRecordImplCopyWith<$Res> {
  __$$BuddyRecordImplCopyWithImpl(
      _$BuddyRecordImpl _value, $Res Function(_$BuddyRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? buddy = null,
    Object? sharedPlaysCount = null,
  }) {
    return _then(_$BuddyRecordImpl(
      buddy: null == buddy
          ? _value.buddy
          : buddy // ignore: cast_nullable_to_non_nullable
              as Player,
      sharedPlaysCount: null == sharedPlaysCount
          ? _value.sharedPlaysCount
          : sharedPlaysCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$BuddyRecordImpl implements _BuddyRecord {
  const _$BuddyRecordImpl(
      {required this.buddy, required this.sharedPlaysCount});

  @override
  final Player buddy;
  @override
  final int sharedPlaysCount;

  @override
  String toString() {
    return 'BuddyRecord(buddy: $buddy, sharedPlaysCount: $sharedPlaysCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuddyRecordImpl &&
            (identical(other.buddy, buddy) || other.buddy == buddy) &&
            (identical(other.sharedPlaysCount, sharedPlaysCount) ||
                other.sharedPlaysCount == sharedPlaysCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, buddy, sharedPlaysCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BuddyRecordImplCopyWith<_$BuddyRecordImpl> get copyWith =>
      __$$BuddyRecordImplCopyWithImpl<_$BuddyRecordImpl>(this, _$identity);
}

abstract class _BuddyRecord implements BuddyRecord {
  const factory _BuddyRecord(
      {required final Player buddy,
      required final int sharedPlaysCount}) = _$BuddyRecordImpl;

  @override
  Player get buddy;
  @override
  int get sharedPlaysCount;
  @override
  @JsonKey(ignore: true)
  _$$BuddyRecordImplCopyWith<_$BuddyRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
