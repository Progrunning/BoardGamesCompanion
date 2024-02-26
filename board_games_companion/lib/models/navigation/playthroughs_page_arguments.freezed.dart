// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

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
      _$PlaythroughsPageArgumentsCopyWithImpl<$Res, PlaythroughsPageArguments>;
  @useResult
  $Res call({BoardGameDetails boardGameDetails, String boardGameImageHeroId});

  $BoardGameDetailsCopyWith<$Res> get boardGameDetails;
}

/// @nodoc
class _$PlaythroughsPageArgumentsCopyWithImpl<$Res,
        $Val extends PlaythroughsPageArguments>
    implements $PlaythroughsPageArgumentsCopyWith<$Res> {
  _$PlaythroughsPageArgumentsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGameDetails = null,
    Object? boardGameImageHeroId = null,
  }) {
    return _then(_value.copyWith(
      boardGameDetails: null == boardGameDetails
          ? _value.boardGameDetails
          : boardGameDetails // ignore: cast_nullable_to_non_nullable
              as BoardGameDetails,
      boardGameImageHeroId: null == boardGameImageHeroId
          ? _value.boardGameImageHeroId
          : boardGameImageHeroId // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$PlaythroughsPageArgumentsImplCopyWith<$Res>
    implements $PlaythroughsPageArgumentsCopyWith<$Res> {
  factory _$$PlaythroughsPageArgumentsImplCopyWith(
          _$PlaythroughsPageArgumentsImpl value,
          $Res Function(_$PlaythroughsPageArgumentsImpl) then) =
      __$$PlaythroughsPageArgumentsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({BoardGameDetails boardGameDetails, String boardGameImageHeroId});

  @override
  $BoardGameDetailsCopyWith<$Res> get boardGameDetails;
}

/// @nodoc
class __$$PlaythroughsPageArgumentsImplCopyWithImpl<$Res>
    extends _$PlaythroughsPageArgumentsCopyWithImpl<$Res,
        _$PlaythroughsPageArgumentsImpl>
    implements _$$PlaythroughsPageArgumentsImplCopyWith<$Res> {
  __$$PlaythroughsPageArgumentsImplCopyWithImpl(
      _$PlaythroughsPageArgumentsImpl _value,
      $Res Function(_$PlaythroughsPageArgumentsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardGameDetails = null,
    Object? boardGameImageHeroId = null,
  }) {
    return _then(_$PlaythroughsPageArgumentsImpl(
      boardGameDetails: null == boardGameDetails
          ? _value.boardGameDetails
          : boardGameDetails // ignore: cast_nullable_to_non_nullable
              as BoardGameDetails,
      boardGameImageHeroId: null == boardGameImageHeroId
          ? _value.boardGameImageHeroId
          : boardGameImageHeroId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PlaythroughsPageArgumentsImpl implements _PlaythroughsPageArguments {
  const _$PlaythroughsPageArgumentsImpl(
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
            other is _$PlaythroughsPageArgumentsImpl &&
            (identical(other.boardGameDetails, boardGameDetails) ||
                other.boardGameDetails == boardGameDetails) &&
            (identical(other.boardGameImageHeroId, boardGameImageHeroId) ||
                other.boardGameImageHeroId == boardGameImageHeroId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, boardGameDetails, boardGameImageHeroId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaythroughsPageArgumentsImplCopyWith<_$PlaythroughsPageArgumentsImpl>
      get copyWith => __$$PlaythroughsPageArgumentsImplCopyWithImpl<
          _$PlaythroughsPageArgumentsImpl>(this, _$identity);
}

abstract class _PlaythroughsPageArguments implements PlaythroughsPageArguments {
  const factory _PlaythroughsPageArguments(
          {required final BoardGameDetails boardGameDetails,
          required final String boardGameImageHeroId}) =
      _$PlaythroughsPageArgumentsImpl;

  @override
  BoardGameDetails get boardGameDetails;
  @override
  String get boardGameImageHeroId;
  @override
  @JsonKey(ignore: true)
  _$$PlaythroughsPageArgumentsImplCopyWith<_$PlaythroughsPageArgumentsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
