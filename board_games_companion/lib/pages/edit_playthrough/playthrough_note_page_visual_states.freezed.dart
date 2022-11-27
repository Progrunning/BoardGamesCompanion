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
    required TResult Function(_add value) add,
    required TResult Function(_edit value) edit,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_add value)? add,
    TResult Function(_edit value)? edit,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_add value)? add,
    TResult Function(_edit value)? edit,
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
abstract class _$$_addCopyWith<$Res> {
  factory _$$_addCopyWith(_$_add value, $Res Function(_$_add) then) =
      __$$_addCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_addCopyWithImpl<$Res>
    extends _$PlaythroughNotePageVisualStateCopyWithImpl<$Res>
    implements _$$_addCopyWith<$Res> {
  __$$_addCopyWithImpl(_$_add _value, $Res Function(_$_add) _then)
      : super(_value, (v) => _then(v as _$_add));

  @override
  _$_add get _value => super._value as _$_add;
}

/// @nodoc

class _$_add implements _add {
  const _$_add();

  @override
  String toString() {
    return 'PlaythroughNotePageVisualState.add()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_add);
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
    required TResult Function(_add value) add,
    required TResult Function(_edit value) edit,
  }) {
    return add(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_add value)? add,
    TResult Function(_edit value)? edit,
  }) {
    return add?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_add value)? add,
    TResult Function(_edit value)? edit,
    required TResult orElse(),
  }) {
    if (add != null) {
      return add(this);
    }
    return orElse();
  }
}

abstract class _add implements PlaythroughNotePageVisualState {
  const factory _add() = _$_add;
}

/// @nodoc
abstract class _$$_editCopyWith<$Res> {
  factory _$$_editCopyWith(_$_edit value, $Res Function(_$_edit) then) =
      __$$_editCopyWithImpl<$Res>;
  $Res call({PlaythroughNote note});

  $PlaythroughNoteCopyWith<$Res> get note;
}

/// @nodoc
class __$$_editCopyWithImpl<$Res>
    extends _$PlaythroughNotePageVisualStateCopyWithImpl<$Res>
    implements _$$_editCopyWith<$Res> {
  __$$_editCopyWithImpl(_$_edit _value, $Res Function(_$_edit) _then)
      : super(_value, (v) => _then(v as _$_edit));

  @override
  _$_edit get _value => super._value as _$_edit;

  @override
  $Res call({
    Object? note = freezed,
  }) {
    return _then(_$_edit(
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

class _$_edit implements _edit {
  const _$_edit(this.note);

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
            other is _$_edit &&
            const DeepCollectionEquality().equals(other.note, note));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(note));

  @JsonKey(ignore: true)
  @override
  _$$_editCopyWith<_$_edit> get copyWith =>
      __$$_editCopyWithImpl<_$_edit>(this, _$identity);

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
    required TResult Function(_add value) add,
    required TResult Function(_edit value) edit,
  }) {
    return edit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_add value)? add,
    TResult Function(_edit value)? edit,
  }) {
    return edit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_add value)? add,
    TResult Function(_edit value)? edit,
    required TResult orElse(),
  }) {
    if (edit != null) {
      return edit(this);
    }
    return orElse();
  }
}

abstract class _edit implements PlaythroughNotePageVisualState {
  const factory _edit(final PlaythroughNote note) = _$_edit;

  PlaythroughNote get note;
  @JsonKey(ignore: true)
  _$$_editCopyWith<_$_edit> get copyWith => throw _privateConstructorUsedError;
}
