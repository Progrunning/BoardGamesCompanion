// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'grouped_board_game_playthroughs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GroupedBoardGamePlaythroughs {
  DateTime get date => throw _privateConstructorUsedError;
  List<BoardGamePlaythrough> get boardGamePlaythroughs =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GroupedBoardGamePlaythroughsCopyWith<GroupedBoardGamePlaythroughs>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupedBoardGamePlaythroughsCopyWith<$Res> {
  factory $GroupedBoardGamePlaythroughsCopyWith(
          GroupedBoardGamePlaythroughs value,
          $Res Function(GroupedBoardGamePlaythroughs) then) =
      _$GroupedBoardGamePlaythroughsCopyWithImpl<$Res>;
  $Res call({DateTime date, List<BoardGamePlaythrough> boardGamePlaythroughs});
}

/// @nodoc
class _$GroupedBoardGamePlaythroughsCopyWithImpl<$Res>
    implements $GroupedBoardGamePlaythroughsCopyWith<$Res> {
  _$GroupedBoardGamePlaythroughsCopyWithImpl(this._value, this._then);

  final GroupedBoardGamePlaythroughs _value;
  // ignore: unused_field
  final $Res Function(GroupedBoardGamePlaythroughs) _then;

  @override
  $Res call({
    Object? date = freezed,
    Object? boardGamePlaythroughs = freezed,
  }) {
    return _then(_value.copyWith(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      boardGamePlaythroughs: boardGamePlaythroughs == freezed
          ? _value.boardGamePlaythroughs
          : boardGamePlaythroughs // ignore: cast_nullable_to_non_nullable
              as List<BoardGamePlaythrough>,
    ));
  }
}

/// @nodoc
abstract class _$$_GroupedBoardGamePlaythroughsCopyWith<$Res>
    implements $GroupedBoardGamePlaythroughsCopyWith<$Res> {
  factory _$$_GroupedBoardGamePlaythroughsCopyWith(
          _$_GroupedBoardGamePlaythroughs value,
          $Res Function(_$_GroupedBoardGamePlaythroughs) then) =
      __$$_GroupedBoardGamePlaythroughsCopyWithImpl<$Res>;
  @override
  $Res call({DateTime date, List<BoardGamePlaythrough> boardGamePlaythroughs});
}

/// @nodoc
class __$$_GroupedBoardGamePlaythroughsCopyWithImpl<$Res>
    extends _$GroupedBoardGamePlaythroughsCopyWithImpl<$Res>
    implements _$$_GroupedBoardGamePlaythroughsCopyWith<$Res> {
  __$$_GroupedBoardGamePlaythroughsCopyWithImpl(
      _$_GroupedBoardGamePlaythroughs _value,
      $Res Function(_$_GroupedBoardGamePlaythroughs) _then)
      : super(_value, (v) => _then(v as _$_GroupedBoardGamePlaythroughs));

  @override
  _$_GroupedBoardGamePlaythroughs get _value =>
      super._value as _$_GroupedBoardGamePlaythroughs;

  @override
  $Res call({
    Object? date = freezed,
    Object? boardGamePlaythroughs = freezed,
  }) {
    return _then(_$_GroupedBoardGamePlaythroughs(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      boardGamePlaythroughs: boardGamePlaythroughs == freezed
          ? _value._boardGamePlaythroughs
          : boardGamePlaythroughs // ignore: cast_nullable_to_non_nullable
              as List<BoardGamePlaythrough>,
    ));
  }
}

/// @nodoc

class _$_GroupedBoardGamePlaythroughs implements _GroupedBoardGamePlaythroughs {
  const _$_GroupedBoardGamePlaythroughs(
      {required this.date,
      required final List<BoardGamePlaythrough> boardGamePlaythroughs})
      : _boardGamePlaythroughs = boardGamePlaythroughs;

  @override
  final DateTime date;
  final List<BoardGamePlaythrough> _boardGamePlaythroughs;
  @override
  List<BoardGamePlaythrough> get boardGamePlaythroughs {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_boardGamePlaythroughs);
  }

  @override
  String toString() {
    return 'GroupedBoardGamePlaythroughs(date: $date, boardGamePlaythroughs: $boardGamePlaythroughs)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GroupedBoardGamePlaythroughs &&
            const DeepCollectionEquality().equals(other.date, date) &&
            const DeepCollectionEquality()
                .equals(other._boardGamePlaythroughs, _boardGamePlaythroughs));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(date),
      const DeepCollectionEquality().hash(_boardGamePlaythroughs));

  @JsonKey(ignore: true)
  @override
  _$$_GroupedBoardGamePlaythroughsCopyWith<_$_GroupedBoardGamePlaythroughs>
      get copyWith => __$$_GroupedBoardGamePlaythroughsCopyWithImpl<
          _$_GroupedBoardGamePlaythroughs>(this, _$identity);
}

abstract class _GroupedBoardGamePlaythroughs
    implements GroupedBoardGamePlaythroughs {
  const factory _GroupedBoardGamePlaythroughs(
          {required final DateTime date,
          required final List<BoardGamePlaythrough> boardGamePlaythroughs}) =
      _$_GroupedBoardGamePlaythroughs;

  @override
  DateTime get date;
  @override
  List<BoardGamePlaythrough> get boardGamePlaythroughs;
  @override
  @JsonKey(ignore: true)
  _$$_GroupedBoardGamePlaythroughsCopyWith<_$_GroupedBoardGamePlaythroughs>
      get copyWith => throw _privateConstructorUsedError;
}
