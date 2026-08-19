// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_statistics_visual_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlayerStatisticsVisualState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function() empty,
    required TResult Function(PlayerOverallStatistics statistics) loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function()? empty,
    TResult? Function(PlayerOverallStatistics statistics)? loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function()? empty,
    TResult Function(PlayerOverallStatistics statistics)? loaded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerStatisticsLoading value) loading,
    required TResult Function(PlayerStatisticsEmpty value) empty,
    required TResult Function(PlayerStatisticsLoaded value) loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerStatisticsLoading value)? loading,
    TResult? Function(PlayerStatisticsEmpty value)? empty,
    TResult? Function(PlayerStatisticsLoaded value)? loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerStatisticsLoading value)? loading,
    TResult Function(PlayerStatisticsEmpty value)? empty,
    TResult Function(PlayerStatisticsLoaded value)? loaded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerStatisticsVisualStateCopyWith<$Res> {
  factory $PlayerStatisticsVisualStateCopyWith(
          PlayerStatisticsVisualState value,
          $Res Function(PlayerStatisticsVisualState) then) =
      _$PlayerStatisticsVisualStateCopyWithImpl<$Res,
          PlayerStatisticsVisualState>;
}

/// @nodoc
class _$PlayerStatisticsVisualStateCopyWithImpl<$Res,
        $Val extends PlayerStatisticsVisualState>
    implements $PlayerStatisticsVisualStateCopyWith<$Res> {
  _$PlayerStatisticsVisualStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$PlayerStatisticsLoadingImplCopyWith<$Res> {
  factory _$$PlayerStatisticsLoadingImplCopyWith(
          _$PlayerStatisticsLoadingImpl value,
          $Res Function(_$PlayerStatisticsLoadingImpl) then) =
      __$$PlayerStatisticsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PlayerStatisticsLoadingImplCopyWithImpl<$Res>
    extends _$PlayerStatisticsVisualStateCopyWithImpl<$Res,
        _$PlayerStatisticsLoadingImpl>
    implements _$$PlayerStatisticsLoadingImplCopyWith<$Res> {
  __$$PlayerStatisticsLoadingImplCopyWithImpl(
      _$PlayerStatisticsLoadingImpl _value,
      $Res Function(_$PlayerStatisticsLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$PlayerStatisticsLoadingImpl implements PlayerStatisticsLoading {
  const _$PlayerStatisticsLoadingImpl();

  @override
  String toString() {
    return 'PlayerStatisticsVisualState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerStatisticsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function() empty,
    required TResult Function(PlayerOverallStatistics statistics) loaded,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function()? empty,
    TResult? Function(PlayerOverallStatistics statistics)? loaded,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function()? empty,
    TResult Function(PlayerOverallStatistics statistics)? loaded,
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
    required TResult Function(PlayerStatisticsLoading value) loading,
    required TResult Function(PlayerStatisticsEmpty value) empty,
    required TResult Function(PlayerStatisticsLoaded value) loaded,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerStatisticsLoading value)? loading,
    TResult? Function(PlayerStatisticsEmpty value)? empty,
    TResult? Function(PlayerStatisticsLoaded value)? loaded,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerStatisticsLoading value)? loading,
    TResult Function(PlayerStatisticsEmpty value)? empty,
    TResult Function(PlayerStatisticsLoaded value)? loaded,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class PlayerStatisticsLoading implements PlayerStatisticsVisualState {
  const factory PlayerStatisticsLoading() = _$PlayerStatisticsLoadingImpl;
}

/// @nodoc
abstract class _$$PlayerStatisticsEmptyImplCopyWith<$Res> {
  factory _$$PlayerStatisticsEmptyImplCopyWith(
          _$PlayerStatisticsEmptyImpl value,
          $Res Function(_$PlayerStatisticsEmptyImpl) then) =
      __$$PlayerStatisticsEmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PlayerStatisticsEmptyImplCopyWithImpl<$Res>
    extends _$PlayerStatisticsVisualStateCopyWithImpl<$Res,
        _$PlayerStatisticsEmptyImpl>
    implements _$$PlayerStatisticsEmptyImplCopyWith<$Res> {
  __$$PlayerStatisticsEmptyImplCopyWithImpl(_$PlayerStatisticsEmptyImpl _value,
      $Res Function(_$PlayerStatisticsEmptyImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$PlayerStatisticsEmptyImpl implements PlayerStatisticsEmpty {
  const _$PlayerStatisticsEmptyImpl();

  @override
  String toString() {
    return 'PlayerStatisticsVisualState.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerStatisticsEmptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function() empty,
    required TResult Function(PlayerOverallStatistics statistics) loaded,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function()? empty,
    TResult? Function(PlayerOverallStatistics statistics)? loaded,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function()? empty,
    TResult Function(PlayerOverallStatistics statistics)? loaded,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerStatisticsLoading value) loading,
    required TResult Function(PlayerStatisticsEmpty value) empty,
    required TResult Function(PlayerStatisticsLoaded value) loaded,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerStatisticsLoading value)? loading,
    TResult? Function(PlayerStatisticsEmpty value)? empty,
    TResult? Function(PlayerStatisticsLoaded value)? loaded,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerStatisticsLoading value)? loading,
    TResult Function(PlayerStatisticsEmpty value)? empty,
    TResult Function(PlayerStatisticsLoaded value)? loaded,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class PlayerStatisticsEmpty implements PlayerStatisticsVisualState {
  const factory PlayerStatisticsEmpty() = _$PlayerStatisticsEmptyImpl;
}

/// @nodoc
abstract class _$$PlayerStatisticsLoadedImplCopyWith<$Res> {
  factory _$$PlayerStatisticsLoadedImplCopyWith(
          _$PlayerStatisticsLoadedImpl value,
          $Res Function(_$PlayerStatisticsLoadedImpl) then) =
      __$$PlayerStatisticsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PlayerOverallStatistics statistics});

  $PlayerOverallStatisticsCopyWith<$Res> get statistics;
}

/// @nodoc
class __$$PlayerStatisticsLoadedImplCopyWithImpl<$Res>
    extends _$PlayerStatisticsVisualStateCopyWithImpl<$Res,
        _$PlayerStatisticsLoadedImpl>
    implements _$$PlayerStatisticsLoadedImplCopyWith<$Res> {
  __$$PlayerStatisticsLoadedImplCopyWithImpl(
      _$PlayerStatisticsLoadedImpl _value,
      $Res Function(_$PlayerStatisticsLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statistics = null,
  }) {
    return _then(_$PlayerStatisticsLoadedImpl(
      null == statistics
          ? _value.statistics
          : statistics // ignore: cast_nullable_to_non_nullable
              as PlayerOverallStatistics,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $PlayerOverallStatisticsCopyWith<$Res> get statistics {
    return $PlayerOverallStatisticsCopyWith<$Res>(_value.statistics, (value) {
      return _then(_value.copyWith(statistics: value));
    });
  }
}

/// @nodoc

class _$PlayerStatisticsLoadedImpl implements PlayerStatisticsLoaded {
  const _$PlayerStatisticsLoadedImpl(this.statistics);

  @override
  final PlayerOverallStatistics statistics;

  @override
  String toString() {
    return 'PlayerStatisticsVisualState.loaded(statistics: $statistics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerStatisticsLoadedImpl &&
            (identical(other.statistics, statistics) ||
                other.statistics == statistics));
  }

  @override
  int get hashCode => Object.hash(runtimeType, statistics);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerStatisticsLoadedImplCopyWith<_$PlayerStatisticsLoadedImpl>
      get copyWith => __$$PlayerStatisticsLoadedImplCopyWithImpl<
          _$PlayerStatisticsLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function() empty,
    required TResult Function(PlayerOverallStatistics statistics) loaded,
  }) {
    return loaded(statistics);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function()? empty,
    TResult? Function(PlayerOverallStatistics statistics)? loaded,
  }) {
    return loaded?.call(statistics);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function()? empty,
    TResult Function(PlayerOverallStatistics statistics)? loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(statistics);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerStatisticsLoading value) loading,
    required TResult Function(PlayerStatisticsEmpty value) empty,
    required TResult Function(PlayerStatisticsLoaded value) loaded,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerStatisticsLoading value)? loading,
    TResult? Function(PlayerStatisticsEmpty value)? empty,
    TResult? Function(PlayerStatisticsLoaded value)? loaded,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerStatisticsLoading value)? loading,
    TResult Function(PlayerStatisticsEmpty value)? empty,
    TResult Function(PlayerStatisticsLoaded value)? loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class PlayerStatisticsLoaded implements PlayerStatisticsVisualState {
  const factory PlayerStatisticsLoaded(
      final PlayerOverallStatistics statistics) = _$PlayerStatisticsLoadedImpl;

  PlayerOverallStatistics get statistics;
  @JsonKey(ignore: true)
  _$$PlayerStatisticsLoadedImplCopyWith<_$PlayerStatisticsLoadedImpl>
      get copyWith => throw _privateConstructorUsedError;
}
