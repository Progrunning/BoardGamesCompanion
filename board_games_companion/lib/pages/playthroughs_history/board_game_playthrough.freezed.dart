// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'board_game_playthrough.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BoardGamePlaythrough {
  PlaythroughDetails get playthrough => throw _privateConstructorUsedError;
  BoardGameDetails get boardGameDetails => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BoardGamePlaythroughCopyWith<BoardGamePlaythrough> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardGamePlaythroughCopyWith<$Res> {
  factory $BoardGamePlaythroughCopyWith(BoardGamePlaythrough value,
          $Res Function(BoardGamePlaythrough) then) =
      _$BoardGamePlaythroughCopyWithImpl<$Res>;
  $Res call(
      {PlaythroughDetails playthrough, BoardGameDetails boardGameDetails});

  $PlaythroughDetailsCopyWith<$Res> get playthrough;
  $BoardGameDetailsCopyWith<$Res> get boardGameDetails;
}

/// @nodoc
class _$BoardGamePlaythroughCopyWithImpl<$Res>
    implements $BoardGamePlaythroughCopyWith<$Res> {
  _$BoardGamePlaythroughCopyWithImpl(this._value, this._then);

  final BoardGamePlaythrough _value;
  // ignore: unused_field
  final $Res Function(BoardGamePlaythrough) _then;

  @override
  $Res call({
    Object? playthrough = freezed,
    Object? boardGameDetails = freezed,
  }) {
    return _then(_value.copyWith(
      playthrough: playthrough == freezed
          ? _value.playthrough
          : playthrough // ignore: cast_nullable_to_non_nullable
              as PlaythroughDetails,
      boardGameDetails: boardGameDetails == freezed
          ? _value.boardGameDetails
          : boardGameDetails // ignore: cast_nullable_to_non_nullable
              as BoardGameDetails,
    ));
  }

  @override
  $PlaythroughDetailsCopyWith<$Res> get playthrough {
    return $PlaythroughDetailsCopyWith<$Res>(_value.playthrough, (value) {
      return _then(_value.copyWith(playthrough: value));
    });
  }

  @override
  $BoardGameDetailsCopyWith<$Res> get boardGameDetails {
    return $BoardGameDetailsCopyWith<$Res>(_value.boardGameDetails, (value) {
      return _then(_value.copyWith(boardGameDetails: value));
    });
  }
}

/// @nodoc
abstract class _$$_BoardGamePlaythroughCopyWith<$Res>
    implements $BoardGamePlaythroughCopyWith<$Res> {
  factory _$$_BoardGamePlaythroughCopyWith(_$_BoardGamePlaythrough value,
          $Res Function(_$_BoardGamePlaythrough) then) =
      __$$_BoardGamePlaythroughCopyWithImpl<$Res>;
  @override
  $Res call(
      {PlaythroughDetails playthrough, BoardGameDetails boardGameDetails});

  @override
  $PlaythroughDetailsCopyWith<$Res> get playthrough;
  @override
  $BoardGameDetailsCopyWith<$Res> get boardGameDetails;
}

/// @nodoc
class __$$_BoardGamePlaythroughCopyWithImpl<$Res>
    extends _$BoardGamePlaythroughCopyWithImpl<$Res>
    implements _$$_BoardGamePlaythroughCopyWith<$Res> {
  __$$_BoardGamePlaythroughCopyWithImpl(_$_BoardGamePlaythrough _value,
      $Res Function(_$_BoardGamePlaythrough) _then)
      : super(_value, (v) => _then(v as _$_BoardGamePlaythrough));

  @override
  _$_BoardGamePlaythrough get _value => super._value as _$_BoardGamePlaythrough;

  @override
  $Res call({
    Object? playthrough = freezed,
    Object? boardGameDetails = freezed,
  }) {
    return _then(_$_BoardGamePlaythrough(
      playthrough: playthrough == freezed
          ? _value.playthrough
          : playthrough // ignore: cast_nullable_to_non_nullable
              as PlaythroughDetails,
      boardGameDetails: boardGameDetails == freezed
          ? _value.boardGameDetails
          : boardGameDetails // ignore: cast_nullable_to_non_nullable
              as BoardGameDetails,
    ));
  }
}

/// @nodoc

class _$_BoardGamePlaythrough implements _BoardGamePlaythrough {
  const _$_BoardGamePlaythrough(
      {required this.playthrough, required this.boardGameDetails});

  @override
  final PlaythroughDetails playthrough;
  @override
  final BoardGameDetails boardGameDetails;

  @override
  String toString() {
    return 'BoardGamePlaythrough(playthrough: $playthrough, boardGameDetails: $boardGameDetails)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BoardGamePlaythrough &&
            const DeepCollectionEquality()
                .equals(other.playthrough, playthrough) &&
            const DeepCollectionEquality()
                .equals(other.boardGameDetails, boardGameDetails));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(playthrough),
      const DeepCollectionEquality().hash(boardGameDetails));

  @JsonKey(ignore: true)
  @override
  _$$_BoardGamePlaythroughCopyWith<_$_BoardGamePlaythrough> get copyWith =>
      __$$_BoardGamePlaythroughCopyWithImpl<_$_BoardGamePlaythrough>(
          this, _$identity);
}

abstract class _BoardGamePlaythrough implements BoardGamePlaythrough {
  const factory _BoardGamePlaythrough(
          {required final PlaythroughDetails playthrough,
          required final BoardGameDetails boardGameDetails}) =
      _$_BoardGamePlaythrough;

  @override
  PlaythroughDetails get playthrough;
  @override
  BoardGameDetails get boardGameDetails;
  @override
  @JsonKey(ignore: true)
  _$$_BoardGamePlaythroughCopyWith<_$_BoardGamePlaythrough> get copyWith =>
      throw _privateConstructorUsedError;
}
