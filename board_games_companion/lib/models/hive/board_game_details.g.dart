// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardGameDetailsAdapter extends TypeAdapter<_$_BoardGameDetails> {
  @override
  final int typeId = 0;

  @override
  _$_BoardGameDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_BoardGameDetails(
      id: fields[0] as String,
      name: fields[1] as String,
      thumbnailUrl: fields[2] as String?,
      rank: fields[3] as int?,
      yearPublished: fields[4] as int?,
      imageUrl: fields[5] as String?,
      description: fields[6] as String?,
      categories: (fields[7] as List?)?.cast<BoardGameCategory>(),
      rating: fields[8] as double?,
      votes: fields[9] as int?,
      minPlayers: fields[10] as int?,
      minPlaytime: fields[11] as int?,
      maxPlayers: fields[12] as int?,
      maxPlaytime: fields[13] as int?,
      minAge: fields[14] as int?,
      avgWeight: fields[15] as num?,
      publishers: (fields[16] as List).cast<BoardGamePublisher>(),
      artists: (fields[17] as List).cast<BoardGameArtist>(),
      desingers: (fields[18] as List).cast<BoardGameDesigner>(),
      commentsNumber: fields[19] as int?,
      ranks: (fields[20] as List).cast<BoardGameRank>(),
      lastModified: fields[21] as DateTime?,
      expansions: (fields[22] as List).cast<BoardGameExpansion>(),
      isExpansion: fields[23] as bool?,
      isOwned: fields[24] as bool?,
      isOnWishlist: fields[25] as bool?,
      isFriends: fields[26] as bool?,
      isBggSynced: fields[27] as bool?,
      settings: fields[28] as BoardGameSettings?,
      isCreatedByUser: fields[29] == null ? false : fields[29] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, _$_BoardGameDetails obj) {
    writer
      ..writeByte(30)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.thumbnailUrl)
      ..writeByte(3)
      ..write(obj.rank)
      ..writeByte(4)
      ..write(obj.yearPublished)
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
      ..writeByte(19)
      ..write(obj.commentsNumber)
      ..writeByte(21)
      ..write(obj.lastModified)
      ..writeByte(23)
      ..write(obj.isExpansion)
      ..writeByte(24)
      ..write(obj.isOwned)
      ..writeByte(25)
      ..write(obj.isOnWishlist)
      ..writeByte(26)
      ..write(obj.isFriends)
      ..writeByte(27)
      ..write(obj.isBggSynced)
      ..writeByte(28)
      ..write(obj.settings)
      ..writeByte(29)
      ..write(obj.isCreatedByUser)
      ..writeByte(7)
      ..write(obj.categories)
      ..writeByte(16)
      ..write(obj.publishers)
      ..writeByte(17)
      ..write(obj.artists)
      ..writeByte(18)
      ..write(obj.desingers)
      ..writeByte(20)
      ..write(obj.ranks)
      ..writeByte(22)
      ..write(obj.expansions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardGameDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
