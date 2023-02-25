// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

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

  @JsonKey(ignore: true)
  $GameSpinnerFiltersCopyWith<GameSpinnerFilters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameSpinnerFiltersCopyWith<$Res> {
  factory $GameSpinnerFiltersCopyWith(
          GameSpinnerFilters value, $Res Function(GameSpinnerFilters) then) =
      _$GameSpinnerFiltersCopyWithImpl<$Res>;
  $Res call(
      {Set<CollectionType> collections,
      bool includeExpansions,
      NumberOfPlayersFilter numberOfPlayersFilter});

  $NumberOfPlayersFilterCopyWith<$Res> get numberOfPlayersFilter;
}

/// @nodoc
class _$GameSpinnerFiltersCopyWithImpl<$Res>
    implements $GameSpinnerFiltersCopyWith<$Res> {
  _$GameSpinnerFiltersCopyWithImpl(this._value, this._then);

  final GameSpinnerFilters _value;
  // ignore: unused_field
  final $Res Function(GameSpinnerFilters) _then;

  @override
  $Res call({
    Object? collections = freezed,
    Object? includeExpansions = freezed,
    Object? numberOfPlayersFilter = freezed,
  }) {
    return _then(_value.copyWith(
      collections: collections == freezed
          ? _value.collections
          : collections // ignore: cast_nullable_to_non_nullable
              as Set<CollectionType>,
      includeExpansions: includeExpansions == freezed
          ? _value.includeExpansions
          : includeExpansions // ignore: cast_nullable_to_non_nullable
              as bool,
      numberOfPlayersFilter: numberOfPlayersFilter == freezed
          ? _value.numberOfPlayersFilter
          : numberOfPlayersFilter // ignore: cast_nullable_to_non_nullable
              as NumberOfPlayersFilter,
    ));
  }

  @override
  $NumberOfPlayersFilterCopyWith<$Res> get numberOfPlayersFilter {
    return $NumberOfPlayersFilterCopyWith<$Res>(_value.numberOfPlayersFilter,
        (value) {
      return _then(_value.copyWith(numberOfPlayersFilter: value));
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
  $Res call(
      {Set<CollectionType> collections,
      bool includeExpansions,
      NumberOfPlayersFilter numberOfPlayersFilter});

  @override
  $NumberOfPlayersFilterCopyWith<$Res> get numberOfPlayersFilter;
}

/// @nodoc
class __$$_GameSpinnerFiltersCopyWithImpl<$Res>
    extends _$GameSpinnerFiltersCopyWithImpl<$Res>
    implements _$$_GameSpinnerFiltersCopyWith<$Res> {
  __$$_GameSpinnerFiltersCopyWithImpl(
      _$_GameSpinnerFilters _value, $Res Function(_$_GameSpinnerFilters) _then)
      : super(_value, (v) => _then(v as _$_GameSpinnerFilters));

  @override
  _$_GameSpinnerFilters get _value => super._value as _$_GameSpinnerFilters;

  @override
  $Res call({
    Object? collections = freezed,
    Object? includeExpansions = freezed,
    Object? numberOfPlayersFilter = freezed,
  }) {
    return _then(_$_GameSpinnerFilters(
      collections: collections == freezed
          ? _value._collections
          : collections // ignore: cast_nullable_to_non_nullable
              as Set<CollectionType>,
      includeExpansions: includeExpansions == freezed
          ? _value.includeExpansions
          : includeExpansions // ignore: cast_nullable_to_non_nullable
              as bool,
      numberOfPlayersFilter: numberOfPlayersFilter == freezed
          ? _value.numberOfPlayersFilter
          : numberOfPlayersFilter // ignore: cast_nullable_to_non_nullable
              as NumberOfPlayersFilter,
    ));
  }
}

/// @nodoc

class _$_GameSpinnerFilters extends _GameSpinnerFilters {
  const _$_GameSpinnerFilters(
      {required final Set<CollectionType> collections,
      required this.includeExpansions,
      this.numberOfPlayersFilter = const NumberOfPlayersFilter.any()})
      : _collections = collections,
        super._();

  final Set<CollectionType> _collections;
  @override
  Set<CollectionType> get collections {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_collections);
  }

  @override
  final bool includeExpansions;
  @override
  @JsonKey()
  final NumberOfPlayersFilter numberOfPlayersFilter;

  @override
  String toString() {
    return 'GameSpinnerFilters(collections: $collections, includeExpansions: $includeExpansions, numberOfPlayersFilter: $numberOfPlayersFilter)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GameSpinnerFilters &&
            const DeepCollectionEquality()
                .equals(other._collections, _collections) &&
            const DeepCollectionEquality()
                .equals(other.includeExpansions, includeExpansions) &&
            const DeepCollectionEquality()
                .equals(other.numberOfPlayersFilter, numberOfPlayersFilter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_collections),
      const DeepCollectionEquality().hash(includeExpansions),
      const DeepCollectionEquality().hash(numberOfPlayersFilter));

  @JsonKey(ignore: true)
  @override
  _$$_GameSpinnerFiltersCopyWith<_$_GameSpinnerFilters> get copyWith =>
      __$$_GameSpinnerFiltersCopyWithImpl<_$_GameSpinnerFilters>(
          this, _$identity);
}

abstract class _GameSpinnerFilters extends GameSpinnerFilters {
  const factory _GameSpinnerFilters(
          {required final Set<CollectionType> collections,
          required final bool includeExpansions,
          final NumberOfPlayersFilter numberOfPlayersFilter}) =
      _$_GameSpinnerFilters;
  const _GameSpinnerFilters._() : super._();

  @override
  Set<CollectionType> get collections;
  @override
  bool get includeExpansions;
  @override
  NumberOfPlayersFilter get numberOfPlayersFilter;
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
    TResult Function()? any,
    TResult Function()? singlePlayerOnly,
    TResult Function(int moreThanNumberOfPlayers)? moreThan,
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
    required TResult Function(_any value) any,
    required TResult Function(_singlePlayerOnly value) singlePlayerOnly,
    required TResult Function(_moreThan value) moreThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_any value)? any,
    TResult Function(_singlePlayerOnly value)? singlePlayerOnly,
    TResult Function(_moreThan value)? moreThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_any value)? any,
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
      _$NumberOfPlayersFilterCopyWithImpl<$Res>;
}

