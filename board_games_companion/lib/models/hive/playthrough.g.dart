// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthrough.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaythroughAdapter extends TypeAdapter<Playthrough> {
  @override
  final int typeId = 3;

  @override
  Playthrough read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Playthrough(
      id: fields[0] as String,
      boardGameId: fields[1] as String,
      playerIds: (fields[2] as List).cast<String>(),
      scoreIds: (fields[3] as List).cast<String>(),
      startDate: fields[4] as DateTime,
      bggPlayId: fields[8] as int?,
    )
      ..endDate = fields[5] as DateTime?
      ..status = fields[6] as PlaythroughStatus?
      ..isDeleted = fields[7] as bool?;
  }

  @override
  void write(BinaryWriter writer, Playthrough obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.boardGameId)
      ..writeByte(2)
      ..write(obj.playerIds)
      ..writeByte(3)
      ..write(obj.scoreIds)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.isDeleted)
      ..writeByte(8)
      ..write(obj.bggPlayId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaythroughAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Playthrough on _Playthrough, Store {
  late final _$startDateAtom =
      Atom(name: '_Playthrough.startDate', context: context);

  @override
  DateTime get startDate {
    _$startDateAtom.reportRead();
    return super.startDate;
  }

  @override
  set startDate(DateTime value) {
    _$startDateAtom.reportWrite(value, super.startDate, () {
      super.startDate = value;
    });
  }

  late final _$endDateAtom =
      Atom(name: '_Playthrough.endDate', context: context);

  @override
  DateTime? get endDate {
    _$endDateAtom.reportRead();
    return super.endDate;
  }

  @override
  set endDate(DateTime? value) {
    _$endDateAtom.reportWrite(value, super.endDate, () {
      super.endDate = value;
    });
  }

  late final _$statusAtom = Atom(name: '_Playthrough.status', context: context);

  @override
  PlaythroughStatus? get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(PlaythroughStatus? value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$isDeletedAtom =
      Atom(name: '_Playthrough.isDeleted', context: context);

  @override
  bool? get isDeleted {
    _$isDeletedAtom.reportRead();
    return super.isDeleted;
  }

  @override
  set isDeleted(bool? value) {
    _$isDeletedAtom.reportWrite(value, super.isDeleted, () {
      super.isDeleted = value;
    });
  }

  @override
  String toString() {
    return '''
startDate: ${startDate},
endDate: ${endDate},
status: ${status},
isDeleted: ${isDeleted}
    ''';
  }
}
