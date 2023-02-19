// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'board_game_creation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GameCreationResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String boardGameId, String boardGameName) success,
    required TResult Function() cancelled,
    required TResult Function() failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String boardGameId, String boardGameName)? success,
    TResult Function()? cancelled,
    TResult Function()? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String boardGameId, String boardGameName)? success,
    TResult Function()? cancelled,
    TResult Function()? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_success value) success,
    required TResult Function(_cancelled value) cancelled,
    required TResult Function(_failure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_success value)? success,
    TResult Function(_cancelled value)? cancelled,
    TResult Function(_failure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_success value)? success,
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
      _$GameCreationResultCopyWithImpl<$Res>;
}

/// @nodoc
class _$GameCreationResultCopyWithImpl<$Res>
    implements $GameCreationResultCopyWith<$Res> {
  _$GameCreationResultCopyWithImpl(this._value, this._then);

  final GameCreationResult _value;
  // ignore: unused_field
  final $Res Function(GameCreationResult) _then;
}

/// @nodoc
abstract class _$$_successCopyWith<$Res> {
  factory _$$_successCopyWith(
          _$_success value, $Res Function(_$_success) then) =
      __$$_successCopyWithImpl<$Res>;
  $Res call({String boardGameId, String boardGameName});
}

/// @nodoc
class __$$_successCopyWithImpl<$Res>
    extends _$GameCreationResultCopyWithImpl<$Res>
    implements _$$_successCopyWith<$Res> {
  __$$_successCopyWithImpl(_$_success _value, $Res Function(_$_success) _then)
      : super(_value, (v) => _then(v as _$_success));

  @override
  _$_success get _value => super._value as _$_success;

  @override
  $Res call({
    Object? boardGameId = freezed,
    Object? boardGameName = freezed,
  }) {
    return _then(_$_success(
      boardGameId: boardGameId == freezed
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameName: boardGameName == freezed
          ? _value.boardGameName
          : boardGameName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_success implements _success {
  const _$_success({required this.boardGameId, required this.boardGameName});

  @override
  final String boardGameId;
  @override
  final String boardGameName;

  @override
  String toString() {
    return 'GameCreationResult.success(boardGameId: $boardGameId, boardGameName: $boardGameName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_success &&
            const DeepCollectionEquality()
                .equals(other.boardGameId, boardGameId) &&
            const DeepCollectionEquality()
                .equals(other.boardGameName, boardGameName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(boardGameId),
      const DeepCollectionEquality().hash(boardGameName));

  @JsonKey(ignore: true)
  @override
  _$$_successCopyWith<_$_success> get copyWith =>
      __$$_successCopyWithImpl<_$_success>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String boardGameId, String boardGameName) success,
    required TResult Function() cancelled,
    required TResult Function() failure,
  }) {
    return success(boardGameId, boardGameName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String boardGameId, String boardGameName)? success,
    TResult Function()? cancelled,
    TResult Function()? failure,
  }) {
    return success?.call(boardGameId, boardGameName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String boardGameId, String boardGameName)? success,
    TResult Function()? cancelled,
    TResult Function()? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(boardGameId, boardGameName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_success value) success,
    required TResult Function(_cancelled value) cancelled,
    required TResult Function(_failure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_success value)? success,
    TResult Function(_cancelled value)? cancelled,
    TResult Function(_failure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_success value)? success,
    TResult Function(_cancelled value)? cancelled,
    TResult Function(_failure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _success implements GameCreationResult {
  const factory _success(
      {required final String boardGameId,
      required final String boardGameName}) = _$_success;

  String get boardGameId;
  String get boardGameName;
  @JsonKey(ignore: true)
  _$$_successCopyWith<_$_success> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_cancelledCopyWith<$Res> {
  factory _$$_cancelledCopyWith(
          _$_cancelled value, $Res Function(_$_cancelled) then) =
      __$$_cancelledCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_cancelledCopyWithImpl<$Res>
    extends _$GameCreationResultCopyWithImpl<$Res>
    implements _$$_cancelledCopyWith<$Res> {
  __$$_cancelledCopyWithImpl(
      _$_cancelled _value, $Res Function(_$_cancelled) _then)
      : super(_value, (v) => _then(v as _$_cancelled));

  @override
  _$_cancelled get _value => super._value as _$_cancelled;
}

/// @nodoc

class _$_cancelled implements _cancelled {
  const _$_cancelled();

  @override
  String toString() {
    return 'GameCreationResult.cancelled()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_cancelled);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String boardGameId, String boardGameName) success,
    required TResult Function() cancelled,
    required TResult Function() failure,
  }) {
    return cancelled();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String boardGameId, String boardGameName)? success,
    TResult Function()? cancelled,
    TResult Function()? failure,
  }) {
    return cancelled?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String boardGameId, String boardGameName)? success,
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
    required TResult Function(_success value) success,
    required TResult Function(_cancelled value) cancelled,
    required TResult Function(_failure value) failure,
  }) {
    return cancelled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_success value)? success,
    TResult Function(_cancelled value)? cancelled,
    TResult Function(_failure value)? failure,
  }) {
    return cancelled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_success value)? success,
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
  const factory _cancelled() = _$_cancelled;
}

/// @nodoc
abstract class _$$_failureCopyWith<$Res> {
  factory _$$_failureCopyWith(
          _$_failure value, $Res Function(_$_failure) then) =
      __$$_failureCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_failureCopyWithImpl<$Res>
    extends _$GameCreationResultCopyWithImpl<$Res>
    implements _$$_failureCopyWith<$Res> {
  __$$_failureCopyWithImpl(_$_failure _value, $Res Function(_$_failure) _then)
      : super(_value, (v) => _then(v as _$_failure));

  @override
  _$_failure get _value => super._value as _$_failure;
}

/// @nodoc

class _$_failure implements _failure {
  const _$_failure();

  @override
  String toString() {
    return 'GameCreationResult.failure()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_failure);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String boardGameId, String boardGameName) success,
    required TResult Function() cancelled,
    required TResult Function() failure,
  }) {
    return failure();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String boardGameId, String boardGameName)? success,
    TResult Function()? cancelled,
    TResult Function()? failure,
  }) {
    return failure?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String boardGameId, String boardGameName)? success,
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
    required TResult Function(_success value) success,
    required TResult Function(_cancelled value) cancelled,
    required TResult Function(_failure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_success value)? success,
    TResult Function(_cancelled value)? cancelled,
    TResult Function(_failure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_success value)? success,
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
  const factory _failure() = _$_failure;
}
