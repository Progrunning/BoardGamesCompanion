// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plays_page_visual_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PlaysPageVisualState {
  PlaysTab get playsTab => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PlaysTab playsTab,
            List<GroupedBoardGamePlaythroughs> finishedBoardGamePlaythroughs)
        history,
    required TResult Function(PlaysTab playsTab) statistics,
    required TResult Function(
            PlaysTab playsTab, List<BoardGameDetails> shuffledBoardGames)
        selectGame,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PlaysTab playsTab,
            List<GroupedBoardGamePlaythroughs> finishedBoardGamePlaythroughs)?
        history,
    TResult? Function(PlaysTab playsTab)? statistics,
    TResult? Function(
            PlaysTab playsTab, List<BoardGameDetails> shuffledBoardGames)?
        selectGame,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PlaysTab playsTab,
            List<GroupedBoardGamePlaythroughs> finishedBoardGamePlaythroughs)?
        history,
    TResult Function(PlaysTab playsTab)? statistics,
    TResult Function(
            PlaysTab playsTab, List<BoardGameDetails> shuffledBoardGames)?
        selectGame,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_History value) history,
    required TResult Function(_Statistics value) statistics,
    required TResult Function(_SelectGame value) selectGame,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_History value)? history,
    TResult? Function(_Statistics value)? statistics,
    TResult? Function(_SelectGame value)? selectGame,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_History value)? history,
    TResult Function(_Statistics value)? statistics,
    TResult Function(_SelectGame value)? selectGame,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlaysPageVisualStateCopyWith<PlaysPageVisualState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaysPageVisualStateCopyWith<$Res> {
  factory $PlaysPageVisualStateCopyWith(PlaysPageVisualState value,
          $Res Function(PlaysPageVisualState) then) =
      _$PlaysPageVisualStateCopyWithImpl<$Res, PlaysPageVisualState>;
  @useResult
  $Res call({PlaysTab playsTab});
}

/// @nodoc
class _$PlaysPageVisualStateCopyWithImpl<$Res,
        $Val extends PlaysPageVisualState>
    implements $PlaysPageVisualStateCopyWith<$Res> {
  _$PlaysPageVisualStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playsTab = null,
  }) {
    return _then(_value.copyWith(
      playsTab: null == playsTab
          ? _value.playsTab
          : playsTab // ignore: cast_nullable_to_non_nullable
              as PlaysTab,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_HistoryCopyWith<$Res>
    implements $PlaysPageVisualStateCopyWith<$Res> {
  factory _$$_HistoryCopyWith(
          _$_History value, $Res Function(_$_History) then) =
      __$$_HistoryCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PlaysTab playsTab,
      List<GroupedBoardGamePlaythroughs> finishedBoardGamePlaythroughs});
}

/// @nodoc
class __$$_HistoryCopyWithImpl<$Res>
    extends _$PlaysPageVisualStateCopyWithImpl<$Res, _$_History>
    implements _$$_HistoryCopyWith<$Res> {
  __$$_HistoryCopyWithImpl(_$_History _value, $Res Function(_$_History) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playsTab = null,
    Object? finishedBoardGamePlaythroughs = null,
  }) {
    return _then(_$_History(
      null == playsTab
          ? _value.playsTab
          : playsTab // ignore: cast_nullable_to_non_nullable
              as PlaysTab,
      null == finishedBoardGamePlaythroughs
          ? _value._finishedBoardGamePlaythroughs
          : finishedBoardGamePlaythroughs // ignore: cast_nullable_to_non_nullable
              as List<GroupedBoardGamePlaythroughs>,
    ));
  }
}

/// @nodoc

class _$_History implements _History {
  const _$_History(this.playsTab,
      final List<GroupedBoardGamePlaythroughs> finishedBoardGamePlaythroughs)
      : _finishedBoardGamePlaythroughs = finishedBoardGamePlaythroughs;

