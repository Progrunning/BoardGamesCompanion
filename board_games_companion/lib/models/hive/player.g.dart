// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerAdapter extends TypeAdapter<_$PlayerImpl> {
  @override
  final int typeId = 2;

  @override
  _$PlayerImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$PlayerImpl(
      id: fields[0] as String,
      name: fields[1] as String?,
      isDeleted: fields[3] as bool?,
      avatarFileName: fields[4] as String?,
      bggName: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, _$PlayerImpl obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.isDeleted)
      ..writeByte(4)
      ..write(obj.avatarFileName)
      ..writeByte(5)
      ..write(obj.bggName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
