// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playthrough.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Playthrough {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get boardGameId => throw _privateConstructorUsedError;
  @HiveField(2)
  List<String> get playerIds => throw _privateConstructorUsedError;
  @HiveField(3)
  List<String> get scoreIds => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime get startDate => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime? get endDate => throw _privateConstructorUsedError;
  @HiveField(6)
  PlaythroughStatus? get status => throw _privateConstructorUsedError;
  @HiveField(7)
  bool? get isDeleted => throw _privateConstructorUsedError;
  @HiveField(8)
  int? get bggPlayId => throw _privateConstructorUsedError;
  @HiveField(9)
  List<PlaythroughNote>? get notes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlaythroughCopyWith<Playthrough> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaythroughCopyWith<$Res> {
  factory $PlaythroughCopyWith(
          Playthrough value, $Res Function(Playthrough) then) =
      _$PlaythroughCopyWithImpl<$Res, Playthrough>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String boardGameId,
      @HiveField(2) List<String> playerIds,
      @HiveField(3) List<String> scoreIds,
      @HiveField(4) DateTime startDate,
      @HiveField(5) DateTime? endDate,
      @HiveField(6) PlaythroughStatus? status,
      @HiveField(7) bool? isDeleted,
      @HiveField(8) int? bggPlayId,
      @HiveField(9) List<PlaythroughNote>? notes});
}

/// @nodoc
class _$PlaythroughCopyWithImpl<$Res, $Val extends Playthrough>
    implements $PlaythroughCopyWith<$Res> {
  _$PlaythroughCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? boardGameId = null,
    Object? playerIds = null,
    Object? scoreIds = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? status = freezed,
    Object? isDeleted = freezed,
    Object? bggPlayId = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameId: null == boardGameId
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      playerIds: null == playerIds
          ? _value.playerIds
          : playerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scoreIds: null == scoreIds
          ? _value.scoreIds
          : scoreIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlaythroughStatus?,
      isDeleted: freezed == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      bggPlayId: freezed == bggPlayId
          ? _value.bggPlayId
          : bggPlayId // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<PlaythroughNote>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PlaythroughCopyWith<$Res>
    implements $PlaythroughCopyWith<$Res> {
  factory _$$_PlaythroughCopyWith(
          _$_Playthrough value, $Res Function(_$_Playthrough) then) =
      __$$_PlaythroughCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String boardGameId,
      @HiveField(2) List<String> playerIds,
      @HiveField(3) List<String> scoreIds,
      @HiveField(4) DateTime startDate,
      @HiveField(5) DateTime? endDate,
      @HiveField(6) PlaythroughStatus? status,
      @HiveField(7) bool? isDeleted,
      @HiveField(8) int? bggPlayId,
      @HiveField(9) List<PlaythroughNote>? notes});
}

/// @nodoc
class __$$_PlaythroughCopyWithImpl<$Res>
    extends _$PlaythroughCopyWithImpl<$Res, _$_Playthrough>
    implements _$$_PlaythroughCopyWith<$Res> {
  __$$_PlaythroughCopyWithImpl(
      _$_Playthrough _value, $Res Function(_$_Playthrough) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? boardGameId = null,
    Object? playerIds = null,
    Object? scoreIds = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? status = freezed,
    Object? isDeleted = freezed,
    Object? bggPlayId = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$_Playthrough(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameId: null == boardGameId
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      playerIds: null == playerIds
          ? _value._playerIds
          : playerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scoreIds: null == scoreIds
          ? _value._scoreIds
          : scoreIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlaythroughStatus?,
      isDeleted: freezed == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      bggPlayId: freezed == bggPlayId
          ? _value.bggPlayId
          : bggPlayId // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<PlaythroughNote>?,
    ));
  }
}

/// @nodoc

@HiveType(
    typeId: HiveBoxes.playthroughTypeId, adapterName: 'PlaythroughAdapter')
