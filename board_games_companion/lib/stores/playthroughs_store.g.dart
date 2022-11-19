// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthroughs_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughsStore on _PlaythroughsStore, Store {
  Computed<List<Playthrough>>? _$finishedPlaythroughsComputed;

  @override
  List<Playthrough> get finishedPlaythroughs =>
      (_$finishedPlaythroughsComputed ??= Computed<List<Playthrough>>(
              () => super.finishedPlaythroughs,
              name: '_PlaythroughsStore.finishedPlaythroughs'))
          .value;
  Computed<List<Playthrough>>? _$ongoingPlaythroughsComputed;

  @override
  List<Playthrough> get ongoingPlaythroughs =>
      (_$ongoingPlaythroughsComputed ??= Computed<List<Playthrough>>(
              () => super.ongoingPlaythroughs,
              name: '_PlaythroughsStore.ongoingPlaythroughs'))
          .value;

  late final _$playthroughsAtom =
      Atom(name: '_PlaythroughsStore.playthroughs', context: context);

  @override
  ObservableList<Playthrough> get playthroughs {
    _$playthroughsAtom.reportRead();
    return super.playthroughs;
  }

  @override
  set playthroughs(ObservableList<Playthrough> value) {
    _$playthroughsAtom.reportWrite(value, super.playthroughs, () {
      super.playthroughs = value;
    });
  }

  @override
  String toString() {
    return '''
playthroughs: ${playthroughs},
finishedPlaythroughs: ${finishedPlaythroughs},
ongoingPlaythroughs: ${ongoingPlaythroughs}
    ''';
  }
}
