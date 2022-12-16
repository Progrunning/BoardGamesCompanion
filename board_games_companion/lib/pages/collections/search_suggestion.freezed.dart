// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'search_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SearchSuggestion {
  String get suggestion => throw _privateConstructorUsedError;
  SuggestionType get type => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SearchSuggestionCopyWith<SearchSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchSuggestionCopyWith<$Res> {
  factory $SearchSuggestionCopyWith(
          SearchSuggestion value, $Res Function(SearchSuggestion) then) =
      _$SearchSuggestionCopyWithImpl<$Res>;
  $Res call({String suggestion, SuggestionType type});
}

/// @nodoc
class _$SearchSuggestionCopyWithImpl<$Res>
    implements $SearchSuggestionCopyWith<$Res> {
  _$SearchSuggestionCopyWithImpl(this._value, this._then);

  final SearchSuggestion _value;
  // ignore: unused_field
  final $Res Function(SearchSuggestion) _then;

  @override
  $Res call({
    Object? suggestion = freezed,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      suggestion: suggestion == freezed
          ? _value.suggestion
          : suggestion // ignore: cast_nullable_to_non_nullable
              as String,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SuggestionType,
    ));
  }
}

/// @nodoc
abstract class _$$_SearchSuggestionCopyWith<$Res>
    implements $SearchSuggestionCopyWith<$Res> {
  factory _$$_SearchSuggestionCopyWith(
          _$_SearchSuggestion value, $Res Function(_$_SearchSuggestion) then) =
      __$$_SearchSuggestionCopyWithImpl<$Res>;
  @override
  $Res call({String suggestion, SuggestionType type});
}

/// @nodoc
class __$$_SearchSuggestionCopyWithImpl<$Res>
    extends _$SearchSuggestionCopyWithImpl<$Res>
    implements _$$_SearchSuggestionCopyWith<$Res> {
  __$$_SearchSuggestionCopyWithImpl(
      _$_SearchSuggestion _value, $Res Function(_$_SearchSuggestion) _then)
      : super(_value, (v) => _then(v as _$_SearchSuggestion));

  @override
  _$_SearchSuggestion get _value => super._value as _$_SearchSuggestion;

  @override
  $Res call({
    Object? suggestion = freezed,
    Object? type = freezed,
  }) {
    return _then(_$_SearchSuggestion(
      suggestion: suggestion == freezed
          ? _value.suggestion
          : suggestion // ignore: cast_nullable_to_non_nullable
              as String,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SuggestionType,
    ));
  }
}

/// @nodoc

class _$_SearchSuggestion implements _SearchSuggestion {
  const _$_SearchSuggestion({required this.suggestion, required this.type});

  @override
  final String suggestion;
  @override
  final SuggestionType type;

  @override
  String toString() {
    return 'SearchSuggestion(suggestion: $suggestion, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SearchSuggestion &&
            const DeepCollectionEquality()
                .equals(other.suggestion, suggestion) &&
            const DeepCollectionEquality().equals(other.type, type));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(suggestion),
      const DeepCollectionEquality().hash(type));

  @JsonKey(ignore: true)
  @override
  _$$_SearchSuggestionCopyWith<_$_SearchSuggestion> get copyWith =>
      __$$_SearchSuggestionCopyWithImpl<_$_SearchSuggestion>(this, _$identity);
}

abstract class _SearchSuggestion implements SearchSuggestion {
  const factory _SearchSuggestion(
      {required final String suggestion,
      required final SuggestionType type}) = _$_SearchSuggestion;

  @override
  String get suggestion;
  @override
  SuggestionType get type;
  @override
  @JsonKey(ignore: true)
  _$$_SearchSuggestionCopyWith<_$_SearchSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}
