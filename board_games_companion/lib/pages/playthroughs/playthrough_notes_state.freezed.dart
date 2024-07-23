// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playthrough_notes_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlaythroughNotesState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(List<PlaythroughNote> playthroughNotes) notes,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(List<PlaythroughNote> playthroughNotes)? notes,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(List<PlaythroughNote> playthroughNotes)? notes,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_empty value) empty,
    required TResult Function(_notes value) notes,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_empty value)? empty,
    TResult? Function(_notes value)? notes,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_empty value)? empty,
    TResult Function(_notes value)? notes,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaythroughNotesStateCopyWith<$Res> {
  factory $PlaythroughNotesStateCopyWith(PlaythroughNotesState value,
          $Res Function(PlaythroughNotesState) then) =
      _$PlaythroughNotesStateCopyWithImpl<$Res, PlaythroughNotesState>;
}

/// @nodoc
class _$PlaythroughNotesStateCopyWithImpl<$Res,
        $Val extends PlaythroughNotesState>
    implements $PlaythroughNotesStateCopyWith<$Res> {
  _$PlaythroughNotesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$emptyImplCopyWith<$Res> {
  factory _$$emptyImplCopyWith(
          _$emptyImpl value, $Res Function(_$emptyImpl) then) =
      __$$emptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$emptyImplCopyWithImpl<$Res>
    extends _$PlaythroughNotesStateCopyWithImpl<$Res, _$emptyImpl>
    implements _$$emptyImplCopyWith<$Res> {
  __$$emptyImplCopyWithImpl(
      _$emptyImpl _value, $Res Function(_$emptyImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$emptyImpl implements _empty {
  const _$emptyImpl();

  @override
  String toString() {
    return 'PlaythroughNotesState.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$emptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(List<PlaythroughNote> playthroughNotes) notes,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(List<PlaythroughNote> playthroughNotes)? notes,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(List<PlaythroughNote> playthroughNotes)? notes,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_empty value) empty,
    required TResult Function(_notes value) notes,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_empty value)? empty,
    TResult? Function(_notes value)? notes,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_empty value)? empty,
    TResult Function(_notes value)? notes,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class _empty implements PlaythroughNotesState {
  const factory _empty() = _$emptyImpl;
}

/// @nodoc
abstract class _$$notesImplCopyWith<$Res> {
  factory _$$notesImplCopyWith(
          _$notesImpl value, $Res Function(_$notesImpl) then) =
      __$$notesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<PlaythroughNote> playthroughNotes});
}

/// @nodoc
class __$$notesImplCopyWithImpl<$Res>
    extends _$PlaythroughNotesStateCopyWithImpl<$Res, _$notesImpl>
    implements _$$notesImplCopyWith<$Res> {
  __$$notesImplCopyWithImpl(
      _$notesImpl _value, $Res Function(_$notesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playthroughNotes = null,
  }) {
    return _then(_$notesImpl(
      playthroughNotes: null == playthroughNotes
          ? _value._playthroughNotes
          : playthroughNotes // ignore: cast_nullable_to_non_nullable
              as List<PlaythroughNote>,
    ));
  }
}

/// @nodoc

class _$notesImpl implements _notes {
  const _$notesImpl({required final List<PlaythroughNote> playthroughNotes})
      : _playthroughNotes = playthroughNotes;

  final List<PlaythroughNote> _playthroughNotes;
  @override
  List<PlaythroughNote> get playthroughNotes {
    if (_playthroughNotes is EqualUnmodifiableListView)
      return _playthroughNotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playthroughNotes);
  }

  @override
  String toString() {
    return 'PlaythroughNotesState.notes(playthroughNotes: $playthroughNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$notesImpl &&
            const DeepCollectionEquality()
                .equals(other._playthroughNotes, _playthroughNotes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_playthroughNotes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$notesImplCopyWith<_$notesImpl> get copyWith =>
      __$$notesImplCopyWithImpl<_$notesImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(List<PlaythroughNote> playthroughNotes) notes,
  }) {
    return notes(playthroughNotes);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(List<PlaythroughNote> playthroughNotes)? notes,
  }) {
    return notes?.call(playthroughNotes);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(List<PlaythroughNote> playthroughNotes)? notes,
    required TResult orElse(),
  }) {
    if (notes != null) {
      return notes(playthroughNotes);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_empty value) empty,
    required TResult Function(_notes value) notes,
  }) {
    return notes(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_empty value)? empty,
    TResult? Function(_notes value)? notes,
  }) {
    return notes?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_empty value)? empty,
    TResult Function(_notes value)? notes,
    required TResult orElse(),
  }) {
    if (notes != null) {
      return notes(this);
    }
    return orElse();
  }
}

abstract class _notes implements PlaythroughNotesState {
  const factory _notes(
      {required final List<PlaythroughNote> playthroughNotes}) = _$notesImpl;

  List<PlaythroughNote> get playthroughNotes;
  @JsonKey(ignore: true)
  _$$notesImplCopyWith<_$notesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
