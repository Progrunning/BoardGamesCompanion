// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_filters.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollectionFiltersAdapter extends TypeAdapter<CollectionFilters> {
  @override
  final int typeId = 14;

  @override
  CollectionFilters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CollectionFilters()
      ..sortBy = fields[0] as SortBy
      ..filterByRating = fields[1] as double
      ..minNumberOfPlayers = fields[2] as int
      ..maxNumberOfPlayers = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, CollectionFilters obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.sortBy)
      ..writeByte(1)
      ..write(obj.filterByRating)
      ..writeByte(2)
      ..write(obj.minNumberOfPlayers)
      ..writeByte(3)
      ..write(obj.maxNumberOfPlayers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectionFiltersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
