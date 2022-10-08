// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

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
      _$PlaythroughCopyWithImpl<$Res>;
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
class _$PlaythroughCopyWithImpl<$Res> implements $PlaythroughCopyWith<$Res> {
  _$PlaythroughCopyWithImpl(this._value, this._then);

  final Playthrough _value;
  // ignore: unused_field
  final $Res Function(Playthrough) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? boardGameId = freezed,
    Object? playerIds = freezed,
    Object? scoreIds = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? status = freezed,
    Object? isDeleted = freezed,
    Object? bggPlayId = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameId: boardGameId == freezed
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      playerIds: playerIds == freezed
          ? _value.playerIds
          : playerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scoreIds: scoreIds == freezed
          ? _value.scoreIds
          : scoreIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startDate: startDate == freezed
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: endDate == freezed
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlaythroughStatus?,
      isDeleted: isDeleted == freezed
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      bggPlayId: bggPlayId == freezed
          ? _value.bggPlayId
          : bggPlayId // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: notes == freezed
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<PlaythroughNote>?,
    ));
  }
}

/// @nodoc
abstract class _$$_PlaythroughCopyWith<$Res>
    implements $PlaythroughCopyWith<$Res> {
  factory _$$_PlaythroughCopyWith(
          _$_Playthrough value, $Res Function(_$_Playthrough) then) =
      __$$_PlaythroughCopyWithImpl<$Res>;
  @override
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
class __$$_PlaythroughCopyWithImpl<$Res> extends _$PlaythroughCopyWithImpl<$Res>
    implements _$$_PlaythroughCopyWith<$Res> {
  __$$_PlaythroughCopyWithImpl(
      _$_Playthrough _value, $Res Function(_$_Playthrough) _then)
      : super(_value, (v) => _then(v as _$_Playthrough));

  @override
  _$_Playthrough get _value => super._value as _$_Playthrough;

  @override
  $Res call({
    Object? id = freezed,
    Object? boardGameId = freezed,
    Object? playerIds = freezed,
    Object? scoreIds = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? status = freezed,
    Object? isDeleted = freezed,
    Object? bggPlayId = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$_Playthrough(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameId: boardGameId == freezed
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      playerIds: playerIds == freezed
          ? _value._playerIds
          : playerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scoreIds: scoreIds == freezed
          ? _value._scoreIds
          : scoreIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startDate: startDate == freezed
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: endDate == freezed
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlaythroughStatus?,
      isDeleted: isDeleted == freezed
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      bggPlayId: bggPlayId == freezed
          ? _value.bggPlayId
          : bggPlayId // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: notes == freezed
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
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playerIds);
  }

  final List<String> _scoreIds;
  @override
  @HiveField(3)
  List<String> get scoreIds {
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
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality()
                .equals(other.boardGameId, boardGameId) &&
            const DeepCollectionEquality()
                .equals(other._playerIds, _playerIds) &&
            const DeepCollectionEquality().equals(other._scoreIds, _scoreIds) &&
            const DeepCollectionEquality().equals(other.startDate, startDate) &&
            const DeepCollectionEquality().equals(other.endDate, endDate) &&
            const DeepCollectionEquality().equals(other.status, status) &&
            const DeepCollectionEquality().equals(other.isDeleted, isDeleted) &&
            const DeepCollectionEquality().equals(other.bggPlayId, bggPlayId) &&
            const DeepCollectionEquality().equals(other._notes, _notes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(boardGameId),
      const DeepCollectionEquality().hash(_playerIds),
      const DeepCollectionEquality().hash(_scoreIds),
      const DeepCollectionEquality().hash(startDate),
      const DeepCollectionEquality().hash(endDate),
      const DeepCollectionEquality().hash(status),
      const DeepCollectionEquality().hash(isDeleted),
      const DeepCollectionEquality().hash(bggPlayId),
      const DeepCollectionEquality().hash(_notes));

  @JsonKey(ignore: true)
  @override
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
