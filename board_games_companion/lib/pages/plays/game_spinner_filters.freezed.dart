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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
abstract class _$$GameSpinnerFiltersImplCopyWith<$Res>
    implements $GameSpinnerFiltersCopyWith<$Res> {
  factory _$$GameSpinnerFiltersImplCopyWith(_$GameSpinnerFiltersImpl value,
          $Res Function(_$GameSpinnerFiltersImpl) then) =
      __$$GameSpinnerFiltersImplCopyWithImpl<$Res>;
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
class __$$GameSpinnerFiltersImplCopyWithImpl<$Res>
    extends _$GameSpinnerFiltersCopyWithImpl<$Res, _$GameSpinnerFiltersImpl>
    implements _$$GameSpinnerFiltersImplCopyWith<$Res> {
  __$$GameSpinnerFiltersImplCopyWithImpl(_$GameSpinnerFiltersImpl _value,
      $Res Function(_$GameSpinnerFiltersImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collections = null,
    Object? includeExpansions = null,
    Object? numberOfPlayersFilter = null,
    Object? playtimeFilter = null,
  }) {
    return _then(_$GameSpinnerFiltersImpl(
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

class _$GameSpinnerFiltersImpl extends _GameSpinnerFilters {
  const _$GameSpinnerFiltersImpl(
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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameSpinnerFiltersImpl &&
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
  _$$GameSpinnerFiltersImplCopyWith<_$GameSpinnerFiltersImpl> get copyWith =>
      __$$GameSpinnerFiltersImplCopyWithImpl<_$GameSpinnerFiltersImpl>(
          this, _$identity);
}

abstract class _GameSpinnerFilters extends GameSpinnerFilters {
  const factory _GameSpinnerFilters(
      {required final Set<CollectionType> collections,
      required final bool includeExpansions,
      final NumberOfPlayersFilter numberOfPlayersFilter,
      final PlaytimeFilter playtimeFilter}) = _$GameSpinnerFiltersImpl;
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
  _$$GameSpinnerFiltersImplCopyWith<_$GameSpinnerFiltersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NumberOfPlayersFilter {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() any,
    required TResult Function() solo,
    required TResult Function() couple,
    required TResult Function(int numberOfPlayers) moreOrEqualTo,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? any,
    TResult? Function()? solo,
    TResult? Function()? couple,
    TResult? Function(int numberOfPlayers)? moreOrEqualTo,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? any,
    TResult Function()? solo,
    TResult Function()? couple,
    TResult Function(int numberOfPlayers)? moreOrEqualTo,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_numberOfPlayersAny value) any,
    required TResult Function(_solo value) solo,
    required TResult Function(_couple value) couple,
    required TResult Function(_moreOrEqualTo value) moreOrEqualTo,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_numberOfPlayersAny value)? any,
    TResult? Function(_solo value)? solo,
    TResult? Function(_couple value)? couple,
    TResult? Function(_moreOrEqualTo value)? moreOrEqualTo,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_numberOfPlayersAny value)? any,
    TResult Function(_solo value)? solo,
    TResult Function(_couple value)? couple,
    TResult Function(_moreOrEqualTo value)? moreOrEqualTo,
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
abstract class _$$numberOfPlayersAnyImplCopyWith<$Res> {
  factory _$$numberOfPlayersAnyImplCopyWith(_$numberOfPlayersAnyImpl value,
          $Res Function(_$numberOfPlayersAnyImpl) then) =
      __$$numberOfPlayersAnyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$numberOfPlayersAnyImplCopyWithImpl<$Res>
    extends _$NumberOfPlayersFilterCopyWithImpl<$Res, _$numberOfPlayersAnyImpl>
    implements _$$numberOfPlayersAnyImplCopyWith<$Res> {
  __$$numberOfPlayersAnyImplCopyWithImpl(_$numberOfPlayersAnyImpl _value,
      $Res Function(_$numberOfPlayersAnyImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$numberOfPlayersAnyImpl implements _numberOfPlayersAny {
  const _$numberOfPlayersAnyImpl();

  @override
  String toString() {
    return 'NumberOfPlayersFilter.any()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$numberOfPlayersAnyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() any,
    required TResult Function() solo,
    required TResult Function() couple,
    required TResult Function(int numberOfPlayers) moreOrEqualTo,
  }) {
    return any();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? any,
    TResult? Function()? solo,
    TResult? Function()? couple,
    TResult? Function(int numberOfPlayers)? moreOrEqualTo,
  }) {
    return any?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? any,
    TResult Function()? solo,
    TResult Function()? couple,
    TResult Function(int numberOfPlayers)? moreOrEqualTo,
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
    required TResult Function(_solo value) solo,
    required TResult Function(_couple value) couple,
    required TResult Function(_moreOrEqualTo value) moreOrEqualTo,
  }) {
    return any(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_numberOfPlayersAny value)? any,
    TResult? Function(_solo value)? solo,
    TResult? Function(_couple value)? couple,
    TResult? Function(_moreOrEqualTo value)? moreOrEqualTo,
  }) {
    return any?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_numberOfPlayersAny value)? any,
    TResult Function(_solo value)? solo,
    TResult Function(_couple value)? couple,
    TResult Function(_moreOrEqualTo value)? moreOrEqualTo,
    required TResult orElse(),
  }) {
    if (any != null) {
      return any(this);
    }
    return orElse();
  }
}

abstract class _numberOfPlayersAny implements NumberOfPlayersFilter {
  const factory _numberOfPlayersAny() = _$numberOfPlayersAnyImpl;
}

/// @nodoc
abstract class _$$soloImplCopyWith<$Res> {
  factory _$$soloImplCopyWith(
          _$soloImpl value, $Res Function(_$soloImpl) then) =
      __$$soloImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$soloImplCopyWithImpl<$Res>
    extends _$NumberOfPlayersFilterCopyWithImpl<$Res, _$soloImpl>
    implements _$$soloImplCopyWith<$Res> {
  __$$soloImplCopyWithImpl(_$soloImpl _value, $Res Function(_$soloImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$soloImpl implements _solo {
  const _$soloImpl();

  @override
  String toString() {
    return 'NumberOfPlayersFilter.solo()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$soloImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() any,
    required TResult Function() solo,
    required TResult Function() couple,
    required TResult Function(int numberOfPlayers) moreOrEqualTo,
  }) {
    return solo();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? any,
    TResult? Function()? solo,
    TResult? Function()? couple,
    TResult? Function(int numberOfPlayers)? moreOrEqualTo,
  }) {
    return solo?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? any,
    TResult Function()? solo,
    TResult Function()? couple,
    TResult Function(int numberOfPlayers)? moreOrEqualTo,
    required TResult orElse(),
  }) {
    if (solo != null) {
      return solo();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_numberOfPlayersAny value) any,
    required TResult Function(_solo value) solo,
    required TResult Function(_couple value) couple,
    required TResult Function(_moreOrEqualTo value) moreOrEqualTo,
  }) {
    return solo(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_numberOfPlayersAny value)? any,
    TResult? Function(_solo value)? solo,
    TResult? Function(_couple value)? couple,
    TResult? Function(_moreOrEqualTo value)? moreOrEqualTo,
  }) {
    return solo?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_numberOfPlayersAny value)? any,
    TResult Function(_solo value)? solo,
    TResult Function(_couple value)? couple,
    TResult Function(_moreOrEqualTo value)? moreOrEqualTo,
    required TResult orElse(),
  }) {
    if (solo != null) {
      return solo(this);
    }
    return orElse();
  }
}

