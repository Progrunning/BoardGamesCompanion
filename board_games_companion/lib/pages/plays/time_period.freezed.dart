// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_period.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TimePeriod {
  PlayStatsPresetTimePeriod get presetTimePeriod =>
      throw _privateConstructorUsedError;
  DateTime get earliestPlaythrough => throw _privateConstructorUsedError;
  DateTime get from => throw _privateConstructorUsedError;
  DateTime get to => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TimePeriodCopyWith<TimePeriod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimePeriodCopyWith<$Res> {
  factory $TimePeriodCopyWith(
          TimePeriod value, $Res Function(TimePeriod) then) =
      _$TimePeriodCopyWithImpl<$Res, TimePeriod>;
  @useResult
  $Res call(
      {PlayStatsPresetTimePeriod presetTimePeriod,
      DateTime earliestPlaythrough,
      DateTime from,
      DateTime to});
}

/// @nodoc
class _$TimePeriodCopyWithImpl<$Res, $Val extends TimePeriod>
    implements $TimePeriodCopyWith<$Res> {
  _$TimePeriodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? presetTimePeriod = null,
    Object? earliestPlaythrough = null,
    Object? from = null,
    Object? to = null,
  }) {
    return _then(_value.copyWith(
      presetTimePeriod: null == presetTimePeriod
          ? _value.presetTimePeriod
          : presetTimePeriod // ignore: cast_nullable_to_non_nullable
              as PlayStatsPresetTimePeriod,
      earliestPlaythrough: null == earliestPlaythrough
          ? _value.earliestPlaythrough
          : earliestPlaythrough // ignore: cast_nullable_to_non_nullable
              as DateTime,
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as DateTime,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimePeriodImplCopyWith<$Res>
    implements $TimePeriodCopyWith<$Res> {
  factory _$$TimePeriodImplCopyWith(
          _$TimePeriodImpl value, $Res Function(_$TimePeriodImpl) then) =
      __$$TimePeriodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PlayStatsPresetTimePeriod presetTimePeriod,
      DateTime earliestPlaythrough,
      DateTime from,
      DateTime to});
}

/// @nodoc
class __$$TimePeriodImplCopyWithImpl<$Res>
    extends _$TimePeriodCopyWithImpl<$Res, _$TimePeriodImpl>
    implements _$$TimePeriodImplCopyWith<$Res> {
  __$$TimePeriodImplCopyWithImpl(
      _$TimePeriodImpl _value, $Res Function(_$TimePeriodImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? presetTimePeriod = null,
    Object? earliestPlaythrough = null,
    Object? from = null,
    Object? to = null,
  }) {
    return _then(_$TimePeriodImpl(
      presetTimePeriod: null == presetTimePeriod
          ? _value.presetTimePeriod
          : presetTimePeriod // ignore: cast_nullable_to_non_nullable
              as PlayStatsPresetTimePeriod,
      earliestPlaythrough: null == earliestPlaythrough
          ? _value.earliestPlaythrough
          : earliestPlaythrough // ignore: cast_nullable_to_non_nullable
              as DateTime,
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as DateTime,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$TimePeriodImpl extends _TimePeriod {
  const _$TimePeriodImpl(
      {required this.presetTimePeriod,
      required this.earliestPlaythrough,
      required this.from,
      required this.to})
      : super._();

  @override
  final PlayStatsPresetTimePeriod presetTimePeriod;
  @override
  final DateTime earliestPlaythrough;
  @override
  final DateTime from;
  @override
  final DateTime to;

  @override
  String toString() {
    return 'TimePeriod(presetTimePeriod: $presetTimePeriod, earliestPlaythrough: $earliestPlaythrough, from: $from, to: $to)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimePeriodImpl &&
            (identical(other.presetTimePeriod, presetTimePeriod) ||
                other.presetTimePeriod == presetTimePeriod) &&
            (identical(other.earliestPlaythrough, earliestPlaythrough) ||
                other.earliestPlaythrough == earliestPlaythrough) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, presetTimePeriod, earliestPlaythrough, from, to);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimePeriodImplCopyWith<_$TimePeriodImpl> get copyWith =>
      __$$TimePeriodImplCopyWithImpl<_$TimePeriodImpl>(this, _$identity);
}

abstract class _TimePeriod extends TimePeriod {
  const factory _TimePeriod(
      {required final PlayStatsPresetTimePeriod presetTimePeriod,
      required final DateTime earliestPlaythrough,
      required final DateTime from,
      required final DateTime to}) = _$TimePeriodImpl;
  const _TimePeriod._() : super._();

  @override
  PlayStatsPresetTimePeriod get presetTimePeriod;
  @override
  DateTime get earliestPlaythrough;
  @override
  DateTime get from;
  @override
  DateTime get to;
  @override
  @JsonKey(ignore: true)
  _$$TimePeriodImplCopyWith<_$TimePeriodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
