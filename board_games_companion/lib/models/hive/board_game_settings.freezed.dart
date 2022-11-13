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
  GameWinningCondition get winningCondition =>
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
  $Res call({@HiveField(1) GameWinningCondition winningCondition});
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
    Object? winningCondition = freezed,
  }) {
    return _then(_value.copyWith(
      winningCondition: winningCondition == freezed
          ? _value.winningCondition
          : winningCondition // ignore: cast_nullable_to_non_nullable
              as GameWinningCondition,
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
  $Res call({@HiveField(1) GameWinningCondition winningCondition});
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
    Object? winningCondition = freezed,
  }) {
    return _then(_$_BoardGameSettings(
      winningCondition: winningCondition == freezed
          ? _value.winningCondition
          : winningCondition // ignore: cast_nullable_to_non_nullable
              as GameWinningCondition,
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
          this.winningCondition = GameWinningCondition.HighestScore});

  @override
  @JsonKey()
  @HiveField(1)
  final GameWinningCondition winningCondition;

  @override
  String toString() {
    return 'BoardGameSettings(winningCondition: $winningCondition)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BoardGameSettings &&
            const DeepCollectionEquality()
                .equals(other.winningCondition, winningCondition));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(winningCondition));

  @JsonKey(ignore: true)
  @override
  _$$_BoardGameSettingsCopyWith<_$_BoardGameSettings> get copyWith =>
      __$$_BoardGameSettingsCopyWithImpl<_$_BoardGameSettings>(
          this, _$identity);
}

abstract class _BoardGameSettings implements BoardGameSettings {
  const factory _BoardGameSettings(
          {@HiveField(1) final GameWinningCondition winningCondition}) =
      _$_BoardGameSettings;

  @override
  @HiveField(1)
  GameWinningCondition get winningCondition;
  @override
  @JsonKey(ignore: true)
  _$$_BoardGameSettingsCopyWith<_$_BoardGameSettings> get copyWith =>
      throw _privateConstructorUsedError;
}
