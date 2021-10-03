// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_by.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderByAdapter extends TypeAdapter<OrderBy> {
  @override
  final int typeId = 13;

  @override
  OrderBy read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrderBy.Ascending;
      case 1:
        return OrderBy.Descending;
      default:
        return OrderBy.Ascending;
    }
  }

  @override
  void write(BinaryWriter writer, OrderBy obj) {
    switch (obj) {
      case OrderBy.Ascending:
        writer.writeByte(0);
        break;
      case OrderBy.Descending:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderByAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
