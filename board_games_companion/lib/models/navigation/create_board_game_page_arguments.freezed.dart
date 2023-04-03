// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_board_game_page_arguments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CreateBoardGamePageArguments {
  String? get boardGameName => throw _privateConstructorUsedError;
  String? get boardGameId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CreateBoardGamePageArgumentsCopyWith<CreateBoardGamePageArguments>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateBoardGamePageArgumentsCopyWith<$Res> {
  factory $CreateBoardGamePageArgumentsCopyWith(
          CreateBoardGamePageArguments value,
          $Res Function(CreateBoardGamePageArguments) then) =
      _$CreateBoardGamePageArgumentsCopyWithImpl<$Res,
          CreateBoardGamePageArguments>;
  @useResult
  $Res call({String? boardGameName, String? boardGameId});
}

/// @nodoc
class _$CreateBoardGamePageArgumentsCopyWithImpl<$Res,
        $Val extends CreateBoardGamePageArguments>
    implements $CreateBoardGamePageArgumentsCopyWith<$Res> {
  _$CreateBoardGamePageArgumentsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGameName = freezed,
    Object? boardGameId = freezed,
  }) {
    return _then(_value.copyWith(
      boardGameName: freezed == boardGameName
          ? _value.boardGameName
          : boardGameName // ignore: cast_nullable_to_non_nullable
              as String?,
      boardGameId: freezed == boardGameId
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
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
  @useResult
  $Res call({String? boardGameName, String? boardGameId});
}

/// @nodoc
class __$$_CreateBoardGamePageArgumentsCopyWithImpl<$Res>
    extends _$CreateBoardGamePageArgumentsCopyWithImpl<$Res,
        _$_CreateBoardGamePageArguments>
    implements _$$_CreateBoardGamePageArgumentsCopyWith<$Res> {
  __$$_CreateBoardGamePageArgumentsCopyWithImpl(
      _$_CreateBoardGamePageArguments _value,
      $Res Function(_$_CreateBoardGamePageArguments) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGameName = freezed,
    Object? boardGameId = freezed,
  }) {
    return _then(_$_CreateBoardGamePageArguments(
      boardGameName: freezed == boardGameName
          ? _value.boardGameName
          : boardGameName // ignore: cast_nullable_to_non_nullable
              as String?,
      boardGameId: freezed == boardGameId
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_CreateBoardGamePageArguments extends _CreateBoardGamePageArguments {
  const _$_CreateBoardGamePageArguments({this.boardGameName, this.boardGameId})
      : super._();

  @override
  final String? boardGameName;
  @override
  final String? boardGameId;

  @override
  String toString() {
    return 'CreateBoardGamePageArguments(boardGameName: $boardGameName, boardGameId: $boardGameId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CreateBoardGamePageArguments &&
            (identical(other.boardGameName, boardGameName) ||
                other.boardGameName == boardGameName) &&
            (identical(other.boardGameId, boardGameId) ||
                other.boardGameId == boardGameId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, boardGameName, boardGameId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CreateBoardGamePageArgumentsCopyWith<_$_CreateBoardGamePageArguments>
      get copyWith => __$$_CreateBoardGamePageArgumentsCopyWithImpl<
          _$_CreateBoardGamePageArguments>(this, _$identity);
}

abstract class _CreateBoardGamePageArguments
    extends CreateBoardGamePageArguments {
  const factory _CreateBoardGamePageArguments(
      {final String? boardGameName,
      final String? boardGameId}) = _$_CreateBoardGamePageArguments;
  const _CreateBoardGamePageArguments._() : super._();

  @override
  String? get boardGameName;
  @override
  String? get boardGameId;
  @override
  @JsonKey(ignore: true)
  _$$_CreateBoardGamePageArgumentsCopyWith<_$_CreateBoardGamePageArguments>
      get copyWith => throw _privateConstructorUsedError;
}
