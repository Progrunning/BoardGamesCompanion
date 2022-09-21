// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Score {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(2)
  String get playerId => throw _privateConstructorUsedError;
  @HiveField(3)
  String get boardGameId => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get value => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get playthroughId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScoreCopyWith<Score> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreCopyWith<$Res> {
  factory $ScoreCopyWith(Score value, $Res Function(Score) then) =
      _$ScoreCopyWithImpl<$Res>;
  $Res call(
      {@HiveField(0) String id,
      @HiveField(2) String playerId,
      @HiveField(3) String boardGameId,
      @HiveField(4) String? value,
      @HiveField(1) String? playthroughId});
}

/// @nodoc
class _$ScoreCopyWithImpl<$Res> implements $ScoreCopyWith<$Res> {
  _$ScoreCopyWithImpl(this._value, this._then);

  final Score _value;
  // ignore: unused_field
  final $Res Function(Score) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? playerId = freezed,
    Object? boardGameId = freezed,
    Object? value = freezed,
    Object? playthroughId = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      playerId: playerId == freezed
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameId: boardGameId == freezed
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      playthroughId: playthroughId == freezed
          ? _value.playthroughId
          : playthroughId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_ScoreCopyWith<$Res> implements $ScoreCopyWith<$Res> {
  factory _$$_ScoreCopyWith(_$_Score value, $Res Function(_$_Score) then) =
      __$$_ScoreCopyWithImpl<$Res>;
  @override
  $Res call(
      {@HiveField(0) String id,
      @HiveField(2) String playerId,
      @HiveField(3) String boardGameId,
      @HiveField(4) String? value,
      @HiveField(1) String? playthroughId});
}

/// @nodoc
class __$$_ScoreCopyWithImpl<$Res> extends _$ScoreCopyWithImpl<$Res>
    implements _$$_ScoreCopyWith<$Res> {
  __$$_ScoreCopyWithImpl(_$_Score _value, $Res Function(_$_Score) _then)
      : super(_value, (v) => _then(v as _$_Score));

  @override
  _$_Score get _value => super._value as _$_Score;

  @override
  $Res call({
    Object? id = freezed,
    Object? playerId = freezed,
    Object? boardGameId = freezed,
    Object? value = freezed,
    Object? playthroughId = freezed,
  }) {
    return _then(_$_Score(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      playerId: playerId == freezed
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameId: boardGameId == freezed
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      playthroughId: playthroughId == freezed
          ? _value.playthroughId
          : playthroughId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@HiveType(typeId: HiveBoxes.scoreTypeId, adapterName: 'ScoreAdapter')
class _$_Score extends _Score {
  const _$_Score(
      {@HiveField(0) required this.id,
      @HiveField(2) required this.playerId,
      @HiveField(3) required this.boardGameId,
      @HiveField(4) this.value,
      @HiveField(1) this.playthroughId})
      : super._();

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(2)
  final String playerId;
  @override
  @HiveField(3)
  final String boardGameId;
  @override
  @HiveField(4)
  final String? value;
  @override
  @HiveField(1)
  final String? playthroughId;

  @override
  String toString() {
    return 'Score(id: $id, playerId: $playerId, boardGameId: $boardGameId, value: $value, playthroughId: $playthroughId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Score &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.playerId, playerId) &&
            const DeepCollectionEquality()
                .equals(other.boardGameId, boardGameId) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            const DeepCollectionEquality()
                .equals(other.playthroughId, playthroughId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(playerId),
      const DeepCollectionEquality().hash(boardGameId),
      const DeepCollectionEquality().hash(value),
      const DeepCollectionEquality().hash(playthroughId));

  @JsonKey(ignore: true)
  @override
  _$$_ScoreCopyWith<_$_Score> get copyWith =>
      __$$_ScoreCopyWithImpl<_$_Score>(this, _$identity);
}

abstract class _Score extends Score {
  const factory _Score(
      {@HiveField(0) required final String id,
      @HiveField(2) required final String playerId,
      @HiveField(3) required final String boardGameId,
      @HiveField(4) final String? value,
      @HiveField(1) final String? playthroughId}) = _$_Score;
  const _Score._() : super._();

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(2)
  String get playerId;
  @override
  @HiveField(3)
  String get boardGameId;
  @override
  @HiveField(4)
  String? get value;
  @override
  @HiveField(1)
  String? get playthroughId;
  @override
  @JsonKey(ignore: true)
  _$$_ScoreCopyWith<_$_Score> get copyWith =>
      throw _privateConstructorUsedError;
}
