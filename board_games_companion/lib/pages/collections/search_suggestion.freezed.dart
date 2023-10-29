// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

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
      _$SearchSuggestionCopyWithImpl<$Res, SearchSuggestion>;
  @useResult
  $Res call({String suggestion, SuggestionType type});
}

/// @nodoc
class _$SearchSuggestionCopyWithImpl<$Res, $Val extends SearchSuggestion>
    implements $SearchSuggestionCopyWith<$Res> {
  _$SearchSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suggestion = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      suggestion: null == suggestion
          ? _value.suggestion
          : suggestion // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SuggestionType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchSuggestionImplCopyWith<$Res>
    implements $SearchSuggestionCopyWith<$Res> {
  factory _$$SearchSuggestionImplCopyWith(_$SearchSuggestionImpl value,
          $Res Function(_$SearchSuggestionImpl) then) =
      __$$SearchSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String suggestion, SuggestionType type});
}

/// @nodoc
class __$$SearchSuggestionImplCopyWithImpl<$Res>
    extends _$SearchSuggestionCopyWithImpl<$Res, _$SearchSuggestionImpl>
    implements _$$SearchSuggestionImplCopyWith<$Res> {
  __$$SearchSuggestionImplCopyWithImpl(_$SearchSuggestionImpl _value,
      $Res Function(_$SearchSuggestionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suggestion = null,
    Object? type = null,
  }) {
    return _then(_$SearchSuggestionImpl(
      suggestion: null == suggestion
          ? _value.suggestion
          : suggestion // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SuggestionType,
    ));
  }
}

/// @nodoc

class _$SearchSuggestionImpl implements _SearchSuggestion {
  const _$SearchSuggestionImpl({required this.suggestion, required this.type});

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
            other is _$SearchSuggestionImpl &&
            (identical(other.suggestion, suggestion) ||
                other.suggestion == suggestion) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, suggestion, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchSuggestionImplCopyWith<_$SearchSuggestionImpl> get copyWith =>
      __$$SearchSuggestionImplCopyWithImpl<_$SearchSuggestionImpl>(
          this, _$identity);
}

abstract class _SearchSuggestion implements SearchSuggestion {
  const factory _SearchSuggestion(
      {required final String suggestion,
      required final SuggestionType type}) = _$SearchSuggestionImpl;

  @override
  String get suggestion;
  @override
  SuggestionType get type;
  @override
  @JsonKey(ignore: true)
  _$$SearchSuggestionImplCopyWith<_$SearchSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
