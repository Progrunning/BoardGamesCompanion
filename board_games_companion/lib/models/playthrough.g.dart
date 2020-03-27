// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthrough.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaythroughAdapter extends TypeAdapter<Playthrough> {
  @override
  final typeId = 3;

  @override
  Playthrough read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Playthrough()
      ..id = fields[0] as String
      ..boardGameId = fields[1] as String
      ..playerIds = (fields[2] as List)?.cast<String>()
      ..scoreIds = (fields[3] as List)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, Playthrough obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.boardGameId)
      ..writeByte(2)
      ..write(obj.playerIds)
      ..writeByte(3)
      ..write(obj.scoreIds);
  }
}
