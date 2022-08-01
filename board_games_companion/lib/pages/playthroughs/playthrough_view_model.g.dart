// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthrough_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughViewModel on _PlaythroughViewModel, Store {
  Computed<Playthrough>? _$playthroughComputed;

  @override
  Playthrough get playthrough =>
      (_$playthroughComputed ??= Computed<Playthrough>(() => super.playthrough,
              name: '_PlaythroughViewModel.playthrough'))
          .value;
  Computed<bool>? _$playthoughEndedComputed;

  @override
  bool get playthoughEnded =>
      (_$playthoughEndedComputed ??= Computed<bool>(() => super.playthoughEnded,
              name: '_PlaythroughViewModel.playthoughEnded'))
          .value;

  late final _$_playthroughAtom =
      Atom(name: '_PlaythroughViewModel._playthrough', context: context);

  @override
  Playthrough? get _playthrough {
    _$_playthroughAtom.reportRead();
    return super._playthrough;
  }

  @override
  set _playthrough(Playthrough? value) {
    _$_playthroughAtom.reportWrite(value, super._playthrough, () {
      super._playthrough = value;
    });
  }

  late final _$scoresAtom =
      Atom(name: '_PlaythroughViewModel.scores', context: context);

  @override
  ObservableList<Score>? get scores {
    _$scoresAtom.reportRead();
    return super.scores;
  }

  @override
  set scores(ObservableList<Score>? value) {
    _$scoresAtom.reportWrite(value, super.scores, () {
      super.scores = value;
    });
  }

  late final _$playersAtom =
      Atom(name: '_PlaythroughViewModel.players', context: context);

  @override
  ObservableList<Player>? get players {
    _$playersAtom.reportRead();
    return super.players;
  }

  @override
  set players(ObservableList<Player>? value) {
    _$playersAtom.reportWrite(value, super.players, () {
      super.players = value;
    });
  }

  late final _$playerScoresAtom =
      Atom(name: '_PlaythroughViewModel.playerScores', context: context);

  @override
  ObservableList<PlayerScore>? get playerScores {
    _$playerScoresAtom.reportRead();
    return super.playerScores;
  }

  @override
  set playerScores(ObservableList<PlayerScore>? value) {
    _$playerScoresAtom.reportWrite(value, super.playerScores, () {
      super.playerScores = value;
    });
  }

  late final _$futureLoadPlaythroughAtom = Atom(
      name: '_PlaythroughViewModel.futureLoadPlaythrough', context: context);

  @override
  ObservableFuture<void>? get futureLoadPlaythrough {
    _$futureLoadPlaythroughAtom.reportRead();
    return super.futureLoadPlaythrough;
  }

  @override
  set futureLoadPlaythrough(ObservableFuture<void>? value) {
    _$futureLoadPlaythroughAtom.reportWrite(value, super.futureLoadPlaythrough,
        () {
      super.futureLoadPlaythrough = value;
    });
  }

  late final _$_PlaythroughViewModelActionController =
      ActionController(name: '_PlaythroughViewModel', context: context);

  @override
  void loadPlaythrough(Playthrough playthrough) {
    final _$actionInfo = _$_PlaythroughViewModelActionController.startAction(
        name: '_PlaythroughViewModel.loadPlaythrough');
    try {
      return super.loadPlaythrough(playthrough);
    } finally {
      _$_PlaythroughViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
scores: ${scores},
players: ${players},
playerScores: ${playerScores},
futureLoadPlaythrough: ${futureLoadPlaythrough},
playthrough: ${playthrough},
playthoughEnded: ${playthoughEnded}
    ''';
  }
}
