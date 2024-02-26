// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_game_details_visual_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BoardGameDetailsVisualState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(BoardGameDetails boardGameDetails) detailsLoaded,
    required TResult Function() loadingFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(BoardGameDetails boardGameDetails)? detailsLoaded,
    TResult? Function()? loadingFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(BoardGameDetails boardGameDetails)? detailsLoaded,
    TResult Function()? loadingFailed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_loading value) loading,
    required TResult Function(_detailsLoaded value) detailsLoaded,
    required TResult Function(_loadingFailed value) loadingFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_loading value)? loading,
    TResult? Function(_detailsLoaded value)? detailsLoaded,
    TResult? Function(_loadingFailed value)? loadingFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_loading value)? loading,
    TResult Function(_detailsLoaded value)? detailsLoaded,
    TResult Function(_loadingFailed value)? loadingFailed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardGameDetailsVisualStateCopyWith<$Res> {
  factory $BoardGameDetailsVisualStateCopyWith(
          BoardGameDetailsVisualState value,
          $Res Function(BoardGameDetailsVisualState) then) =
      _$BoardGameDetailsVisualStateCopyWithImpl<$Res,
          BoardGameDetailsVisualState>;
}

/// @nodoc
class _$BoardGameDetailsVisualStateCopyWithImpl<$Res,
        $Val extends BoardGameDetailsVisualState>
    implements $BoardGameDetailsVisualStateCopyWith<$Res> {
  _$BoardGameDetailsVisualStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$loadingImplCopyWith<$Res> {
  factory _$$loadingImplCopyWith(
          _$loadingImpl value, $Res Function(_$loadingImpl) then) =
      __$$loadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$loadingImplCopyWithImpl<$Res>
    extends _$BoardGameDetailsVisualStateCopyWithImpl<$Res, _$loadingImpl>
    implements _$$loadingImplCopyWith<$Res> {
  __$$loadingImplCopyWithImpl(
      _$loadingImpl _value, $Res Function(_$loadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$loadingImpl implements _loading {
  const _$loadingImpl();

  @override
  String toString() {
    return 'BoardGameDetailsVisualState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$loadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(BoardGameDetails boardGameDetails) detailsLoaded,
    required TResult Function() loadingFailed,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(BoardGameDetails boardGameDetails)? detailsLoaded,
    TResult? Function()? loadingFailed,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(BoardGameDetails boardGameDetails)? detailsLoaded,
    TResult Function()? loadingFailed,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_loading value) loading,
    required TResult Function(_detailsLoaded value) detailsLoaded,
    required TResult Function(_loadingFailed value) loadingFailed,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_loading value)? loading,
    TResult? Function(_detailsLoaded value)? detailsLoaded,
    TResult? Function(_loadingFailed value)? loadingFailed,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_loading value)? loading,
    TResult Function(_detailsLoaded value)? detailsLoaded,
    TResult Function(_loadingFailed value)? loadingFailed,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _loading implements BoardGameDetailsVisualState {
  const factory _loading() = _$loadingImpl;
}

/// @nodoc
abstract class _$$detailsLoadedImplCopyWith<$Res> {
  factory _$$detailsLoadedImplCopyWith(
          _$detailsLoadedImpl value, $Res Function(_$detailsLoadedImpl) then) =
      __$$detailsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BoardGameDetails boardGameDetails});

  $BoardGameDetailsCopyWith<$Res> get boardGameDetails;
}

/// @nodoc
class __$$detailsLoadedImplCopyWithImpl<$Res>
    extends _$BoardGameDetailsVisualStateCopyWithImpl<$Res, _$detailsLoadedImpl>
    implements _$$detailsLoadedImplCopyWith<$Res> {
  __$$detailsLoadedImplCopyWithImpl(
      _$detailsLoadedImpl _value, $Res Function(_$detailsLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGameDetails = null,
  }) {
    return _then(_$detailsLoadedImpl(
      boardGameDetails: null == boardGameDetails
          ? _value.boardGameDetails
          : boardGameDetails // ignore: cast_nullable_to_non_nullable
              as BoardGameDetails,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $BoardGameDetailsCopyWith<$Res> get boardGameDetails {
    return $BoardGameDetailsCopyWith<$Res>(_value.boardGameDetails, (value) {
      return _then(_value.copyWith(boardGameDetails: value));
    });
  }
}

/// @nodoc

class _$detailsLoadedImpl implements _detailsLoaded {
  const _$detailsLoadedImpl({required this.boardGameDetails});

  @override
  final BoardGameDetails boardGameDetails;

  @override
  String toString() {
    return 'BoardGameDetailsVisualState.detailsLoaded(boardGameDetails: $boardGameDetails)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$detailsLoadedImpl &&
            (identical(other.boardGameDetails, boardGameDetails) ||
                other.boardGameDetails == boardGameDetails));
  }

  @override
  int get hashCode => Object.hash(runtimeType, boardGameDetails);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$detailsLoadedImplCopyWith<_$detailsLoadedImpl> get copyWith =>
      __$$detailsLoadedImplCopyWithImpl<_$detailsLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(BoardGameDetails boardGameDetails) detailsLoaded,
    required TResult Function() loadingFailed,
  }) {
    return detailsLoaded(boardGameDetails);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(BoardGameDetails boardGameDetails)? detailsLoaded,
    TResult? Function()? loadingFailed,
  }) {
    return detailsLoaded?.call(boardGameDetails);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(BoardGameDetails boardGameDetails)? detailsLoaded,
    TResult Function()? loadingFailed,
    required TResult orElse(),
  }) {
    if (detailsLoaded != null) {
      return detailsLoaded(boardGameDetails);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_loading value) loading,
    required TResult Function(_detailsLoaded value) detailsLoaded,
    required TResult Function(_loadingFailed value) loadingFailed,
  }) {
    return detailsLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_loading value)? loading,
    TResult? Function(_detailsLoaded value)? detailsLoaded,
    TResult? Function(_loadingFailed value)? loadingFailed,
  }) {
    return detailsLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_loading value)? loading,
    TResult Function(_detailsLoaded value)? detailsLoaded,
    TResult Function(_loadingFailed value)? loadingFailed,
    required TResult orElse(),
  }) {
    if (detailsLoaded != null) {
      return detailsLoaded(this);
    }
    return orElse();
  }
}

