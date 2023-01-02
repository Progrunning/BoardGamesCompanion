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

  @JsonKey(ignore: true)
  $GameSpinnerFiltersCopyWith<GameSpinnerFilters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameSpinnerFiltersCopyWith<$Res> {
  factory $GameSpinnerFiltersCopyWith(
          GameSpinnerFilters value, $Res Function(GameSpinnerFilters) then) =
      _$GameSpinnerFiltersCopyWithImpl<$Res>;
  $Res call({Set<CollectionType> collections, bool includeExpansions});
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
    ));
  }
}

/// @nodoc
abstract class _$$_GameSpinnerFiltersCopyWith<$Res>
    implements $GameSpinnerFiltersCopyWith<$Res> {
  factory _$$_GameSpinnerFiltersCopyWith(_$_GameSpinnerFilters value,
          $Res Function(_$_GameSpinnerFilters) then) =
      __$$_GameSpinnerFiltersCopyWithImpl<$Res>;
  @override
  $Res call({Set<CollectionType> collections, bool includeExpansions});
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
    ));
  }
}

/// @nodoc

class _$_GameSpinnerFilters extends _GameSpinnerFilters {
  const _$_GameSpinnerFilters(
      {required final Set<CollectionType> collections,
      required this.includeExpansions})
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
  String toString() {
    return 'GameSpinnerFilters(collections: $collections, includeExpansions: $includeExpansions)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GameSpinnerFilters &&
            const DeepCollectionEquality()
                .equals(other._collections, _collections) &&
            const DeepCollectionEquality()
                .equals(other.includeExpansions, includeExpansions));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_collections),
      const DeepCollectionEquality().hash(includeExpansions));

  @JsonKey(ignore: true)
  @override
  _$$_GameSpinnerFiltersCopyWith<_$_GameSpinnerFilters> get copyWith =>
      __$$_GameSpinnerFiltersCopyWithImpl<_$_GameSpinnerFilters>(
          this, _$identity);
}

abstract class _GameSpinnerFilters extends GameSpinnerFilters {
  const factory _GameSpinnerFilters(
      {required final Set<CollectionType> collections,
      required final bool includeExpansions}) = _$_GameSpinnerFilters;
  const _GameSpinnerFilters._() : super._();

  @override
  Set<CollectionType> get collections;
  @override
  bool get includeExpansions;
  @override
  @JsonKey(ignore: true)
  _$$_GameSpinnerFiltersCopyWith<_$_GameSpinnerFilters> get copyWith =>
      throw _privateConstructorUsedError;
}
