// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_game_details_page_arguments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BoardGameDetailsPageArguments {
  String get boardGameId => throw _privateConstructorUsedError;
  Type get navigatingFromType => throw _privateConstructorUsedError;
  String get boardGameImageHeroId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BoardGameDetailsPageArgumentsCopyWith<BoardGameDetailsPageArguments>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardGameDetailsPageArgumentsCopyWith<$Res> {
  factory $BoardGameDetailsPageArgumentsCopyWith(
          BoardGameDetailsPageArguments value,
          $Res Function(BoardGameDetailsPageArguments) then) =
      _$BoardGameDetailsPageArgumentsCopyWithImpl<$Res,
          BoardGameDetailsPageArguments>;
  @useResult
  $Res call(
      {String boardGameId,
      Type navigatingFromType,
      String boardGameImageHeroId});
}

/// @nodoc
class _$BoardGameDetailsPageArgumentsCopyWithImpl<$Res,
        $Val extends BoardGameDetailsPageArguments>
    implements $BoardGameDetailsPageArgumentsCopyWith<$Res> {
  _$BoardGameDetailsPageArgumentsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGameId = null,
    Object? navigatingFromType = null,
    Object? boardGameImageHeroId = null,
  }) {
    return _then(_value.copyWith(
      boardGameId: null == boardGameId
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      navigatingFromType: null == navigatingFromType
          ? _value.navigatingFromType
          : navigatingFromType // ignore: cast_nullable_to_non_nullable
              as Type,
      boardGameImageHeroId: null == boardGameImageHeroId
          ? _value.boardGameImageHeroId
          : boardGameImageHeroId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoardGameDetailsPageArgumentsImplCopyWith<$Res>
    implements $BoardGameDetailsPageArgumentsCopyWith<$Res> {
  factory _$$BoardGameDetailsPageArgumentsImplCopyWith(
          _$BoardGameDetailsPageArgumentsImpl value,
          $Res Function(_$BoardGameDetailsPageArgumentsImpl) then) =
      __$$BoardGameDetailsPageArgumentsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String boardGameId,
      Type navigatingFromType,
      String boardGameImageHeroId});
}

/// @nodoc
class __$$BoardGameDetailsPageArgumentsImplCopyWithImpl<$Res>
    extends _$BoardGameDetailsPageArgumentsCopyWithImpl<$Res,
        _$BoardGameDetailsPageArgumentsImpl>
    implements _$$BoardGameDetailsPageArgumentsImplCopyWith<$Res> {
  __$$BoardGameDetailsPageArgumentsImplCopyWithImpl(
      _$BoardGameDetailsPageArgumentsImpl _value,
      $Res Function(_$BoardGameDetailsPageArgumentsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGameId = null,
    Object? navigatingFromType = null,
    Object? boardGameImageHeroId = null,
  }) {
    return _then(_$BoardGameDetailsPageArgumentsImpl(
      boardGameId: null == boardGameId
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      navigatingFromType: null == navigatingFromType
          ? _value.navigatingFromType
          : navigatingFromType // ignore: cast_nullable_to_non_nullable
              as Type,
      boardGameImageHeroId: null == boardGameImageHeroId
          ? _value.boardGameImageHeroId
          : boardGameImageHeroId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$BoardGameDetailsPageArgumentsImpl
    implements _BoardGameDetailsPageArguments {
  const _$BoardGameDetailsPageArgumentsImpl(
      {required this.boardGameId,
      required this.navigatingFromType,
      required this.boardGameImageHeroId});

  @override
  final String boardGameId;
  @override
  final Type navigatingFromType;
  @override
  final String boardGameImageHeroId;

  @override
  String toString() {
    return 'BoardGameDetailsPageArguments(boardGameId: $boardGameId, navigatingFromType: $navigatingFromType, boardGameImageHeroId: $boardGameImageHeroId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardGameDetailsPageArgumentsImpl &&
            (identical(other.boardGameId, boardGameId) ||
                other.boardGameId == boardGameId) &&
            (identical(other.navigatingFromType, navigatingFromType) ||
                other.navigatingFromType == navigatingFromType) &&
            (identical(other.boardGameImageHeroId, boardGameImageHeroId) ||
                other.boardGameImageHeroId == boardGameImageHeroId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, boardGameId, navigatingFromType, boardGameImageHeroId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardGameDetailsPageArgumentsImplCopyWith<
          _$BoardGameDetailsPageArgumentsImpl>
      get copyWith => __$$BoardGameDetailsPageArgumentsImplCopyWithImpl<
          _$BoardGameDetailsPageArgumentsImpl>(this, _$identity);
}

abstract class _BoardGameDetailsPageArguments
    implements BoardGameDetailsPageArguments {
  const factory _BoardGameDetailsPageArguments(
          {required final String boardGameId,
          required final Type navigatingFromType,
          required final String boardGameImageHeroId}) =
      _$BoardGameDetailsPageArgumentsImpl;

  @override
  String get boardGameId;
  @override
  Type get navigatingFromType;
  @override
  String get boardGameImageHeroId;
  @override
  @JsonKey(ignore: true)
  _$$BoardGameDetailsPageArgumentsImplCopyWith<
          _$BoardGameDetailsPageArgumentsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
