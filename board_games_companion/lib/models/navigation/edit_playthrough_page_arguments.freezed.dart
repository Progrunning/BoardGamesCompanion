// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'edit_playthrough_page_arguments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$EditPlaythroughPageArguments {
  String get playthroughId => throw _privateConstructorUsedError;
  String get boardGameId => throw _privateConstructorUsedError;
  String get goBackPageRoute => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EditPlaythroughPageArgumentsCopyWith<EditPlaythroughPageArguments>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditPlaythroughPageArgumentsCopyWith<$Res> {
  factory $EditPlaythroughPageArgumentsCopyWith(
          EditPlaythroughPageArguments value,
          $Res Function(EditPlaythroughPageArguments) then) =
      _$EditPlaythroughPageArgumentsCopyWithImpl<$Res>;
  $Res call({String playthroughId, String boardGameId, String goBackPageRoute});
}

/// @nodoc
class _$EditPlaythroughPageArgumentsCopyWithImpl<$Res>
    implements $EditPlaythroughPageArgumentsCopyWith<$Res> {
  _$EditPlaythroughPageArgumentsCopyWithImpl(this._value, this._then);

  final EditPlaythroughPageArguments _value;
  // ignore: unused_field
  final $Res Function(EditPlaythroughPageArguments) _then;

  @override
  $Res call({
    Object? playthroughId = freezed,
    Object? boardGameId = freezed,
    Object? goBackPageRoute = freezed,
  }) {
    return _then(_value.copyWith(
      playthroughId: playthroughId == freezed
          ? _value.playthroughId
          : playthroughId // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameId: boardGameId == freezed
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      goBackPageRoute: goBackPageRoute == freezed
          ? _value.goBackPageRoute
          : goBackPageRoute // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_EditPlaythroughPageArgumentsCopyWith<$Res>
    implements $EditPlaythroughPageArgumentsCopyWith<$Res> {
  factory _$$_EditPlaythroughPageArgumentsCopyWith(
          _$_EditPlaythroughPageArguments value,
          $Res Function(_$_EditPlaythroughPageArguments) then) =
      __$$_EditPlaythroughPageArgumentsCopyWithImpl<$Res>;
  @override
  $Res call({String playthroughId, String boardGameId, String goBackPageRoute});
}

/// @nodoc
class __$$_EditPlaythroughPageArgumentsCopyWithImpl<$Res>
    extends _$EditPlaythroughPageArgumentsCopyWithImpl<$Res>
    implements _$$_EditPlaythroughPageArgumentsCopyWith<$Res> {
  __$$_EditPlaythroughPageArgumentsCopyWithImpl(
      _$_EditPlaythroughPageArguments _value,
      $Res Function(_$_EditPlaythroughPageArguments) _then)
      : super(_value, (v) => _then(v as _$_EditPlaythroughPageArguments));

  @override
  _$_EditPlaythroughPageArguments get _value =>
      super._value as _$_EditPlaythroughPageArguments;

  @override
  $Res call({
    Object? playthroughId = freezed,
    Object? boardGameId = freezed,
    Object? goBackPageRoute = freezed,
  }) {
    return _then(_$_EditPlaythroughPageArguments(
      playthroughId: playthroughId == freezed
          ? _value.playthroughId
          : playthroughId // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameId: boardGameId == freezed
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      goBackPageRoute: goBackPageRoute == freezed
          ? _value.goBackPageRoute
          : goBackPageRoute // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_EditPlaythroughPageArguments implements _EditPlaythroughPageArguments {
  const _$_EditPlaythroughPageArguments(
      {required this.playthroughId,
      required this.boardGameId,
      required this.goBackPageRoute});

  @override
  final String playthroughId;
  @override
  final String boardGameId;
  @override
  final String goBackPageRoute;

  @override
  String toString() {
    return 'EditPlaythroughPageArguments(playthroughId: $playthroughId, boardGameId: $boardGameId, goBackPageRoute: $goBackPageRoute)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EditPlaythroughPageArguments &&
            const DeepCollectionEquality()
                .equals(other.playthroughId, playthroughId) &&
            const DeepCollectionEquality()
                .equals(other.boardGameId, boardGameId) &&
            const DeepCollectionEquality()
                .equals(other.goBackPageRoute, goBackPageRoute));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(playthroughId),
      const DeepCollectionEquality().hash(boardGameId),
      const DeepCollectionEquality().hash(goBackPageRoute));

  @JsonKey(ignore: true)
  @override
  _$$_EditPlaythroughPageArgumentsCopyWith<_$_EditPlaythroughPageArguments>
      get copyWith => __$$_EditPlaythroughPageArgumentsCopyWithImpl<
          _$_EditPlaythroughPageArguments>(this, _$identity);
}

abstract class _EditPlaythroughPageArguments
    implements EditPlaythroughPageArguments {
  const factory _EditPlaythroughPageArguments(
      {required final String playthroughId,
      required final String boardGameId,
      required final String goBackPageRoute}) = _$_EditPlaythroughPageArguments;

  @override
  String get playthroughId;
  @override
  String get boardGameId;
  @override
  String get goBackPageRoute;
  @override
  @JsonKey(ignore: true)
  _$$_EditPlaythroughPageArgumentsCopyWith<_$_EditPlaythroughPageArguments>
      get copyWith => throw _privateConstructorUsedError;
}
