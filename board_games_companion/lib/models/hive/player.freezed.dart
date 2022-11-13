// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

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
      _$PlayerCopyWithImpl<$Res>;
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
class _$PlayerCopyWithImpl<$Res> implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._value, this._then);

  final Player _value;
  // ignore: unused_field
  final $Res Function(Player) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? isDeleted = freezed,
    Object? avatarFileName = freezed,
    Object? bggName = freezed,
    Object? avatarImageUri = freezed,
    Object? avatarFileToSave = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: isDeleted == freezed
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      avatarFileName: avatarFileName == freezed
          ? _value.avatarFileName
          : avatarFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      bggName: bggName == freezed
          ? _value.bggName
          : bggName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarImageUri: avatarImageUri == freezed
          ? _value.avatarImageUri
          : avatarImageUri // ignore: cast_nullable_to_non_nullable
              as String,
      avatarFileToSave: avatarFileToSave == freezed
          ? _value.avatarFileToSave
          : avatarFileToSave // ignore: cast_nullable_to_non_nullable
              as XFile?,
    ));
  }
}

/// @nodoc
abstract class _$$_PlayerCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$$_PlayerCopyWith(_$_Player value, $Res Function(_$_Player) then) =
      __$$_PlayerCopyWithImpl<$Res>;
  @override
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
class __$$_PlayerCopyWithImpl<$Res> extends _$PlayerCopyWithImpl<$Res>
    implements _$$_PlayerCopyWith<$Res> {
  __$$_PlayerCopyWithImpl(_$_Player _value, $Res Function(_$_Player) _then)
      : super(_value, (v) => _then(v as _$_Player));

  @override
  _$_Player get _value => super._value as _$_Player;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? isDeleted = freezed,
    Object? avatarFileName = freezed,
    Object? bggName = freezed,
    Object? avatarImageUri = freezed,
    Object? avatarFileToSave = freezed,
  }) {
    return _then(_$_Player(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: isDeleted == freezed
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      avatarFileName: avatarFileName == freezed
          ? _value.avatarFileName
          : avatarFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      bggName: bggName == freezed
          ? _value.bggName
          : bggName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarImageUri: avatarImageUri == freezed
          ? _value.avatarImageUri
          : avatarImageUri // ignore: cast_nullable_to_non_nullable
              as String,
      avatarFileToSave: avatarFileToSave == freezed
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
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.isDeleted, isDeleted) &&
            const DeepCollectionEquality()
                .equals(other.avatarFileName, avatarFileName) &&
            const DeepCollectionEquality().equals(other.bggName, bggName) &&
            const DeepCollectionEquality()
                .equals(other.avatarImageUri, avatarImageUri) &&
            const DeepCollectionEquality()
                .equals(other.avatarFileToSave, avatarFileToSave));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(isDeleted),
      const DeepCollectionEquality().hash(avatarFileName),
      const DeepCollectionEquality().hash(bggName),
      const DeepCollectionEquality().hash(avatarImageUri),
      const DeepCollectionEquality().hash(avatarFileToSave));

  @JsonKey(ignore: true)
  @override
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
