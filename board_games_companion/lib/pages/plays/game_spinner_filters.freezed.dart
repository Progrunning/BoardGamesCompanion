// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_spinner_filters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GameSpinnerFilters {
  Set<CollectionType> get collections => throw _privateConstructorUsedError;
  bool get includeExpansions => throw _privateConstructorUsedError;
  NumberOfPlayersFilter get numberOfPlayersFilter =>
      throw _privateConstructorUsedError;
  PlaytimeFilter get playtimeFilter => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GameSpinnerFiltersCopyWith<GameSpinnerFilters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameSpinnerFiltersCopyWith<$Res> {
  factory $GameSpinnerFiltersCopyWith(
          GameSpinnerFilters value, $Res Function(GameSpinnerFilters) then) =
      _$GameSpinnerFiltersCopyWithImpl<$Res, GameSpinnerFilters>;
  @useResult
  $Res call(
      {Set<CollectionType> collections,
      bool includeExpansions,
      NumberOfPlayersFilter numberOfPlayersFilter,
      PlaytimeFilter playtimeFilter});

  $NumberOfPlayersFilterCopyWith<$Res> get numberOfPlayersFilter;
  $PlaytimeFilterCopyWith<$Res> get playtimeFilter;
}

/// @nodoc
class _$GameSpinnerFiltersCopyWithImpl<$Res, $Val extends GameSpinnerFilters>
    implements $GameSpinnerFiltersCopyWith<$Res> {
  _$GameSpinnerFiltersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collections = null,
    Object? includeExpansions = null,
    Object? numberOfPlayersFilter = null,
    Object? playtimeFilter = null,
  }) {
    return _then(_value.copyWith(
      collections: null == collections
          ? _value.collections
          : collections // ignore: cast_nullable_to_non_nullable
              as Set<CollectionType>,
      includeExpansions: null == includeExpansions
          ? _value.includeExpansions
          : includeExpansions // ignore: cast_nullable_to_non_nullable
              as bool,
      numberOfPlayersFilter: null == numberOfPlayersFilter
          ? _value.numberOfPlayersFilter
          : numberOfPlayersFilter // ignore: cast_nullable_to_non_nullable
              as NumberOfPlayersFilter,
      playtimeFilter: null == playtimeFilter
          ? _value.playtimeFilter
          : playtimeFilter // ignore: cast_nullable_to_non_nullable
              as PlaytimeFilter,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NumberOfPlayersFilterCopyWith<$Res> get numberOfPlayersFilter {
    return $NumberOfPlayersFilterCopyWith<$Res>(_value.numberOfPlayersFilter,
        (value) {
      return _then(_value.copyWith(numberOfPlayersFilter: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlaytimeFilterCopyWith<$Res> get playtimeFilter {
    return $PlaytimeFilterCopyWith<$Res>(_value.playtimeFilter, (value) {
      return _then(_value.copyWith(playtimeFilter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_GameSpinnerFiltersCopyWith<$Res>
    implements $GameSpinnerFiltersCopyWith<$Res> {
  factory _$$_GameSpinnerFiltersCopyWith(_$_GameSpinnerFilters value,
          $Res Function(_$_GameSpinnerFilters) then) =
      __$$_GameSpinnerFiltersCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Set<CollectionType> collections,
      bool includeExpansions,
      NumberOfPlayersFilter numberOfPlayersFilter,
      PlaytimeFilter playtimeFilter});

  @override
  $NumberOfPlayersFilterCopyWith<$Res> get numberOfPlayersFilter;
  @override
  $PlaytimeFilterCopyWith<$Res> get playtimeFilter;
}

/// @nodoc
class __$$_GameSpinnerFiltersCopyWithImpl<$Res>
    extends _$GameSpinnerFiltersCopyWithImpl<$Res, _$_GameSpinnerFilters>
    implements _$$_GameSpinnerFiltersCopyWith<$Res> {
  __$$_GameSpinnerFiltersCopyWithImpl(
      _$_GameSpinnerFilters _value, $Res Function(_$_GameSpinnerFilters) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collections = null,
    Object? includeExpansions = null,
    Object? numberOfPlayersFilter = null,
    Object? playtimeFilter = null,
  }) {
    return _then(_$_GameSpinnerFilters(
      collections: null == collections
          ? _value._collections
          : collections // ignore: cast_nullable_to_non_nullable
              as Set<CollectionType>,
      includeExpansions: null == includeExpansions
          ? _value.includeExpansions
          : includeExpansions // ignore: cast_nullable_to_non_nullable
              as bool,
      numberOfPlayersFilter: null == numberOfPlayersFilter
          ? _value.numberOfPlayersFilter
          : numberOfPlayersFilter // ignore: cast_nullable_to_non_nullable
              as NumberOfPlayersFilter,
      playtimeFilter: null == playtimeFilter
          ? _value.playtimeFilter
          : playtimeFilter // ignore: cast_nullable_to_non_nullable
              as PlaytimeFilter,
    ));
  }
}

/// @nodoc

class _$_GameSpinnerFilters extends _GameSpinnerFilters {
  const _$_GameSpinnerFilters(
      {required final Set<CollectionType> collections,
      required this.includeExpansions,
      this.numberOfPlayersFilter = const NumberOfPlayersFilter.any(),
      this.playtimeFilter = const PlaytimeFilter.any()})
      : _collections = collections,
        super._();

  final Set<CollectionType> _collections;
  @override
  Set<CollectionType> get collections {
    if (_collections is EqualUnmodifiableSetView) return _collections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_collections);
  }

  @override
  final bool includeExpansions;
  @override
  @JsonKey()
  final NumberOfPlayersFilter numberOfPlayersFilter;
  @override
  @JsonKey()
  final PlaytimeFilter playtimeFilter;

  @override
  String toString() {
    return 'GameSpinnerFilters(collections: $collections, includeExpansions: $includeExpansions, numberOfPlayersFilter: $numberOfPlayersFilter, playtimeFilter: $playtimeFilter)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GameSpinnerFilters &&
            const DeepCollectionEquality()
                .equals(other._collections, _collections) &&
            (identical(other.includeExpansions, includeExpansions) ||
                other.includeExpansions == includeExpansions) &&
            (identical(other.numberOfPlayersFilter, numberOfPlayersFilter) ||
                other.numberOfPlayersFilter == numberOfPlayersFilter) &&
            (identical(other.playtimeFilter, playtimeFilter) ||
                other.playtimeFilter == playtimeFilter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_collections),
      includeExpansions,
      numberOfPlayersFilter,
      playtimeFilter);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GameSpinnerFiltersCopyWith<_$_GameSpinnerFilters> get copyWith =>
      __$$_GameSpinnerFiltersCopyWithImpl<_$_GameSpinnerFilters>(
          this, _$identity);
}

abstract class _GameSpinnerFilters extends GameSpinnerFilters {
  const factory _GameSpinnerFilters(
      {required final Set<CollectionType> collections,
      required final bool includeExpansions,
      final NumberOfPlayersFilter numberOfPlayersFilter,
      final PlaytimeFilter playtimeFilter}) = _$_GameSpinnerFilters;
  const _GameSpinnerFilters._() : super._();

  @override
  Set<CollectionType> get collections;
  @override
  bool get includeExpansions;
  @override
  NumberOfPlayersFilter get numberOfPlayersFilter;
  @override
  PlaytimeFilter get playtimeFilter;
  @override
  @JsonKey(ignore: true)
  _$$_GameSpinnerFiltersCopyWith<_$_GameSpinnerFilters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NumberOfPlayersFilter {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() any,
    required TResult Function() singlePlayerOnly,
    required TResult Function(int moreThanNumberOfPlayers) moreThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? any,
    TResult? Function()? singlePlayerOnly,
    TResult? Function(int moreThanNumberOfPlayers)? moreThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? any,
    TResult Function()? singlePlayerOnly,
    TResult Function(int moreThanNumberOfPlayers)? moreThan,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_numberOfPlayersAny value) any,
    required TResult Function(_singlePlayerOnly value) singlePlayerOnly,
    required TResult Function(_moreThan value) moreThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_numberOfPlayersAny value)? any,
    TResult? Function(_singlePlayerOnly value)? singlePlayerOnly,
    TResult? Function(_moreThan value)? moreThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_numberOfPlayersAny value)? any,
    TResult Function(_singlePlayerOnly value)? singlePlayerOnly,
    TResult Function(_moreThan value)? moreThan,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NumberOfPlayersFilterCopyWith<$Res> {
  factory $NumberOfPlayersFilterCopyWith(NumberOfPlayersFilter value,
          $Res Function(NumberOfPlayersFilter) then) =
      _$NumberOfPlayersFilterCopyWithImpl<$Res, NumberOfPlayersFilter>;
}

/// @nodoc
class _$NumberOfPlayersFilterCopyWithImpl<$Res,
        $Val extends NumberOfPlayersFilter>
    implements $NumberOfPlayersFilterCopyWith<$Res> {
  _$NumberOfPlayersFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_numberOfPlayersAnyCopyWith<$Res> {
  factory _$$_numberOfPlayersAnyCopyWith(_$_numberOfPlayersAny value,
          $Res Function(_$_numberOfPlayersAny) then) =
      __$$_numberOfPlayersAnyCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_numberOfPlayersAnyCopyWithImpl<$Res>
    extends _$NumberOfPlayersFilterCopyWithImpl<$Res, _$_numberOfPlayersAny>
    implements _$$_numberOfPlayersAnyCopyWith<$Res> {
  __$$_numberOfPlayersAnyCopyWithImpl(
      _$_numberOfPlayersAny _value, $Res Function(_$_numberOfPlayersAny) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_numberOfPlayersAny implements _numberOfPlayersAny {
  const _$_numberOfPlayersAny();

  @override
  String toString() {
    return 'NumberOfPlayersFilter.any()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_numberOfPlayersAny);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() any,
    required TResult Function() singlePlayerOnly,
    required TResult Function(int moreThanNumberOfPlayers) moreThan,
  }) {
    return any();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? any,
    TResult? Function()? singlePlayerOnly,
    TResult? Function(int moreThanNumberOfPlayers)? moreThan,
  }) {
    return any?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? any,
    TResult Function()? singlePlayerOnly,
    TResult Function(int moreThanNumberOfPlayers)? moreThan,
    required TResult orElse(),
  }) {
    if (any != null) {
      return any();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_numberOfPlayersAny value) any,
    required TResult Function(_singlePlayerOnly value) singlePlayerOnly,
    required TResult Function(_moreThan value) moreThan,
  }) {
    return any(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_numberOfPlayersAny value)? any,
    TResult? Function(_singlePlayerOnly value)? singlePlayerOnly,
    TResult? Function(_moreThan value)? moreThan,
  }) {
    return any?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_numberOfPlayersAny value)? any,
    TResult Function(_singlePlayerOnly value)? singlePlayerOnly,
    TResult Function(_moreThan value)? moreThan,
    required TResult orElse(),
  }) {
    if (any != null) {
      return any(this);
    }
    return orElse();
  }
}

abstract class _numberOfPlayersAny implements NumberOfPlayersFilter {
  const factory _numberOfPlayersAny() = _$_numberOfPlayersAny;
}

/// @nodoc
abstract class _$$_singlePlayerOnlyCopyWith<$Res> {
  factory _$$_singlePlayerOnlyCopyWith(
          _$_singlePlayerOnly value, $Res Function(_$_singlePlayerOnly) then) =
      __$$_singlePlayerOnlyCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_singlePlayerOnlyCopyWithImpl<$Res>
    extends _$NumberOfPlayersFilterCopyWithImpl<$Res, _$_singlePlayerOnly>
    implements _$$_singlePlayerOnlyCopyWith<$Res> {
  __$$_singlePlayerOnlyCopyWithImpl(
      _$_singlePlayerOnly _value, $Res Function(_$_singlePlayerOnly) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_singlePlayerOnly implements _singlePlayerOnly {
  const _$_singlePlayerOnly();

  @override
  String toString() {
    return 'NumberOfPlayersFilter.singlePlayerOnly()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_singlePlayerOnly);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() any,
    required TResult Function() singlePlayerOnly,
    required TResult Function(int moreThanNumberOfPlayers) moreThan,
  }) {
    return singlePlayerOnly();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? any,
    TResult? Function()? singlePlayerOnly,
    TResult? Function(int moreThanNumberOfPlayers)? moreThan,
  }) {
    return singlePlayerOnly?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? any,
    TResult Function()? singlePlayerOnly,
    TResult Function(int moreThanNumberOfPlayers)? moreThan,
    required TResult orElse(),
  }) {
    if (singlePlayerOnly != null) {
      return singlePlayerOnly();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_numberOfPlayersAny value) any,
    required TResult Function(_singlePlayerOnly value) singlePlayerOnly,
    required TResult Function(_moreThan value) moreThan,
  }) {
    return singlePlayerOnly(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_numberOfPlayersAny value)? any,
    TResult? Function(_singlePlayerOnly value)? singlePlayerOnly,
    TResult? Function(_moreThan value)? moreThan,
  }) {
    return singlePlayerOnly?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_numberOfPlayersAny value)? any,
    TResult Function(_singlePlayerOnly value)? singlePlayerOnly,
    TResult Function(_moreThan value)? moreThan,
    required TResult orElse(),
  }) {
    if (singlePlayerOnly != null) {
      return singlePlayerOnly(this);
    }
    return orElse();
  }
}

abstract class _singlePlayerOnly implements NumberOfPlayersFilter {
  const factory _singlePlayerOnly() = _$_singlePlayerOnly;
}

/// @nodoc
abstract class _$$_moreThanCopyWith<$Res> {
  factory _$$_moreThanCopyWith(
          _$_moreThan value, $Res Function(_$_moreThan) then) =
      __$$_moreThanCopyWithImpl<$Res>;
  @useResult
  $Res call({int moreThanNumberOfPlayers});
}

/// @nodoc
class __$$_moreThanCopyWithImpl<$Res>
    extends _$NumberOfPlayersFilterCopyWithImpl<$Res, _$_moreThan>
    implements _$$_moreThanCopyWith<$Res> {
  __$$_moreThanCopyWithImpl(
      _$_moreThan _value, $Res Function(_$_moreThan) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moreThanNumberOfPlayers = null,
  }) {
    return _then(_$_moreThan(
      moreThanNumberOfPlayers: null == moreThanNumberOfPlayers
          ? _value.moreThanNumberOfPlayers
          : moreThanNumberOfPlayers // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_moreThan implements _moreThan {
  const _$_moreThan({required this.moreThanNumberOfPlayers});

  @override
  final int moreThanNumberOfPlayers;

  @override
  String toString() {
    return 'NumberOfPlayersFilter.moreThan(moreThanNumberOfPlayers: $moreThanNumberOfPlayers)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_moreThan &&
            (identical(
                    other.moreThanNumberOfPlayers, moreThanNumberOfPlayers) ||
                other.moreThanNumberOfPlayers == moreThanNumberOfPlayers));
  }

  @override
  int get hashCode => Object.hash(runtimeType, moreThanNumberOfPlayers);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_moreThanCopyWith<_$_moreThan> get copyWith =>
      __$$_moreThanCopyWithImpl<_$_moreThan>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() any,
    required TResult Function() singlePlayerOnly,
    required TResult Function(int moreThanNumberOfPlayers) moreThan,
  }) {
    return moreThan(moreThanNumberOfPlayers);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? any,
    TResult? Function()? singlePlayerOnly,
    TResult? Function(int moreThanNumberOfPlayers)? moreThan,
  }) {
    return moreThan?.call(moreThanNumberOfPlayers);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? any,
    TResult Function()? singlePlayerOnly,
    TResult Function(int moreThanNumberOfPlayers)? moreThan,
    required TResult orElse(),
  }) {
    if (moreThan != null) {
      return moreThan(moreThanNumberOfPlayers);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_numberOfPlayersAny value) any,
    required TResult Function(_singlePlayerOnly value) singlePlayerOnly,
    required TResult Function(_moreThan value) moreThan,
  }) {
    return moreThan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_numberOfPlayersAny value)? any,
    TResult? Function(_singlePlayerOnly value)? singlePlayerOnly,
    TResult? Function(_moreThan value)? moreThan,
  }) {
    return moreThan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_numberOfPlayersAny value)? any,
    TResult Function(_singlePlayerOnly value)? singlePlayerOnly,
    TResult Function(_moreThan value)? moreThan,
    required TResult orElse(),
  }) {
    if (moreThan != null) {
      return moreThan(this);
    }
    return orElse();
  }
}

