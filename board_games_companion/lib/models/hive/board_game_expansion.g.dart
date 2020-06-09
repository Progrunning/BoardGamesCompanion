// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_expansion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardGamesExpansionAdapter extends TypeAdapter<BoardGamesExpansion> {
  @override
  final typeId = 15;

  @override
  BoardGamesExpansion read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoardGamesExpansion()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..isInCollection = fields[2] as bool;
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
}
