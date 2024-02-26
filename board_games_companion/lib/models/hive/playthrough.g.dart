// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthrough.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaythroughAdapter extends TypeAdapter<_$PlaythroughImpl> {
  @override
  final int typeId = 3;

  @override
  _$PlaythroughImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$PlaythroughImpl(
      id: fields[0] as String,
      boardGameId: fields[1] as String,
      playerIds: (fields[2] as List).cast<String>(),
      scoreIds: (fields[3] as List).cast<String>(),
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime?,
      status: fields[6] as PlaythroughStatus?,
      isDeleted: fields[7] as bool?,
      bggPlayId: fields[8] as int?,
      notes: (fields[9] as List?)?.cast<PlaythroughNote>(),
    );
  }

  @override
  void write(BinaryWriter writer, _$PlaythroughImpl obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.boardGameId)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.isDeleted)
      ..writeByte(8)
      ..write(obj.bggPlayId)
      ..writeByte(2)
      ..write(obj.playerIds)
      ..writeByte(3)
      ..write(obj.scoreIds)
      ..writeByte(9)
      ..write(obj.notes);
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
