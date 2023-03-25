// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Player {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get name => throw _privateConstructorUsedError;
  @HiveField(3)
  bool? get isDeleted => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get avatarFileName => throw _privateConstructorUsedError;
  @HiveField(5)
  String? get bggName => throw _privateConstructorUsedError;
  String get avatarImageUri => throw _privateConstructorUsedError;
  XFile? get avatarFileToSave => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlayerCopyWith<Player> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerCopyWith<$Res> {
  factory $PlayerCopyWith(Player value, $Res Function(Player) then) =
      _$PlayerCopyWithImpl<$Res, Player>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String? name,
      @HiveField(3) bool? isDeleted,
      @HiveField(4) String? avatarFileName,
      @HiveField(5) String? bggName,
      String avatarImageUri,
      XFile? avatarFileToSave});
}

/// @nodoc
class _$PlayerCopyWithImpl<$Res, $Val extends Player>
    implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? isDeleted = freezed,
    Object? avatarFileName = freezed,
    Object? bggName = freezed,
    Object? avatarImageUri = null,
    Object? avatarFileToSave = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: freezed == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      avatarFileName: freezed == avatarFileName
          ? _value.avatarFileName
          : avatarFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      bggName: freezed == bggName
          ? _value.bggName
          : bggName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarImageUri: null == avatarImageUri
          ? _value.avatarImageUri
          : avatarImageUri // ignore: cast_nullable_to_non_nullable
              as String,
      avatarFileToSave: freezed == avatarFileToSave
          ? _value.avatarFileToSave
          : avatarFileToSave // ignore: cast_nullable_to_non_nullable
              as XFile?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PlayerCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$$_PlayerCopyWith(_$_Player value, $Res Function(_$_Player) then) =
      __$$_PlayerCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String? name,
      @HiveField(3) bool? isDeleted,
      @HiveField(4) String? avatarFileName,
      @HiveField(5) String? bggName,
      String avatarImageUri,
      XFile? avatarFileToSave});
}

/// @nodoc
class __$$_PlayerCopyWithImpl<$Res>
    extends _$PlayerCopyWithImpl<$Res, _$_Player>
    implements _$$_PlayerCopyWith<$Res> {
  __$$_PlayerCopyWithImpl(_$_Player _value, $Res Function(_$_Player) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? isDeleted = freezed,
    Object? avatarFileName = freezed,
    Object? bggName = freezed,
    Object? avatarImageUri = null,
    Object? avatarFileToSave = freezed,
  }) {
    return _then(_$_Player(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: freezed == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      avatarFileName: freezed == avatarFileName
          ? _value.avatarFileName
          : avatarFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      bggName: freezed == bggName
          ? _value.bggName
          : bggName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarImageUri: null == avatarImageUri
          ? _value.avatarImageUri
          : avatarImageUri // ignore: cast_nullable_to_non_nullable
              as String,
      avatarFileToSave: freezed == avatarFileToSave
          ? _value.avatarFileToSave
          : avatarFileToSave // ignore: cast_nullable_to_non_nullable
              as XFile?,
    ));
  }
}

/// @nodoc

@HiveType(typeId: HiveBoxes.playersTypeId, adapterName: 'PlayerAdapter')
class _$_Player implements _Player {
  const _$_Player(
      {@HiveField(0) required this.id,
      @HiveField(1) this.name,
      @HiveField(3) this.isDeleted,
      @HiveField(4) this.avatarFileName,
      @HiveField(5) this.bggName,
      this.avatarImageUri = Constants.defaultAvatartAssetsPath,
      this.avatarFileToSave});

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String? name;
  @override
  @HiveField(3)
  final bool? isDeleted;
  @override
  @HiveField(4)
  final String? avatarFileName;
  @override
  @HiveField(5)
  final String? bggName;
  @override
  @JsonKey()
  final String avatarImageUri;
  @override
  final XFile? avatarFileToSave;

  @override
  String toString() {
    return 'Player(id: $id, name: $name, isDeleted: $isDeleted, avatarFileName: $avatarFileName, bggName: $bggName, avatarImageUri: $avatarImageUri, avatarFileToSave: $avatarFileToSave)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Player &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.avatarFileName, avatarFileName) ||
                other.avatarFileName == avatarFileName) &&
            (identical(other.bggName, bggName) || other.bggName == bggName) &&
            (identical(other.avatarImageUri, avatarImageUri) ||
                other.avatarImageUri == avatarImageUri) &&
            (identical(other.avatarFileToSave, avatarFileToSave) ||
                other.avatarFileToSave == avatarFileToSave));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, isDeleted,
      avatarFileName, bggName, avatarImageUri, avatarFileToSave);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PlayerCopyWith<_$_Player> get copyWith =>
      __$$_PlayerCopyWithImpl<_$_Player>(this, _$identity);
}

abstract class _Player implements Player {
  const factory _Player(
      {@HiveField(0) required final String id,
      @HiveField(1) final String? name,
      @HiveField(3) final bool? isDeleted,
      @HiveField(4) final String? avatarFileName,
      @HiveField(5) final String? bggName,
      final String avatarImageUri,
      final XFile? avatarFileToSave}) = _$_Player;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String? get name;
  @override
  @HiveField(3)
  bool? get isDeleted;
  @override
  @HiveField(4)
  String? get avatarFileName;
  @override
  @HiveField(5)
  String? get bggName;
  @override
  String get avatarImageUri;
  @override
  XFile? get avatarFileToSave;
  @override
  @JsonKey(ignore: true)
  _$$_PlayerCopyWith<_$_Player> get copyWith =>
      throw _privateConstructorUsedError;
}
