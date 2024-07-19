// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_visual_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlayerVisualState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() create,
    required TResult Function() edit,
    required TResult Function() deleted,
    required TResult Function() restored,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? create,
    TResult? Function()? edit,
    TResult? Function()? deleted,
    TResult? Function()? restored,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? create,
    TResult Function()? edit,
    TResult Function()? deleted,
    TResult Function()? restored,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(Create value) create,
    required TResult Function(Edit value) edit,
    required TResult Function(Deleted value) deleted,
    required TResult Function(Restored value) restored,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(Create value)? create,
    TResult? Function(Edit value)? edit,
    TResult? Function(Deleted value)? deleted,
    TResult? Function(Restored value)? restored,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(Create value)? create,
    TResult Function(Edit value)? edit,
    TResult Function(Deleted value)? deleted,
    TResult Function(Restored value)? restored,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerVisualStateCopyWith<$Res> {
  factory $PlayerVisualStateCopyWith(
          PlayerVisualState value, $Res Function(PlayerVisualState) then) =
      _$PlayerVisualStateCopyWithImpl<$Res, PlayerVisualState>;
}

/// @nodoc
class _$PlayerVisualStateCopyWithImpl<$Res, $Val extends PlayerVisualState>
    implements $PlayerVisualStateCopyWith<$Res> {
  _$PlayerVisualStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitImplCopyWith<$Res> {
  factory _$$InitImplCopyWith(
          _$InitImpl value, $Res Function(_$InitImpl) then) =
      __$$InitImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitImplCopyWithImpl<$Res>
    extends _$PlayerVisualStateCopyWithImpl<$Res, _$InitImpl>
    implements _$$InitImplCopyWith<$Res> {
  __$$InitImplCopyWithImpl(_$InitImpl _value, $Res Function(_$InitImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitImpl extends Init {
  const _$InitImpl() : super._();

  @override
  String toString() {
    return 'PlayerVisualState.init()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() create,
    required TResult Function() edit,
    required TResult Function() deleted,
    required TResult Function() restored,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? create,
    TResult? Function()? edit,
    TResult? Function()? deleted,
    TResult? Function()? restored,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? create,
    TResult Function()? edit,
    TResult Function()? deleted,
    TResult Function()? restored,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(Create value) create,
    required TResult Function(Edit value) edit,
    required TResult Function(Deleted value) deleted,
    required TResult Function(Restored value) restored,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(Create value)? create,
    TResult? Function(Edit value)? edit,
    TResult? Function(Deleted value)? deleted,
    TResult? Function(Restored value)? restored,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(Create value)? create,
    TResult Function(Edit value)? edit,
    TResult Function(Deleted value)? deleted,
    TResult Function(Restored value)? restored,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class Init extends PlayerVisualState {
  const factory Init() = _$InitImpl;
  const Init._() : super._();
}

/// @nodoc
abstract class _$$CreateImplCopyWith<$Res> {
  factory _$$CreateImplCopyWith(
          _$CreateImpl value, $Res Function(_$CreateImpl) then) =
      __$$CreateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CreateImplCopyWithImpl<$Res>
    extends _$PlayerVisualStateCopyWithImpl<$Res, _$CreateImpl>
    implements _$$CreateImplCopyWith<$Res> {
  __$$CreateImplCopyWithImpl(
      _$CreateImpl _value, $Res Function(_$CreateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CreateImpl extends Create {
  const _$CreateImpl() : super._();

  @override
  String toString() {
    return 'PlayerVisualState.create()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CreateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() create,
    required TResult Function() edit,
    required TResult Function() deleted,
    required TResult Function() restored,
  }) {
    return create();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? create,
    TResult? Function()? edit,
    TResult? Function()? deleted,
    TResult? Function()? restored,
  }) {
    return create?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? create,
    TResult Function()? edit,
    TResult Function()? deleted,
    TResult Function()? restored,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(Create value) create,
    required TResult Function(Edit value) edit,
    required TResult Function(Deleted value) deleted,
    required TResult Function(Restored value) restored,
  }) {
    return create(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(Create value)? create,
    TResult? Function(Edit value)? edit,
    TResult? Function(Deleted value)? deleted,
    TResult? Function(Restored value)? restored,
  }) {
    return create?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(Create value)? create,
    TResult Function(Edit value)? edit,
    TResult Function(Deleted value)? deleted,
    TResult Function(Restored value)? restored,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(this);
    }
    return orElse();
  }
}

abstract class Create extends PlayerVisualState {
  const factory Create() = _$CreateImpl;
  const Create._() : super._();
}

/// @nodoc
abstract class _$$EditImplCopyWith<$Res> {
  factory _$$EditImplCopyWith(
          _$EditImpl value, $Res Function(_$EditImpl) then) =
      __$$EditImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$EditImplCopyWithImpl<$Res>
    extends _$PlayerVisualStateCopyWithImpl<$Res, _$EditImpl>
    implements _$$EditImplCopyWith<$Res> {
  __$$EditImplCopyWithImpl(_$EditImpl _value, $Res Function(_$EditImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$EditImpl extends Edit {
  const _$EditImpl() : super._();

  @override
  String toString() {
    return 'PlayerVisualState.edit()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$EditImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() create,
    required TResult Function() edit,
    required TResult Function() deleted,
    required TResult Function() restored,
  }) {
    return edit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? create,
    TResult? Function()? edit,
    TResult? Function()? deleted,
    TResult? Function()? restored,
  }) {
    return edit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? create,
    TResult Function()? edit,
    TResult Function()? deleted,
    TResult Function()? restored,
    required TResult orElse(),
  }) {
    if (edit != null) {
      return edit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(Create value) create,
    required TResult Function(Edit value) edit,
    required TResult Function(Deleted value) deleted,
    required TResult Function(Restored value) restored,
  }) {
    return edit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(Create value)? create,
    TResult? Function(Edit value)? edit,
    TResult? Function(Deleted value)? deleted,
    TResult? Function(Restored value)? restored,
  }) {
    return edit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(Create value)? create,
    TResult Function(Edit value)? edit,
    TResult Function(Deleted value)? deleted,
    TResult Function(Restored value)? restored,
    required TResult orElse(),
  }) {
    if (edit != null) {
      return edit(this);
    }
    return orElse();
  }
}

abstract class Edit extends PlayerVisualState {
  const factory Edit() = _$EditImpl;
  const Edit._() : super._();
}

/// @nodoc
abstract class _$$DeletedImplCopyWith<$Res> {
  factory _$$DeletedImplCopyWith(
          _$DeletedImpl value, $Res Function(_$DeletedImpl) then) =
      __$$DeletedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeletedImplCopyWithImpl<$Res>
    extends _$PlayerVisualStateCopyWithImpl<$Res, _$DeletedImpl>
    implements _$$DeletedImplCopyWith<$Res> {
  __$$DeletedImplCopyWithImpl(
      _$DeletedImpl _value, $Res Function(_$DeletedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$DeletedImpl extends Deleted {
  const _$DeletedImpl() : super._();

  @override
  String toString() {
    return 'PlayerVisualState.deleted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DeletedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() create,
    required TResult Function() edit,
    required TResult Function() deleted,
    required TResult Function() restored,
  }) {
    return deleted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? create,
    TResult? Function()? edit,
    TResult? Function()? deleted,
    TResult? Function()? restored,
  }) {
    return deleted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? create,
    TResult Function()? edit,
    TResult Function()? deleted,
    TResult Function()? restored,
    required TResult orElse(),
  }) {
    if (deleted != null) {
      return deleted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(Create value) create,
    required TResult Function(Edit value) edit,
    required TResult Function(Deleted value) deleted,
    required TResult Function(Restored value) restored,
  }) {
    return deleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(Create value)? create,
    TResult? Function(Edit value)? edit,
    TResult? Function(Deleted value)? deleted,
    TResult? Function(Restored value)? restored,
  }) {
    return deleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(Create value)? create,
    TResult Function(Edit value)? edit,
    TResult Function(Deleted value)? deleted,
    TResult Function(Restored value)? restored,
    required TResult orElse(),
  }) {
    if (deleted != null) {
      return deleted(this);
    }
    return orElse();
  }
}

abstract class Deleted extends PlayerVisualState {
  const factory Deleted() = _$DeletedImpl;
  const Deleted._() : super._();
}

/// @nodoc
abstract class _$$RestoredImplCopyWith<$Res> {
  factory _$$RestoredImplCopyWith(
          _$RestoredImpl value, $Res Function(_$RestoredImpl) then) =
      __$$RestoredImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RestoredImplCopyWithImpl<$Res>
    extends _$PlayerVisualStateCopyWithImpl<$Res, _$RestoredImpl>
    implements _$$RestoredImplCopyWith<$Res> {
  __$$RestoredImplCopyWithImpl(
      _$RestoredImpl _value, $Res Function(_$RestoredImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$RestoredImpl extends Restored {
  const _$RestoredImpl() : super._();

  @override
  String toString() {
    return 'PlayerVisualState.restored()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RestoredImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() create,
    required TResult Function() edit,
    required TResult Function() deleted,
    required TResult Function() restored,
  }) {
    return restored();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? create,
    TResult? Function()? edit,
    TResult? Function()? deleted,
    TResult? Function()? restored,
  }) {
    return restored?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? create,
    TResult Function()? edit,
    TResult Function()? deleted,
    TResult Function()? restored,
    required TResult orElse(),
  }) {
    if (restored != null) {
      return restored();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(Create value) create,
    required TResult Function(Edit value) edit,
    required TResult Function(Deleted value) deleted,
    required TResult Function(Restored value) restored,
  }) {
    return restored(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(Create value)? create,
    TResult? Function(Edit value)? edit,
    TResult? Function(Deleted value)? deleted,
    TResult? Function(Restored value)? restored,
  }) {
    return restored?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(Create value)? create,
    TResult Function(Edit value)? edit,
    TResult Function(Deleted value)? deleted,
    TResult Function(Restored value)? restored,
    required TResult orElse(),
  }) {
    if (restored != null) {
      return restored(this);
    }
    return orElse();
  }
}

abstract class Restored extends PlayerVisualState {
  const factory Restored() = _$RestoredImpl;
  const Restored._() : super._();
}
