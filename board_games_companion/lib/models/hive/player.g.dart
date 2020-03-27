// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final typeId = 2;

  @override
  Player read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Player()
      ..id = fields[0] as String
      .._name = fields[1] as String
      .._imageUri = fields[2] as String
      .._isDeleted = fields[3] as bool;
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj._name)
      ..writeByte(2)
      ..write(obj._imageUri)
      ..writeByte(3)
      ..write(obj._isDeleted);
  }
}
