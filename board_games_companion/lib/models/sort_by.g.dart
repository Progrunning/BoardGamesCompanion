// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sort_by.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SortByAdapter extends TypeAdapter<SortBy> {
  @override
  final int typeId = 11;

  @override
  SortBy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SortBy(
      sortByOption: fields[0] as SortByOption,
    )
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

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortByAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SortBy on _SortBy, Store {
  late final _$sortByOptionAtom =
      Atom(name: '_SortBy.sortByOption', context: context);

  @override
  SortByOption get sortByOption {
    _$sortByOptionAtom.reportRead();
    return super.sortByOption;
  }

  @override
  set sortByOption(SortByOption value) {
    _$sortByOptionAtom.reportWrite(value, super.sortByOption, () {
      super.sortByOption = value;
    });
  }

  late final _$orderByAtom = Atom(name: '_SortBy.orderBy', context: context);

  @override
  OrderBy get orderBy {
    _$orderByAtom.reportRead();
    return super.orderBy;
  }

  @override
  set orderBy(OrderBy value) {
    _$orderByAtom.reportWrite(value, super.orderBy, () {
      super.orderBy = value;
    });
  }

  late final _$selectedAtom = Atom(name: '_SortBy.selected', context: context);

  @override
  bool get selected {
    _$selectedAtom.reportRead();
    return super.selected;
  }

  @override
  set selected(bool value) {
    _$selectedAtom.reportWrite(value, super.selected, () {
      super.selected = value;
    });
  }

  @override
  String toString() {
    return '''
sortByOption: ${sortByOption},
orderBy: ${orderBy},
selected: ${selected}
    ''';
  }
}
