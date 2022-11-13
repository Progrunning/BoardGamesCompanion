// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardGameSettingsAdapter extends TypeAdapter<_$_BoardGameSettings> {
  @override
  final int typeId = 17;

  @override
  _$_BoardGameSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_BoardGameSettings(
      winningCondition: fields[1] as GameWinningCondition,
    );
  }

  @override
  void write(BinaryWriter writer, _$_BoardGameSettings obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.winningCondition);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardGameSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
