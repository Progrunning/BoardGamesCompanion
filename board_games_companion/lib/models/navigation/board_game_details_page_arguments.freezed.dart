// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

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
      _$BoardGameDetailsPageArgumentsCopyWithImpl<$Res>;
  $Res call(
      {String boardGameId,
      Type navigatingFromType,
      String boardGameImageHeroId});
}

/// @nodoc
class _$BoardGameDetailsPageArgumentsCopyWithImpl<$Res>
    implements $BoardGameDetailsPageArgumentsCopyWith<$Res> {
  _$BoardGameDetailsPageArgumentsCopyWithImpl(this._value, this._then);

  final BoardGameDetailsPageArguments _value;
  // ignore: unused_field
  final $Res Function(BoardGameDetailsPageArguments) _then;

  @override
  $Res call({
    Object? boardGameId = freezed,
    Object? navigatingFromType = freezed,
    Object? boardGameImageHeroId = freezed,
  }) {
    return _then(_value.copyWith(
      boardGameId: boardGameId == freezed
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      navigatingFromType: navigatingFromType == freezed
          ? _value.navigatingFromType
          : navigatingFromType // ignore: cast_nullable_to_non_nullable
              as Type,
      boardGameImageHeroId: boardGameImageHeroId == freezed
          ? _value.boardGameImageHeroId
          : boardGameImageHeroId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_BoardGameDetailsPageArgumentsCopyWith<$Res>
    implements $BoardGameDetailsPageArgumentsCopyWith<$Res> {
  factory _$$_BoardGameDetailsPageArgumentsCopyWith(
          _$_BoardGameDetailsPageArguments value,
          $Res Function(_$_BoardGameDetailsPageArguments) then) =
      __$$_BoardGameDetailsPageArgumentsCopyWithImpl<$Res>;
  @override
  $Res call(
      {String boardGameId,
      Type navigatingFromType,
      String boardGameImageHeroId});
}

/// @nodoc
class __$$_BoardGameDetailsPageArgumentsCopyWithImpl<$Res>
    extends _$BoardGameDetailsPageArgumentsCopyWithImpl<$Res>
    implements _$$_BoardGameDetailsPageArgumentsCopyWith<$Res> {
  __$$_BoardGameDetailsPageArgumentsCopyWithImpl(
      _$_BoardGameDetailsPageArguments _value,
      $Res Function(_$_BoardGameDetailsPageArguments) _then)
      : super(_value, (v) => _then(v as _$_BoardGameDetailsPageArguments));

  @override
  _$_BoardGameDetailsPageArguments get _value =>
      super._value as _$_BoardGameDetailsPageArguments;

  @override
  $Res call({
    Object? boardGameId = freezed,
    Object? navigatingFromType = freezed,
    Object? boardGameImageHeroId = freezed,
  }) {
    return _then(_$_BoardGameDetailsPageArguments(
      boardGameId: boardGameId == freezed
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      navigatingFromType: navigatingFromType == freezed
          ? _value.navigatingFromType
          : navigatingFromType // ignore: cast_nullable_to_non_nullable
              as Type,
      boardGameImageHeroId: boardGameImageHeroId == freezed
          ? _value.boardGameImageHeroId
          : boardGameImageHeroId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_BoardGameDetailsPageArguments
    implements _BoardGameDetailsPageArguments {
  const _$_BoardGameDetailsPageArguments(
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
            other is _$_BoardGameDetailsPageArguments &&
            const DeepCollectionEquality()
                .equals(other.boardGameId, boardGameId) &&
            const DeepCollectionEquality()
                .equals(other.navigatingFromType, navigatingFromType) &&
            const DeepCollectionEquality()
                .equals(other.boardGameImageHeroId, boardGameImageHeroId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(boardGameId),
      const DeepCollectionEquality().hash(navigatingFromType),
      const DeepCollectionEquality().hash(boardGameImageHeroId));

  @JsonKey(ignore: true)
  @override
  _$$_BoardGameDetailsPageArgumentsCopyWith<_$_BoardGameDetailsPageArguments>
      get copyWith => __$$_BoardGameDetailsPageArgumentsCopyWithImpl<
          _$_BoardGameDetailsPageArguments>(this, _$identity);
}

abstract class _BoardGameDetailsPageArguments
    implements BoardGameDetailsPageArguments {
  const factory _BoardGameDetailsPageArguments(
          {required final String boardGameId,
          required final Type navigatingFromType,
          required final String boardGameImageHeroId}) =
      _$_BoardGameDetailsPageArguments;

  @override
  String get boardGameId;
  @override
  Type get navigatingFromType;
  @override
  String get boardGameImageHeroId;
  @override
  @JsonKey(ignore: true)
  _$$_BoardGameDetailsPageArgumentsCopyWith<_$_BoardGameDetailsPageArguments>
      get copyWith => throw _privateConstructorUsedError;
}
