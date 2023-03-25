// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'average_score_precision.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AverageScorePrecision {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(int value) precision,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(int value)? precision,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int value)? precision,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_none value) none,
    required TResult Function(_precision value) precision,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_none value)? none,
    TResult? Function(_precision value)? precision,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_none value)? none,
    TResult Function(_precision value)? precision,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AverageScorePrecisionCopyWith<$Res> {
  factory $AverageScorePrecisionCopyWith(AverageScorePrecision value,
          $Res Function(AverageScorePrecision) then) =
      _$AverageScorePrecisionCopyWithImpl<$Res, AverageScorePrecision>;
}

/// @nodoc
class _$AverageScorePrecisionCopyWithImpl<$Res,
        $Val extends AverageScorePrecision>
    implements $AverageScorePrecisionCopyWith<$Res> {
  _$AverageScorePrecisionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_noneCopyWith<$Res> {
  factory _$$_noneCopyWith(_$_none value, $Res Function(_$_none) then) =
      __$$_noneCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_noneCopyWithImpl<$Res>
    extends _$AverageScorePrecisionCopyWithImpl<$Res, _$_none>
    implements _$$_noneCopyWith<$Res> {
  __$$_noneCopyWithImpl(_$_none _value, $Res Function(_$_none) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_none implements _none {
  const _$_none();

  @override
  String toString() {
    return 'AverageScorePrecision.none()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_none);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(int value) precision,
  }) {
    return none();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(int value)? precision,
  }) {
    return none?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int value)? precision,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_none value) none,
    required TResult Function(_precision value) precision,
  }) {
    return none(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_none value)? none,
    TResult? Function(_precision value)? precision,
  }) {
    return none?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_none value)? none,
    TResult Function(_precision value)? precision,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(this);
    }
    return orElse();
  }
}

abstract class _none implements AverageScorePrecision {
  const factory _none() = _$_none;
}

/// @nodoc
abstract class _$$_precisionCopyWith<$Res> {
  factory _$$_precisionCopyWith(
          _$_precision value, $Res Function(_$_precision) then) =
      __$$_precisionCopyWithImpl<$Res>;
  @useResult
  $Res call({int value});
}

/// @nodoc
class __$$_precisionCopyWithImpl<$Res>
    extends _$AverageScorePrecisionCopyWithImpl<$Res, _$_precision>
    implements _$$_precisionCopyWith<$Res> {
  __$$_precisionCopyWithImpl(
      _$_precision _value, $Res Function(_$_precision) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_precision(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_precision implements _precision {
  const _$_precision({required this.value});

  @override
  final int value;

  @override
  String toString() {
    return 'AverageScorePrecision.precision(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_precision &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_precisionCopyWith<_$_precision> get copyWith =>
      __$$_precisionCopyWithImpl<_$_precision>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(int value) precision,
  }) {
    return precision(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(int value)? precision,
  }) {
    return precision?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int value)? precision,
    required TResult orElse(),
  }) {
    if (precision != null) {
      return precision(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_none value) none,
    required TResult Function(_precision value) precision,
  }) {
    return precision(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_none value)? none,
    TResult? Function(_precision value)? precision,
  }) {
    return precision?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_none value)? none,
    TResult Function(_precision value)? precision,
    required TResult orElse(),
  }) {
    if (precision != null) {
      return precision(this);
    }
    return orElse();
  }
}

abstract class _precision implements AverageScorePrecision {
  const factory _precision({required final int value}) = _$_precision;

  int get value;
  @JsonKey(ignore: true)
  _$$_precisionCopyWith<_$_precision> get copyWith =>
      throw _privateConstructorUsedError;
}
