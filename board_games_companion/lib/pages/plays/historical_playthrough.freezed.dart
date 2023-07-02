// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'historical_playthrough.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HistoricalPlaythrough {
  BoardGamePlaythrough get boardGamePlaythroughs =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            DateTime playedOn, BoardGamePlaythrough boardGamePlaythroughs)
        withDateHeader,
    required TResult Function(BoardGamePlaythrough boardGamePlaythroughs)
        withoutDateHeader,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            DateTime playedOn, BoardGamePlaythrough boardGamePlaythroughs)?
        withDateHeader,
    TResult? Function(BoardGamePlaythrough boardGamePlaythroughs)?
        withoutDateHeader,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            DateTime playedOn, BoardGamePlaythrough boardGamePlaythroughs)?
        withDateHeader,
    TResult Function(BoardGamePlaythrough boardGamePlaythroughs)?
        withoutDateHeader,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_withDateHeader value) withDateHeader,
    required TResult Function(_withoutDateHeader value) withoutDateHeader,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_withDateHeader value)? withDateHeader,
    TResult? Function(_withoutDateHeader value)? withoutDateHeader,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_withDateHeader value)? withDateHeader,
    TResult Function(_withoutDateHeader value)? withoutDateHeader,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HistoricalPlaythroughCopyWith<HistoricalPlaythrough> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoricalPlaythroughCopyWith<$Res> {
  factory $HistoricalPlaythroughCopyWith(HistoricalPlaythrough value,
          $Res Function(HistoricalPlaythrough) then) =
      _$HistoricalPlaythroughCopyWithImpl<$Res, HistoricalPlaythrough>;
  @useResult
  $Res call({BoardGamePlaythrough boardGamePlaythroughs});

  $BoardGamePlaythroughCopyWith<$Res> get boardGamePlaythroughs;
}

/// @nodoc
class _$HistoricalPlaythroughCopyWithImpl<$Res,
        $Val extends HistoricalPlaythrough>
    implements $HistoricalPlaythroughCopyWith<$Res> {
  _$HistoricalPlaythroughCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGamePlaythroughs = null,
  }) {
    return _then(_value.copyWith(
      boardGamePlaythroughs: null == boardGamePlaythroughs
          ? _value.boardGamePlaythroughs
          : boardGamePlaythroughs // ignore: cast_nullable_to_non_nullable
              as BoardGamePlaythrough,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BoardGamePlaythroughCopyWith<$Res> get boardGamePlaythroughs {
    return $BoardGamePlaythroughCopyWith<$Res>(_value.boardGamePlaythroughs,
        (value) {
      return _then(_value.copyWith(boardGamePlaythroughs: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_withDateHeaderCopyWith<$Res>
    implements $HistoricalPlaythroughCopyWith<$Res> {
  factory _$$_withDateHeaderCopyWith(
          _$_withDateHeader value, $Res Function(_$_withDateHeader) then) =
      __$$_withDateHeaderCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime playedOn, BoardGamePlaythrough boardGamePlaythroughs});

  @override
  $BoardGamePlaythroughCopyWith<$Res> get boardGamePlaythroughs;
}

/// @nodoc
class __$$_withDateHeaderCopyWithImpl<$Res>
    extends _$HistoricalPlaythroughCopyWithImpl<$Res, _$_withDateHeader>
    implements _$$_withDateHeaderCopyWith<$Res> {
  __$$_withDateHeaderCopyWithImpl(
      _$_withDateHeader _value, $Res Function(_$_withDateHeader) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playedOn = null,
    Object? boardGamePlaythroughs = null,
  }) {
    return _then(_$_withDateHeader(
      playedOn: null == playedOn
          ? _value.playedOn
          : playedOn // ignore: cast_nullable_to_non_nullable
              as DateTime,
      boardGamePlaythroughs: null == boardGamePlaythroughs
          ? _value.boardGamePlaythroughs
          : boardGamePlaythroughs // ignore: cast_nullable_to_non_nullable
              as BoardGamePlaythrough,
    ));
  }
}

/// @nodoc

class _$_withDateHeader implements _withDateHeader {
  const _$_withDateHeader(
      {required this.playedOn, required this.boardGamePlaythroughs});

  @override
  final DateTime playedOn;
  @override
  final BoardGamePlaythrough boardGamePlaythroughs;

  @override
  String toString() {
    return 'HistoricalPlaythrough.withDateHeader(playedOn: $playedOn, boardGamePlaythroughs: $boardGamePlaythroughs)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_withDateHeader &&
            (identical(other.playedOn, playedOn) ||
                other.playedOn == playedOn) &&
            (identical(other.boardGamePlaythroughs, boardGamePlaythroughs) ||
                other.boardGamePlaythroughs == boardGamePlaythroughs));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playedOn, boardGamePlaythroughs);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_withDateHeaderCopyWith<_$_withDateHeader> get copyWith =>
      __$$_withDateHeaderCopyWithImpl<_$_withDateHeader>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            DateTime playedOn, BoardGamePlaythrough boardGamePlaythroughs)
        withDateHeader,
    required TResult Function(BoardGamePlaythrough boardGamePlaythroughs)
        withoutDateHeader,
  }) {
    return withDateHeader(playedOn, boardGamePlaythroughs);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            DateTime playedOn, BoardGamePlaythrough boardGamePlaythroughs)?
        withDateHeader,
    TResult? Function(BoardGamePlaythrough boardGamePlaythroughs)?
        withoutDateHeader,
  }) {
    return withDateHeader?.call(playedOn, boardGamePlaythroughs);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            DateTime playedOn, BoardGamePlaythrough boardGamePlaythroughs)?
        withDateHeader,
    TResult Function(BoardGamePlaythrough boardGamePlaythroughs)?
        withoutDateHeader,
    required TResult orElse(),
  }) {
    if (withDateHeader != null) {
      return withDateHeader(playedOn, boardGamePlaythroughs);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_withDateHeader value) withDateHeader,
    required TResult Function(_withoutDateHeader value) withoutDateHeader,
  }) {
    return withDateHeader(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_withDateHeader value)? withDateHeader,
    TResult? Function(_withoutDateHeader value)? withoutDateHeader,
  }) {
    return withDateHeader?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_withDateHeader value)? withDateHeader,
    TResult Function(_withoutDateHeader value)? withoutDateHeader,
    required TResult orElse(),
  }) {
    if (withDateHeader != null) {
      return withDateHeader(this);
    }
    return orElse();
  }
}

