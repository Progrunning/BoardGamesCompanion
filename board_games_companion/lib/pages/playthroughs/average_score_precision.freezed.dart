// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

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
    required TResult Function(int precision) value,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int precision)? value,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int precision)? value,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_none value) none,
    required TResult Function(_value value) value,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_none value)? none,
    TResult Function(_value value)? value,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_none value)? none,
    TResult Function(_value value)? value,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AverageScorePrecisionCopyWith<$Res> {
  factory $AverageScorePrecisionCopyWith(AverageScorePrecision value,
          $Res Function(AverageScorePrecision) then) =
      _$AverageScorePrecisionCopyWithImpl<$Res>;
}

/// @nodoc
class _$AverageScorePrecisionCopyWithImpl<$Res>
    implements $AverageScorePrecisionCopyWith<$Res> {
  _$AverageScorePrecisionCopyWithImpl(this._value, this._then);

  final AverageScorePrecision _value;
  // ignore: unused_field
  final $Res Function(AverageScorePrecision) _then;
}

/// @nodoc
abstract class _$$_noneCopyWith<$Res> {
  factory _$$_noneCopyWith(_$_none value, $Res Function(_$_none) then) =
      __$$_noneCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_noneCopyWithImpl<$Res>
    extends _$AverageScorePrecisionCopyWithImpl<$Res>
    implements _$$_noneCopyWith<$Res> {
  __$$_noneCopyWithImpl(_$_none _value, $Res Function(_$_none) _then)
      : super(_value, (v) => _then(v as _$_none));

  @override
  _$_none get _value => super._value as _$_none;
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
    required TResult Function(int precision) value,
  }) {
    return none();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int precision)? value,
  }) {
    return none?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int precision)? value,
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
    required TResult Function(_value value) value,
  }) {
    return none(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_none value)? none,
    TResult Function(_value value)? value,
  }) {
    return none?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_none value)? none,
    TResult Function(_value value)? value,
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
abstract class _$$_valueCopyWith<$Res> {
  factory _$$_valueCopyWith(_$_value value, $Res Function(_$_value) then) =
      __$$_valueCopyWithImpl<$Res>;
  $Res call({int precision});
}

/// @nodoc
class __$$_valueCopyWithImpl<$Res>
    extends _$AverageScorePrecisionCopyWithImpl<$Res>
    implements _$$_valueCopyWith<$Res> {
  __$$_valueCopyWithImpl(_$_value _value, $Res Function(_$_value) _then)
      : super(_value, (v) => _then(v as _$_value));

  @override
  _$_value get _value => super._value as _$_value;

  @override
  $Res call({
    Object? precision = freezed,
  }) {
    return _then(_$_value(
      precision: precision == freezed
          ? _value.precision
          : precision // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_value implements _value {
  const _$_value({required this.precision});

  @override
  final int precision;

  @override
  String toString() {
    return 'AverageScorePrecision.value(precision: $precision)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_value &&
            const DeepCollectionEquality().equals(other.precision, precision));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(precision));

  @JsonKey(ignore: true)
  @override
  _$$_valueCopyWith<_$_value> get copyWith =>
      __$$_valueCopyWithImpl<_$_value>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(int precision) value,
  }) {
    return value(precision);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int precision)? value,
  }) {
    return value?.call(precision);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int precision)? value,
    required TResult orElse(),
  }) {
    if (value != null) {
      return value(precision);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_none value) none,
    required TResult Function(_value value) value,
  }) {
    return value(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_none value)? none,
    TResult Function(_value value)? value,
  }) {
    return value?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_none value)? none,
    TResult Function(_value value)? value,
    required TResult orElse(),
  }) {
    if (value != null) {
      return value(this);
    }
    return orElse();
  }
}

abstract class _value implements AverageScorePrecision {
  const factory _value({required final int precision}) = _$_value;

  int get precision;
  @JsonKey(ignore: true)
  _$$_valueCopyWith<_$_value> get copyWith =>
      throw _privateConstructorUsedError;
}
