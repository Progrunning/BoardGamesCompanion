// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playthrough_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PlaythroughNote {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get text => throw _privateConstructorUsedError;
  @HiveField(2)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(3)
  DateTime? get modifiedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlaythroughNoteCopyWith<PlaythroughNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaythroughNoteCopyWith<$Res> {
  factory $PlaythroughNoteCopyWith(
          PlaythroughNote value, $Res Function(PlaythroughNote) then) =
      _$PlaythroughNoteCopyWithImpl<$Res, PlaythroughNote>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String text,
      @HiveField(2) DateTime createdAt,
      @HiveField(3) DateTime? modifiedAt});
}

/// @nodoc
class _$PlaythroughNoteCopyWithImpl<$Res, $Val extends PlaythroughNote>
    implements $PlaythroughNoteCopyWith<$Res> {
  _$PlaythroughNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? createdAt = null,
    Object? modifiedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      modifiedAt: freezed == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PlaythroughNoteCopyWith<$Res>
    implements $PlaythroughNoteCopyWith<$Res> {
  factory _$$_PlaythroughNoteCopyWith(
          _$_PlaythroughNote value, $Res Function(_$_PlaythroughNote) then) =
      __$$_PlaythroughNoteCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String text,
      @HiveField(2) DateTime createdAt,
      @HiveField(3) DateTime? modifiedAt});
}

/// @nodoc
class __$$_PlaythroughNoteCopyWithImpl<$Res>
    extends _$PlaythroughNoteCopyWithImpl<$Res, _$_PlaythroughNote>
    implements _$$_PlaythroughNoteCopyWith<$Res> {
  __$$_PlaythroughNoteCopyWithImpl(
      _$_PlaythroughNote _value, $Res Function(_$_PlaythroughNote) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? createdAt = null,
    Object? modifiedAt = freezed,
  }) {
    return _then(_$_PlaythroughNote(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      modifiedAt: freezed == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@HiveType(
    typeId: HiveBoxes.playthroughNoteId, adapterName: 'PlaythroughNoteAdapter')
class _$_PlaythroughNote implements _PlaythroughNote {
  const _$_PlaythroughNote(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.text,
      @HiveField(2) required this.createdAt,
      @HiveField(3) this.modifiedAt});

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String text;
  @override
  @HiveField(2)
  final DateTime createdAt;
  @override
  @HiveField(3)
  final DateTime? modifiedAt;

  @override
  String toString() {
    return 'PlaythroughNote(id: $id, text: $text, createdAt: $createdAt, modifiedAt: $modifiedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PlaythroughNote &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.modifiedAt, modifiedAt) ||
                other.modifiedAt == modifiedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, text, createdAt, modifiedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PlaythroughNoteCopyWith<_$_PlaythroughNote> get copyWith =>
      __$$_PlaythroughNoteCopyWithImpl<_$_PlaythroughNote>(this, _$identity);
}

abstract class _PlaythroughNote implements PlaythroughNote {
  const factory _PlaythroughNote(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String text,
      @HiveField(2) required final DateTime createdAt,
      @HiveField(3) final DateTime? modifiedAt}) = _$_PlaythroughNote;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get text;
  @override
  @HiveField(2)
  DateTime get createdAt;
  @override
  @HiveField(3)
  DateTime? get modifiedAt;
  @override
  @JsonKey(ignore: true)
  _$$_PlaythroughNoteCopyWith<_$_PlaythroughNote> get copyWith =>
      throw _privateConstructorUsedError;
}
