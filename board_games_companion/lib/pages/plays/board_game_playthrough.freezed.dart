// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

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
      _$BoardGamePlaythroughCopyWithImpl<$Res, BoardGamePlaythrough>;
  @useResult
  $Res call(
      {PlaythroughDetails playthrough, BoardGameDetails boardGameDetails});

  $PlaythroughDetailsCopyWith<$Res> get playthrough;
  $BoardGameDetailsCopyWith<$Res> get boardGameDetails;
}

/// @nodoc
class _$BoardGamePlaythroughCopyWithImpl<$Res,
        $Val extends BoardGamePlaythrough>
    implements $BoardGamePlaythroughCopyWith<$Res> {
  _$BoardGamePlaythroughCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playthrough = null,
    Object? boardGameDetails = null,
  }) {
    return _then(_value.copyWith(
      playthrough: null == playthrough
          ? _value.playthrough
          : playthrough // ignore: cast_nullable_to_non_nullable
              as PlaythroughDetails,
      boardGameDetails: null == boardGameDetails
          ? _value.boardGameDetails
          : boardGameDetails // ignore: cast_nullable_to_non_nullable
              as BoardGameDetails,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlaythroughDetailsCopyWith<$Res> get playthrough {
    return $PlaythroughDetailsCopyWith<$Res>(_value.playthrough, (value) {
      return _then(_value.copyWith(playthrough: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BoardGameDetailsCopyWith<$Res> get boardGameDetails {
    return $BoardGameDetailsCopyWith<$Res>(_value.boardGameDetails, (value) {
      return _then(_value.copyWith(boardGameDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BoardGamePlaythroughImplCopyWith<$Res>
    implements $BoardGamePlaythroughCopyWith<$Res> {
  factory _$$BoardGamePlaythroughImplCopyWith(_$BoardGamePlaythroughImpl value,
          $Res Function(_$BoardGamePlaythroughImpl) then) =
      __$$BoardGamePlaythroughImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PlaythroughDetails playthrough, BoardGameDetails boardGameDetails});

  @override
  $PlaythroughDetailsCopyWith<$Res> get playthrough;
  @override
  $BoardGameDetailsCopyWith<$Res> get boardGameDetails;
}

/// @nodoc
class __$$BoardGamePlaythroughImplCopyWithImpl<$Res>
    extends _$BoardGamePlaythroughCopyWithImpl<$Res, _$BoardGamePlaythroughImpl>
    implements _$$BoardGamePlaythroughImplCopyWith<$Res> {
  __$$BoardGamePlaythroughImplCopyWithImpl(_$BoardGamePlaythroughImpl _value,
      $Res Function(_$BoardGamePlaythroughImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playthrough = null,
    Object? boardGameDetails = null,
  }) {
    return _then(_$BoardGamePlaythroughImpl(
      playthrough: null == playthrough
          ? _value.playthrough
          : playthrough // ignore: cast_nullable_to_non_nullable
              as PlaythroughDetails,
      boardGameDetails: null == boardGameDetails
          ? _value.boardGameDetails
          : boardGameDetails // ignore: cast_nullable_to_non_nullable
              as BoardGameDetails,
    ));
  }
}

/// @nodoc

class _$BoardGamePlaythroughImpl extends _BoardGamePlaythrough {
  const _$BoardGamePlaythroughImpl(
      {required this.playthrough, required this.boardGameDetails})
      : super._();

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
            other is _$BoardGamePlaythroughImpl &&
            (identical(other.playthrough, playthrough) ||
                other.playthrough == playthrough) &&
            (identical(other.boardGameDetails, boardGameDetails) ||
                other.boardGameDetails == boardGameDetails));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playthrough, boardGameDetails);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardGamePlaythroughImplCopyWith<_$BoardGamePlaythroughImpl>
      get copyWith =>
          __$$BoardGamePlaythroughImplCopyWithImpl<_$BoardGamePlaythroughImpl>(
              this, _$identity);
}

abstract class _BoardGamePlaythrough extends BoardGamePlaythrough {
  const factory _BoardGamePlaythrough(
          {required final PlaythroughDetails playthrough,
          required final BoardGameDetails boardGameDetails}) =
      _$BoardGamePlaythroughImpl;
  const _BoardGamePlaythrough._() : super._();

  @override
  PlaythroughDetails get playthrough;
  @override
  BoardGameDetails get boardGameDetails;
  @override
  @JsonKey(ignore: true)
  _$$BoardGamePlaythroughImplCopyWith<_$BoardGamePlaythroughImpl>
      get copyWith => throw _privateConstructorUsedError;
}