abstract class _solo implements NumberOfPlayersFilter {
  const factory _solo() = _$soloImpl;
}

/// @nodoc
abstract class _$$coupleImplCopyWith<$Res> {
  factory _$$coupleImplCopyWith(
          _$coupleImpl value, $Res Function(_$coupleImpl) then) =
      __$$coupleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$coupleImplCopyWithImpl<$Res>
    extends _$NumberOfPlayersFilterCopyWithImpl<$Res, _$coupleImpl>
    implements _$$coupleImplCopyWith<$Res> {
  __$$coupleImplCopyWithImpl(
      _$coupleImpl _value, $Res Function(_$coupleImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$coupleImpl implements _couple {
  const _$coupleImpl();

  @override
  String toString() {
    return 'NumberOfPlayersFilter.couple()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$coupleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() any,
    required TResult Function() solo,
    required TResult Function() couple,
    required TResult Function(int numberOfPlayers) moreOrEqualTo,
  }) {
    return couple();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? any,
    TResult? Function()? solo,
    TResult? Function()? couple,
    TResult? Function(int numberOfPlayers)? moreOrEqualTo,
  }) {
    return couple?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? any,
    TResult Function()? solo,
    TResult Function()? couple,
    TResult Function(int numberOfPlayers)? moreOrEqualTo,
    required TResult orElse(),
  }) {
    if (couple != null) {
      return couple();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_numberOfPlayersAny value) any,
    required TResult Function(_solo value) solo,
    required TResult Function(_couple value) couple,
    required TResult Function(_moreOrEqualTo value) moreOrEqualTo,
  }) {
    return couple(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_numberOfPlayersAny value)? any,
    TResult? Function(_solo value)? solo,
    TResult? Function(_couple value)? couple,
    TResult? Function(_moreOrEqualTo value)? moreOrEqualTo,
  }) {
    return couple?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_numberOfPlayersAny value)? any,
    TResult Function(_solo value)? solo,
    TResult Function(_couple value)? couple,
    TResult Function(_moreOrEqualTo value)? moreOrEqualTo,
    required TResult orElse(),
  }) {
    if (couple != null) {
      return couple(this);
    }
    return orElse();
  }
}

