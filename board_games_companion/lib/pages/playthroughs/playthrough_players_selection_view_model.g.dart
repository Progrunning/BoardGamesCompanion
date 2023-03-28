// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthrough_players_selection_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughPlayersSelectionViewModel
    on _PlaythroughPlayersSelectionViewModel, Store {
  Computed<ObservableList<Player>>? _$playersComputed;

  @override
  ObservableList<Player> get players => (_$playersComputed ??=
          Computed<ObservableList<Player>>(() => super.players,
              name: '_PlaythroughPlayersSelectionViewModel.players'))
      .value;
  Computed<Map<String, Player>>? _$playersMapComputed;

  @override
  Map<String, Player> get playersMap => (_$playersMapComputed ??=
          Computed<Map<String, Player>>(() => super.playersMap,
              name: '_PlaythroughPlayersSelectionViewModel.playersMap'))
      .value;

  late final _$selectedPlayersMapAtom = Atom(
      name: '_PlaythroughPlayersSelectionViewModel.selectedPlayersMap',
      context: context);

  @override
  ObservableMap<String, Player> get selectedPlayersMap {
    _$selectedPlayersMapAtom.reportRead();
    return super.selectedPlayersMap;
  }

  @override
  set selectedPlayersMap(ObservableMap<String, Player> value) {
    _$selectedPlayersMapAtom.reportWrite(value, super.selectedPlayersMap, () {
      super.selectedPlayersMap = value;
    });
  }

  late final _$futureLoadPlayersAtom = Atom(
      name: '_PlaythroughPlayersSelectionViewModel.futureLoadPlayers',
      context: context);

  @override
  ObservableFuture<void>? get futureLoadPlayers {
    _$futureLoadPlayersAtom.reportRead();
    return super.futureLoadPlayers;
  }

  @override
  set futureLoadPlayers(ObservableFuture<void>? value) {
    _$futureLoadPlayersAtom.reportWrite(value, super.futureLoadPlayers, () {
      super.futureLoadPlayers = value;
    });
  }

  late final _$_PlaythroughPlayersSelectionViewModelActionController =
      ActionController(
          name: '_PlaythroughPlayersSelectionViewModel', context: context);

  @override
  void loadPlayers() {
    final _$actionInfo = _$_PlaythroughPlayersSelectionViewModelActionController
        .startAction(name: '_PlaythroughPlayersSelectionViewModel.loadPlayers');
    try {
      return super.loadPlayers();
    } finally {
      _$_PlaythroughPlayersSelectionViewModelActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void togglePlayerSelection(Player player) {
    final _$actionInfo =
        _$_PlaythroughPlayersSelectionViewModelActionController.startAction(
            name:
                '_PlaythroughPlayersSelectionViewModel.togglePlayerSelection');
    try {
      return super.togglePlayerSelection(player);
    } finally {
      _$_PlaythroughPlayersSelectionViewModelActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedPlayersMap: ${selectedPlayersMap},
futureLoadPlayers: ${futureLoadPlayers},
players: ${players},
playersMap: ${playersMap}
    ''';
  }
}
