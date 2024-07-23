// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_game_creation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GameCreationResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String boardGameId, String boardGameName)
        saveSuccess,
    required TResult Function(String boardGameName)
        removingFromCollectionsSucceeded,
    required TResult Function() cancelled,
    required TResult Function() failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String boardGameId, String boardGameName)? saveSuccess,
    TResult? Function(String boardGameName)? removingFromCollectionsSucceeded,
    TResult? Function()? cancelled,
    TResult? Function()? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String boardGameId, String boardGameName)? saveSuccess,
    TResult Function(String boardGameName)? removingFromCollectionsSucceeded,
    TResult Function()? cancelled,
    TResult Function()? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_saveSuccess value) saveSuccess,
    required TResult Function(_removingFromCollectionsSucceeded value)
        removingFromCollectionsSucceeded,
    required TResult Function(_cancelled value) cancelled,
    required TResult Function(_failure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_saveSuccess value)? saveSuccess,
    TResult? Function(_removingFromCollectionsSucceeded value)?
        removingFromCollectionsSucceeded,
    TResult? Function(_cancelled value)? cancelled,
    TResult? Function(_failure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_saveSuccess value)? saveSuccess,
    TResult Function(_removingFromCollectionsSucceeded value)?
        removingFromCollectionsSucceeded,
    TResult Function(_cancelled value)? cancelled,
    TResult Function(_failure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameCreationResultCopyWith<$Res> {
  factory $GameCreationResultCopyWith(
          GameCreationResult value, $Res Function(GameCreationResult) then) =
      _$GameCreationResultCopyWithImpl<$Res, GameCreationResult>;
}

/// @nodoc
class _$GameCreationResultCopyWithImpl<$Res, $Val extends GameCreationResult>
    implements $GameCreationResultCopyWith<$Res> {
  _$GameCreationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$saveSuccessImplCopyWith<$Res> {
  factory _$$saveSuccessImplCopyWith(
          _$saveSuccessImpl value, $Res Function(_$saveSuccessImpl) then) =
      __$$saveSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String boardGameId, String boardGameName});
}

/// @nodoc
class __$$saveSuccessImplCopyWithImpl<$Res>
    extends _$GameCreationResultCopyWithImpl<$Res, _$saveSuccessImpl>
    implements _$$saveSuccessImplCopyWith<$Res> {
  __$$saveSuccessImplCopyWithImpl(
      _$saveSuccessImpl _value, $Res Function(_$saveSuccessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGameId = null,
    Object? boardGameName = null,
  }) {
    return _then(_$saveSuccessImpl(
      boardGameId: null == boardGameId
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameName: null == boardGameName
          ? _value.boardGameName
          : boardGameName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$saveSuccessImpl implements _saveSuccess {
  const _$saveSuccessImpl(
      {required this.boardGameId, required this.boardGameName});

  @override
  final String boardGameId;
  @override
  final String boardGameName;

  @override
  String toString() {
    return 'GameCreationResult.saveSuccess(boardGameId: $boardGameId, boardGameName: $boardGameName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$saveSuccessImpl &&
            (identical(other.boardGameId, boardGameId) ||
                other.boardGameId == boardGameId) &&
            (identical(other.boardGameName, boardGameName) ||
                other.boardGameName == boardGameName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, boardGameId, boardGameName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$saveSuccessImplCopyWith<_$saveSuccessImpl> get copyWith =>
      __$$saveSuccessImplCopyWithImpl<_$saveSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String boardGameId, String boardGameName)
        saveSuccess,
    required TResult Function(String boardGameName)
        removingFromCollectionsSucceeded,
    required TResult Function() cancelled,
    required TResult Function() failure,
  }) {
    return saveSuccess(boardGameId, boardGameName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String boardGameId, String boardGameName)? saveSuccess,
    TResult? Function(String boardGameName)? removingFromCollectionsSucceeded,
    TResult? Function()? cancelled,
    TResult? Function()? failure,
  }) {
    return saveSuccess?.call(boardGameId, boardGameName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String boardGameId, String boardGameName)? saveSuccess,
    TResult Function(String boardGameName)? removingFromCollectionsSucceeded,
    TResult Function()? cancelled,
    TResult Function()? failure,
    required TResult orElse(),
  }) {
    if (saveSuccess != null) {
      return saveSuccess(boardGameId, boardGameName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_saveSuccess value) saveSuccess,
    required TResult Function(_removingFromCollectionsSucceeded value)
        removingFromCollectionsSucceeded,
    required TResult Function(_cancelled value) cancelled,
    required TResult Function(_failure value) failure,
  }) {
    return saveSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_saveSuccess value)? saveSuccess,
    TResult? Function(_removingFromCollectionsSucceeded value)?
        removingFromCollectionsSucceeded,
    TResult? Function(_cancelled value)? cancelled,
    TResult? Function(_failure value)? failure,
  }) {
    return saveSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_saveSuccess value)? saveSuccess,
    TResult Function(_removingFromCollectionsSucceeded value)?
        removingFromCollectionsSucceeded,
    TResult Function(_cancelled value)? cancelled,
    TResult Function(_failure value)? failure,
    required TResult orElse(),
  }) {
    if (saveSuccess != null) {
      return saveSuccess(this);
    }
    return orElse();
  }
}