abstract class _couple implements NumberOfPlayersFilter {
  const factory _couple() = _$coupleImpl;
}

/// @nodoc
abstract class _$$moreOrEqualToImplCopyWith<$Res> {
  factory _$$moreOrEqualToImplCopyWith(
          _$moreOrEqualToImpl value, $Res Function(_$moreOrEqualToImpl) then) =
      __$$moreOrEqualToImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int numberOfPlayers});
}

/// @nodoc
class __$$moreOrEqualToImplCopyWithImpl<$Res>
    extends _$NumberOfPlayersFilterCopyWithImpl<$Res, _$moreOrEqualToImpl>
    implements _$$moreOrEqualToImplCopyWith<$Res> {
  __$$moreOrEqualToImplCopyWithImpl(
      _$moreOrEqualToImpl _value, $Res Function(_$moreOrEqualToImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? numberOfPlayers = null,
  }) {
    return _then(_$moreOrEqualToImpl(
      numberOfPlayers: null == numberOfPlayers
          ? _value.numberOfPlayers
          : numberOfPlayers // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$moreOrEqualToImpl implements _moreOrEqualTo {
  const _$moreOrEqualToImpl({required this.numberOfPlayers});

  @override
  final int numberOfPlayers;

  @override
  String toString() {
    return 'NumberOfPlayersFilter.moreOrEqualTo(numberOfPlayers: $numberOfPlayers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$moreOrEqualToImpl &&
            (identical(other.numberOfPlayers, numberOfPlayers) ||
                other.numberOfPlayers == numberOfPlayers));
  }

  @override
  int get hashCode => Object.hash(runtimeType, numberOfPlayers);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$moreOrEqualToImplCopyWith<_$moreOrEqualToImpl> get copyWith =>
      __$$moreOrEqualToImplCopyWithImpl<_$moreOrEqualToImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() any,
    required TResult Function() solo,
    required TResult Function() couple,
    required TResult Function(int numberOfPlayers) moreOrEqualTo,
  }) {
    return moreOrEqualTo(numberOfPlayers);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? any,
    TResult? Function()? solo,
    TResult? Function()? couple,
    TResult? Function(int numberOfPlayers)? moreOrEqualTo,
  }) {
    return moreOrEqualTo?.call(numberOfPlayers);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? any,
    TResult Function()? solo,
    TResult Function()? couple,
    TResult Function(int numberOfPlayers)? moreOrEqualTo,
    required TResult orElse(),
  }) {
    if (moreOrEqualTo != null) {
      return moreOrEqualTo(numberOfPlayers);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_numberOfPlayersAny value) any,
    required TResult Function(_solo value) solo,
    required TResult Function(_couple value) couple,
    required TResult Function(_moreOrEqualTo value) moreOrEqualTo,
  }) {
    return moreOrEqualTo(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_numberOfPlayersAny value)? any,
    TResult? Function(_solo value)? solo,
    TResult? Function(_couple value)? couple,
    TResult? Function(_moreOrEqualTo value)? moreOrEqualTo,
  }) {
    return moreOrEqualTo?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_numberOfPlayersAny value)? any,
    TResult Function(_solo value)? solo,
    TResult Function(_couple value)? couple,
    TResult Function(_moreOrEqualTo value)? moreOrEqualTo,
    required TResult orElse(),
  }) {
    if (moreOrEqualTo != null) {
      return moreOrEqualTo(this);
    }
    return orElse();
  }
}

