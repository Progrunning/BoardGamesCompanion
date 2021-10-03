// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthrough.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaythroughAdapter extends TypeAdapter<Playthrough> {
  @override
  final int typeId = 3;

  @override
  Playthrough read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Playthrough()
      ..id = fields[0] as String
      ..boardGameId = fields[1] as String
      ..playerIds = (fields[2] as List).cast<String>()
      ..scoreIds = (fields[3] as List).cast<String>()
      ..startDate = fields[4] as DateTime
      ..endDate = fields[5] as DateTime?
      ..status = fields[6] as PlaythroughStatus
      ..isDeleted = fields[7] as bool;
  }

  @override
  void write(BinaryWriter writer, Playthrough obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.boardGameId)
      ..writeByte(2)
      ..write(obj.playerIds)
      ..writeByte(3)
      ..write(obj.scoreIds)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaythroughAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
