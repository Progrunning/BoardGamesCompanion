// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_prices.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardGamePricesAdapter extends TypeAdapter<_$BoardGamePricesImpl> {
  @override
  final int typeId = 23;

  @override
  _$BoardGamePricesImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$BoardGamePricesImpl(
      region: fields[0] as String,
      websiteUrl: fields[1] as String,
      highest: fields[2] as double?,
      average: fields[3] as double?,
      median: fields[4] as double?,
      lowest: fields[5] as double?,
      lowestStoreName: fields[6] as String?,
      lowest30d: fields[7] as double?,
      lowest30dStore: fields[8] as String?,
      lowest30dDate: fields[9] as DateTime?,
      lowest52w: fields[10] as double?,
      lowest52wStore: fields[11] as String?,
      lowest52wDate: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, _$BoardGamePricesImpl obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.region)
      ..writeByte(1)
      ..write(obj.websiteUrl)
      ..writeByte(2)
      ..write(obj.highest)
      ..writeByte(3)
      ..write(obj.average)
      ..writeByte(4)
      ..write(obj.median)
      ..writeByte(5)
      ..write(obj.lowest)
      ..writeByte(6)
      ..write(obj.lowestStoreName)
      ..writeByte(7)
      ..write(obj.lowest30d)
      ..writeByte(8)
      ..write(obj.lowest30dStore)
      ..writeByte(9)
      ..write(obj.lowest30dDate)
      ..writeByte(10)
      ..write(obj.lowest52w)
      ..writeByte(11)
      ..write(obj.lowest52wStore)
      ..writeByte(12)
      ..write(obj.lowest52wDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardGamePricesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