abstract class _withDateHeader implements HistoricalPlaythrough {
  const factory _withDateHeader(
          {required final DateTime playedOn,
          required final BoardGamePlaythrough boardGamePlaythroughs}) =
      _$_withDateHeader;

  DateTime get playedOn;
  @override
  BoardGamePlaythrough get boardGamePlaythroughs;
  @override
  @JsonKey(ignore: true)
  _$$_withDateHeaderCopyWith<_$_withDateHeader> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_withoutDateHeaderCopyWith<$Res>
    implements $HistoricalPlaythroughCopyWith<$Res> {
  factory _$$_withoutDateHeaderCopyWith(_$_withoutDateHeader value,
          $Res Function(_$_withoutDateHeader) then) =
      __$$_withoutDateHeaderCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({BoardGamePlaythrough boardGamePlaythroughs});

  @override
  $BoardGamePlaythroughCopyWith<$Res> get boardGamePlaythroughs;
}

/// @nodoc
class __$$_withoutDateHeaderCopyWithImpl<$Res>
    extends _$HistoricalPlaythroughCopyWithImpl<$Res, _$_withoutDateHeader>
    implements _$$_withoutDateHeaderCopyWith<$Res> {
  __$$_withoutDateHeaderCopyWithImpl(
      _$_withoutDateHeader _value, $Res Function(_$_withoutDateHeader) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGamePlaythroughs = null,
  }) {
    return _then(_$_withoutDateHeader(
      boardGamePlaythroughs: null == boardGamePlaythroughs
          ? _value.boardGamePlaythroughs
          : boardGamePlaythroughs // ignore: cast_nullable_to_non_nullable
              as BoardGamePlaythrough,
    ));
  }
}

/// @nodoc

class _$_withoutDateHeader implements _withoutDateHeader {
  const _$_withoutDateHeader({required this.boardGamePlaythroughs});

  @override
  final BoardGamePlaythrough boardGamePlaythroughs;

  @override
  String toString() {
    return 'HistoricalPlaythrough.withoutDateHeader(boardGamePlaythroughs: $boardGamePlaythroughs)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_withoutDateHeader &&
            (identical(other.boardGamePlaythroughs, boardGamePlaythroughs) ||
                other.boardGamePlaythroughs == boardGamePlaythroughs));
  }

  @override
  int get hashCode => Object.hash(runtimeType, boardGamePlaythroughs);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_withoutDateHeaderCopyWith<_$_withoutDateHeader> get copyWith =>
      __$$_withoutDateHeaderCopyWithImpl<_$_withoutDateHeader>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            DateTime playedOn, BoardGamePlaythrough boardGamePlaythroughs)
        withDateHeader,
    required TResult Function(BoardGamePlaythrough boardGamePlaythroughs)
        withoutDateHeader,
  }) {
    return withoutDateHeader(boardGamePlaythroughs);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            DateTime playedOn, BoardGamePlaythrough boardGamePlaythroughs)?
        withDateHeader,
    TResult? Function(BoardGamePlaythrough boardGamePlaythroughs)?
        withoutDateHeader,
  }) {
    return withoutDateHeader?.call(boardGamePlaythroughs);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            DateTime playedOn, BoardGamePlaythrough boardGamePlaythroughs)?
        withDateHeader,
    TResult Function(BoardGamePlaythrough boardGamePlaythroughs)?
        withoutDateHeader,
    required TResult orElse(),
  }) {
    if (withoutDateHeader != null) {
      return withoutDateHeader(boardGamePlaythroughs);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_withDateHeader value) withDateHeader,
    required TResult Function(_withoutDateHeader value) withoutDateHeader,
  }) {
    return withoutDateHeader(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_withDateHeader value)? withDateHeader,
    TResult? Function(_withoutDateHeader value)? withoutDateHeader,
  }) {
    return withoutDateHeader?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_withDateHeader value)? withDateHeader,
    TResult Function(_withoutDateHeader value)? withoutDateHeader,
    required TResult orElse(),
  }) {
    if (withoutDateHeader != null) {
      return withoutDateHeader(this);
    }
    return orElse();
  }
}

abstract class _withoutDateHeader implements HistoricalPlaythrough {
  const factory _withoutDateHeader(
          {required final BoardGamePlaythrough boardGamePlaythroughs}) =
      _$_withoutDateHeader;

  @override
  BoardGamePlaythrough get boardGamePlaythroughs;
  @override
  @JsonKey(ignore: true)
  _$$_withoutDateHeaderCopyWith<_$_withoutDateHeader> get copyWith =>
      throw _privateConstructorUsedError;
}