abstract class _detailsLoaded implements BoardGameDetailsVisualState {
  const factory _detailsLoaded(
      {required final BoardGameDetails boardGameDetails}) = _$detailsLoadedImpl;

  BoardGameDetails get boardGameDetails;
  @JsonKey(ignore: true)
  _$$detailsLoadedImplCopyWith<_$detailsLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$loadingFailedImplCopyWith<$Res> {
  factory _$$loadingFailedImplCopyWith(
          _$loadingFailedImpl value, $Res Function(_$loadingFailedImpl) then) =
      __$$loadingFailedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$loadingFailedImplCopyWithImpl<$Res>
    extends _$BoardGameDetailsVisualStateCopyWithImpl<$Res, _$loadingFailedImpl>
    implements _$$loadingFailedImplCopyWith<$Res> {
  __$$loadingFailedImplCopyWithImpl(
      _$loadingFailedImpl _value, $Res Function(_$loadingFailedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$loadingFailedImpl implements _loadingFailed {
  const _$loadingFailedImpl();

  @override
  String toString() {
    return 'BoardGameDetailsVisualState.loadingFailed()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$loadingFailedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(BoardGameDetails boardGameDetails) detailsLoaded,
    required TResult Function() loadingFailed,
  }) {
    return loadingFailed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(BoardGameDetails boardGameDetails)? detailsLoaded,
    TResult? Function()? loadingFailed,
  }) {
    return loadingFailed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(BoardGameDetails boardGameDetails)? detailsLoaded,
    TResult Function()? loadingFailed,
    required TResult orElse(),
  }) {
    if (loadingFailed != null) {
      return loadingFailed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_loading value) loading,
    required TResult Function(_detailsLoaded value) detailsLoaded,
    required TResult Function(_loadingFailed value) loadingFailed,
  }) {
    return loadingFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_loading value)? loading,
    TResult? Function(_detailsLoaded value)? detailsLoaded,
    TResult? Function(_loadingFailed value)? loadingFailed,
  }) {
    return loadingFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_loading value)? loading,
    TResult Function(_detailsLoaded value)? detailsLoaded,
    TResult Function(_loadingFailed value)? loadingFailed,
    required TResult orElse(),
  }) {
    if (loadingFailed != null) {
      return loadingFailed(this);
    }
    return orElse();
  }
}

abstract class _loadingFailed implements BoardGameDetailsVisualState {
  const factory _loadingFailed() = _$loadingFailedImpl;
}
