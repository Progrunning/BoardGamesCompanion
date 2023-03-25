// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

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
      _$GroupedBoardGamePlaythroughsCopyWithImpl<$Res,
          GroupedBoardGamePlaythroughs>;
  @useResult
  $Res call({DateTime date, List<BoardGamePlaythrough> boardGamePlaythroughs});
}

/// @nodoc
class _$GroupedBoardGamePlaythroughsCopyWithImpl<$Res,
        $Val extends GroupedBoardGamePlaythroughs>
    implements $GroupedBoardGamePlaythroughsCopyWith<$Res> {
  _$GroupedBoardGamePlaythroughsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? boardGamePlaythroughs = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      boardGamePlaythroughs: null == boardGamePlaythroughs
          ? _value.boardGamePlaythroughs
          : boardGamePlaythroughs // ignore: cast_nullable_to_non_nullable
              as List<BoardGamePlaythrough>,
    ) as $Val);
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
  @useResult
  $Res call({DateTime date, List<BoardGamePlaythrough> boardGamePlaythroughs});
}

/// @nodoc
class __$$_GroupedBoardGamePlaythroughsCopyWithImpl<$Res>
    extends _$GroupedBoardGamePlaythroughsCopyWithImpl<$Res,
        _$_GroupedBoardGamePlaythroughs>
    implements _$$_GroupedBoardGamePlaythroughsCopyWith<$Res> {
  __$$_GroupedBoardGamePlaythroughsCopyWithImpl(
      _$_GroupedBoardGamePlaythroughs _value,
      $Res Function(_$_GroupedBoardGamePlaythroughs) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? boardGamePlaythroughs = null,
  }) {
    return _then(_$_GroupedBoardGamePlaythroughs(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      boardGamePlaythroughs: null == boardGamePlaythroughs
          ? _value._boardGamePlaythroughs
          : boardGamePlaythroughs // ignore: cast_nullable_to_non_nullable
              as List<BoardGamePlaythrough>,
    ));
  }
}

/// @nodoc

class _$_GroupedBoardGamePlaythroughs extends _GroupedBoardGamePlaythroughs {
  const _$_GroupedBoardGamePlaythroughs(
      {required this.date,
      required final List<BoardGamePlaythrough> boardGamePlaythroughs})
      : _boardGamePlaythroughs = boardGamePlaythroughs,
        super._();

  @override
  final DateTime date;
  final List<BoardGamePlaythrough> _boardGamePlaythroughs;
  @override
  List<BoardGamePlaythrough> get boardGamePlaythroughs {
    if (_boardGamePlaythroughs is EqualUnmodifiableListView)
      return _boardGamePlaythroughs;
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
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality()
                .equals(other._boardGamePlaythroughs, _boardGamePlaythroughs));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date,
      const DeepCollectionEquality().hash(_boardGamePlaythroughs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GroupedBoardGamePlaythroughsCopyWith<_$_GroupedBoardGamePlaythroughs>
      get copyWith => __$$_GroupedBoardGamePlaythroughsCopyWithImpl<
          _$_GroupedBoardGamePlaythroughs>(this, _$identity);
}

abstract class _GroupedBoardGamePlaythroughs
    extends GroupedBoardGamePlaythroughs {
  const factory _GroupedBoardGamePlaythroughs(
          {required final DateTime date,
          required final List<BoardGamePlaythrough> boardGamePlaythroughs}) =
      _$_GroupedBoardGamePlaythroughs;
  const _GroupedBoardGamePlaythroughs._() : super._();

  @override
  DateTime get date;
  @override
  List<BoardGamePlaythrough> get boardGamePlaythroughs;
  @override
  @JsonKey(ignore: true)
  _$$_GroupedBoardGamePlaythroughsCopyWith<_$_GroupedBoardGamePlaythroughs>
      get copyWith => throw _privateConstructorUsedError;
}
