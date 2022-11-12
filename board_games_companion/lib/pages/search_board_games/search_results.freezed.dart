// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'search_results.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SearchResults {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<BoardGame> boardGames) results,
    required TResult Function(String searchPhrase) searching,
    required TResult Function() failure,
    required TResult Function() init,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(List<BoardGame> boardGames)? results,
    TResult Function(String searchPhrase)? searching,
    TResult Function()? failure,
    TResult Function()? init,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<BoardGame> boardGames)? results,
    TResult Function(String searchPhrase)? searching,
    TResult Function()? failure,
    TResult Function()? init,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Results value) results,
    required TResult Function(_Searching value) searching,
    required TResult Function(_Failure value) failure,
    required TResult Function(_Init value) init,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Results value)? results,
    TResult Function(_Searching value)? searching,
    TResult Function(_Failure value)? failure,
    TResult Function(_Init value)? init,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Results value)? results,
    TResult Function(_Searching value)? searching,
    TResult Function(_Failure value)? failure,
    TResult Function(_Init value)? init,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultsCopyWith<$Res> {
  factory $SearchResultsCopyWith(
          SearchResults value, $Res Function(SearchResults) then) =
      _$SearchResultsCopyWithImpl<$Res>;
}

/// @nodoc
class _$SearchResultsCopyWithImpl<$Res>
    implements $SearchResultsCopyWith<$Res> {
  _$SearchResultsCopyWithImpl(this._value, this._then);

  final SearchResults _value;
  // ignore: unused_field
  final $Res Function(SearchResults) _then;
}

/// @nodoc
abstract class _$$_ResultsCopyWith<$Res> {
  factory _$$_ResultsCopyWith(
          _$_Results value, $Res Function(_$_Results) then) =
      __$$_ResultsCopyWithImpl<$Res>;
  $Res call({List<BoardGame> boardGames});
}

/// @nodoc
class __$$_ResultsCopyWithImpl<$Res> extends _$SearchResultsCopyWithImpl<$Res>
    implements _$$_ResultsCopyWith<$Res> {
  __$$_ResultsCopyWithImpl(_$_Results _value, $Res Function(_$_Results) _then)
      : super(_value, (v) => _then(v as _$_Results));

  @override
  _$_Results get _value => super._value as _$_Results;

  @override
  $Res call({
    Object? boardGames = freezed,
  }) {
    return _then(_$_Results(
      boardGames == freezed
          ? _value._boardGames
          : boardGames // ignore: cast_nullable_to_non_nullable
              as List<BoardGame>,
    ));
  }
}

/// @nodoc

class _$_Results implements _Results {
  const _$_Results(final List<BoardGame> boardGames) : _boardGames = boardGames;

  final List<BoardGame> _boardGames;
  @override
  List<BoardGame> get boardGames {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_boardGames);
  }

  @override
  String toString() {
    return 'SearchResults.results(boardGames: $boardGames)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Results &&
            const DeepCollectionEquality()
                .equals(other._boardGames, _boardGames));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_boardGames));

  @JsonKey(ignore: true)
  @override
  _$$_ResultsCopyWith<_$_Results> get copyWith =>
      __$$_ResultsCopyWithImpl<_$_Results>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<BoardGame> boardGames) results,
    required TResult Function(String searchPhrase) searching,
    required TResult Function() failure,
    required TResult Function() init,
  }) {
    return results(boardGames);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(List<BoardGame> boardGames)? results,
    TResult Function(String searchPhrase)? searching,
    TResult Function()? failure,
    TResult Function()? init,
  }) {
    return results?.call(boardGames);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<BoardGame> boardGames)? results,
    TResult Function(String searchPhrase)? searching,
    TResult Function()? failure,
    TResult Function()? init,
    required TResult orElse(),
  }) {
    if (results != null) {
      return results(boardGames);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Results value) results,
    required TResult Function(_Searching value) searching,
    required TResult Function(_Failure value) failure,
    required TResult Function(_Init value) init,
  }) {
    return results(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Results value)? results,
    TResult Function(_Searching value)? searching,
    TResult Function(_Failure value)? failure,
    TResult Function(_Init value)? init,
  }) {
    return results?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Results value)? results,
    TResult Function(_Searching value)? searching,
    TResult Function(_Failure value)? failure,
    TResult Function(_Init value)? init,
    required TResult orElse(),
  }) {
    if (results != null) {
      return results(this);
    }
    return orElse();
  }
}

abstract class _Results implements SearchResults {
  const factory _Results(final List<BoardGame> boardGames) = _$_Results;