  @override
  final PlaysTab playsTab;
  final List<GroupedBoardGamePlaythroughs> _finishedBoardGamePlaythroughs;
  @override
  List<GroupedBoardGamePlaythroughs> get finishedBoardGamePlaythroughs {
    if (_finishedBoardGamePlaythroughs is EqualUnmodifiableListView)
      return _finishedBoardGamePlaythroughs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_finishedBoardGamePlaythroughs);
  }

  @override
  String toString() {
    return 'PlaysPageVisualState.history(playsTab: $playsTab, finishedBoardGamePlaythroughs: $finishedBoardGamePlaythroughs)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_History &&
            (identical(other.playsTab, playsTab) ||
                other.playsTab == playsTab) &&
            const DeepCollectionEquality().equals(
                other._finishedBoardGamePlaythroughs,
                _finishedBoardGamePlaythroughs));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playsTab,
      const DeepCollectionEquality().hash(_finishedBoardGamePlaythroughs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HistoryCopyWith<_$_History> get copyWith =>
      __$$_HistoryCopyWithImpl<_$_History>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PlaysTab playsTab,
            List<GroupedBoardGamePlaythroughs> finishedBoardGamePlaythroughs)
        history,
    required TResult Function(PlaysTab playsTab) statistics,
    required TResult Function(
            PlaysTab playsTab, List<BoardGameDetails> shuffledBoardGames)
        selectGame,
  }) {
    return history(playsTab, finishedBoardGamePlaythroughs);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PlaysTab playsTab,
            List<GroupedBoardGamePlaythroughs> finishedBoardGamePlaythroughs)?
        history,
    TResult? Function(PlaysTab playsTab)? statistics,
    TResult? Function(
            PlaysTab playsTab, List<BoardGameDetails> shuffledBoardGames)?
        selectGame,
  }) {
    return history?.call(playsTab, finishedBoardGamePlaythroughs);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PlaysTab playsTab,
            List<GroupedBoardGamePlaythroughs> finishedBoardGamePlaythroughs)?
        history,
    TResult Function(PlaysTab playsTab)? statistics,
    TResult Function(
            PlaysTab playsTab, List<BoardGameDetails> shuffledBoardGames)?
        selectGame,
    required TResult orElse(),
  }) {
    if (history != null) {
      return history(playsTab, finishedBoardGamePlaythroughs);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_History value) history,
    required TResult Function(_Statistics value) statistics,
    required TResult Function(_SelectGame value) selectGame,
  }) {
    return history(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_History value)? history,
    TResult? Function(_Statistics value)? statistics,
    TResult? Function(_SelectGame value)? selectGame,
  }) {
    return history?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_History value)? history,
    TResult Function(_Statistics value)? statistics,
    TResult Function(_SelectGame value)? selectGame,
    required TResult orElse(),
  }) {
    if (history != null) {
      return history(this);
    }
    return orElse();
  }
}

abstract class _History implements PlaysPageVisualState {
  const factory _History(
      final PlaysTab playsTab,
      final List<GroupedBoardGamePlaythroughs>
          finishedBoardGamePlaythroughs) = _$_History;

  @override
  PlaysTab get playsTab;
  List<GroupedBoardGamePlaythroughs> get finishedBoardGamePlaythroughs;
  @override
  @JsonKey(ignore: true)
  _$$_HistoryCopyWith<_$_History> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_StatisticsCopyWith<$Res>
    implements $PlaysPageVisualStateCopyWith<$Res> {
  factory _$$_StatisticsCopyWith(
          _$_Statistics value, $Res Function(_$_Statistics) then) =
      __$$_StatisticsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PlaysTab playsTab});
}

/// @nodoc
class __$$_StatisticsCopyWithImpl<$Res>
    extends _$PlaysPageVisualStateCopyWithImpl<$Res, _$_Statistics>
    implements _$$_StatisticsCopyWith<$Res> {
  __$$_StatisticsCopyWithImpl(
      _$_Statistics _value, $Res Function(_$_Statistics) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playsTab = null,
  }) {
    return _then(_$_Statistics(
      null == playsTab
          ? _value.playsTab
          : playsTab // ignore: cast_nullable_to_non_nullable
              as PlaysTab,
    ));
  }
}

/// @nodoc

class _$_Statistics implements _Statistics {
  const _$_Statistics(this.playsTab);

  @override
  final PlaysTab playsTab;

  @override
  String toString() {
    return 'PlaysPageVisualState.statistics(playsTab: $playsTab)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Statistics &&
            (identical(other.playsTab, playsTab) ||
                other.playsTab == playsTab));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playsTab);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StatisticsCopyWith<_$_Statistics> get copyWith =>
      __$$_StatisticsCopyWithImpl<_$_Statistics>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PlaysTab playsTab,
            List<GroupedBoardGamePlaythroughs> finishedBoardGamePlaythroughs)
        history,
    required TResult Function(PlaysTab playsTab) statistics,
    required TResult Function(
            PlaysTab playsTab, List<BoardGameDetails> shuffledBoardGames)
        selectGame,
  }) {
    return statistics(playsTab);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PlaysTab playsTab,
            List<GroupedBoardGamePlaythroughs> finishedBoardGamePlaythroughs)?
        history,
    TResult? Function(PlaysTab playsTab)? statistics,
    TResult? Function(
            PlaysTab playsTab, List<BoardGameDetails> shuffledBoardGames)?
        selectGame,
  }) {
    return statistics?.call(playsTab);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PlaysTab playsTab,
            List<GroupedBoardGamePlaythroughs> finishedBoardGamePlaythroughs)?
        history,
    TResult Function(PlaysTab playsTab)? statistics,
    TResult Function(
            PlaysTab playsTab, List<BoardGameDetails> shuffledBoardGames)?
        selectGame,
    required TResult orElse(),
  }) {
    if (statistics != null) {
      return statistics(playsTab);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_History value) history,
    required TResult Function(_Statistics value) statistics,
    required TResult Function(_SelectGame value) selectGame,
  }) {
    return statistics(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_History value)? history,
    TResult? Function(_Statistics value)? statistics,
    TResult? Function(_SelectGame value)? selectGame,
  }) {
    return statistics?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_History value)? history,
    TResult Function(_Statistics value)? statistics,
    TResult Function(_SelectGame value)? selectGame,
    required TResult orElse(),
  }) {
    if (statistics != null) {
      return statistics(this);
    }
    return orElse();
  }
}

