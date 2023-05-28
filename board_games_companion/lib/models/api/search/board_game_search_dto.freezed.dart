// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_game_search_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BoardGameSearchDto _$BoardGameSearchDtoFromJson(Map<String, dynamic> json) {
  return _BoardGameSearchDto.fromJson(json);
}

/// @nodoc
mixin _$BoardGameSearchDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BoardGameSearchDtoCopyWith<BoardGameSearchDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardGameSearchDtoCopyWith<$Res> {
  factory $BoardGameSearchDtoCopyWith(
          BoardGameSearchDto value, $Res Function(BoardGameSearchDto) then) =
      _$BoardGameSearchDtoCopyWithImpl<$Res, BoardGameSearchDto>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$BoardGameSearchDtoCopyWithImpl<$Res, $Val extends BoardGameSearchDto>
    implements $BoardGameSearchDtoCopyWith<$Res> {
  _$BoardGameSearchDtoCopyWithImpl(this._value, this._then);

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
abstract class _$$_BoardGameSearchDtoCopyWith<$Res>
    implements $BoardGameSearchDtoCopyWith<$Res> {
  factory _$$_BoardGameSearchDtoCopyWith(_$_BoardGameSearchDto value,
          $Res Function(_$_BoardGameSearchDto) then) =
      __$$_BoardGameSearchDtoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$_BoardGameSearchDtoCopyWithImpl<$Res>
    extends _$BoardGameSearchDtoCopyWithImpl<$Res, _$_BoardGameSearchDto>
    implements _$$_BoardGameSearchDtoCopyWith<$Res> {
  __$$_BoardGameSearchDtoCopyWithImpl(
      _$_BoardGameSearchDto _value, $Res Function(_$_BoardGameSearchDto) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$_BoardGameSearchDto(
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
@JsonSerializable()
class _$_BoardGameSearchDto extends _BoardGameSearchDto {
  const _$_BoardGameSearchDto({required this.id, required this.name})
      : super._();

  factory _$_BoardGameSearchDto.fromJson(Map<String, dynamic> json) =>
      _$$_BoardGameSearchDtoFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'BoardGameSearchDto(id: $id, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BoardGameSearchDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BoardGameSearchDtoCopyWith<_$_BoardGameSearchDto> get copyWith =>
      __$$_BoardGameSearchDtoCopyWithImpl<_$_BoardGameSearchDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BoardGameSearchDtoToJson(
      this,
    );
  }
}

abstract class _BoardGameSearchDto extends BoardGameSearchDto {
  const factory _BoardGameSearchDto(
      {required final String id,
      required final String name}) = _$_BoardGameSearchDto;
  const _BoardGameSearchDto._() : super._();

  factory _BoardGameSearchDto.fromJson(Map<String, dynamic> json) =
      _$_BoardGameSearchDto.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$_BoardGameSearchDtoCopyWith<_$_BoardGameSearchDto> get copyWith =>
      throw _privateConstructorUsedError;
}
