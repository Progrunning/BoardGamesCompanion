// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_artist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardGameArtistAdapter extends TypeAdapter<BoardGameArtist> {
  @override
  final typeId = 7;

  @override
  BoardGameArtist read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoardGameArtist()
      ..id = fields[0] as String
      ..name = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, BoardGameArtist obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }
}
