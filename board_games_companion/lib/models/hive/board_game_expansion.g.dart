// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_expansion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardGamesExpansionAdapter extends TypeAdapter<BoardGamesExpansion> {
  @override
  final int typeId = 15;

  @override
  BoardGamesExpansion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoardGamesExpansion(
      id: fields[0] as String,
      name: fields[1] as String,
    )..isInCollection = fields[2] as bool?;
  }

  @override
  void write(BinaryWriter writer, BoardGamesExpansion obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isInCollection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardGamesExpansionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
