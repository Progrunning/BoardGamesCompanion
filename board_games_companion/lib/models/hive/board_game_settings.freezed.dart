// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

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
      _$BoardGameSettingsCopyWithImpl<$Res>;
  $Res call(
      {@HiveField(1)
          GameFamily gameFamily,
      @HiveField(2, defaultValue: 0)
          int averageScorePrecision,
      @HiveField(3, defaultValue: GameClassification.Score)
          GameClassification gameClassification});
}

/// @nodoc
class _$BoardGameSettingsCopyWithImpl<$Res>
    implements $BoardGameSettingsCopyWith<$Res> {
  _$BoardGameSettingsCopyWithImpl(this._value, this._then);

  final BoardGameSettings _value;
  // ignore: unused_field
  final $Res Function(BoardGameSettings) _then;

  @override
  $Res call({
    Object? gameFamily = freezed,
    Object? averageScorePrecision = freezed,
    Object? gameClassification = freezed,
  }) {
    return _then(_value.copyWith(
      gameFamily: gameFamily == freezed
          ? _value.gameFamily
          : gameFamily // ignore: cast_nullable_to_non_nullable
              as GameFamily,
      averageScorePrecision: averageScorePrecision == freezed
          ? _value.averageScorePrecision
          : averageScorePrecision // ignore: cast_nullable_to_non_nullable
              as int,
      gameClassification: gameClassification == freezed
          ? _value.gameClassification
          : gameClassification // ignore: cast_nullable_to_non_nullable
              as GameClassification,
    ));
  }
}

/// @nodoc
abstract class _$$_BoardGameSettingsCopyWith<$Res>
    implements $BoardGameSettingsCopyWith<$Res> {
  factory _$$_BoardGameSettingsCopyWith(_$_BoardGameSettings value,
          $Res Function(_$_BoardGameSettings) then) =
      __$$_BoardGameSettingsCopyWithImpl<$Res>;
  @override
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
    extends _$BoardGameSettingsCopyWithImpl<$Res>
    implements _$$_BoardGameSettingsCopyWith<$Res> {
  __$$_BoardGameSettingsCopyWithImpl(
      _$_BoardGameSettings _value, $Res Function(_$_BoardGameSettings) _then)
      : super(_value, (v) => _then(v as _$_BoardGameSettings));

  @override
  _$_BoardGameSettings get _value => super._value as _$_BoardGameSettings;

  @override
  $Res call({
    Object? gameFamily = freezed,
    Object? averageScorePrecision = freezed,
    Object? gameClassification = freezed,
  }) {
    return _then(_$_BoardGameSettings(
      gameFamily: gameFamily == freezed
          ? _value.gameFamily
          : gameFamily // ignore: cast_nullable_to_non_nullable
              as GameFamily,
      averageScorePrecision: averageScorePrecision == freezed
          ? _value.averageScorePrecision
          : averageScorePrecision // ignore: cast_nullable_to_non_nullable
              as int,
      gameClassification: gameClassification == freezed
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
            const DeepCollectionEquality()
                .equals(other.gameFamily, gameFamily) &&
            const DeepCollectionEquality()
                .equals(other.averageScorePrecision, averageScorePrecision) &&
            const DeepCollectionEquality()
                .equals(other.gameClassification, gameClassification));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(gameFamily),
      const DeepCollectionEquality().hash(averageScorePrecision),
      const DeepCollectionEquality().hash(gameClassification));

  @JsonKey(ignore: true)
  @override
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
