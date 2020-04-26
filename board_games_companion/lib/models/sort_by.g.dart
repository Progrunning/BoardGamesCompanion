// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sort_by.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SortByAdapter extends TypeAdapter<SortBy> {
  @override
  final typeId = 11;

  @override
  SortBy read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SortBy()
      ..sortByOption = fields[0] as SortByOption
      ..orderBy = fields[1] as OrderBy
      ..selected = fields[2] as bool;
  }

  @override
  void write(BinaryWriter writer, SortBy obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.sortByOption)
      ..writeByte(1)
      ..write(obj.orderBy)
      ..writeByte(2)
      ..write(obj.selected);
  }
}
