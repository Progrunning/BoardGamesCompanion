// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_history_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SearchHistoryEntry {
  @HiveField(0)
  String get query => throw _privateConstructorUsedError;
  @HiveField(1)
  DateTime get dateTime => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SearchHistoryEntryCopyWith<SearchHistoryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchHistoryEntryCopyWith<$Res> {
  factory $SearchHistoryEntryCopyWith(
          SearchHistoryEntry value, $Res Function(SearchHistoryEntry) then) =
      _$SearchHistoryEntryCopyWithImpl<$Res, SearchHistoryEntry>;
  @useResult
  $Res call({@HiveField(0) String query, @HiveField(1) DateTime dateTime});
}

/// @nodoc
class _$SearchHistoryEntryCopyWithImpl<$Res, $Val extends SearchHistoryEntry>
    implements $SearchHistoryEntryCopyWith<$Res> {
  _$SearchHistoryEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? dateTime = null,
  }) {
    return _then(_value.copyWith(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SearchHistoryEntryCopyWith<$Res>
    implements $SearchHistoryEntryCopyWith<$Res> {
  factory _$$_SearchHistoryEntryCopyWith(_$_SearchHistoryEntry value,
          $Res Function(_$_SearchHistoryEntry) then) =
      __$$_SearchHistoryEntryCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@HiveField(0) String query, @HiveField(1) DateTime dateTime});
}

/// @nodoc
class __$$_SearchHistoryEntryCopyWithImpl<$Res>
    extends _$SearchHistoryEntryCopyWithImpl<$Res, _$_SearchHistoryEntry>
    implements _$$_SearchHistoryEntryCopyWith<$Res> {
  __$$_SearchHistoryEntryCopyWithImpl(
      _$_SearchHistoryEntry _value, $Res Function(_$_SearchHistoryEntry) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? dateTime = null,
  }) {
    return _then(_$_SearchHistoryEntry(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@HiveType(
    typeId: HiveBoxes.searchHistoryEntryId,
    adapterName: 'SearchHistoryEntryAdapter')
class _$_SearchHistoryEntry implements _SearchHistoryEntry {
  const _$_SearchHistoryEntry(
      {@HiveField(0) required this.query,
      @HiveField(1) required this.dateTime});

  @override
  @HiveField(0)
  final String query;
  @override
  @HiveField(1)
  final DateTime dateTime;

  @override
  String toString() {
    return 'SearchHistoryEntry(query: $query, dateTime: $dateTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SearchHistoryEntry &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query, dateTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SearchHistoryEntryCopyWith<_$_SearchHistoryEntry> get copyWith =>
      __$$_SearchHistoryEntryCopyWithImpl<_$_SearchHistoryEntry>(
          this, _$identity);
}

abstract class _SearchHistoryEntry implements SearchHistoryEntry {
  const factory _SearchHistoryEntry(
      {@HiveField(0) required final String query,
      @HiveField(1) required final DateTime dateTime}) = _$_SearchHistoryEntry;

  @override
  @HiveField(0)
  String get query;
  @override
  @HiveField(1)
  DateTime get dateTime;
  @override
  @JsonKey(ignore: true)
  _$$_SearchHistoryEntryCopyWith<_$_SearchHistoryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}
