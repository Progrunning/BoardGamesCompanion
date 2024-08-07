// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bgg_search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BggSearchResult {
  String get boardGameName => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String boardGameName) createGame,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String boardGameName)? createGame,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String boardGameName)? createGame,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_createGame value) createGame,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_createGame value)? createGame,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_createGame value)? createGame,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BggSearchResultCopyWith<BggSearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BggSearchResultCopyWith<$Res> {
  factory $BggSearchResultCopyWith(
          BggSearchResult value, $Res Function(BggSearchResult) then) =
      _$BggSearchResultCopyWithImpl<$Res, BggSearchResult>;
  @useResult
  $Res call({String boardGameName});
}

/// @nodoc
class _$BggSearchResultCopyWithImpl<$Res, $Val extends BggSearchResult>
    implements $BggSearchResultCopyWith<$Res> {
  _$BggSearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGameName = null,
  }) {
    return _then(_value.copyWith(
      boardGameName: null == boardGameName
          ? _value.boardGameName
          : boardGameName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$createGameImplCopyWith<$Res>
    implements $BggSearchResultCopyWith<$Res> {
  factory _$$createGameImplCopyWith(
          _$createGameImpl value, $Res Function(_$createGameImpl) then) =
      __$$createGameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String boardGameName});
}

/// @nodoc
class __$$createGameImplCopyWithImpl<$Res>
    extends _$BggSearchResultCopyWithImpl<$Res, _$createGameImpl>
    implements _$$createGameImplCopyWith<$Res> {
  __$$createGameImplCopyWithImpl(
      _$createGameImpl _value, $Res Function(_$createGameImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGameName = null,
  }) {
    return _then(_$createGameImpl(
      boardGameName: null == boardGameName
          ? _value.boardGameName
          : boardGameName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$createGameImpl implements _createGame {
  const _$createGameImpl({required this.boardGameName});

  @override
  final String boardGameName;

  @override
  String toString() {
    return 'BggSearchResult.createGame(boardGameName: $boardGameName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$createGameImpl &&
            (identical(other.boardGameName, boardGameName) ||
                other.boardGameName == boardGameName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, boardGameName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$createGameImplCopyWith<_$createGameImpl> get copyWith =>
      __$$createGameImplCopyWithImpl<_$createGameImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String boardGameName) createGame,
  }) {
    return createGame(boardGameName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String boardGameName)? createGame,
  }) {
    return createGame?.call(boardGameName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String boardGameName)? createGame,
    required TResult orElse(),
  }) {
    if (createGame != null) {
      return createGame(boardGameName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_createGame value) createGame,
  }) {
    return createGame(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_createGame value)? createGame,
  }) {
    return createGame?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_createGame value)? createGame,
    required TResult orElse(),
  }) {
    if (createGame != null) {
      return createGame(this);
    }
    return orElse();
  }
}

abstract class _createGame implements BggSearchResult {
  const factory _createGame({required final String boardGameName}) =
      _$createGameImpl;

  @override
  String get boardGameName;
  @override
  @JsonKey(ignore: true)
  _$$createGameImplCopyWith<_$createGameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
