// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthroughs_history_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughsHistoryViewModel on _PlaythroughsHistoryViewModel, Store {
  Computed<ObservableList<PlaythroughDetails>>? _$playthroughsComputed;

  @override
  ObservableList<PlaythroughDetails> get playthroughs =>
      (_$playthroughsComputed ??= Computed<ObservableList<PlaythroughDetails>>(
              () => super.playthroughs,
              name: '_PlaythroughsHistoryViewModel.playthroughs'))
          .value;
  Computed<bool>? _$hasAnyPlaythroughsComputed;

  @override
  bool get hasAnyPlaythroughs => (_$hasAnyPlaythroughsComputed ??=
          Computed<bool>(() => super.hasAnyPlaythroughs,
              name: '_PlaythroughsHistoryViewModel.hasAnyPlaythroughs'))
      .value;
  Computed<GameClassification>? _$gameClassificationComputed;

  @override
  GameClassification get gameClassification => (_$gameClassificationComputed ??=
          Computed<GameClassification>(() => super.gameClassification,
              name: '_PlaythroughsHistoryViewModel.gameClassification'))
      .value;

  late final _$futureloadPlaythroughsAtom = Atom(
      name: '_PlaythroughsHistoryViewModel.futureloadPlaythroughs',
      context: context);

  @override
  ObservableFuture<void>? get futureloadPlaythroughs {
    _$futureloadPlaythroughsAtom.reportRead();
    return super.futureloadPlaythroughs;
  }

  @override
  set futureloadPlaythroughs(ObservableFuture<void>? value) {
    _$futureloadPlaythroughsAtom
        .reportWrite(value, super.futureloadPlaythroughs, () {
      super.futureloadPlaythroughs = value;
    });
  }

  late final _$_PlaythroughsHistoryViewModelActionController =
      ActionController(name: '_PlaythroughsHistoryViewModel', context: context);

  @override
  void loadPlaythroughs() {
    final _$actionInfo = _$_PlaythroughsHistoryViewModelActionController
        .startAction(name: '_PlaythroughsHistoryViewModel.loadPlaythroughs');
    try {
      return super.loadPlaythroughs();
    } finally {
      _$_PlaythroughsHistoryViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
futureloadPlaythroughs: ${futureloadPlaythroughs},
playthroughs: ${playthroughs},
hasAnyPlaythroughs: ${hasAnyPlaythroughs},
gameClassification: ${gameClassification}
    ''';
  }
}
