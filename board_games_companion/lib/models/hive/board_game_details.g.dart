// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardGameDetailsAdapter extends TypeAdapter<BoardGameDetails> {
  @override
  final typeId = 0;

  @override
  BoardGameDetails read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoardGameDetails()
      ..imageUrl = fields[5] as String
      ..description = fields[6] as String
      ..categories = (fields[7] as List)?.cast<dynamic>()
      ..rating = fields[8] as double
      ..votes = fields[9] as int;
  }

  @override
  void write(BinaryWriter writer, BoardGameDetails obj) {
    writer
      ..writeByte(5)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.categories)
      ..writeByte(8)
      ..write(obj.rating)
      ..writeByte(9)
      ..write(obj.votes);
  }
}
