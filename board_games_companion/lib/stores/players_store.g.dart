// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'players_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlayersStore on _PlayersStore, Store {
  Computed<List<Player>>? _$activePlayersComputed;

  @override
  List<Player> get activePlayers => (_$activePlayersComputed ??=
          Computed<List<Player>>(() => super.activePlayers,
              name: '_PlayersStore.activePlayers'))
      .value;
  Computed<Map<String, Player>>? _$playersByIdComputed;

  @override
  Map<String, Player> get playersById => (_$playersByIdComputed ??=
          Computed<Map<String, Player>>(() => super.playersById,
              name: '_PlayersStore.playersById'))
      .value;

  late final _$playersAtom =
      Atom(name: '_PlayersStore.players', context: context);

  @override
  ObservableList<Player> get players {
    _$playersAtom.reportRead();
    return super.players;
  }

  @override
  set players(ObservableList<Player> value) {
    _$playersAtom.reportWrite(value, super.players, () {
      super.players = value;
    });
  }

  late final _$loadPlayersAsyncAction =
      AsyncAction('_PlayersStore.loadPlayers', context: context);

  @override
  Future<void> loadPlayers() {
    return _$loadPlayersAsyncAction.run(() => super.loadPlayers());
  }

  late final _$createOrUpdatePlayerAsyncAction =
      AsyncAction('_PlayersStore.createOrUpdatePlayer', context: context);

  @override
  Future<bool> createOrUpdatePlayer(Player player) {
    return _$createOrUpdatePlayerAsyncAction
        .run(() => super.createOrUpdatePlayer(player));
  }

  late final _$deletePlayerAsyncAction =
      AsyncAction('_PlayersStore.deletePlayer', context: context);

  @override
  Future<bool> deletePlayer(String playerId) {
    return _$deletePlayerAsyncAction.run(() => super.deletePlayer(playerId));
  }

  @override
  String toString() {
    return '''
players: ${players},
activePlayers: ${activePlayers},
playersById: ${playersById}
    ''';
  }
}
