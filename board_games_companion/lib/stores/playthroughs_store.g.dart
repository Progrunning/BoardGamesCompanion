// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthroughs_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughsStore on _PlaythroughsStore, Store {
  late final _$playthroughsDetailsAtom =
      Atom(name: '_PlaythroughsStore.playthroughsDetails', context: context);

  @override
  ObservableList<PlaythroughDetails> get playthroughsDetails {
    _$playthroughsDetailsAtom.reportRead();
    return super.playthroughsDetails;
  }

  @override
  set playthroughsDetails(ObservableList<PlaythroughDetails> value) {
    _$playthroughsDetailsAtom.reportWrite(value, super.playthroughsDetails, () {
      super.playthroughsDetails = value;
    });
  }

  late final _$loadPlaythroughsAsyncAction =
      AsyncAction('_PlaythroughsStore.loadPlaythroughs', context: context);

  @override
  Future<void> loadPlaythroughs() {
    return _$loadPlaythroughsAsyncAction.run(() => super.loadPlaythroughs());
  }

  late final _$_PlaythroughsStoreActionController =
      ActionController(name: '_PlaythroughsStore', context: context);

  @override
  void setBoardGame(BoardGameDetails boardGame) {
    final _$actionInfo = _$_PlaythroughsStoreActionController.startAction(
        name: '_PlaythroughsStore.setBoardGame');
    try {
      return super.setBoardGame(boardGame);
    } finally {
      _$_PlaythroughsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
playthroughsDetails: ${playthroughsDetails}
    ''';
  }
}
