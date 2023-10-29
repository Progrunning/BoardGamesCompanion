// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardGameSettingsAdapter extends TypeAdapter<_$BoardGameSettingsImpl> {
  @override
  final int typeId = 17;

  @override
  _$BoardGameSettingsImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$BoardGameSettingsImpl(
      gameFamily: fields[1] as GameFamily,
      averageScorePrecision: fields[2] == null ? 0 : fields[2] as int,
      gameClassification: fields[3] == null
          ? GameClassification.Score
          : fields[3] as GameClassification,
    );
  }

  @override
  void write(BinaryWriter writer, _$BoardGameSettingsImpl obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.gameFamily)
      ..writeByte(2)
      ..write(obj.averageScorePrecision)
      ..writeByte(3)
      ..write(obj.gameClassification);
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
