// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_filters.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollectionFiltersAdapter extends TypeAdapter<CollectionFilters> {
  @override
  final int typeId = 14;

  @override
  CollectionFilters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CollectionFilters()
      ..sortBy = fields[0] as SortBy?
      ..filterByRating = fields[1] as double?
      ..numberOfPlayers = fields[2] as int?;
  }

  @override
  void write(BinaryWriter writer, CollectionFilters obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.sortBy)
      ..writeByte(1)
      ..write(obj.filterByRating)
      ..writeByte(2)
      ..write(obj.numberOfPlayers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectionFiltersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CollectionFilters on _CollectionFilters, Store {
  late final _$sortByAtom =
      Atom(name: '_CollectionFilters.sortBy', context: context);

  @override
  SortBy? get sortBy {
    _$sortByAtom.reportRead();
    return super.sortBy;
  }

  @override
  set sortBy(SortBy? value) {
    _$sortByAtom.reportWrite(value, super.sortBy, () {
      super.sortBy = value;
    });
  }

  late final _$filterByRatingAtom =
      Atom(name: '_CollectionFilters.filterByRating', context: context);

  @override
  double? get filterByRating {
    _$filterByRatingAtom.reportRead();
    return super.filterByRating;
  }

  @override
  set filterByRating(double? value) {
    _$filterByRatingAtom.reportWrite(value, super.filterByRating, () {
      super.filterByRating = value;
    });
  }

  late final _$numberOfPlayersAtom =
      Atom(name: '_CollectionFilters.numberOfPlayers', context: context);

  @override
  int? get numberOfPlayers {
    _$numberOfPlayersAtom.reportRead();
    return super.numberOfPlayers;
  }

  @override
  set numberOfPlayers(int? value) {
    _$numberOfPlayersAtom.reportWrite(value, super.numberOfPlayers, () {
      super.numberOfPlayers = value;
    });
  }

  @override
  String toString() {
    return '''
sortBy: ${sortBy},
filterByRating: ${filterByRating},
numberOfPlayers: ${numberOfPlayers}
    ''';
  }
}
