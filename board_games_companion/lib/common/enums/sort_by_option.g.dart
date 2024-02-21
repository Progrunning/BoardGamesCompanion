// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sort_by_option.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SortByOptionAdapter extends TypeAdapter<SortByOption> {
  @override
  final int typeId = 12;

  @override
  SortByOption read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SortByOption.Name;
      case 1:
        return SortByOption.YearPublished;
      case 2:
        return SortByOption.LastUpdated;
      case 3:
        return SortByOption.Rank;
      case 4:
        return SortByOption.NumberOfPlayers;
      case 5:
        return SortByOption.Playtime;
      case 6:
        return SortByOption.Rating;
      case 7:
        return SortByOption.MostRecentlyPlayed;
      default:
        return SortByOption.Name;
    }
  }

  @override
  void write(BinaryWriter writer, SortByOption obj) {
    switch (obj) {
      case SortByOption.Name:
        writer.writeByte(0);
        break;
      case SortByOption.YearPublished:
        writer.writeByte(1);
        break;
      case SortByOption.LastUpdated:
        writer.writeByte(2);
        break;
      case SortByOption.Rank:
        writer.writeByte(3);
        break;
      case SortByOption.NumberOfPlayers:
        writer.writeByte(4);
        break;
      case SortByOption.Playtime:
        writer.writeByte(5);
        break;
      case SortByOption.Rating:
        writer.writeByte(6);
        break;
      case SortByOption.MostRecentlyPlayed:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortByOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
