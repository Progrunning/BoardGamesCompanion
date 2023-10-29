// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playthrough_players_selection_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PlaythroughPlayersSelectionResult {
  List<Player> get players => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Player> players) selectedPlayers,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Player> players)? selectedPlayers,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Player> players)? selectedPlayers,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_selectedPlayers value) selectedPlayers,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_selectedPlayers value)? selectedPlayers,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_selectedPlayers value)? selectedPlayers,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlaythroughPlayersSelectionResultCopyWith<PlaythroughPlayersSelectionResult>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaythroughPlayersSelectionResultCopyWith<$Res> {
  factory $PlaythroughPlayersSelectionResultCopyWith(
          PlaythroughPlayersSelectionResult value,
          $Res Function(PlaythroughPlayersSelectionResult) then) =
      _$PlaythroughPlayersSelectionResultCopyWithImpl<$Res,
          PlaythroughPlayersSelectionResult>;
  @useResult
  $Res call({List<Player> players});
}

/// @nodoc
class _$PlaythroughPlayersSelectionResultCopyWithImpl<$Res,
        $Val extends PlaythroughPlayersSelectionResult>
    implements $PlaythroughPlayersSelectionResultCopyWith<$Res> {
  _$PlaythroughPlayersSelectionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? players = null,
  }) {
    return _then(_value.copyWith(
      players: null == players
          ? _value.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<Player>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$selectedPlayersImplCopyWith<$Res>
    implements $PlaythroughPlayersSelectionResultCopyWith<$Res> {
  factory _$$selectedPlayersImplCopyWith(_$selectedPlayersImpl value,
          $Res Function(_$selectedPlayersImpl) then) =
      __$$selectedPlayersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Player> players});
}

/// @nodoc
class __$$selectedPlayersImplCopyWithImpl<$Res>
    extends _$PlaythroughPlayersSelectionResultCopyWithImpl<$Res,
        _$selectedPlayersImpl> implements _$$selectedPlayersImplCopyWith<$Res> {
  __$$selectedPlayersImplCopyWithImpl(
      _$selectedPlayersImpl _value, $Res Function(_$selectedPlayersImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? players = null,
  }) {
    return _then(_$selectedPlayersImpl(
      players: null == players
          ? _value._players
          : players // ignore: cast_nullable_to_non_nullable
              as List<Player>,
    ));
  }
}

/// @nodoc

class _$selectedPlayersImpl implements _selectedPlayers {
  const _$selectedPlayersImpl({required final List<Player> players})
      : _players = players;

  final List<Player> _players;
  @override
  List<Player> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  String toString() {
    return 'PlaythroughPlayersSelectionResult.selectedPlayers(players: $players)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$selectedPlayersImpl &&
            const DeepCollectionEquality().equals(other._players, _players));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_players));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$selectedPlayersImplCopyWith<_$selectedPlayersImpl> get copyWith =>
      __$$selectedPlayersImplCopyWithImpl<_$selectedPlayersImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Player> players) selectedPlayers,
  }) {
    return selectedPlayers(players);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Player> players)? selectedPlayers,
  }) {
    return selectedPlayers?.call(players);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Player> players)? selectedPlayers,
    required TResult orElse(),
  }) {
    if (selectedPlayers != null) {
      return selectedPlayers(players);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_selectedPlayers value) selectedPlayers,
  }) {
    return selectedPlayers(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_selectedPlayers value)? selectedPlayers,
  }) {
    return selectedPlayers?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_selectedPlayers value)? selectedPlayers,
    required TResult orElse(),
  }) {
    if (selectedPlayers != null) {
      return selectedPlayers(this);
    }
    return orElse();
  }
}

abstract class _selectedPlayers implements PlaythroughPlayersSelectionResult {
  const factory _selectedPlayers({required final List<Player> players}) =
      _$selectedPlayersImpl;

  @override
  List<Player> get players;
  @override
  @JsonKey(ignore: true)
  _$$selectedPlayersImplCopyWith<_$selectedPlayersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
