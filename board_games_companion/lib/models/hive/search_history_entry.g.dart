// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchHistoryEntryAdapter extends TypeAdapter<_$_SearchHistoryEntry> {
  @override
  final int typeId = 19;

  @override
  _$_SearchHistoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_SearchHistoryEntry(
      query: fields[0] as String,
      dateTime: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, _$_SearchHistoryEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.query)
      ..writeByte(1)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchHistoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
