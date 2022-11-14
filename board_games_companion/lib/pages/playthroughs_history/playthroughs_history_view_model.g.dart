// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthroughs_history_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughsHistoryViewModel on _PlaythroughsHistoryViewModel, Store {
  Computed<Map<DateTime, BoardGamePlaythrough>>? _$finishedPlaythroughsComputed;

  @override
  Map<DateTime, BoardGamePlaythrough> get finishedPlaythroughs =>
      (_$finishedPlaythroughsComputed ??=
              Computed<Map<DateTime, BoardGamePlaythrough>>(
                  () => super.finishedPlaythroughs,
                  name: '_PlaythroughsHistoryViewModel.finishedPlaythroughs'))
          .value;

  late final _$futureLoadGamesPlaythroughsAtom = Atom(
      name: '_PlaythroughsHistoryViewModel.futureLoadGamesPlaythroughs',
      context: context);

  @override
  ObservableFuture<void>? get futureLoadGamesPlaythroughs {
    _$futureLoadGamesPlaythroughsAtom.reportRead();
    return super.futureLoadGamesPlaythroughs;
  }

  @override
  set futureLoadGamesPlaythroughs(ObservableFuture<void>? value) {
    _$futureLoadGamesPlaythroughsAtom
        .reportWrite(value, super.futureLoadGamesPlaythroughs, () {
      super.futureLoadGamesPlaythroughs = value;
    });
  }

  late final _$_PlaythroughsHistoryViewModelActionController =
      ActionController(name: '_PlaythroughsHistoryViewModel', context: context);

  @override
  void loadGamesPlaythroughs() {
    final _$actionInfo =
        _$_PlaythroughsHistoryViewModelActionController.startAction(
            name: '_PlaythroughsHistoryViewModel.loadGamesPlaythroughs');
    try {
      return super.loadGamesPlaythroughs();
    } finally {
      _$_PlaythroughsHistoryViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
futureLoadGamesPlaythroughs: ${futureLoadGamesPlaythroughs},
finishedPlaythroughs: ${finishedPlaythroughs}
    ''';
  }
}
