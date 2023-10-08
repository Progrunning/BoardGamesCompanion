// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_tiebreaker_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ScoreTiebreakerResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sharedPlace,
    required TResult Function(int place) place,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sharedPlace,
    TResult? Function(int place)? place,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sharedPlace,
    TResult Function(int place)? place,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_sharedPlace value) sharedPlace,
    required TResult Function(_place value) place,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_sharedPlace value)? sharedPlace,
    TResult? Function(_place value)? place,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_sharedPlace value)? sharedPlace,
    TResult Function(_place value)? place,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreTiebreakerResultCopyWith<$Res> {
  factory $ScoreTiebreakerResultCopyWith(ScoreTiebreakerResult value,
          $Res Function(ScoreTiebreakerResult) then) =
      _$ScoreTiebreakerResultCopyWithImpl<$Res, ScoreTiebreakerResult>;
}

/// @nodoc
class _$ScoreTiebreakerResultCopyWithImpl<$Res,
        $Val extends ScoreTiebreakerResult>
    implements $ScoreTiebreakerResultCopyWith<$Res> {
  _$ScoreTiebreakerResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_sharedPlaceCopyWith<$Res> {
  factory _$$_sharedPlaceCopyWith(
          _$_sharedPlace value, $Res Function(_$_sharedPlace) then) =
      __$$_sharedPlaceCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_sharedPlaceCopyWithImpl<$Res>
    extends _$ScoreTiebreakerResultCopyWithImpl<$Res, _$_sharedPlace>
    implements _$$_sharedPlaceCopyWith<$Res> {
  __$$_sharedPlaceCopyWithImpl(
      _$_sharedPlace _value, $Res Function(_$_sharedPlace) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_sharedPlace implements _sharedPlace {
  const _$_sharedPlace();

  @override
  String toString() {
    return 'ScoreTiebreakerResult.sharedPlace()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_sharedPlace);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sharedPlace,
    required TResult Function(int place) place,
  }) {
    return sharedPlace();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sharedPlace,
    TResult? Function(int place)? place,
  }) {
    return sharedPlace?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sharedPlace,
    TResult Function(int place)? place,
    required TResult orElse(),
  }) {
    if (sharedPlace != null) {
      return sharedPlace();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_sharedPlace value) sharedPlace,
    required TResult Function(_place value) place,
  }) {
    return sharedPlace(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_sharedPlace value)? sharedPlace,
    TResult? Function(_place value)? place,
  }) {
    return sharedPlace?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_sharedPlace value)? sharedPlace,
    TResult Function(_place value)? place,
    required TResult orElse(),
  }) {
    if (sharedPlace != null) {
      return sharedPlace(this);
    }
    return orElse();
  }
}

abstract class _sharedPlace implements ScoreTiebreakerResult {
  const factory _sharedPlace() = _$_sharedPlace;
}

/// @nodoc
abstract class _$$_placeCopyWith<$Res> {
  factory _$$_placeCopyWith(_$_place value, $Res Function(_$_place) then) =
      __$$_placeCopyWithImpl<$Res>;
  @useResult
  $Res call({int place});
}

/// @nodoc
class __$$_placeCopyWithImpl<$Res>
    extends _$ScoreTiebreakerResultCopyWithImpl<$Res, _$_place>
    implements _$$_placeCopyWith<$Res> {
  __$$_placeCopyWithImpl(_$_place _value, $Res Function(_$_place) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? place = null,
  }) {
    return _then(_$_place(
      place: null == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_place implements _place {
  const _$_place({required this.place});

  @override
  final int place;

  @override
  String toString() {
    return 'ScoreTiebreakerResult.place(place: $place)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_place &&
            (identical(other.place, place) || other.place == place));
  }

  @override
  int get hashCode => Object.hash(runtimeType, place);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_placeCopyWith<_$_place> get copyWith =>
      __$$_placeCopyWithImpl<_$_place>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sharedPlace,
    required TResult Function(int place) place,
  }) {
    return place(this.place);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sharedPlace,
    TResult? Function(int place)? place,
  }) {
    return place?.call(this.place);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sharedPlace,
    TResult Function(int place)? place,
    required TResult orElse(),
  }) {
    if (place != null) {
      return place(this.place);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_sharedPlace value) sharedPlace,
    required TResult Function(_place value) place,
  }) {
    return place(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_sharedPlace value)? sharedPlace,
    TResult? Function(_place value)? place,
  }) {
    return place?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_sharedPlace value)? sharedPlace,
    TResult Function(_place value)? place,
    required TResult orElse(),
  }) {
    if (place != null) {
      return place(this);
    }
    return orElse();
  }
}

abstract class _place implements ScoreTiebreakerResult {
  const factory _place({required final int place}) = _$_place;

  int get place;
  @JsonKey(ignore: true)
  _$$_placeCopyWith<_$_place> get copyWith =>
      throw _privateConstructorUsedError;
}
