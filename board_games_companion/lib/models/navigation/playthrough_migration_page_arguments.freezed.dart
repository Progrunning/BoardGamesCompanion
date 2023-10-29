// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playthrough_migration_page_arguments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PlaythroughMigrationArguments {
  PlaythroughMigration get playthroughMigration =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlaythroughMigrationArgumentsCopyWith<PlaythroughMigrationArguments>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaythroughMigrationArgumentsCopyWith<$Res> {
  factory $PlaythroughMigrationArgumentsCopyWith(
          PlaythroughMigrationArguments value,
          $Res Function(PlaythroughMigrationArguments) then) =
      _$PlaythroughMigrationArgumentsCopyWithImpl<$Res,
          PlaythroughMigrationArguments>;
  @useResult
  $Res call({PlaythroughMigration playthroughMigration});

  $PlaythroughMigrationCopyWith<$Res> get playthroughMigration;
}

/// @nodoc
class _$PlaythroughMigrationArgumentsCopyWithImpl<$Res,
        $Val extends PlaythroughMigrationArguments>
    implements $PlaythroughMigrationArgumentsCopyWith<$Res> {
  _$PlaythroughMigrationArgumentsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playthroughMigration = null,
  }) {
    return _then(_value.copyWith(
      playthroughMigration: null == playthroughMigration
          ? _value.playthroughMigration
          : playthroughMigration // ignore: cast_nullable_to_non_nullable
              as PlaythroughMigration,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlaythroughMigrationCopyWith<$Res> get playthroughMigration {
    return $PlaythroughMigrationCopyWith<$Res>(_value.playthroughMigration,
        (value) {
      return _then(_value.copyWith(playthroughMigration: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlaythroughMigrationArgumentsImplCopyWith<$Res>
    implements $PlaythroughMigrationArgumentsCopyWith<$Res> {
  factory _$$PlaythroughMigrationArgumentsImplCopyWith(
          _$PlaythroughMigrationArgumentsImpl value,
          $Res Function(_$PlaythroughMigrationArgumentsImpl) then) =
      __$$PlaythroughMigrationArgumentsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PlaythroughMigration playthroughMigration});

  @override
  $PlaythroughMigrationCopyWith<$Res> get playthroughMigration;
}

/// @nodoc
class __$$PlaythroughMigrationArgumentsImplCopyWithImpl<$Res>
    extends _$PlaythroughMigrationArgumentsCopyWithImpl<$Res,
        _$PlaythroughMigrationArgumentsImpl>
    implements _$$PlaythroughMigrationArgumentsImplCopyWith<$Res> {
  __$$PlaythroughMigrationArgumentsImplCopyWithImpl(
      _$PlaythroughMigrationArgumentsImpl _value,
      $Res Function(_$PlaythroughMigrationArgumentsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playthroughMigration = null,
  }) {
    return _then(_$PlaythroughMigrationArgumentsImpl(
      playthroughMigration: null == playthroughMigration
          ? _value.playthroughMigration
          : playthroughMigration // ignore: cast_nullable_to_non_nullable
              as PlaythroughMigration,
    ));
  }
}

/// @nodoc

class _$PlaythroughMigrationArgumentsImpl
    extends _PlaythroughMigrationArguments {
  const _$PlaythroughMigrationArgumentsImpl(
      {required this.playthroughMigration})
      : super._();

  @override
  final PlaythroughMigration playthroughMigration;

  @override
  String toString() {
    return 'PlaythroughMigrationArguments(playthroughMigration: $playthroughMigration)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaythroughMigrationArgumentsImpl &&
            (identical(other.playthroughMigration, playthroughMigration) ||
                other.playthroughMigration == playthroughMigration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playthroughMigration);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaythroughMigrationArgumentsImplCopyWith<
          _$PlaythroughMigrationArgumentsImpl>
      get copyWith => __$$PlaythroughMigrationArgumentsImplCopyWithImpl<
          _$PlaythroughMigrationArgumentsImpl>(this, _$identity);
}

abstract class _PlaythroughMigrationArguments
    extends PlaythroughMigrationArguments {
  const factory _PlaythroughMigrationArguments(
          {required final PlaythroughMigration playthroughMigration}) =
      _$PlaythroughMigrationArgumentsImpl;
  const _PlaythroughMigrationArguments._() : super._();

  @override
  PlaythroughMigration get playthroughMigration;
  @override
  @JsonKey(ignore: true)
  _$$PlaythroughMigrationArgumentsImplCopyWith<
          _$PlaythroughMigrationArgumentsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
