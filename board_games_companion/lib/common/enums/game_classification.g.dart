// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_classification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameClassificationAdapter extends TypeAdapter<GameClassification> {
  @override
  final int typeId = 20;

  @override
  GameClassification read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GameClassification.Score;
      case 1:
        return GameClassification.NoScore;
      default:
        return GameClassification.Score;
    }
  }

  @override
  void write(BinaryWriter writer, GameClassification obj) {
    switch (obj) {
      case GameClassification.Score:
        writer.writeByte(0);
        break;
      case GameClassification.NoScore:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameClassificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
