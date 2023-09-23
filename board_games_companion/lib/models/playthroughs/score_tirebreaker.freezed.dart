// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_tirebreaker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ScoreTiebreaker {
  String get playerScoreId => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String playerScoreId) sharedPlace,
    required TResult Function(String playerScoreId) victory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String playerScoreId)? sharedPlace,
    TResult? Function(String playerScoreId)? victory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String playerScoreId)? sharedPlace,
    TResult Function(String playerScoreId)? victory,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_sharedPlace value) sharedPlace,
    required TResult Function(_victory value) victory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_sharedPlace value)? sharedPlace,
    TResult? Function(_victory value)? victory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_sharedPlace value)? sharedPlace,
    TResult Function(_victory value)? victory,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScoreTiebreakerCopyWith<ScoreTiebreaker> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreTiebreakerCopyWith<$Res> {
  factory $ScoreTiebreakerCopyWith(
          ScoreTiebreaker value, $Res Function(ScoreTiebreaker) then) =
      _$ScoreTiebreakerCopyWithImpl<$Res, ScoreTiebreaker>;
  @useResult
  $Res call({String playerScoreId});
}

/// @nodoc
class _$ScoreTiebreakerCopyWithImpl<$Res, $Val extends ScoreTiebreaker>
    implements $ScoreTiebreakerCopyWith<$Res> {
  _$ScoreTiebreakerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerScoreId = null,
  }) {
    return _then(_value.copyWith(
      playerScoreId: null == playerScoreId
          ? _value.playerScoreId
          : playerScoreId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_sharedPlaceCopyWith<$Res>
    implements $ScoreTiebreakerCopyWith<$Res> {
  factory _$$_sharedPlaceCopyWith(
          _$_sharedPlace value, $Res Function(_$_sharedPlace) then) =
      __$$_sharedPlaceCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerScoreId});
}

/// @nodoc
class __$$_sharedPlaceCopyWithImpl<$Res>
    extends _$ScoreTiebreakerCopyWithImpl<$Res, _$_sharedPlace>
    implements _$$_sharedPlaceCopyWith<$Res> {
  __$$_sharedPlaceCopyWithImpl(
      _$_sharedPlace _value, $Res Function(_$_sharedPlace) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerScoreId = null,
  }) {
    return _then(_$_sharedPlace(
      playerScoreId: null == playerScoreId
          ? _value.playerScoreId
          : playerScoreId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_sharedPlace implements _sharedPlace {
  const _$_sharedPlace({required this.playerScoreId});

  @override
  final String playerScoreId;

  @override
  String toString() {
    return 'ScoreTiebreaker.sharedPlace(playerScoreId: $playerScoreId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_sharedPlace &&
            (identical(other.playerScoreId, playerScoreId) ||
                other.playerScoreId == playerScoreId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerScoreId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_sharedPlaceCopyWith<_$_sharedPlace> get copyWith =>
      __$$_sharedPlaceCopyWithImpl<_$_sharedPlace>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String playerScoreId) sharedPlace,
    required TResult Function(String playerScoreId) victory,
  }) {
    return sharedPlace(playerScoreId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String playerScoreId)? sharedPlace,
    TResult? Function(String playerScoreId)? victory,
  }) {
    return sharedPlace?.call(playerScoreId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String playerScoreId)? sharedPlace,
    TResult Function(String playerScoreId)? victory,
    required TResult orElse(),
  }) {
    if (sharedPlace != null) {
      return sharedPlace(playerScoreId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_sharedPlace value) sharedPlace,
    required TResult Function(_victory value) victory,
  }) {
    return sharedPlace(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_sharedPlace value)? sharedPlace,
    TResult? Function(_victory value)? victory,
  }) {
    return sharedPlace?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_sharedPlace value)? sharedPlace,
    TResult Function(_victory value)? victory,
    required TResult orElse(),
  }) {
    if (sharedPlace != null) {
      return sharedPlace(this);
    }
    return orElse();
  }
}

abstract class _sharedPlace implements ScoreTiebreaker {
  const factory _sharedPlace({required final String playerScoreId}) =
      _$_sharedPlace;

  @override
  String get playerScoreId;
  @override
  @JsonKey(ignore: true)
  _$$_sharedPlaceCopyWith<_$_sharedPlace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_victoryCopyWith<$Res>
    implements $ScoreTiebreakerCopyWith<$Res> {
  factory _$$_victoryCopyWith(
          _$_victory value, $Res Function(_$_victory) then) =
      __$$_victoryCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerScoreId});
}

/// @nodoc
class __$$_victoryCopyWithImpl<$Res>
    extends _$ScoreTiebreakerCopyWithImpl<$Res, _$_victory>
    implements _$$_victoryCopyWith<$Res> {
  __$$_victoryCopyWithImpl(_$_victory _value, $Res Function(_$_victory) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerScoreId = null,
  }) {
    return _then(_$_victory(
      playerScoreId: null == playerScoreId
          ? _value.playerScoreId
          : playerScoreId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_victory implements _victory {
  const _$_victory({required this.playerScoreId});

  @override
  final String playerScoreId;

  @override
  String toString() {
    return 'ScoreTiebreaker.victory(playerScoreId: $playerScoreId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_victory &&
            (identical(other.playerScoreId, playerScoreId) ||
                other.playerScoreId == playerScoreId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerScoreId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_victoryCopyWith<_$_victory> get copyWith =>
      __$$_victoryCopyWithImpl<_$_victory>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String playerScoreId) sharedPlace,
    required TResult Function(String playerScoreId) victory,
  }) {
    return victory(playerScoreId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String playerScoreId)? sharedPlace,
    TResult? Function(String playerScoreId)? victory,
  }) {
    return victory?.call(playerScoreId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String playerScoreId)? sharedPlace,
    TResult Function(String playerScoreId)? victory,
    required TResult orElse(),
  }) {
    if (victory != null) {
      return victory(playerScoreId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_sharedPlace value) sharedPlace,
    required TResult Function(_victory value) victory,
  }) {
    return victory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_sharedPlace value)? sharedPlace,
    TResult? Function(_victory value)? victory,
  }) {
    return victory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_sharedPlace value)? sharedPlace,
    TResult Function(_victory value)? victory,
    required TResult orElse(),
  }) {
    if (victory != null) {
      return victory(this);
    }
    return orElse();
  }
}

abstract class _victory implements ScoreTiebreaker {
  const factory _victory({required final String playerScoreId}) = _$_victory;

  @override
  String get playerScoreId;
  @override
  @JsonKey(ignore: true)
  _$$_victoryCopyWith<_$_victory> get copyWith =>
      throw _privateConstructorUsedError;
}
