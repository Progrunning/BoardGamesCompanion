// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_game_expansion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BoardGameExpansion {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BoardGameExpansionCopyWith<BoardGameExpansion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardGameExpansionCopyWith<$Res> {
  factory $BoardGameExpansionCopyWith(
          BoardGameExpansion value, $Res Function(BoardGameExpansion) then) =
      _$BoardGameExpansionCopyWithImpl<$Res, BoardGameExpansion>;
  @useResult
  $Res call({@HiveField(0) String id, @HiveField(1) String name});
}

/// @nodoc
class _$BoardGameExpansionCopyWithImpl<$Res, $Val extends BoardGameExpansion>
    implements $BoardGameExpansionCopyWith<$Res> {
  _$BoardGameExpansionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoardGameExpansionImplCopyWith<$Res>
    implements $BoardGameExpansionCopyWith<$Res> {
  factory _$$BoardGameExpansionImplCopyWith(_$BoardGameExpansionImpl value,
          $Res Function(_$BoardGameExpansionImpl) then) =
      __$$BoardGameExpansionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@HiveField(0) String id, @HiveField(1) String name});
}

/// @nodoc
class __$$BoardGameExpansionImplCopyWithImpl<$Res>
    extends _$BoardGameExpansionCopyWithImpl<$Res, _$BoardGameExpansionImpl>
    implements _$$BoardGameExpansionImplCopyWith<$Res> {
  __$$BoardGameExpansionImplCopyWithImpl(_$BoardGameExpansionImpl _value,
      $Res Function(_$BoardGameExpansionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$BoardGameExpansionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@HiveType(
    typeId: HiveBoxes.boardGamesExpansionId,
    adapterName: 'BoardGamesExpansionAdapter')
class _$BoardGameExpansionImpl implements _BoardGameExpansion {
  const _$BoardGameExpansionImpl(
      {@HiveField(0) required this.id, @HiveField(1) required this.name});

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;

  @override
  String toString() {
    return 'BoardGameExpansion(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardGameExpansionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardGameExpansionImplCopyWith<_$BoardGameExpansionImpl> get copyWith =>
      __$$BoardGameExpansionImplCopyWithImpl<_$BoardGameExpansionImpl>(
          this, _$identity);
}

abstract class _BoardGameExpansion implements BoardGameExpansion {
  const factory _BoardGameExpansion(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name}) = _$BoardGameExpansionImpl;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$BoardGameExpansionImplCopyWith<_$BoardGameExpansionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
