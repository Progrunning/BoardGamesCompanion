// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'no_score_game_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoScoreGameResultAdapter extends TypeAdapter<_$_NoScoreGameResult> {
  @override
  final int typeId = 21;

  @override
  _$_NoScoreGameResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_NoScoreGameResult();
  }

  @override
  void write(BinaryWriter writer, _$_NoScoreGameResult obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoScoreGameResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
