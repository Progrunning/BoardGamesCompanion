// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'create_board_game_page_arguments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CreateBoardGamePageArguments {
  String get boardGameName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CreateBoardGamePageArgumentsCopyWith<CreateBoardGamePageArguments>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateBoardGamePageArgumentsCopyWith<$Res> {
  factory $CreateBoardGamePageArgumentsCopyWith(
          CreateBoardGamePageArguments value,
          $Res Function(CreateBoardGamePageArguments) then) =
      _$CreateBoardGamePageArgumentsCopyWithImpl<$Res>;
  $Res call({String boardGameName});
}

/// @nodoc
class _$CreateBoardGamePageArgumentsCopyWithImpl<$Res>
    implements $CreateBoardGamePageArgumentsCopyWith<$Res> {
  _$CreateBoardGamePageArgumentsCopyWithImpl(this._value, this._then);

  final CreateBoardGamePageArguments _value;
  // ignore: unused_field
  final $Res Function(CreateBoardGamePageArguments) _then;

  @override
  $Res call({
    Object? boardGameName = freezed,
  }) {
    return _then(_value.copyWith(
      boardGameName: boardGameName == freezed
          ? _value.boardGameName
          : boardGameName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_CreateBoardGamePageArgumentsCopyWith<$Res>
    implements $CreateBoardGamePageArgumentsCopyWith<$Res> {
  factory _$$_CreateBoardGamePageArgumentsCopyWith(
          _$_CreateBoardGamePageArguments value,
          $Res Function(_$_CreateBoardGamePageArguments) then) =
      __$$_CreateBoardGamePageArgumentsCopyWithImpl<$Res>;
  @override
  $Res call({String boardGameName});
}

/// @nodoc
class __$$_CreateBoardGamePageArgumentsCopyWithImpl<$Res>
    extends _$CreateBoardGamePageArgumentsCopyWithImpl<$Res>
    implements _$$_CreateBoardGamePageArgumentsCopyWith<$Res> {
  __$$_CreateBoardGamePageArgumentsCopyWithImpl(
      _$_CreateBoardGamePageArguments _value,
      $Res Function(_$_CreateBoardGamePageArguments) _then)
      : super(_value, (v) => _then(v as _$_CreateBoardGamePageArguments));

  @override
  _$_CreateBoardGamePageArguments get _value =>
      super._value as _$_CreateBoardGamePageArguments;

  @override
  $Res call({
    Object? boardGameName = freezed,
  }) {
    return _then(_$_CreateBoardGamePageArguments(
      boardGameName: boardGameName == freezed
          ? _value.boardGameName
          : boardGameName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_CreateBoardGamePageArguments extends _CreateBoardGamePageArguments {
  const _$_CreateBoardGamePageArguments({required this.boardGameName})
      : super._();

  @override
  final String boardGameName;

  @override
  String toString() {
    return 'CreateBoardGamePageArguments(boardGameName: $boardGameName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CreateBoardGamePageArguments &&
            const DeepCollectionEquality()
                .equals(other.boardGameName, boardGameName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(boardGameName));

  @JsonKey(ignore: true)
  @override
  _$$_CreateBoardGamePageArgumentsCopyWith<_$_CreateBoardGamePageArguments>
      get copyWith => __$$_CreateBoardGamePageArgumentsCopyWithImpl<
          _$_CreateBoardGamePageArguments>(this, _$identity);
}

abstract class _CreateBoardGamePageArguments
    extends CreateBoardGamePageArguments {
  const factory _CreateBoardGamePageArguments(
      {required final String boardGameName}) = _$_CreateBoardGamePageArguments;
  const _CreateBoardGamePageArguments._() : super._();

  @override
  String get boardGameName;
  @override
  @JsonKey(ignore: true)
  _$$_CreateBoardGamePageArgumentsCopyWith<_$_CreateBoardGamePageArguments>
      get copyWith => throw _privateConstructorUsedError;
}
