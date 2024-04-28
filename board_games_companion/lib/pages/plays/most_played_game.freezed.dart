// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'most_played_game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MostPlayedGame {
  BoardGameDetails get boardGameDetails => throw _privateConstructorUsedError;
  int get totalNumberOfPlays => throw _privateConstructorUsedError;
  int get totalTimePlayedInSeconds => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MostPlayedGameCopyWith<MostPlayedGame> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MostPlayedGameCopyWith<$Res> {
  factory $MostPlayedGameCopyWith(
          MostPlayedGame value, $Res Function(MostPlayedGame) then) =
      _$MostPlayedGameCopyWithImpl<$Res, MostPlayedGame>;
  @useResult
  $Res call(
      {BoardGameDetails boardGameDetails,
      int totalNumberOfPlays,
      int totalTimePlayedInSeconds});

  $BoardGameDetailsCopyWith<$Res> get boardGameDetails;
}

/// @nodoc
class _$MostPlayedGameCopyWithImpl<$Res, $Val extends MostPlayedGame>
    implements $MostPlayedGameCopyWith<$Res> {
  _$MostPlayedGameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGameDetails = null,
    Object? totalNumberOfPlays = null,
    Object? totalTimePlayedInSeconds = null,
  }) {
    return _then(_value.copyWith(
      boardGameDetails: null == boardGameDetails
          ? _value.boardGameDetails
          : boardGameDetails // ignore: cast_nullable_to_non_nullable
              as BoardGameDetails,
      totalNumberOfPlays: null == totalNumberOfPlays
          ? _value.totalNumberOfPlays
          : totalNumberOfPlays // ignore: cast_nullable_to_non_nullable
              as int,
      totalTimePlayedInSeconds: null == totalTimePlayedInSeconds
          ? _value.totalTimePlayedInSeconds
          : totalTimePlayedInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
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
abstract class _$$MostPlayedGameImplCopyWith<$Res>
    implements $MostPlayedGameCopyWith<$Res> {
  factory _$$MostPlayedGameImplCopyWith(_$MostPlayedGameImpl value,
          $Res Function(_$MostPlayedGameImpl) then) =
      __$$MostPlayedGameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BoardGameDetails boardGameDetails,
      int totalNumberOfPlays,
      int totalTimePlayedInSeconds});

  @override
  $BoardGameDetailsCopyWith<$Res> get boardGameDetails;
}

/// @nodoc
class __$$MostPlayedGameImplCopyWithImpl<$Res>
    extends _$MostPlayedGameCopyWithImpl<$Res, _$MostPlayedGameImpl>
    implements _$$MostPlayedGameImplCopyWith<$Res> {
  __$$MostPlayedGameImplCopyWithImpl(
      _$MostPlayedGameImpl _value, $Res Function(_$MostPlayedGameImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGameDetails = null,
    Object? totalNumberOfPlays = null,
    Object? totalTimePlayedInSeconds = null,
  }) {
    return _then(_$MostPlayedGameImpl(
      boardGameDetails: null == boardGameDetails
          ? _value.boardGameDetails
          : boardGameDetails // ignore: cast_nullable_to_non_nullable
              as BoardGameDetails,
      totalNumberOfPlays: null == totalNumberOfPlays
          ? _value.totalNumberOfPlays
          : totalNumberOfPlays // ignore: cast_nullable_to_non_nullable
              as int,
      totalTimePlayedInSeconds: null == totalTimePlayedInSeconds
          ? _value.totalTimePlayedInSeconds
          : totalTimePlayedInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$MostPlayedGameImpl extends _MostPlayedGame {
  const _$MostPlayedGameImpl(
      {required this.boardGameDetails,
      required this.totalNumberOfPlays,
      required this.totalTimePlayedInSeconds})
      : super._();

  @override
  final BoardGameDetails boardGameDetails;
  @override
  final int totalNumberOfPlays;
  @override
  final int totalTimePlayedInSeconds;

  @override
  String toString() {
    return 'MostPlayedGame(boardGameDetails: $boardGameDetails, totalNumberOfPlays: $totalNumberOfPlays, totalTimePlayedInSeconds: $totalTimePlayedInSeconds)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MostPlayedGameImpl &&
            (identical(other.boardGameDetails, boardGameDetails) ||
                other.boardGameDetails == boardGameDetails) &&
            (identical(other.totalNumberOfPlays, totalNumberOfPlays) ||
                other.totalNumberOfPlays == totalNumberOfPlays) &&
            (identical(
                    other.totalTimePlayedInSeconds, totalTimePlayedInSeconds) ||
                other.totalTimePlayedInSeconds == totalTimePlayedInSeconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, boardGameDetails,
      totalNumberOfPlays, totalTimePlayedInSeconds);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MostPlayedGameImplCopyWith<_$MostPlayedGameImpl> get copyWith =>
      __$$MostPlayedGameImplCopyWithImpl<_$MostPlayedGameImpl>(
          this, _$identity);
}

abstract class _MostPlayedGame extends MostPlayedGame {
  const factory _MostPlayedGame(
      {required final BoardGameDetails boardGameDetails,
      required final int totalNumberOfPlays,
      required final int totalTimePlayedInSeconds}) = _$MostPlayedGameImpl;
  const _MostPlayedGame._() : super._();

  @override
  BoardGameDetails get boardGameDetails;
  @override
  int get totalNumberOfPlays;
  @override
  int get totalTimePlayedInSeconds;
  @override
  @JsonKey(ignore: true)
  _$$MostPlayedGameImplCopyWith<_$MostPlayedGameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
