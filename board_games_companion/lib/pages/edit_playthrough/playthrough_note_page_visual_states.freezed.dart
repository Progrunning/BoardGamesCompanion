// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'playthrough_note_page_visual_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PlaythroughNotePageVisualState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() add,
    required TResult Function(PlaythroughNote note) edit,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? add,
    TResult Function(PlaythroughNote note)? edit,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? add,
    TResult Function(PlaythroughNote note)? edit,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Add value) add,
    required TResult Function(Edit value) edit,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Add value)? add,
    TResult Function(Edit value)? edit,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Add value)? add,
    TResult Function(Edit value)? edit,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaythroughNotePageVisualStateCopyWith<$Res> {
  factory $PlaythroughNotePageVisualStateCopyWith(
          PlaythroughNotePageVisualState value,
          $Res Function(PlaythroughNotePageVisualState) then) =
      _$PlaythroughNotePageVisualStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$PlaythroughNotePageVisualStateCopyWithImpl<$Res>
    implements $PlaythroughNotePageVisualStateCopyWith<$Res> {
  _$PlaythroughNotePageVisualStateCopyWithImpl(this._value, this._then);

  final PlaythroughNotePageVisualState _value;
  // ignore: unused_field
  final $Res Function(PlaythroughNotePageVisualState) _then;
}

/// @nodoc
abstract class _$$AddCopyWith<$Res> {
  factory _$$AddCopyWith(_$Add value, $Res Function(_$Add) then) =
      __$$AddCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AddCopyWithImpl<$Res>
    extends _$PlaythroughNotePageVisualStateCopyWithImpl<$Res>
    implements _$$AddCopyWith<$Res> {
  __$$AddCopyWithImpl(_$Add _value, $Res Function(_$Add) _then)
      : super(_value, (v) => _then(v as _$Add));

  @override
  _$Add get _value => super._value as _$Add;
}

/// @nodoc

class _$Add implements Add {
  const _$Add();

  @override
  String toString() {
    return 'PlaythroughNotePageVisualState.add()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Add);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() add,
    required TResult Function(PlaythroughNote note) edit,
  }) {
    return add();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? add,
    TResult Function(PlaythroughNote note)? edit,
  }) {
    return add?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? add,
    TResult Function(PlaythroughNote note)? edit,
    required TResult orElse(),
  }) {
    if (add != null) {
      return add();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Add value) add,
    required TResult Function(Edit value) edit,
  }) {
    return add(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Add value)? add,
    TResult Function(Edit value)? edit,
  }) {
    return add?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Add value)? add,
    TResult Function(Edit value)? edit,
    required TResult orElse(),
  }) {
    if (add != null) {
      return add(this);
    }
    return orElse();
  }
}

abstract class Add implements PlaythroughNotePageVisualState {
  const factory Add() = _$Add;
}

/// @nodoc
abstract class _$$EditCopyWith<$Res> {
  factory _$$EditCopyWith(_$Edit value, $Res Function(_$Edit) then) =
      __$$EditCopyWithImpl<$Res>;
  $Res call({PlaythroughNote note});

  $PlaythroughNoteCopyWith<$Res> get note;
}

/// @nodoc
class __$$EditCopyWithImpl<$Res>
    extends _$PlaythroughNotePageVisualStateCopyWithImpl<$Res>
    implements _$$EditCopyWith<$Res> {
  __$$EditCopyWithImpl(_$Edit _value, $Res Function(_$Edit) _then)
      : super(_value, (v) => _then(v as _$Edit));

  @override
  _$Edit get _value => super._value as _$Edit;

  @override
  $Res call({
    Object? note = freezed,
  }) {
    return _then(_$Edit(
      note == freezed
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as PlaythroughNote,
    ));
  }

  @override
  $PlaythroughNoteCopyWith<$Res> get note {
    return $PlaythroughNoteCopyWith<$Res>(_value.note, (value) {
      return _then(_value.copyWith(note: value));
    });
  }
}

/// @nodoc

class _$Edit implements Edit {
  const _$Edit(this.note);

  @override
  final PlaythroughNote note;

  @override
  String toString() {
    return 'PlaythroughNotePageVisualState.edit(note: $note)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Edit &&
            const DeepCollectionEquality().equals(other.note, note));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(note));

  @JsonKey(ignore: true)
  @override
  _$$EditCopyWith<_$Edit> get copyWith =>
      __$$EditCopyWithImpl<_$Edit>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() add,
    required TResult Function(PlaythroughNote note) edit,
  }) {
    return edit(note);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? add,
    TResult Function(PlaythroughNote note)? edit,
  }) {
    return edit?.call(note);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? add,
    TResult Function(PlaythroughNote note)? edit,
    required TResult orElse(),
  }) {
    if (edit != null) {
      return edit(note);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Add value) add,
    required TResult Function(Edit value) edit,
  }) {
    return edit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Add value)? add,
    TResult Function(Edit value)? edit,
  }) {
    return edit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Add value)? add,
    TResult Function(Edit value)? edit,
    required TResult orElse(),
  }) {
    if (edit != null) {
      return edit(this);
    }
    return orElse();
  }
}

abstract class Edit implements PlaythroughNotePageVisualState {
  const factory Edit(final PlaythroughNote note) = _$Edit;

  PlaythroughNote get note;
  @JsonKey(ignore: true)
  _$$EditCopyWith<_$Edit> get copyWith => throw _privateConstructorUsedError;
}