abstract class _saveSuccess implements GameCreationResult {
  const factory _saveSuccess(
      {required final String boardGameId,
      required final String boardGameName}) = _$saveSuccessImpl;

  String get boardGameId;
  String get boardGameName;
  @JsonKey(ignore: true)
  _$$saveSuccessImplCopyWith<_$saveSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$removingFromCollectionsSucceededImplCopyWith<$Res> {
  factory _$$removingFromCollectionsSucceededImplCopyWith(
          _$removingFromCollectionsSucceededImpl value,
          $Res Function(_$removingFromCollectionsSucceededImpl) then) =
      __$$removingFromCollectionsSucceededImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String boardGameName});
}

/// @nodoc
class __$$removingFromCollectionsSucceededImplCopyWithImpl<$Res>
    extends _$GameCreationResultCopyWithImpl<$Res,
        _$removingFromCollectionsSucceededImpl>
    implements _$$removingFromCollectionsSucceededImplCopyWith<$Res> {
  __$$removingFromCollectionsSucceededImplCopyWithImpl(
      _$removingFromCollectionsSucceededImpl _value,
      $Res Function(_$removingFromCollectionsSucceededImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGameName = null,
  }) {
    return _then(_$removingFromCollectionsSucceededImpl(
      boardGameName: null == boardGameName
          ? _value.boardGameName
          : boardGameName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$removingFromCollectionsSucceededImpl
    implements _removingFromCollectionsSucceeded {
  const _$removingFromCollectionsSucceededImpl({required this.boardGameName});

  @override
  final String boardGameName;

  @override
  String toString() {
    return 'GameCreationResult.removingFromCollectionsSucceeded(boardGameName: $boardGameName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$removingFromCollectionsSucceededImpl &&
            (identical(other.boardGameName, boardGameName) ||
                other.boardGameName == boardGameName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, boardGameName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$removingFromCollectionsSucceededImplCopyWith<
          _$removingFromCollectionsSucceededImpl>
      get copyWith => __$$removingFromCollectionsSucceededImplCopyWithImpl<
          _$removingFromCollectionsSucceededImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String boardGameId, String boardGameName)
        saveSuccess,
    required TResult Function(String boardGameName)
        removingFromCollectionsSucceeded,
    required TResult Function() cancelled,
    required TResult Function() failure,
  }) {
    return removingFromCollectionsSucceeded(boardGameName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String boardGameId, String boardGameName)? saveSuccess,
    TResult? Function(String boardGameName)? removingFromCollectionsSucceeded,
    TResult? Function()? cancelled,
    TResult? Function()? failure,
  }) {
    return removingFromCollectionsSucceeded?.call(boardGameName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String boardGameId, String boardGameName)? saveSuccess,
    TResult Function(String boardGameName)? removingFromCollectionsSucceeded,
    TResult Function()? cancelled,
    TResult Function()? failure,
    required TResult orElse(),
  }) {
    if (removingFromCollectionsSucceeded != null) {
      return removingFromCollectionsSucceeded(boardGameName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_saveSuccess value) saveSuccess,
    required TResult Function(_removingFromCollectionsSucceeded value)
        removingFromCollectionsSucceeded,
    required TResult Function(_cancelled value) cancelled,
    required TResult Function(_failure value) failure,
  }) {
    return removingFromCollectionsSucceeded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_saveSuccess value)? saveSuccess,
    TResult? Function(_removingFromCollectionsSucceeded value)?
        removingFromCollectionsSucceeded,
    TResult? Function(_cancelled value)? cancelled,
    TResult? Function(_failure value)? failure,
  }) {
    return removingFromCollectionsSucceeded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_saveSuccess value)? saveSuccess,
    TResult Function(_removingFromCollectionsSucceeded value)?
        removingFromCollectionsSucceeded,
    TResult Function(_cancelled value)? cancelled,
    TResult Function(_failure value)? failure,
    required TResult orElse(),
  }) {
    if (removingFromCollectionsSucceeded != null) {
      return removingFromCollectionsSucceeded(this);
    }
    return orElse();
  }
}

abstract class _removingFromCollectionsSucceeded implements GameCreationResult {
  const factory _removingFromCollectionsSucceeded(
          {required final String boardGameName}) =
      _$removingFromCollectionsSucceededImpl;

