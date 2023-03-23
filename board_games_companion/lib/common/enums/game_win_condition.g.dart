// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_win_condition.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameWinConditionAdapter extends TypeAdapter<GameWinCondition> {
  @override
  final int typeId = 16;

  @override
  GameWinCondition read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GameWinCondition.HighestScore;
      case 1:
        return GameWinCondition.LowestScore;
      default:
        return GameWinCondition.HighestScore;
    }
  }

  @override
  void write(BinaryWriter writer, GameWinCondition obj) {
    switch (obj) {
      case GameWinCondition.HighestScore:
        writer.writeByte(0);
        break;
      case GameWinCondition.LowestScore:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameWinConditionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
