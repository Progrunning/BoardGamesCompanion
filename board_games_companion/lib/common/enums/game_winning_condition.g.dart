// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_winning_condition.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameWinningConditionAdapter extends TypeAdapter<GameWinningCondition> {
  @override
  final int typeId = 16;

  @override
  GameWinningCondition read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GameWinningCondition.HighestScore;
      case 1:
        return GameWinningCondition.LowestScore;
      default:
        return GameWinningCondition.HighestScore;
    }
  }

  @override
  void write(BinaryWriter writer, GameWinningCondition obj) {
    switch (obj) {
      case GameWinningCondition.HighestScore:
        writer.writeByte(0);
        break;
      case GameWinningCondition.LowestScore:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameWinningConditionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