abstract class _moreThan implements NumberOfPlayersFilter {
  const factory _moreThan({required final int moreThanNumberOfPlayers}) =
      _$_moreThan;

  int get moreThanNumberOfPlayers;
  @JsonKey(ignore: true)
  _$$_moreThanCopyWith<_$_moreThan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PlaytimeFilter {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() any,
    required TResult Function(int playtimeInMinutes) lessThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? any,
    TResult? Function(int playtimeInMinutes)? lessThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? any,
    TResult Function(int playtimeInMinutes)? lessThan,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_playtimeAny value) any,
    required TResult Function(_lessThan value) lessThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_playtimeAny value)? any,
    TResult? Function(_lessThan value)? lessThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_playtimeAny value)? any,
    TResult Function(_lessThan value)? lessThan,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaytimeFilterCopyWith<$Res> {
  factory $PlaytimeFilterCopyWith(
          PlaytimeFilter value, $Res Function(PlaytimeFilter) then) =
      _$PlaytimeFilterCopyWithImpl<$Res, PlaytimeFilter>;
}

/// @nodoc
class _$PlaytimeFilterCopyWithImpl<$Res, $Val extends PlaytimeFilter>
    implements $PlaytimeFilterCopyWith<$Res> {
  _$PlaytimeFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_playtimeAnyCopyWith<$Res> {
  factory _$$_playtimeAnyCopyWith(
          _$_playtimeAny value, $Res Function(_$_playtimeAny) then) =
      __$$_playtimeAnyCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_playtimeAnyCopyWithImpl<$Res>
    extends _$PlaytimeFilterCopyWithImpl<$Res, _$_playtimeAny>
    implements _$$_playtimeAnyCopyWith<$Res> {
  __$$_playtimeAnyCopyWithImpl(
      _$_playtimeAny _value, $Res Function(_$_playtimeAny) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_playtimeAny implements _playtimeAny {
  const _$_playtimeAny();

  @override
  String toString() {
    return 'PlaytimeFilter.any()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_playtimeAny);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() any,
    required TResult Function(int playtimeInMinutes) lessThan,
  }) {
    return any();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? any,
    TResult? Function(int playtimeInMinutes)? lessThan,
  }) {
    return any?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? any,
    TResult Function(int playtimeInMinutes)? lessThan,
    required TResult orElse(),
  }) {
    if (any != null) {
      return any();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_playtimeAny value) any,
    required TResult Function(_lessThan value) lessThan,
  }) {
    return any(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_playtimeAny value)? any,
    TResult? Function(_lessThan value)? lessThan,
  }) {
    return any?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_playtimeAny value)? any,
    TResult Function(_lessThan value)? lessThan,
    required TResult orElse(),
  }) {
    if (any != null) {
      return any(this);
    }
    return orElse();
  }
}

