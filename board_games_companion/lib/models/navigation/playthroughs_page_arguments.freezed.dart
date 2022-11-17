// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'playthroughs_page_arguments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PlaythroughsPageArguments {
  BoardGameDetails get boardGameDetails => throw _privateConstructorUsedError;
  String get boardGameImageHeroId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlaythroughsPageArgumentsCopyWith<PlaythroughsPageArguments> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaythroughsPageArgumentsCopyWith<$Res> {
  factory $PlaythroughsPageArgumentsCopyWith(PlaythroughsPageArguments value,
          $Res Function(PlaythroughsPageArguments) then) =
      _$PlaythroughsPageArgumentsCopyWithImpl<$Res>;
  $Res call({BoardGameDetails boardGameDetails, String boardGameImageHeroId});

  $BoardGameDetailsCopyWith<$Res> get boardGameDetails;
}

/// @nodoc
class _$PlaythroughsPageArgumentsCopyWithImpl<$Res>
    implements $PlaythroughsPageArgumentsCopyWith<$Res> {
  _$PlaythroughsPageArgumentsCopyWithImpl(this._value, this._then);

  final PlaythroughsPageArguments _value;
  // ignore: unused_field
  final $Res Function(PlaythroughsPageArguments) _then;

  @override
  $Res call({
    Object? boardGameDetails = freezed,
    Object? boardGameImageHeroId = freezed,
  }) {
    return _then(_value.copyWith(
      boardGameDetails: boardGameDetails == freezed
          ? _value.boardGameDetails
          : boardGameDetails // ignore: cast_nullable_to_non_nullable
              as BoardGameDetails,
      boardGameImageHeroId: boardGameImageHeroId == freezed
          ? _value.boardGameImageHeroId
          : boardGameImageHeroId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  @override
  $BoardGameDetailsCopyWith<$Res> get boardGameDetails {
    return $BoardGameDetailsCopyWith<$Res>(_value.boardGameDetails, (value) {
      return _then(_value.copyWith(boardGameDetails: value));
    });
  }
}

/// @nodoc
abstract class _$$_PlaythroughsPageArgumentsCopyWith<$Res>
    implements $PlaythroughsPageArgumentsCopyWith<$Res> {
  factory _$$_PlaythroughsPageArgumentsCopyWith(
          _$_PlaythroughsPageArguments value,
          $Res Function(_$_PlaythroughsPageArguments) then) =
      __$$_PlaythroughsPageArgumentsCopyWithImpl<$Res>;
  @override
  $Res call({BoardGameDetails boardGameDetails, String boardGameImageHeroId});

  @override
  $BoardGameDetailsCopyWith<$Res> get boardGameDetails;
}

/// @nodoc
class __$$_PlaythroughsPageArgumentsCopyWithImpl<$Res>
    extends _$PlaythroughsPageArgumentsCopyWithImpl<$Res>
    implements _$$_PlaythroughsPageArgumentsCopyWith<$Res> {
  __$$_PlaythroughsPageArgumentsCopyWithImpl(
      _$_PlaythroughsPageArguments _value,
      $Res Function(_$_PlaythroughsPageArguments) _then)
      : super(_value, (v) => _then(v as _$_PlaythroughsPageArguments));

  @override
  _$_PlaythroughsPageArguments get _value =>
      super._value as _$_PlaythroughsPageArguments;

  @override
  $Res call({
    Object? boardGameDetails = freezed,
    Object? boardGameImageHeroId = freezed,
  }) {
    return _then(_$_PlaythroughsPageArguments(
      boardGameDetails: boardGameDetails == freezed
          ? _value.boardGameDetails
          : boardGameDetails // ignore: cast_nullable_to_non_nullable
              as BoardGameDetails,
      boardGameImageHeroId: boardGameImageHeroId == freezed
          ? _value.boardGameImageHeroId
          : boardGameImageHeroId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_PlaythroughsPageArguments implements _PlaythroughsPageArguments {
  const _$_PlaythroughsPageArguments(
      {required this.boardGameDetails, required this.boardGameImageHeroId});

  @override
  final BoardGameDetails boardGameDetails;
  @override
  final String boardGameImageHeroId;

  @override
  String toString() {
    return 'PlaythroughsPageArguments(boardGameDetails: $boardGameDetails, boardGameImageHeroId: $boardGameImageHeroId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PlaythroughsPageArguments &&
            const DeepCollectionEquality()
                .equals(other.boardGameDetails, boardGameDetails) &&
            const DeepCollectionEquality()
                .equals(other.boardGameImageHeroId, boardGameImageHeroId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(boardGameDetails),
      const DeepCollectionEquality().hash(boardGameImageHeroId));

  @JsonKey(ignore: true)
  @override
  _$$_PlaythroughsPageArgumentsCopyWith<_$_PlaythroughsPageArguments>
      get copyWith => __$$_PlaythroughsPageArgumentsCopyWithImpl<
          _$_PlaythroughsPageArguments>(this, _$identity);
}

abstract class _PlaythroughsPageArguments implements PlaythroughsPageArguments {
  const factory _PlaythroughsPageArguments(
          {required final BoardGameDetails boardGameDetails,
          required final String boardGameImageHeroId}) =
      _$_PlaythroughsPageArguments;

  @override
  BoardGameDetails get boardGameDetails;
  @override
  String get boardGameImageHeroId;
  @override
  @JsonKey(ignore: true)
  _$$_PlaythroughsPageArgumentsCopyWith<_$_PlaythroughsPageArguments>
      get copyWith => throw _privateConstructorUsedError;
}
