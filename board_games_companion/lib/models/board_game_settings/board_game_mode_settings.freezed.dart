// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'board_game_mode_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BoardGameModeSettings {
  GameWinCondition get gameWinCondition => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GameWinCondition gameWinCondition,
            AverageScorePrecision averageScorePrecision)
        score,
    required TResult Function(GameWinCondition gameWinCondition) noScore,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(GameWinCondition gameWinCondition,
            AverageScorePrecision averageScorePrecision)?
        score,
    TResult Function(GameWinCondition gameWinCondition)? noScore,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GameWinCondition gameWinCondition,
            AverageScorePrecision averageScorePrecision)?
        score,
    TResult Function(GameWinCondition gameWinCondition)? noScore,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_score value) score,
    required TResult Function(_noScore value) noScore,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_score value)? score,
    TResult Function(_noScore value)? noScore,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_score value)? score,
    TResult Function(_noScore value)? noScore,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BoardGameModeSettingsCopyWith<BoardGameModeSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardGameModeSettingsCopyWith<$Res> {
  factory $BoardGameModeSettingsCopyWith(BoardGameModeSettings value,
          $Res Function(BoardGameModeSettings) then) =
      _$BoardGameModeSettingsCopyWithImpl<$Res>;
  $Res call({GameWinCondition gameWinCondition});
}

/// @nodoc
class _$BoardGameModeSettingsCopyWithImpl<$Res>
    implements $BoardGameModeSettingsCopyWith<$Res> {
  _$BoardGameModeSettingsCopyWithImpl(this._value, this._then);

  final BoardGameModeSettings _value;
  // ignore: unused_field
  final $Res Function(BoardGameModeSettings) _then;

  @override
  $Res call({
    Object? gameWinCondition = freezed,
  }) {
    return _then(_value.copyWith(
      gameWinCondition: gameWinCondition == freezed
          ? _value.gameWinCondition
          : gameWinCondition // ignore: cast_nullable_to_non_nullable
              as GameWinCondition,
    ));
  }
}

/// @nodoc
abstract class _$$_scoreCopyWith<$Res>
    implements $BoardGameModeSettingsCopyWith<$Res> {
  factory _$$_scoreCopyWith(_$_score value, $Res Function(_$_score) then) =
      __$$_scoreCopyWithImpl<$Res>;
  @override
  $Res call(
      {GameWinCondition gameWinCondition,
      AverageScorePrecision averageScorePrecision});

  $AverageScorePrecisionCopyWith<$Res> get averageScorePrecision;
}

/// @nodoc
class __$$_scoreCopyWithImpl<$Res>
    extends _$BoardGameModeSettingsCopyWithImpl<$Res>
    implements _$$_scoreCopyWith<$Res> {
  __$$_scoreCopyWithImpl(_$_score _value, $Res Function(_$_score) _then)
      : super(_value, (v) => _then(v as _$_score));

  @override
  _$_score get _value => super._value as _$_score;

  @override
  $Res call({
    Object? gameWinCondition = freezed,
    Object? averageScorePrecision = freezed,
  }) {
    return _then(_$_score(
      gameWinCondition: gameWinCondition == freezed
          ? _value.gameWinCondition
          : gameWinCondition // ignore: cast_nullable_to_non_nullable
              as GameWinCondition,
      averageScorePrecision: averageScorePrecision == freezed
          ? _value.averageScorePrecision
          : averageScorePrecision // ignore: cast_nullable_to_non_nullable
              as AverageScorePrecision,
    ));
  }

  @override
  $AverageScorePrecisionCopyWith<$Res> get averageScorePrecision {
    return $AverageScorePrecisionCopyWith<$Res>(_value.averageScorePrecision,
        (value) {
      return _then(_value.copyWith(averageScorePrecision: value));
    });
  }
}

/// @nodoc

class _$_score implements _score {
  const _$_score(
      {required this.gameWinCondition, required this.averageScorePrecision});

  @override
  final GameWinCondition gameWinCondition;
  @override
  final AverageScorePrecision averageScorePrecision;

