// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tiebreaker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Tiebreaker {
  List<ScoreTiebreaker> get scoreTiebreakers =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TiebreakerCopyWith<Tiebreaker> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TiebreakerCopyWith<$Res> {
  factory $TiebreakerCopyWith(
          Tiebreaker value, $Res Function(Tiebreaker) then) =
      _$TiebreakerCopyWithImpl<$Res, Tiebreaker>;
  @useResult
  $Res call({List<ScoreTiebreaker> scoreTiebreakers});
}

/// @nodoc
class _$TiebreakerCopyWithImpl<$Res, $Val extends Tiebreaker>
    implements $TiebreakerCopyWith<$Res> {
  _$TiebreakerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scoreTiebreakers = null,
  }) {
    return _then(_value.copyWith(
      scoreTiebreakers: null == scoreTiebreakers
          ? _value.scoreTiebreakers
          : scoreTiebreakers // ignore: cast_nullable_to_non_nullable
              as List<ScoreTiebreaker>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TiebreakerCopyWith<$Res>
    implements $TiebreakerCopyWith<$Res> {
  factory _$$_TiebreakerCopyWith(
          _$_Tiebreaker value, $Res Function(_$_Tiebreaker) then) =
      __$$_TiebreakerCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ScoreTiebreaker> scoreTiebreakers});
}

/// @nodoc
class __$$_TiebreakerCopyWithImpl<$Res>
    extends _$TiebreakerCopyWithImpl<$Res, _$_Tiebreaker>
    implements _$$_TiebreakerCopyWith<$Res> {
  __$$_TiebreakerCopyWithImpl(
      _$_Tiebreaker _value, $Res Function(_$_Tiebreaker) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scoreTiebreakers = null,
  }) {
    return _then(_$_Tiebreaker(
      scoreTiebreakers: null == scoreTiebreakers
          ? _value._scoreTiebreakers
          : scoreTiebreakers // ignore: cast_nullable_to_non_nullable
              as List<ScoreTiebreaker>,
    ));
  }
}

/// @nodoc

class _$_Tiebreaker extends _Tiebreaker {
  const _$_Tiebreaker({required final List<ScoreTiebreaker> scoreTiebreakers})
      : _scoreTiebreakers = scoreTiebreakers,
        super._();

  final List<ScoreTiebreaker> _scoreTiebreakers;
  @override
  List<ScoreTiebreaker> get scoreTiebreakers {
    if (_scoreTiebreakers is EqualUnmodifiableListView)
      return _scoreTiebreakers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scoreTiebreakers);
  }

  @override
  String toString() {
    return 'Tiebreaker(scoreTiebreakers: $scoreTiebreakers)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Tiebreaker &&
            const DeepCollectionEquality()
                .equals(other._scoreTiebreakers, _scoreTiebreakers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_scoreTiebreakers));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TiebreakerCopyWith<_$_Tiebreaker> get copyWith =>
      __$$_TiebreakerCopyWithImpl<_$_Tiebreaker>(this, _$identity);
}

abstract class _Tiebreaker extends Tiebreaker {
  const factory _Tiebreaker(
      {required final List<ScoreTiebreaker> scoreTiebreakers}) = _$_Tiebreaker;
  const _Tiebreaker._() : super._();

  @override
  List<ScoreTiebreaker> get scoreTiebreakers;
  @override
  @JsonKey(ignore: true)
  _$$_TiebreakerCopyWith<_$_Tiebreaker> get copyWith =>
      throw _privateConstructorUsedError;
}