  List<BoardGame> get boardGames;
  @JsonKey(ignore: true)
  _$$_ResultsCopyWith<_$_Results> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_SearchingCopyWith<$Res> {
  factory _$$_SearchingCopyWith(
          _$_Searching value, $Res Function(_$_Searching) then) =
      __$$_SearchingCopyWithImpl<$Res>;
  $Res call({String searchPhrase});
}

/// @nodoc
class __$$_SearchingCopyWithImpl<$Res> extends _$SearchResultsCopyWithImpl<$Res>
    implements _$$_SearchingCopyWith<$Res> {
  __$$_SearchingCopyWithImpl(
      _$_Searching _value, $Res Function(_$_Searching) _then)
      : super(_value, (v) => _then(v as _$_Searching));

  @override
  _$_Searching get _value => super._value as _$_Searching;

  @override
  $Res call({
    Object? searchPhrase = freezed,
  }) {
    return _then(_$_Searching(
      searchPhrase == freezed
          ? _value.searchPhrase
          : searchPhrase // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Searching implements _Searching {
  const _$_Searching(this.searchPhrase);

  @override
  final String searchPhrase;

  @override
  String toString() {
    return 'SearchResults.searching(searchPhrase: $searchPhrase)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Searching &&
            const DeepCollectionEquality()
                .equals(other.searchPhrase, searchPhrase));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(searchPhrase));

  @JsonKey(ignore: true)
  @override
  _$$_SearchingCopyWith<_$_Searching> get copyWith =>
      __$$_SearchingCopyWithImpl<_$_Searching>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<BoardGame> boardGames) results,
    required TResult Function(String searchPhrase) searching,
    required TResult Function() failure,
    required TResult Function() init,
  }) {
    return searching(searchPhrase);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(List<BoardGame> boardGames)? results,
    TResult Function(String searchPhrase)? searching,
    TResult Function()? failure,
    TResult Function()? init,
  }) {
    return searching?.call(searchPhrase);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<BoardGame> boardGames)? results,
    TResult Function(String searchPhrase)? searching,
    TResult Function()? failure,
    TResult Function()? init,
    required TResult orElse(),
  }) {
    if (searching != null) {
      return searching(searchPhrase);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Results value) results,
    required TResult Function(_Searching value) searching,
    required TResult Function(_Failure value) failure,
    required TResult Function(_Init value) init,
  }) {
    return searching(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Results value)? results,
    TResult Function(_Searching value)? searching,
    TResult Function(_Failure value)? failure,
    TResult Function(_Init value)? init,
  }) {
    return searching?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Results value)? results,
    TResult Function(_Searching value)? searching,
    TResult Function(_Failure value)? failure,
    TResult Function(_Init value)? init,
    required TResult orElse(),
  }) {
    if (searching != null) {
      return searching(this);
    }
    return orElse();
  }
}

abstract class _Searching implements SearchResults {
  const factory _Searching(final String searchPhrase) = _$_Searching;

  String get searchPhrase;
  @JsonKey(ignore: true)
  _$$_SearchingCopyWith<_$_Searching> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_FailureCopyWith<$Res> {
  factory _$$_FailureCopyWith(
          _$_Failure value, $Res Function(_$_Failure) then) =
      __$$_FailureCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_FailureCopyWithImpl<$Res> extends _$SearchResultsCopyWithImpl<$Res>
    implements _$$_FailureCopyWith<$Res> {
  __$$_FailureCopyWithImpl(_$_Failure _value, $Res Function(_$_Failure) _then)
      : super(_value, (v) => _then(v as _$_Failure));

  @override
  _$_Failure get _value => super._value as _$_Failure;
}

/// @nodoc

class _$_Failure implements _Failure {
  const _$_Failure();

  @override
  String toString() {
    return 'SearchResults.failure()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Failure);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<BoardGame> boardGames) results,
    required TResult Function(String searchPhrase) searching,
    required TResult Function() failure,
    required TResult Function() init,
  }) {
    return failure();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(List<BoardGame> boardGames)? results,
    TResult Function(String searchPhrase)? searching,
    TResult Function()? failure,
    TResult Function()? init,
  }) {
    return failure?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<BoardGame> boardGames)? results,
    TResult Function(String searchPhrase)? searching,
    TResult Function()? failure,
    TResult Function()? init,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Results value) results,
    required TResult Function(_Searching value) searching,
    required TResult Function(_Failure value) failure,
    required TResult Function(_Init value) init,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Results value)? results,
    TResult Function(_Searching value)? searching,
    TResult Function(_Failure value)? failure,
    TResult Function(_Init value)? init,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Results value)? results,
    TResult Function(_Searching value)? searching,
    TResult Function(_Failure value)? failure,
    TResult Function(_Init value)? init,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class _Failure implements SearchResults {
  const factory _Failure() = _$_Failure;
}

/// @nodoc
abstract class _$$_InitCopyWith<$Res> {
  factory _$$_InitCopyWith(_$_Init value, $Res Function(_$_Init) then) =
      __$$_InitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_InitCopyWithImpl<$Res> extends _$SearchResultsCopyWithImpl<$Res>
    implements _$$_InitCopyWith<$Res> {
  __$$_InitCopyWithImpl(_$_Init _value, $Res Function(_$_Init) _then)
      : super(_value, (v) => _then(v as _$_Init));

  @override
  _$_Init get _value => super._value as _$_Init;
}

/// @nodoc

class _$_Init implements _Init {
  const _$_Init();

  @override
  String toString() {
    return 'SearchResults.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Init);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<BoardGame> boardGames) results,
    required TResult Function(String searchPhrase) searching,
    required TResult Function() failure,
    required TResult Function() init,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(List<BoardGame> boardGames)? results,
    TResult Function(String searchPhrase)? searching,
    TResult Function()? failure,
    TResult Function()? init,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<BoardGame> boardGames)? results,
    TResult Function(String searchPhrase)? searching,
    TResult Function()? failure,
    TResult Function()? init,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Results value) results,
    required TResult Function(_Searching value) searching,
    required TResult Function(_Failure value) failure,
    required TResult Function(_Init value) init,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Results value)? results,
    TResult Function(_Searching value)? searching,
    TResult Function(_Failure value)? failure,
    TResult Function(_Init value)? init,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Results value)? results,
    TResult Function(_Searching value)? searching,
    TResult Function(_Failure value)? failure,
    TResult Function(_Init value)? init,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _Init implements SearchResults {
  const factory _Init() = _$_Init;
}