abstract class _playtimeAny implements PlaytimeFilter {
  const factory _playtimeAny() = _$_playtimeAny;
}

/// @nodoc
abstract class _$$_lessThanCopyWith<$Res> {
  factory _$$_lessThanCopyWith(
          _$_lessThan value, $Res Function(_$_lessThan) then) =
      __$$_lessThanCopyWithImpl<$Res>;
  @useResult
  $Res call({int playtimeInMinutes});
}

/// @nodoc
class __$$_lessThanCopyWithImpl<$Res>
    extends _$PlaytimeFilterCopyWithImpl<$Res, _$_lessThan>
    implements _$$_lessThanCopyWith<$Res> {
  __$$_lessThanCopyWithImpl(
      _$_lessThan _value, $Res Function(_$_lessThan) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playtimeInMinutes = null,
  }) {
    return _then(_$_lessThan(
      playtimeInMinutes: null == playtimeInMinutes
          ? _value.playtimeInMinutes
          : playtimeInMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_lessThan implements _lessThan {
  const _$_lessThan({required this.playtimeInMinutes});

  @override
  final int playtimeInMinutes;

  @override
  String toString() {
    return 'PlaytimeFilter.lessThan(playtimeInMinutes: $playtimeInMinutes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_lessThan &&
            (identical(other.playtimeInMinutes, playtimeInMinutes) ||
                other.playtimeInMinutes == playtimeInMinutes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playtimeInMinutes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_lessThanCopyWith<_$_lessThan> get copyWith =>
      __$$_lessThanCopyWithImpl<_$_lessThan>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() any,
    required TResult Function(int playtimeInMinutes) lessThan,
  }) {
    return lessThan(playtimeInMinutes);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? any,
    TResult? Function(int playtimeInMinutes)? lessThan,
  }) {
    return lessThan?.call(playtimeInMinutes);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? any,
    TResult Function(int playtimeInMinutes)? lessThan,
    required TResult orElse(),
  }) {
    if (lessThan != null) {
      return lessThan(playtimeInMinutes);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_playtimeAny value) any,
    required TResult Function(_lessThan value) lessThan,
  }) {
    return lessThan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_playtimeAny value)? any,
    TResult? Function(_lessThan value)? lessThan,
  }) {
    return lessThan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_playtimeAny value)? any,
    TResult Function(_lessThan value)? lessThan,
    required TResult orElse(),
  }) {
    if (lessThan != null) {
      return lessThan(this);
    }
    return orElse();
  }
}

abstract class _lessThan implements PlaytimeFilter {
  const factory _lessThan({required final int playtimeInMinutes}) = _$_lessThan;

  int get playtimeInMinutes;
  @JsonKey(ignore: true)
  _$$_lessThanCopyWith<_$_lessThan> get copyWith =>
      throw _privateConstructorUsedError;
}
