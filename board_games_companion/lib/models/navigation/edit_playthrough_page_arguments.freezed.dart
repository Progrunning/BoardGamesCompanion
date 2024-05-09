// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_playthrough_page_arguments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
      _$EditPlaythroughPageArgumentsCopyWithImpl<$Res,
          EditPlaythroughPageArguments>;
  @useResult
  $Res call({String playthroughId, String boardGameId, String goBackPageRoute});
}

/// @nodoc
class _$EditPlaythroughPageArgumentsCopyWithImpl<$Res,
        $Val extends EditPlaythroughPageArguments>
    implements $EditPlaythroughPageArgumentsCopyWith<$Res> {
  _$EditPlaythroughPageArgumentsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playthroughId = null,
    Object? boardGameId = null,
    Object? goBackPageRoute = null,
  }) {
    return _then(_value.copyWith(
      playthroughId: null == playthroughId
          ? _value.playthroughId
          : playthroughId // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameId: null == boardGameId
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      goBackPageRoute: null == goBackPageRoute
          ? _value.goBackPageRoute
          : goBackPageRoute // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EditPlaythroughPageArgumentsImplCopyWith<$Res>
    implements $EditPlaythroughPageArgumentsCopyWith<$Res> {
  factory _$$EditPlaythroughPageArgumentsImplCopyWith(
          _$EditPlaythroughPageArgumentsImpl value,
          $Res Function(_$EditPlaythroughPageArgumentsImpl) then) =
      __$$EditPlaythroughPageArgumentsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playthroughId, String boardGameId, String goBackPageRoute});
}

/// @nodoc
class __$$EditPlaythroughPageArgumentsImplCopyWithImpl<$Res>
    extends _$EditPlaythroughPageArgumentsCopyWithImpl<$Res,
        _$EditPlaythroughPageArgumentsImpl>
    implements _$$EditPlaythroughPageArgumentsImplCopyWith<$Res> {
  __$$EditPlaythroughPageArgumentsImplCopyWithImpl(
      _$EditPlaythroughPageArgumentsImpl _value,
      $Res Function(_$EditPlaythroughPageArgumentsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playthroughId = null,
    Object? boardGameId = null,
    Object? goBackPageRoute = null,
  }) {
    return _then(_$EditPlaythroughPageArgumentsImpl(
      playthroughId: null == playthroughId
          ? _value.playthroughId
          : playthroughId // ignore: cast_nullable_to_non_nullable
              as String,
      boardGameId: null == boardGameId
          ? _value.boardGameId
          : boardGameId // ignore: cast_nullable_to_non_nullable
              as String,
      goBackPageRoute: null == goBackPageRoute
          ? _value.goBackPageRoute
          : goBackPageRoute // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$EditPlaythroughPageArgumentsImpl
    implements _EditPlaythroughPageArguments {
  const _$EditPlaythroughPageArgumentsImpl(
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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditPlaythroughPageArgumentsImpl &&
            (identical(other.playthroughId, playthroughId) ||
                other.playthroughId == playthroughId) &&
            (identical(other.boardGameId, boardGameId) ||
                other.boardGameId == boardGameId) &&
            (identical(other.goBackPageRoute, goBackPageRoute) ||
                other.goBackPageRoute == goBackPageRoute));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, playthroughId, boardGameId, goBackPageRoute);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EditPlaythroughPageArgumentsImplCopyWith<
          _$EditPlaythroughPageArgumentsImpl>
      get copyWith => __$$EditPlaythroughPageArgumentsImplCopyWithImpl<
          _$EditPlaythroughPageArgumentsImpl>(this, _$identity);
}

abstract class _EditPlaythroughPageArguments
    implements EditPlaythroughPageArguments {
  const factory _EditPlaythroughPageArguments(
          {required final String playthroughId,
          required final String boardGameId,
          required final String goBackPageRoute}) =
      _$EditPlaythroughPageArgumentsImpl;

  @override
  String get playthroughId;
  @override
  String get boardGameId;
  @override
  String get goBackPageRoute;
  @override
  @JsonKey(ignore: true)
  _$$EditPlaythroughPageArgumentsImplCopyWith<
          _$EditPlaythroughPageArgumentsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
