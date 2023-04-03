// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_game_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BoardGameSettings {
  @HiveField(1)
  GameFamily get gameFamily => throw _privateConstructorUsedError;
  @HiveField(2, defaultValue: 0)
  int get averageScorePrecision => throw _privateConstructorUsedError;
  @HiveField(3, defaultValue: GameClassification.Score)
  GameClassification get gameClassification =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BoardGameSettingsCopyWith<BoardGameSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardGameSettingsCopyWith<$Res> {
  factory $BoardGameSettingsCopyWith(
          BoardGameSettings value, $Res Function(BoardGameSettings) then) =
      _$BoardGameSettingsCopyWithImpl<$Res, BoardGameSettings>;
  @useResult
  $Res call(
      {@HiveField(1)
          GameFamily gameFamily,
      @HiveField(2, defaultValue: 0)
          int averageScorePrecision,
      @HiveField(3, defaultValue: GameClassification.Score)
          GameClassification gameClassification});
}

/// @nodoc
class _$BoardGameSettingsCopyWithImpl<$Res, $Val extends BoardGameSettings>
    implements $BoardGameSettingsCopyWith<$Res> {
  _$BoardGameSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameFamily = null,
    Object? averageScorePrecision = null,
    Object? gameClassification = null,
  }) {
    return _then(_value.copyWith(
      gameFamily: null == gameFamily
          ? _value.gameFamily
          : gameFamily // ignore: cast_nullable_to_non_nullable
              as GameFamily,
      averageScorePrecision: null == averageScorePrecision
          ? _value.averageScorePrecision
          : averageScorePrecision // ignore: cast_nullable_to_non_nullable
              as int,
      gameClassification: null == gameClassification
          ? _value.gameClassification
          : gameClassification // ignore: cast_nullable_to_non_nullable
              as GameClassification,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BoardGameSettingsCopyWith<$Res>
    implements $BoardGameSettingsCopyWith<$Res> {
  factory _$$_BoardGameSettingsCopyWith(_$_BoardGameSettings value,
          $Res Function(_$_BoardGameSettings) then) =
      __$$_BoardGameSettingsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(1)
          GameFamily gameFamily,
      @HiveField(2, defaultValue: 0)
          int averageScorePrecision,
      @HiveField(3, defaultValue: GameClassification.Score)
          GameClassification gameClassification});
}

/// @nodoc
class __$$_BoardGameSettingsCopyWithImpl<$Res>
    extends _$BoardGameSettingsCopyWithImpl<$Res, _$_BoardGameSettings>
    implements _$$_BoardGameSettingsCopyWith<$Res> {
  __$$_BoardGameSettingsCopyWithImpl(
      _$_BoardGameSettings _value, $Res Function(_$_BoardGameSettings) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameFamily = null,
    Object? averageScorePrecision = null,
    Object? gameClassification = null,
  }) {
    return _then(_$_BoardGameSettings(
      gameFamily: null == gameFamily
          ? _value.gameFamily
          : gameFamily // ignore: cast_nullable_to_non_nullable
              as GameFamily,
      averageScorePrecision: null == averageScorePrecision
          ? _value.averageScorePrecision
          : averageScorePrecision // ignore: cast_nullable_to_non_nullable
              as int,
      gameClassification: null == gameClassification
          ? _value.gameClassification
          : gameClassification // ignore: cast_nullable_to_non_nullable
              as GameClassification,
    ));
  }
}

/// @nodoc

@HiveType(
    typeId: HiveBoxes.boardGameSettingsTypeId,
    adapterName: 'BoardGameSettingsAdapter')
class _$_BoardGameSettings implements _BoardGameSettings {
  const _$_BoardGameSettings(
      {@HiveField(1)
          this.gameFamily = GameFamily.HighestScore,
      @HiveField(2, defaultValue: 0)
          this.averageScorePrecision = 0,
      @HiveField(3, defaultValue: GameClassification.Score)
          this.gameClassification = GameClassification.Score});

  @override
  @JsonKey()
  @HiveField(1)
  final GameFamily gameFamily;
  @override
  @JsonKey()
  @HiveField(2, defaultValue: 0)
  final int averageScorePrecision;
  @override
  @JsonKey()
  @HiveField(3, defaultValue: GameClassification.Score)
  final GameClassification gameClassification;

  @override
  String toString() {
    return 'BoardGameSettings(gameFamily: $gameFamily, averageScorePrecision: $averageScorePrecision, gameClassification: $gameClassification)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BoardGameSettings &&
            (identical(other.gameFamily, gameFamily) ||
                other.gameFamily == gameFamily) &&
            (identical(other.averageScorePrecision, averageScorePrecision) ||
                other.averageScorePrecision == averageScorePrecision) &&
            (identical(other.gameClassification, gameClassification) ||
                other.gameClassification == gameClassification));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, gameFamily, averageScorePrecision, gameClassification);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BoardGameSettingsCopyWith<_$_BoardGameSettings> get copyWith =>
      __$$_BoardGameSettingsCopyWithImpl<_$_BoardGameSettings>(
          this, _$identity);
}

abstract class _BoardGameSettings implements BoardGameSettings {
  const factory _BoardGameSettings(
      {@HiveField(1)
          final GameFamily gameFamily,
      @HiveField(2, defaultValue: 0)
          final int averageScorePrecision,
      @HiveField(3, defaultValue: GameClassification.Score)
          final GameClassification gameClassification}) = _$_BoardGameSettings;

  @override
  @HiveField(1)
  GameFamily get gameFamily;
  @override
  @HiveField(2, defaultValue: 0)
  int get averageScorePrecision;
  @override
  @HiveField(3, defaultValue: GameClassification.Score)
  GameClassification get gameClassification;
  @override
  @JsonKey(ignore: true)
  _$$_BoardGameSettingsCopyWith<_$_BoardGameSettings> get copyWith =>
      throw _privateConstructorUsedError;
}