  @override
  String toString() {
    return 'BoardGameModeSettings.score(gameWinCondition: $gameWinCondition, averageScorePrecision: $averageScorePrecision)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_score &&
            const DeepCollectionEquality()
                .equals(other.gameWinCondition, gameWinCondition) &&
            const DeepCollectionEquality()
                .equals(other.averageScorePrecision, averageScorePrecision));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(gameWinCondition),
      const DeepCollectionEquality().hash(averageScorePrecision));

  @JsonKey(ignore: true)
  @override
  _$$_scoreCopyWith<_$_score> get copyWith =>
      __$$_scoreCopyWithImpl<_$_score>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GameWinCondition gameWinCondition,
            AverageScorePrecision averageScorePrecision)
        score,
    required TResult Function(GameWinCondition gameWinCondition) noScore,
  }) {
    return score(gameWinCondition, averageScorePrecision);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(GameWinCondition gameWinCondition,
            AverageScorePrecision averageScorePrecision)?
        score,
    TResult Function(GameWinCondition gameWinCondition)? noScore,
  }) {
    return score?.call(gameWinCondition, averageScorePrecision);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GameWinCondition gameWinCondition,
            AverageScorePrecision averageScorePrecision)?
        score,
    TResult Function(GameWinCondition gameWinCondition)? noScore,
    required TResult orElse(),
  }) {
    if (score != null) {
      return score(gameWinCondition, averageScorePrecision);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_score value) score,
    required TResult Function(_noScore value) noScore,
  }) {
    return score(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_score value)? score,
    TResult Function(_noScore value)? noScore,
  }) {
    return score?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_score value)? score,
    TResult Function(_noScore value)? noScore,
    required TResult orElse(),
  }) {
    if (score != null) {
      return score(this);
    }
    return orElse();
  }
}

abstract class _score implements BoardGameModeSettings {
  const factory _score(
      {required final GameWinCondition gameWinCondition,
      required final AverageScorePrecision averageScorePrecision}) = _$_score;

  @override
  GameWinCondition get gameWinCondition;
  AverageScorePrecision get averageScorePrecision;
  @override
  @JsonKey(ignore: true)
  _$$_scoreCopyWith<_$_score> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_noScoreCopyWith<$Res>
    implements $BoardGameModeSettingsCopyWith<$Res> {
  factory _$$_noScoreCopyWith(
          _$_noScore value, $Res Function(_$_noScore) then) =
      __$$_noScoreCopyWithImpl<$Res>;
  @override
  $Res call({GameWinCondition gameWinCondition});
}

/// @nodoc
class __$$_noScoreCopyWithImpl<$Res>
    extends _$BoardGameModeSettingsCopyWithImpl<$Res>
    implements _$$_noScoreCopyWith<$Res> {
  __$$_noScoreCopyWithImpl(_$_noScore _value, $Res Function(_$_noScore) _then)
      : super(_value, (v) => _then(v as _$_noScore));

  @override
  _$_noScore get _value => super._value as _$_noScore;

  @override
  $Res call({
    Object? gameWinCondition = freezed,
  }) {
    return _then(_$_noScore(
      gameWinCondition: gameWinCondition == freezed
          ? _value.gameWinCondition
          : gameWinCondition // ignore: cast_nullable_to_non_nullable
              as GameWinCondition,
    ));
  }
}

/// @nodoc

class _$_noScore implements _noScore {
  const _$_noScore({required this.gameWinCondition});

  @override
  final GameWinCondition gameWinCondition;

  @override
  String toString() {
    return 'BoardGameModeSettings.noScore(gameWinCondition: $gameWinCondition)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_noScore &&
            const DeepCollectionEquality()
                .equals(other.gameWinCondition, gameWinCondition));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(gameWinCondition));

  @JsonKey(ignore: true)
  @override
  _$$_noScoreCopyWith<_$_noScore> get copyWith =>
      __$$_noScoreCopyWithImpl<_$_noScore>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GameWinCondition gameWinCondition,
            AverageScorePrecision averageScorePrecision)
        score,
    required TResult Function(GameWinCondition gameWinCondition) noScore,
  }) {
    return noScore(gameWinCondition);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(GameWinCondition gameWinCondition,
            AverageScorePrecision averageScorePrecision)?
        score,
    TResult Function(GameWinCondition gameWinCondition)? noScore,
  }) {
    return noScore?.call(gameWinCondition);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GameWinCondition gameWinCondition,
            AverageScorePrecision averageScorePrecision)?
        score,
    TResult Function(GameWinCondition gameWinCondition)? noScore,
    required TResult orElse(),
  }) {
    if (noScore != null) {
      return noScore(gameWinCondition);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_score value) score,
    required TResult Function(_noScore value) noScore,
  }) {
    return noScore(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_score value)? score,
    TResult Function(_noScore value)? noScore,
  }) {
    return noScore?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_score value)? score,
    TResult Function(_noScore value)? noScore,
    required TResult orElse(),
  }) {
    if (noScore != null) {
      return noScore(this);
    }
    return orElse();
  }
}

abstract class _noScore implements BoardGameModeSettings {
  const factory _noScore({required final GameWinCondition gameWinCondition}) =
      _$_noScore;

  @override
  GameWinCondition get gameWinCondition;
  @override
  @JsonKey(ignore: true)
  _$$_noScoreCopyWith<_$_noScore> get copyWith =>
      throw _privateConstructorUsedError;
}
