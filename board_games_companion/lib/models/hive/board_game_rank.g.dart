// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_rank.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardGameRankAdapter extends TypeAdapter<BoardGameRank> {
  @override
  final int typeId = 9;

  @override
  BoardGameRank read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoardGameRank(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      friendlyName: fields[3] as String?,
      rank: fields[4] as num?,
    );
  }

  @override
  void write(BinaryWriter writer, BoardGameRank obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.friendlyName)
      ..writeByte(4)
      ..write(obj.rank);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardGameRankAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