  String get boardGameName;
  @JsonKey(ignore: true)
  _$$removingFromCollectionsSucceededImplCopyWith<
          _$removingFromCollectionsSucceededImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$cancelledImplCopyWith<$Res> {
  factory _$$cancelledImplCopyWith(
          _$cancelledImpl value, $Res Function(_$cancelledImpl) then) =
      __$$cancelledImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$cancelledImplCopyWithImpl<$Res>
    extends _$GameCreationResultCopyWithImpl<$Res, _$cancelledImpl>
    implements _$$cancelledImplCopyWith<$Res> {
  __$$cancelledImplCopyWithImpl(
      _$cancelledImpl _value, $Res Function(_$cancelledImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$cancelledImpl implements _cancelled {
  const _$cancelledImpl();

  @override
  String toString() {
    return 'GameCreationResult.cancelled()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$cancelledImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String boardGameId, String boardGameName)
        saveSuccess,
    required TResult Function(String boardGameName)
        removingFromCollectionsSucceeded,
    required TResult Function() cancelled,
    required TResult Function() failure,
  }) {
    return cancelled();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String boardGameId, String boardGameName)? saveSuccess,
    TResult? Function(String boardGameName)? removingFromCollectionsSucceeded,
    TResult? Function()? cancelled,
    TResult? Function()? failure,
  }) {
    return cancelled?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String boardGameId, String boardGameName)? saveSuccess,
    TResult Function(String boardGameName)? removingFromCollectionsSucceeded,
    TResult Function()? cancelled,
    TResult Function()? failure,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_saveSuccess value) saveSuccess,
    required TResult Function(_removingFromCollectionsSucceeded value)
        removingFromCollectionsSucceeded,
    required TResult Function(_cancelled value) cancelled,
    required TResult Function(_failure value) failure,
  }) {
    return cancelled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_saveSuccess value)? saveSuccess,
    TResult? Function(_removingFromCollectionsSucceeded value)?
        removingFromCollectionsSucceeded,
    TResult? Function(_cancelled value)? cancelled,
    TResult? Function(_failure value)? failure,
  }) {
    return cancelled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_saveSuccess value)? saveSuccess,
    TResult Function(_removingFromCollectionsSucceeded value)?
        removingFromCollectionsSucceeded,
    TResult Function(_cancelled value)? cancelled,
    TResult Function(_failure value)? failure,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled(this);
    }
    return orElse();
  }
}

abstract class _cancelled implements GameCreationResult {
  const factory _cancelled() = _$cancelledImpl;
}

/// @nodoc
abstract class _$$failureImplCopyWith<$Res> {
  factory _$$failureImplCopyWith(
          _$failureImpl value, $Res Function(_$failureImpl) then) =
      __$$failureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$failureImplCopyWithImpl<$Res>
    extends _$GameCreationResultCopyWithImpl<$Res, _$failureImpl>
    implements _$$failureImplCopyWith<$Res> {
  __$$failureImplCopyWithImpl(
      _$failureImpl _value, $Res Function(_$failureImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$failureImpl implements _failure {
  const _$failureImpl();

  @override
  String toString() {
    return 'GameCreationResult.failure()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$failureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String boardGameId, String boardGameName)
        saveSuccess,
    required TResult Function(String boardGameName)
        removingFromCollectionsSucceeded,
    required TResult Function() cancelled,
    required TResult Function() failure,
  }) {
    return failure();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String boardGameId, String boardGameName)? saveSuccess,
    TResult? Function(String boardGameName)? removingFromCollectionsSucceeded,
    TResult? Function()? cancelled,
    TResult? Function()? failure,
  }) {
    return failure?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String boardGameId, String boardGameName)? saveSuccess,
    TResult Function(String boardGameName)? removingFromCollectionsSucceeded,
    TResult Function()? cancelled,
    TResult Function()? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_saveSuccess value) saveSuccess,
    required TResult Function(_removingFromCollectionsSucceeded value)
        removingFromCollectionsSucceeded,
    required TResult Function(_cancelled value) cancelled,
    required TResult Function(_failure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_saveSuccess value)? saveSuccess,
    TResult? Function(_removingFromCollectionsSucceeded value)?
        removingFromCollectionsSucceeded,
    TResult? Function(_cancelled value)? cancelled,
    TResult? Function(_failure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_saveSuccess value)? saveSuccess,
    TResult Function(_removingFromCollectionsSucceeded value)?
        removingFromCollectionsSucceeded,
    TResult Function(_cancelled value)? cancelled,
    TResult Function(_failure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class _failure implements GameCreationResult {
  const factory _failure() = _$failureImpl;
}
