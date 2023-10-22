// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScoreAdapter extends TypeAdapter<_$_Score> {
  @override
  final int typeId = 4;

  @override
  _$_Score read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_Score(
      id: fields[0] as String,
      playerId: fields[2] as String,
      boardGameId: fields[3] as String,
      value: fields[4] as String?,
      playthroughId: fields[1] as String?,
      noScoreGameResult: fields[5] as NoScoreGameResult?,
      scoreGameResult: fields[6] as ScoreGameResult?,
    );
  }

  @override
  void write(BinaryWriter writer, _$_Score obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.playerId)
      ..writeByte(3)
      ..write(obj.boardGameId)
      ..writeByte(4)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.playthroughId)
      ..writeByte(5)
      ..write(obj.noScoreGameResult)
      ..writeByte(6)
      ..write(obj.scoreGameResult);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
