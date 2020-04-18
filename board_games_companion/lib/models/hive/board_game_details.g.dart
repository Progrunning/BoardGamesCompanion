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
      ..categories = (fields[7] as List)?.cast<BoardGameCategory>()
      ..publishers = (fields[16] as List)?.cast<BoardGamePublisher>()
      ..artists = (fields[17] as List)?.cast<BoardGameArtist>()
      ..desingers = (fields[18] as List)?.cast<BoardGameDesigner>()
      ..imageUrl = fields[5] as String
      ..description = fields[6] as String
      ..rating = fields[8] as double
      ..votes = fields[9] as int
      ..minPlayers = fields[10] as int
      ..minPlaytime = fields[11] as int
      ..maxPlayers = fields[12] as int
      ..maxPlaytime = fields[13] as int
      ..minAge = fields[14] as int
      ..avgWeight = fields[15] as num
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..thumbnailUrl = fields[2] as String
      ..rank = fields[3] as int
      ..yearPublished = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, BoardGameDetails obj) {
    writer
      ..writeByte(19)
      ..writeByte(7)
      ..write(obj.categories)
      ..writeByte(16)
      ..write(obj.publishers)
      ..writeByte(17)
      ..write(obj.artists)
      ..writeByte(18)
      ..write(obj.desingers)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.rating)
      ..writeByte(9)
      ..write(obj.votes)
      ..writeByte(10)
      ..write(obj.minPlayers)
      ..writeByte(11)
      ..write(obj.minPlaytime)
      ..writeByte(12)
      ..write(obj.maxPlayers)
      ..writeByte(13)
      ..write(obj.maxPlaytime)
      ..writeByte(14)
      ..write(obj.minAge)
      ..writeByte(15)
      ..write(obj.avgWeight)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.thumbnailUrl)
      ..writeByte(3)
      ..write(obj.rank)
      ..writeByte(4)
      ..write(obj.yearPublished);
  }
}
