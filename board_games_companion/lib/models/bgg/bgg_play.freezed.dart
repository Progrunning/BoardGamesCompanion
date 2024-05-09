// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bgg_play.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BggPlay {
  int get id => throw _privateConstructorUsedError;
  String get boardGameId => throw _privateConstructorUsedError;
  int? get playTimeInMinutes => throw _privateConstructorUsedError;
  DateTime? get playDate => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  List<BggPlayPlayer> get players => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BggPlayCopyWith<BggPlay> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BggPlayCopyWith<$Res> {
  factory $BggPlayCopyWith(BggPlay value, $Res Function(BggPlay) then) =
      _$BggPlayCopyWithImpl<$Res, BggPlay>;
  @useResult
  $Res call(
      {int id,
      String boardGameId,
      int? playTimeInMinutes,
      DateTime? playDate,
      bool completed,
      List<BggPlayPlayer> players});
}

/// @nodoc
class _$BggPlayCopyWithImpl<$Res, $Val extends BggPlay>
    implements $BggPlayCopyWith<$Res> {
  _$BggPlayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? boardGameId = null,
    Object? playTimeInMinutes = freezed,
    Object? playDate = freezed,
    Object? completed = null,
    Object? players = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      boardGameId: null == boardGameId
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      playTimeInMinutes: freezed == playTimeInMinutes
          ? _value.playTimeInMinutes
          : playTimeInMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      playDate: freezed == playDate
          ? _value.playDate
          : playDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      players: null == players
          ? _value.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<BggPlayPlayer>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BggPlayImplCopyWith<$Res> implements $BggPlayCopyWith<$Res> {
  factory _$$BggPlayImplCopyWith(
          _$BggPlayImpl value, $Res Function(_$BggPlayImpl) then) =
      __$$BggPlayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String boardGameId,
      int? playTimeInMinutes,
      DateTime? playDate,
      bool completed,
      List<BggPlayPlayer> players});
}

/// @nodoc
class __$$BggPlayImplCopyWithImpl<$Res>
    extends _$BggPlayCopyWithImpl<$Res, _$BggPlayImpl>
    implements _$$BggPlayImplCopyWith<$Res> {
  __$$BggPlayImplCopyWithImpl(
      _$BggPlayImpl _value, $Res Function(_$BggPlayImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? boardGameId = null,
    Object? playTimeInMinutes = freezed,
    Object? playDate = freezed,
    Object? completed = null,
    Object? players = null,
  }) {
    return _then(_$BggPlayImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      boardGameId: null == boardGameId
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      playTimeInMinutes: freezed == playTimeInMinutes
          ? _value.playTimeInMinutes
          : playTimeInMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      playDate: freezed == playDate
          ? _value.playDate
          : playDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      players: null == players
          ? _value._players
          : players // ignore: cast_nullable_to_non_nullable
              as List<BggPlayPlayer>,
    ));
  }
}

/// @nodoc

class _$BggPlayImpl extends _BggPlay {
  const _$BggPlayImpl(
      {required this.id,
      required this.boardGameId,
      required this.playTimeInMinutes,
      required this.playDate,
      required this.completed,
      required final List<BggPlayPlayer> players})
      : _players = players,
        super._();

  @override
  final int id;
  @override
  final String boardGameId;
  @override
  final int? playTimeInMinutes;
  @override
  final DateTime? playDate;
  @override
  final bool completed;
  final List<BggPlayPlayer> _players;
  @override
  List<BggPlayPlayer> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  String toString() {
    return 'BggPlay(id: $id, boardGameId: $boardGameId, playTimeInMinutes: $playTimeInMinutes, playDate: $playDate, completed: $completed, players: $players)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BggPlayImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.boardGameId, boardGameId) ||
                other.boardGameId == boardGameId) &&
            (identical(other.playTimeInMinutes, playTimeInMinutes) ||
                other.playTimeInMinutes == playTimeInMinutes) &&
            (identical(other.playDate, playDate) ||
                other.playDate == playDate) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            const DeepCollectionEquality().equals(other._players, _players));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      boardGameId,
      playTimeInMinutes,
      playDate,
      completed,
      const DeepCollectionEquality().hash(_players));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BggPlayImplCopyWith<_$BggPlayImpl> get copyWith =>
      __$$BggPlayImplCopyWithImpl<_$BggPlayImpl>(this, _$identity);
}

abstract class _BggPlay extends BggPlay {
  const factory _BggPlay(
      {required final int id,
      required final String boardGameId,
      required final int? playTimeInMinutes,
      required final DateTime? playDate,
      required final bool completed,
      required final List<BggPlayPlayer> players}) = _$BggPlayImpl;
  const _BggPlay._() : super._();

  @override
  int get id;
  @override
  String get boardGameId;
  @override
  int? get playTimeInMinutes;
  @override
  DateTime? get playDate;
  @override
  bool get completed;
  @override
  List<BggPlayPlayer> get players;
  @override
  @JsonKey(ignore: true)
  _$$BggPlayImplCopyWith<_$BggPlayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
