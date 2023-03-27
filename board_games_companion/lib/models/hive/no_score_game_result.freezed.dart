// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'no_score_game_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NoScoreGameResult {
  CooperativeGameResult? get cooperativeGameResult =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NoScoreGameResultCopyWith<NoScoreGameResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoScoreGameResultCopyWith<$Res> {
  factory $NoScoreGameResultCopyWith(
          NoScoreGameResult value, $Res Function(NoScoreGameResult) then) =
      _$NoScoreGameResultCopyWithImpl<$Res, NoScoreGameResult>;
  @useResult
  $Res call({CooperativeGameResult? cooperativeGameResult});
}

/// @nodoc
class _$NoScoreGameResultCopyWithImpl<$Res, $Val extends NoScoreGameResult>
    implements $NoScoreGameResultCopyWith<$Res> {
  _$NoScoreGameResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cooperativeGameResult = freezed,
  }) {
    return _then(_value.copyWith(
      cooperativeGameResult: freezed == cooperativeGameResult
          ? _value.cooperativeGameResult
          : cooperativeGameResult // ignore: cast_nullable_to_non_nullable
              as CooperativeGameResult?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NoScoreGameResultCopyWith<$Res>
    implements $NoScoreGameResultCopyWith<$Res> {
  factory _$$_NoScoreGameResultCopyWith(_$_NoScoreGameResult value,
          $Res Function(_$_NoScoreGameResult) then) =
      __$$_NoScoreGameResultCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CooperativeGameResult? cooperativeGameResult});
}

/// @nodoc
class __$$_NoScoreGameResultCopyWithImpl<$Res>
    extends _$NoScoreGameResultCopyWithImpl<$Res, _$_NoScoreGameResult>
    implements _$$_NoScoreGameResultCopyWith<$Res> {
  __$$_NoScoreGameResultCopyWithImpl(
      _$_NoScoreGameResult _value, $Res Function(_$_NoScoreGameResult) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cooperativeGameResult = freezed,
  }) {
    return _then(_$_NoScoreGameResult(
      cooperativeGameResult: freezed == cooperativeGameResult
          ? _value.cooperativeGameResult
          : cooperativeGameResult // ignore: cast_nullable_to_non_nullable
              as CooperativeGameResult?,
    ));
  }
}

/// @nodoc

@HiveType(
    typeId: HiveBoxes.noScoreGameResult,
    adapterName: 'NoScoreGameResultAdapter')
class _$_NoScoreGameResult extends _NoScoreGameResult {
  const _$_NoScoreGameResult({this.cooperativeGameResult}) : super._();

  @override
  final CooperativeGameResult? cooperativeGameResult;

  @override
  String toString() {
    return 'NoScoreGameResult(cooperativeGameResult: $cooperativeGameResult)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NoScoreGameResult &&
            (identical(other.cooperativeGameResult, cooperativeGameResult) ||
                other.cooperativeGameResult == cooperativeGameResult));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cooperativeGameResult);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NoScoreGameResultCopyWith<_$_NoScoreGameResult> get copyWith =>
      __$$_NoScoreGameResultCopyWithImpl<_$_NoScoreGameResult>(
          this, _$identity);
}

abstract class _NoScoreGameResult extends NoScoreGameResult {
  const factory _NoScoreGameResult(
          {final CooperativeGameResult? cooperativeGameResult}) =
      _$_NoScoreGameResult;
  const _NoScoreGameResult._() : super._();

  @override
  CooperativeGameResult? get cooperativeGameResult;
  @override
  @JsonKey(ignore: true)
  _$$_NoScoreGameResultCopyWith<_$_NoScoreGameResult> get copyWith =>
      throw _privateConstructorUsedError;
}
