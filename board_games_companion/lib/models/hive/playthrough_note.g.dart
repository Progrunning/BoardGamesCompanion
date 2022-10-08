// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthrough_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaythroughNoteAdapter extends TypeAdapter<_$_PlaythroughNote> {
  @override
  final int typeId = 18;

  @override
  _$_PlaythroughNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_PlaythroughNote(
      id: fields[0] as String,
      text: fields[1] as String,
      createdAt: fields[2] as DateTime,
      modifiedAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, _$_PlaythroughNote obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.modifiedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaythroughNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