class _$_Playthrough implements _Playthrough {
  const _$_Playthrough(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.boardGameId,
      @HiveField(2) required final List<String> playerIds,
      @HiveField(3) required final List<String> scoreIds,
      @HiveField(4) required this.startDate,
      @HiveField(5) this.endDate,
      @HiveField(6) this.status,
      @HiveField(7) this.isDeleted = false,
      @HiveField(8) this.bggPlayId,
      @HiveField(9) final List<PlaythroughNote>? notes})
      : _playerIds = playerIds,
        _scoreIds = scoreIds,
        _notes = notes;

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String boardGameId;
  final List<String> _playerIds;
  @override
  @HiveField(2)
  List<String> get playerIds {
    if (_playerIds is EqualUnmodifiableListView) return _playerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playerIds);
  }

  final List<String> _scoreIds;
  @override
  @HiveField(3)
  List<String> get scoreIds {
    if (_scoreIds is EqualUnmodifiableListView) return _scoreIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scoreIds);
  }

  @override
  @HiveField(4)
  final DateTime startDate;
  @override
  @HiveField(5)
  final DateTime? endDate;
  @override
  @HiveField(6)
  final PlaythroughStatus? status;
  @override
  @JsonKey()
  @HiveField(7)
  final bool? isDeleted;
  @override
  @HiveField(8)
  final int? bggPlayId;
  final List<PlaythroughNote>? _notes;
  @override
  @HiveField(9)
  List<PlaythroughNote>? get notes {
    final value = _notes;
    if (value == null) return null;
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Playthrough(id: $id, boardGameId: $boardGameId, playerIds: $playerIds, scoreIds: $scoreIds, startDate: $startDate, endDate: $endDate, status: $status, isDeleted: $isDeleted, bggPlayId: $bggPlayId, notes: $notes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Playthrough &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.boardGameId, boardGameId) ||
                other.boardGameId == boardGameId) &&
            const DeepCollectionEquality()
                .equals(other._playerIds, _playerIds) &&
            const DeepCollectionEquality().equals(other._scoreIds, _scoreIds) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.bggPlayId, bggPlayId) ||
                other.bggPlayId == bggPlayId) &&
            const DeepCollectionEquality().equals(other._notes, _notes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      boardGameId,
      const DeepCollectionEquality().hash(_playerIds),
      const DeepCollectionEquality().hash(_scoreIds),
      startDate,
      endDate,
      status,
      isDeleted,
      bggPlayId,
      const DeepCollectionEquality().hash(_notes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PlaythroughCopyWith<_$_Playthrough> get copyWith =>
      __$$_PlaythroughCopyWithImpl<_$_Playthrough>(this, _$identity);
}

abstract class _Playthrough implements Playthrough {
  const factory _Playthrough(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String boardGameId,
      @HiveField(2) required final List<String> playerIds,
      @HiveField(3) required final List<String> scoreIds,
      @HiveField(4) required final DateTime startDate,
      @HiveField(5) final DateTime? endDate,
      @HiveField(6) final PlaythroughStatus? status,
      @HiveField(7) final bool? isDeleted,
      @HiveField(8) final int? bggPlayId,
      @HiveField(9) final List<PlaythroughNote>? notes}) = _$_Playthrough;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get boardGameId;
  @override
  @HiveField(2)
  List<String> get playerIds;
  @override
  @HiveField(3)
  List<String> get scoreIds;
  @override
  @HiveField(4)
  DateTime get startDate;
  @override
  @HiveField(5)
  DateTime? get endDate;
  @override
  @HiveField(6)
  PlaythroughStatus? get status;
  @override
  @HiveField(7)
  bool? get isDeleted;
  @override
  @HiveField(8)
  int? get bggPlayId;
  @override
  @HiveField(9)
  List<PlaythroughNote>? get notes;
  @override
  @JsonKey(ignore: true)
  _$$_PlaythroughCopyWith<_$_Playthrough> get copyWith =>
      throw _privateConstructorUsedError;
}
