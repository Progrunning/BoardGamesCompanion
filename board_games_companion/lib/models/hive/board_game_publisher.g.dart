// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_publisher.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardGamePublisherAdapter extends TypeAdapter<BoardGamePublisher> {
  @override
  final typeId = 6;

  @override
  BoardGamePublisher read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoardGamePublisher()
      ..id = fields[0] as String
      ..name = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, BoardGamePublisher obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }
}
