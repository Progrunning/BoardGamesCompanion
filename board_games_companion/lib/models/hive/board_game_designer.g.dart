// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_designer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardGameDesignerAdapter extends TypeAdapter<BoardGameDesigner> {
  @override
  final int typeId = 8;

  @override
  BoardGameDesigner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoardGameDesigner(
      id: fields[0] as String,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BoardGameDesigner obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardGameDesignerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