abstract class _moreOrEqualTo implements NumberOfPlayersFilter {
  const factory _moreOrEqualTo({required final int numberOfPlayers}) =
      _$moreOrEqualToImpl;

  int get numberOfPlayers;
  @JsonKey(ignore: true)
  _$$moreOrEqualToImplCopyWith<_$moreOrEqualToImpl> get copyWith =>
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
abstract class _$$playtimeAnyImplCopyWith<$Res> {
  factory _$$playtimeAnyImplCopyWith(
          _$playtimeAnyImpl value, $Res Function(_$playtimeAnyImpl) then) =
      __$$playtimeAnyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$playtimeAnyImplCopyWithImpl<$Res>
    extends _$PlaytimeFilterCopyWithImpl<$Res, _$playtimeAnyImpl>
    implements _$$playtimeAnyImplCopyWith<$Res> {
  __$$playtimeAnyImplCopyWithImpl(
      _$playtimeAnyImpl _value, $Res Function(_$playtimeAnyImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$playtimeAnyImpl implements _playtimeAny {
  const _$playtimeAnyImpl();

  @override
  String toString() {
    return 'PlaytimeFilter.any()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$playtimeAnyImpl);
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
  const factory _playtimeAny() = _$playtimeAnyImpl;
}

/// @nodoc
abstract class _$$lessThanImplCopyWith<$Res> {
  factory _$$lessThanImplCopyWith(
          _$lessThanImpl value, $Res Function(_$lessThanImpl) then) =
      __$$lessThanImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int playtimeInMinutes});
}

/// @nodoc
class __$$lessThanImplCopyWithImpl<$Res>
    extends _$PlaytimeFilterCopyWithImpl<$Res, _$lessThanImpl>
    implements _$$lessThanImplCopyWith<$Res> {
  __$$lessThanImplCopyWithImpl(
      _$lessThanImpl _value, $Res Function(_$lessThanImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playtimeInMinutes = null,
  }) {
    return _then(_$lessThanImpl(
      playtimeInMinutes: null == playtimeInMinutes
          ? _value.playtimeInMinutes
          : playtimeInMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$lessThanImpl implements _lessThan {
  const _$lessThanImpl({required this.playtimeInMinutes});

  @override
  final int playtimeInMinutes;

  @override
  String toString() {
    return 'PlaytimeFilter.lessThan(playtimeInMinutes: $playtimeInMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$lessThanImpl &&
            (identical(other.playtimeInMinutes, playtimeInMinutes) ||
                other.playtimeInMinutes == playtimeInMinutes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playtimeInMinutes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$lessThanImplCopyWith<_$lessThanImpl> get copyWith =>
      __$$lessThanImplCopyWithImpl<_$lessThanImpl>(this, _$identity);

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
  const factory _lessThan({required final int playtimeInMinutes}) =
      _$lessThanImpl;

  int get playtimeInMinutes;
  @JsonKey(ignore: true)
  _$$lessThanImplCopyWith<_$lessThanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
