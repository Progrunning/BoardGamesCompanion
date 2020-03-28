// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScoreAdapter extends TypeAdapter<Score> {
  @override
  final typeId = 4;

  @override
  Score read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Score()
      ..id = fields[0] as String
      ..playthroughId = fields[1] as String
      ..playerId = fields[2] as String
      ..boardGameId = fields[3] as String
      ..value = fields[4] as String
      ..isDeleted = fields[5] as String;
  }

  @override
  void write(BinaryWriter writer, Score obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.playthroughId)
      ..writeByte(2)
      ..write(obj.playerId)
      ..writeByte(3)
      ..write(obj.boardGameId)
      ..writeByte(4)
      ..write(obj.value)
      ..writeByte(5)
      ..write(obj.isDeleted);
  }
}