abstract class _Statistics implements PlaysPageVisualState {
  const factory _Statistics(final PlaysTab playsTab) = _$_Statistics;

  @override
  PlaysTab get playsTab;
  @override
  @JsonKey(ignore: true)
  _$$_StatisticsCopyWith<_$_Statistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_SelectGameCopyWith<$Res>
    implements $PlaysPageVisualStateCopyWith<$Res> {
  factory _$$_SelectGameCopyWith(
          _$_SelectGame value, $Res Function(_$_SelectGame) then) =
      __$$_SelectGameCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PlaysTab playsTab, List<BoardGameDetails> shuffledBoardGames});
}

/// @nodoc
class __$$_SelectGameCopyWithImpl<$Res>
    extends _$PlaysPageVisualStateCopyWithImpl<$Res, _$_SelectGame>
    implements _$$_SelectGameCopyWith<$Res> {
  __$$_SelectGameCopyWithImpl(
      _$_SelectGame _value, $Res Function(_$_SelectGame) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playsTab = null,
    Object? shuffledBoardGames = null,
  }) {
    return _then(_$_SelectGame(
      null == playsTab
          ? _value.playsTab
          : playsTab // ignore: cast_nullable_to_non_nullable
              as PlaysTab,
      null == shuffledBoardGames
          ? _value._shuffledBoardGames
          : shuffledBoardGames // ignore: cast_nullable_to_non_nullable
              as List<BoardGameDetails>,
    ));
  }
}

/// @nodoc

class _$_SelectGame implements _SelectGame {
  const _$_SelectGame(
      this.playsTab, final List<BoardGameDetails> shuffledBoardGames)
      : _shuffledBoardGames = shuffledBoardGames;

  @override
  final PlaysTab playsTab;
  final List<BoardGameDetails> _shuffledBoardGames;
  @override
  List<BoardGameDetails> get shuffledBoardGames {
    if (_shuffledBoardGames is EqualUnmodifiableListView)
      return _shuffledBoardGames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shuffledBoardGames);
  }

  @override
  String toString() {
    return 'PlaysPageVisualState.selectGame(playsTab: $playsTab, shuffledBoardGames: $shuffledBoardGames)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SelectGame &&
            (identical(other.playsTab, playsTab) ||
                other.playsTab == playsTab) &&
            const DeepCollectionEquality()
                .equals(other._shuffledBoardGames, _shuffledBoardGames));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playsTab,
      const DeepCollectionEquality().hash(_shuffledBoardGames));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SelectGameCopyWith<_$_SelectGame> get copyWith =>
      __$$_SelectGameCopyWithImpl<_$_SelectGame>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PlaysTab playsTab,
            List<GroupedBoardGamePlaythroughs> finishedBoardGamePlaythroughs)
        history,
    required TResult Function(PlaysTab playsTab) statistics,
    required TResult Function(
            PlaysTab playsTab, List<BoardGameDetails> shuffledBoardGames)
        selectGame,
  }) {
    return selectGame(playsTab, shuffledBoardGames);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PlaysTab playsTab,
            List<GroupedBoardGamePlaythroughs> finishedBoardGamePlaythroughs)?
        history,
    TResult? Function(PlaysTab playsTab)? statistics,
    TResult? Function(
            PlaysTab playsTab, List<BoardGameDetails> shuffledBoardGames)?
        selectGame,
  }) {
    return selectGame?.call(playsTab, shuffledBoardGames);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PlaysTab playsTab,
            List<GroupedBoardGamePlaythroughs> finishedBoardGamePlaythroughs)?
        history,
    TResult Function(PlaysTab playsTab)? statistics,
    TResult Function(
            PlaysTab playsTab, List<BoardGameDetails> shuffledBoardGames)?
        selectGame,
    required TResult orElse(),
  }) {
    if (selectGame != null) {
      return selectGame(playsTab, shuffledBoardGames);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_History value) history,
    required TResult Function(_Statistics value) statistics,
    required TResult Function(_SelectGame value) selectGame,
  }) {
    return selectGame(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_History value)? history,
    TResult? Function(_Statistics value)? statistics,
    TResult? Function(_SelectGame value)? selectGame,
  }) {
    return selectGame?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_History value)? history,
    TResult Function(_Statistics value)? statistics,
    TResult Function(_SelectGame value)? selectGame,
    required TResult orElse(),
  }) {
    if (selectGame != null) {
      return selectGame(this);
    }
    return orElse();
  }
}

abstract class _SelectGame implements PlaysPageVisualState {
  const factory _SelectGame(final PlaysTab playsTab,
      final List<BoardGameDetails> shuffledBoardGames) = _$_SelectGame;

  @override
  PlaysTab get playsTab;
  List<BoardGameDetails> get shuffledBoardGames;
  @override
  @JsonKey(ignore: true)
  _$$_SelectGameCopyWith<_$_SelectGame> get copyWith =>
      throw _privateConstructorUsedError;
}
