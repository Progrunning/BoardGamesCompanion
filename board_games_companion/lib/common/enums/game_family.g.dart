// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_family.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameFamilyAdapter extends TypeAdapter<GameFamily> {
  @override
  final int typeId = 16;

  @override
  GameFamily read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GameFamily.HighestScore;
      case 1:
        return GameFamily.LowestScore;
      case 2:
        return GameFamily.Cooperative;
      default:
        return GameFamily.HighestScore;
    }
  }

  @override
  void write(BinaryWriter writer, GameFamily obj) {
    switch (obj) {
      case GameFamily.HighestScore:
        writer.writeByte(0);
        break;
      case GameFamily.LowestScore:
        writer.writeByte(1);
        break;
      case GameFamily.Cooperative:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameFamilyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
