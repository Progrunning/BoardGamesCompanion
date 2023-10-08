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
  int get place => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> playerScoreIds, int place)
        sharedPlace,
    required TResult Function(String playerScoreId, int place) place,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> playerScoreIds, int place)? sharedPlace,
    TResult? Function(String playerScoreId, int place)? place,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> playerScoreIds, int place)? sharedPlace,
    TResult Function(String playerScoreId, int place)? place,
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
  $Res call({int place});
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
    Object? place = null,
  }) {
    return _then(_value.copyWith(
      place: null == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as int,
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
  $Res call({List<String> playerScoreIds, int place});
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
    Object? playerScoreIds = null,
    Object? place = null,
  }) {
    return _then(_$_sharedPlace(
      playerScoreIds: null == playerScoreIds
          ? _value._playerScoreIds
          : playerScoreIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      place: null == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_sharedPlace implements _sharedPlace {
  const _$_sharedPlace(
      {required final List<String> playerScoreIds, required this.place})
      : _playerScoreIds = playerScoreIds;

  final List<String> _playerScoreIds;
  @override
  List<String> get playerScoreIds {
    if (_playerScoreIds is EqualUnmodifiableListView) return _playerScoreIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playerScoreIds);
  }

  @override
  final int place;

  @override
  String toString() {
    return 'ScoreTiebreaker.sharedPlace(playerScoreIds: $playerScoreIds, place: $place)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_sharedPlace &&
            const DeepCollectionEquality()
                .equals(other._playerScoreIds, _playerScoreIds) &&
            (identical(other.place, place) || other.place == place));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_playerScoreIds), place);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_sharedPlaceCopyWith<_$_sharedPlace> get copyWith =>
      __$$_sharedPlaceCopyWithImpl<_$_sharedPlace>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> playerScoreIds, int place)
        sharedPlace,
    required TResult Function(String playerScoreId, int place) place,
  }) {
    return sharedPlace(playerScoreIds, this.place);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> playerScoreIds, int place)? sharedPlace,
    TResult? Function(String playerScoreId, int place)? place,
  }) {
    return sharedPlace?.call(playerScoreIds, this.place);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> playerScoreIds, int place)? sharedPlace,
    TResult Function(String playerScoreId, int place)? place,
    required TResult orElse(),
  }) {
    if (sharedPlace != null) {
      return sharedPlace(playerScoreIds, this.place);
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

abstract class _sharedPlace implements ScoreTiebreaker {
  const factory _sharedPlace(
      {required final List<String> playerScoreIds,
      required final int place}) = _$_sharedPlace;

  List<String> get playerScoreIds;
  @override
  int get place;
  @override
  @JsonKey(ignore: true)
  _$$_sharedPlaceCopyWith<_$_sharedPlace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_placeCopyWith<$Res>
    implements $ScoreTiebreakerCopyWith<$Res> {
  factory _$$_placeCopyWith(_$_place value, $Res Function(_$_place) then) =
      __$$_placeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerScoreId, int place});
}

/// @nodoc
class __$$_placeCopyWithImpl<$Res>
    extends _$ScoreTiebreakerCopyWithImpl<$Res, _$_place>
    implements _$$_placeCopyWith<$Res> {
  __$$_placeCopyWithImpl(_$_place _value, $Res Function(_$_place) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerScoreId = null,
    Object? place = null,
  }) {
    return _then(_$_place(
      playerScoreId: null == playerScoreId
          ? _value.playerScoreId
          : playerScoreId // ignore: cast_nullable_to_non_nullable
              as String,
      place: null == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_place implements _place {
  const _$_place({required this.playerScoreId, required this.place});

  @override
  final String playerScoreId;
  @override
  final int place;

  @override
  String toString() {
    return 'ScoreTiebreaker.place(playerScoreId: $playerScoreId, place: $place)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_place &&
            (identical(other.playerScoreId, playerScoreId) ||
                other.playerScoreId == playerScoreId) &&
            (identical(other.place, place) || other.place == place));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerScoreId, place);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_placeCopyWith<_$_place> get copyWith =>
      __$$_placeCopyWithImpl<_$_place>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> playerScoreIds, int place)
        sharedPlace,
    required TResult Function(String playerScoreId, int place) place,
  }) {
    return place(playerScoreId, this.place);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> playerScoreIds, int place)? sharedPlace,
    TResult? Function(String playerScoreId, int place)? place,
  }) {
    return place?.call(playerScoreId, this.place);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> playerScoreIds, int place)? sharedPlace,
    TResult Function(String playerScoreId, int place)? place,
    required TResult orElse(),
  }) {
    if (place != null) {
      return place(playerScoreId, this.place);
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

abstract class _place implements ScoreTiebreaker {
  const factory _place(
      {required final String playerScoreId,
      required final int place}) = _$_place;

  String get playerScoreId;
  @override
  int get place;
  @override
  @JsonKey(ignore: true)
  _$$_placeCopyWith<_$_place> get copyWith =>
      throw _privateConstructorUsedError;
}
