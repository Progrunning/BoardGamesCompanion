// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_game_results.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScoreTiebreakerTypeAdapter extends TypeAdapter<ScoreTiebreakerType> {
  @override
  final int typeId = 25;

  @override
  ScoreTiebreakerType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ScoreTiebreakerType.shared;
      case 1:
        return ScoreTiebreakerType.place;
      default:
        return ScoreTiebreakerType.shared;
    }
  }

  @override
  void write(BinaryWriter writer, ScoreTiebreakerType obj) {
    switch (obj) {
      case ScoreTiebreakerType.shared:
        writer.writeByte(0);
        break;
      case ScoreTiebreakerType.place:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreTiebreakerTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScoreGameResultAdapter extends TypeAdapter<_$_ScoreGameResult> {
  @override
  final int typeId = 24;

  @override
  _$_ScoreGameResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_ScoreGameResult(
      points: fields[0] as double?,
      place: fields[1] as int?,
      tiebreakerType: fields[2] as ScoreTiebreakerType?,
    );
  }

  @override
  void write(BinaryWriter writer, _$_ScoreGameResult obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.points)
      ..writeByte(1)
      ..write(obj.place)
      ..writeByte(2)
      ..write(obj.tiebreakerType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreGameResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
