// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_game_mode_classification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BoardGameClassificationSettings {
  GameFamily get gameFamily => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            GameFamily gameFamily, AverageScorePrecision averageScorePrecision)
        score,
    required TResult Function(GameFamily gameFamily) noScore,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            GameFamily gameFamily, AverageScorePrecision averageScorePrecision)?
        score,
    TResult? Function(GameFamily gameFamily)? noScore,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            GameFamily gameFamily, AverageScorePrecision averageScorePrecision)?
        score,
    TResult Function(GameFamily gameFamily)? noScore,
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
    TResult? Function(_score value)? score,
    TResult? Function(_noScore value)? noScore,
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
  $BoardGameClassificationSettingsCopyWith<BoardGameClassificationSettings>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardGameClassificationSettingsCopyWith<$Res> {
  factory $BoardGameClassificationSettingsCopyWith(
          BoardGameClassificationSettings value,
          $Res Function(BoardGameClassificationSettings) then) =
      _$BoardGameClassificationSettingsCopyWithImpl<$Res,
          BoardGameClassificationSettings>;
  @useResult
  $Res call({GameFamily gameFamily});
}

/// @nodoc
class _$BoardGameClassificationSettingsCopyWithImpl<$Res,
        $Val extends BoardGameClassificationSettings>
    implements $BoardGameClassificationSettingsCopyWith<$Res> {
  _$BoardGameClassificationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameFamily = null,
  }) {
    return _then(_value.copyWith(
      gameFamily: null == gameFamily
          ? _value.gameFamily
          : gameFamily // ignore: cast_nullable_to_non_nullable
              as GameFamily,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$scoreImplCopyWith<$Res>
    implements $BoardGameClassificationSettingsCopyWith<$Res> {
  factory _$$scoreImplCopyWith(
          _$scoreImpl value, $Res Function(_$scoreImpl) then) =
      __$$scoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GameFamily gameFamily, AverageScorePrecision averageScorePrecision});

  $AverageScorePrecisionCopyWith<$Res> get averageScorePrecision;
}

/// @nodoc
class __$$scoreImplCopyWithImpl<$Res>
    extends _$BoardGameClassificationSettingsCopyWithImpl<$Res, _$scoreImpl>
    implements _$$scoreImplCopyWith<$Res> {
  __$$scoreImplCopyWithImpl(
      _$scoreImpl _value, $Res Function(_$scoreImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameFamily = null,
    Object? averageScorePrecision = null,
  }) {
    return _then(_$scoreImpl(
      gameFamily: null == gameFamily
          ? _value.gameFamily
          : gameFamily // ignore: cast_nullable_to_non_nullable
              as GameFamily,
      averageScorePrecision: null == averageScorePrecision
          ? _value.averageScorePrecision
          : averageScorePrecision // ignore: cast_nullable_to_non_nullable
              as AverageScorePrecision,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $AverageScorePrecisionCopyWith<$Res> get averageScorePrecision {
    return $AverageScorePrecisionCopyWith<$Res>(_value.averageScorePrecision,
        (value) {
      return _then(_value.copyWith(averageScorePrecision: value));
    });
  }
}

/// @nodoc

class _$scoreImpl implements _score {
  const _$scoreImpl(
      {required this.gameFamily, required this.averageScorePrecision});

  @override
  final GameFamily gameFamily;
  @override
  final AverageScorePrecision averageScorePrecision;

  @override
  String toString() {
    return 'BoardGameClassificationSettings.score(gameFamily: $gameFamily, averageScorePrecision: $averageScorePrecision)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$scoreImpl &&
            (identical(other.gameFamily, gameFamily) ||
                other.gameFamily == gameFamily) &&
            (identical(other.averageScorePrecision, averageScorePrecision) ||
                other.averageScorePrecision == averageScorePrecision));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, gameFamily, averageScorePrecision);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$scoreImplCopyWith<_$scoreImpl> get copyWith =>
      __$$scoreImplCopyWithImpl<_$scoreImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            GameFamily gameFamily, AverageScorePrecision averageScorePrecision)
        score,
    required TResult Function(GameFamily gameFamily) noScore,
  }) {
    return score(gameFamily, averageScorePrecision);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            GameFamily gameFamily, AverageScorePrecision averageScorePrecision)?
        score,
    TResult? Function(GameFamily gameFamily)? noScore,
  }) {
    return score?.call(gameFamily, averageScorePrecision);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            GameFamily gameFamily, AverageScorePrecision averageScorePrecision)?
        score,
    TResult Function(GameFamily gameFamily)? noScore,
    required TResult orElse(),
  }) {
    if (score != null) {
      return score(gameFamily, averageScorePrecision);
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
    TResult? Function(_score value)? score,
    TResult? Function(_noScore value)? noScore,
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

abstract class _score implements BoardGameClassificationSettings {
  const factory _score(
          {required final GameFamily gameFamily,
          required final AverageScorePrecision averageScorePrecision}) =
      _$scoreImpl;

  @override
  GameFamily get gameFamily;
  AverageScorePrecision get averageScorePrecision;
  @override
  @JsonKey(ignore: true)
  _$$scoreImplCopyWith<_$scoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$noScoreImplCopyWith<$Res>
    implements $BoardGameClassificationSettingsCopyWith<$Res> {
  factory _$$noScoreImplCopyWith(
          _$noScoreImpl value, $Res Function(_$noScoreImpl) then) =
      __$$noScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GameFamily gameFamily});
}

/// @nodoc
class __$$noScoreImplCopyWithImpl<$Res>
    extends _$BoardGameClassificationSettingsCopyWithImpl<$Res, _$noScoreImpl>
    implements _$$noScoreImplCopyWith<$Res> {
  __$$noScoreImplCopyWithImpl(
      _$noScoreImpl _value, $Res Function(_$noScoreImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameFamily = null,
  }) {
    return _then(_$noScoreImpl(
      gameFamily: null == gameFamily
          ? _value.gameFamily
          : gameFamily // ignore: cast_nullable_to_non_nullable
              as GameFamily,
    ));
  }
}

/// @nodoc

class _$noScoreImpl implements _noScore {
  const _$noScoreImpl({required this.gameFamily});

  @override
  final GameFamily gameFamily;

  @override
  String toString() {
    return 'BoardGameClassificationSettings.noScore(gameFamily: $gameFamily)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$noScoreImpl &&
            (identical(other.gameFamily, gameFamily) ||
                other.gameFamily == gameFamily));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gameFamily);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$noScoreImplCopyWith<_$noScoreImpl> get copyWith =>
      __$$noScoreImplCopyWithImpl<_$noScoreImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            GameFamily gameFamily, AverageScorePrecision averageScorePrecision)
        score,
    required TResult Function(GameFamily gameFamily) noScore,
  }) {
    return noScore(gameFamily);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            GameFamily gameFamily, AverageScorePrecision averageScorePrecision)?
        score,
    TResult? Function(GameFamily gameFamily)? noScore,
  }) {
    return noScore?.call(gameFamily);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            GameFamily gameFamily, AverageScorePrecision averageScorePrecision)?
        score,
    TResult Function(GameFamily gameFamily)? noScore,
    required TResult orElse(),
  }) {
    if (noScore != null) {
      return noScore(gameFamily);
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
    TResult? Function(_score value)? score,
    TResult? Function(_noScore value)? noScore,
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

abstract class _noScore implements BoardGameClassificationSettings {
  const factory _noScore({required final GameFamily gameFamily}) =
      _$noScoreImpl;

  @override
  GameFamily get gameFamily;
  @override
  @JsonKey(ignore: true)
  _$$noScoreImplCopyWith<_$noScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