/// @nodoc
class _$NumberOfPlayersFilterCopyWithImpl<$Res>
    implements $NumberOfPlayersFilterCopyWith<$Res> {
  _$NumberOfPlayersFilterCopyWithImpl(this._value, this._then);

  final NumberOfPlayersFilter _value;
  // ignore: unused_field
  final $Res Function(NumberOfPlayersFilter) _then;
}

/// @nodoc
abstract class _$$_anyCopyWith<$Res> {
  factory _$$_anyCopyWith(_$_any value, $Res Function(_$_any) then) =
      __$$_anyCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_anyCopyWithImpl<$Res>
    extends _$NumberOfPlayersFilterCopyWithImpl<$Res>
    implements _$$_anyCopyWith<$Res> {
  __$$_anyCopyWithImpl(_$_any _value, $Res Function(_$_any) _then)
      : super(_value, (v) => _then(v as _$_any));

  @override
  _$_any get _value => super._value as _$_any;
}

/// @nodoc

class _$_any implements _any {
  const _$_any();

  @override
  String toString() {
    return 'NumberOfPlayersFilter.any()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_any);
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
    TResult Function()? any,
    TResult Function()? singlePlayerOnly,
    TResult Function(int moreThanNumberOfPlayers)? moreThan,
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
    required TResult Function(_any value) any,
    required TResult Function(_singlePlayerOnly value) singlePlayerOnly,
    required TResult Function(_moreThan value) moreThan,
  }) {
    return any(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_any value)? any,
    TResult Function(_singlePlayerOnly value)? singlePlayerOnly,
    TResult Function(_moreThan value)? moreThan,
  }) {
    return any?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_any value)? any,
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

abstract class _any implements NumberOfPlayersFilter {
  const factory _any() = _$_any;
}

/// @nodoc
abstract class _$$_singlePlayerOnlyCopyWith<$Res> {
  factory _$$_singlePlayerOnlyCopyWith(
          _$_singlePlayerOnly value, $Res Function(_$_singlePlayerOnly) then) =
      __$$_singlePlayerOnlyCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_singlePlayerOnlyCopyWithImpl<$Res>
    extends _$NumberOfPlayersFilterCopyWithImpl<$Res>
    implements _$$_singlePlayerOnlyCopyWith<$Res> {
  __$$_singlePlayerOnlyCopyWithImpl(
      _$_singlePlayerOnly _value, $Res Function(_$_singlePlayerOnly) _then)
      : super(_value, (v) => _then(v as _$_singlePlayerOnly));

  @override
  _$_singlePlayerOnly get _value => super._value as _$_singlePlayerOnly;
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
    TResult Function()? any,
    TResult Function()? singlePlayerOnly,
    TResult Function(int moreThanNumberOfPlayers)? moreThan,
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
    required TResult Function(_any value) any,
    required TResult Function(_singlePlayerOnly value) singlePlayerOnly,
    required TResult Function(_moreThan value) moreThan,
  }) {
    return singlePlayerOnly(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_any value)? any,
    TResult Function(_singlePlayerOnly value)? singlePlayerOnly,
    TResult Function(_moreThan value)? moreThan,
  }) {
    return singlePlayerOnly?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_any value)? any,
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
  $Res call({int moreThanNumberOfPlayers});
}

/// @nodoc
class __$$_moreThanCopyWithImpl<$Res>
    extends _$NumberOfPlayersFilterCopyWithImpl<$Res>
    implements _$$_moreThanCopyWith<$Res> {
  __$$_moreThanCopyWithImpl(
      _$_moreThan _value, $Res Function(_$_moreThan) _then)
      : super(_value, (v) => _then(v as _$_moreThan));

  @override
  _$_moreThan get _value => super._value as _$_moreThan;

  @override
  $Res call({
    Object? moreThanNumberOfPlayers = freezed,
  }) {
    return _then(_$_moreThan(
      moreThanNumberOfPlayers: moreThanNumberOfPlayers == freezed
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
            const DeepCollectionEquality().equals(
                other.moreThanNumberOfPlayers, moreThanNumberOfPlayers));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(moreThanNumberOfPlayers));

  @JsonKey(ignore: true)
  @override
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
    TResult Function()? any,
    TResult Function()? singlePlayerOnly,
    TResult Function(int moreThanNumberOfPlayers)? moreThan,
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
    required TResult Function(_any value) any,
    required TResult Function(_singlePlayerOnly value) singlePlayerOnly,
    required TResult Function(_moreThan value) moreThan,
  }) {
    return moreThan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_any value)? any,
    TResult Function(_singlePlayerOnly value)? singlePlayerOnly,
    TResult Function(_moreThan value)? moreThan,
  }) {
    return moreThan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_any value)? any,
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
