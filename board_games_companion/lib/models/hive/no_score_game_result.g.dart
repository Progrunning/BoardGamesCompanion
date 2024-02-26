// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'no_score_game_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CooperativeGameResultAdapter extends TypeAdapter<CooperativeGameResult> {
  @override
  final int typeId = 22;

  @override
  CooperativeGameResult read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CooperativeGameResult.win;
      case 1:
        return CooperativeGameResult.loss;
      default:
        return CooperativeGameResult.win;
    }
  }

  @override
  void write(BinaryWriter writer, CooperativeGameResult obj) {
    switch (obj) {
      case CooperativeGameResult.win:
        writer.writeByte(0);
        break;
      case CooperativeGameResult.loss:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CooperativeGameResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NoScoreGameResultAdapter extends TypeAdapter<_$NoScoreGameResultImpl> {
  @override
  final int typeId = 21;

  @override
  _$NoScoreGameResultImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$NoScoreGameResultImpl(
      cooperativeGameResult: fields[0] as CooperativeGameResult?,
    );
  }

  @override
  void write(BinaryWriter writer, _$NoScoreGameResultImpl obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.cooperativeGameResult);
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
