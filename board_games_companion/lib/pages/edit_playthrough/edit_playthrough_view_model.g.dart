// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_playthrough_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditPlaythoughViewModel on _EditPlaythoughViewModel, Store {
  Computed<Map<String, ScoreTiebreakerType>>? _$scoreTiebreakersSetComputed;

  @override
  Map<String, ScoreTiebreakerType> get scoreTiebreakersSet =>
      (_$scoreTiebreakersSetComputed ??=
              Computed<Map<String, ScoreTiebreakerType>>(
                  () => super.scoreTiebreakersSet,
                  name: '_EditPlaythoughViewModel.scoreTiebreakersSet'))
          .value;
  Computed<PlaythroughDetails?>? _$playthroughDetailsComputed;

  @override
  PlaythroughDetails? get playthroughDetails =>
      (_$playthroughDetailsComputed ??= Computed<PlaythroughDetails?>(
              () => super.playthroughDetails,
              name: '_EditPlaythoughViewModel.playthroughDetails'))
          .value;
  Computed<Playthrough>? _$playthroughComputed;

  @override
  Playthrough get playthrough =>
      (_$playthroughComputed ??= Computed<Playthrough>(() => super.playthrough,
              name: '_EditPlaythoughViewModel.playthrough'))
          .value;
  Computed<ObservableList<Player>>? _$playersComputed;

  @override
  ObservableList<Player> get players => (_$playersComputed ??=
          Computed<ObservableList<Player>>(() => super.players,
              name: '_EditPlaythoughViewModel.players'))
      .value;
  Computed<DateTime>? _$playthroughStartTimeComputed;

  @override
  DateTime get playthroughStartTime => (_$playthroughStartTimeComputed ??=
          Computed<DateTime>(() => super.playthroughStartTime,
              name: '_EditPlaythoughViewModel.playthroughStartTime'))
      .value;
  Computed<bool>? _$playthoughEndedComputed;

  @override
  bool get playthoughEnded =>
      (_$playthoughEndedComputed ??= Computed<bool>(() => super.playthoughEnded,
              name: '_EditPlaythoughViewModel.playthoughEnded'))
          .value;
  Computed<Duration>? _$playthoughDurationComputed;

  @override
  Duration get playthoughDuration => (_$playthoughDurationComputed ??=
          Computed<Duration>(() => super.playthoughDuration,
              name: '_EditPlaythoughViewModel.playthoughDuration'))
      .value;
  Computed<bool>? _$hasNotesComputed;

  @override
  bool get hasNotes =>
      (_$hasNotesComputed ??= Computed<bool>(() => super.hasNotes,
              name: '_EditPlaythoughViewModel.hasNotes'))
          .value;
  Computed<ObservableList<PlaythroughNote>?>? _$notesComputed;

  @override
  ObservableList<PlaythroughNote>? get notes => (_$notesComputed ??=
          Computed<ObservableList<PlaythroughNote>?>(() => super.notes,
              name: '_EditPlaythoughViewModel.notes'))
      .value;
  Computed<CooperativeGameResult?>? _$cooperativeGameResultComputed;

  @override
  CooperativeGameResult? get cooperativeGameResult =>
      (_$cooperativeGameResultComputed ??= Computed<CooperativeGameResult?>(
              () => super.cooperativeGameResult,
              name: '_EditPlaythoughViewModel.cooperativeGameResult'))
          .value;

  late final _$playthroughScoresVisualStateAtom = Atom(
      name: '_EditPlaythoughViewModel.playthroughScoresVisualState',
      context: context);

  @override
  PlaythroughScoresVisualState get playthroughScoresVisualState {
    _$playthroughScoresVisualStateAtom.reportRead();
    return super.playthroughScoresVisualState;
  }

  @override
  set playthroughScoresVisualState(PlaythroughScoresVisualState value) {
    _$playthroughScoresVisualStateAtom
        .reportWrite(value, super.playthroughScoresVisualState, () {
      super.playthroughScoresVisualState = value;
    });
  }

  late final _$editPlaythroughPageVisualStateAtom = Atom(
      name: '_EditPlaythoughViewModel.editPlaythroughPageVisualState',
      context: context);

  @override
  EditPlaythroughPageVisualStates get editPlaythroughPageVisualState {
    _$editPlaythroughPageVisualStateAtom.reportRead();
    return super.editPlaythroughPageVisualState;
  }

  @override
  set editPlaythroughPageVisualState(EditPlaythroughPageVisualStates value) {
    _$editPlaythroughPageVisualStateAtom
        .reportWrite(value, super.editPlaythroughPageVisualState, () {
      super.editPlaythroughPageVisualState = value;
    });
  }

  late final _$_playthroughDetailsWorkingCopyAtom = Atom(
      name: '_EditPlaythoughViewModel._playthroughDetailsWorkingCopy',
      context: context);

  @override
  PlaythroughDetails? get _playthroughDetailsWorkingCopy {
    _$_playthroughDetailsWorkingCopyAtom.reportRead();
    return super._playthroughDetailsWorkingCopy;
  }

  @override
  set _playthroughDetailsWorkingCopy(PlaythroughDetails? value) {
    _$_playthroughDetailsWorkingCopyAtom
        .reportWrite(value, super._playthroughDetailsWorkingCopy, () {
      super._playthroughDetailsWorkingCopy = value;
    });
  }

  late final _$playerScoresAtom =
      Atom(name: '_EditPlaythoughViewModel.playerScores', context: context);

  @override
  ObservableList<PlayerScore> get playerScores {
    _$playerScoresAtom.reportRead();
    return super.playerScores;
  }

  @override
  set playerScores(ObservableList<PlayerScore> value) {
    _$playerScoresAtom.reportWrite(value, super.playerScores, () {
      super.playerScores = value;
    });
  }

  late final _$stopPlaythroughAsyncAction =
      AsyncAction('_EditPlaythoughViewModel.stopPlaythrough', context: context);

  @override
  Future<void> stopPlaythrough() {
    return _$stopPlaythroughAsyncAction.run(() => super.stopPlaythrough());
  }

  late final _$saveChangesAsyncAction =
      AsyncAction('_EditPlaythoughViewModel.saveChanges', context: context);

  @override
  Future<void> saveChanges() {
    return _$saveChangesAsyncAction.run(() => super.saveChanges());
  }

  late final _$deletePlaythroughAsyncAction = AsyncAction(
      '_EditPlaythoughViewModel.deletePlaythrough',
      context: context);

  @override
  Future<void> deletePlaythrough() {
    return _$deletePlaythroughAsyncAction.run(() => super.deletePlaythrough());
  }

  late final _$_EditPlaythoughViewModelActionController =
      ActionController(name: '_EditPlaythoughViewModel', context: context);

  @override
  void setPlaythroughId(String playthroughId) {
    final _$actionInfo = _$_EditPlaythoughViewModelActionController.startAction(
        name: '_EditPlaythoughViewModel.setPlaythroughId');
    try {
      return super.setPlaythroughId(playthroughId);
    } finally {
      _$_EditPlaythoughViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBoardGameId(String boardGameId) {
    final _$actionInfo = _$_EditPlaythoughViewModelActionController.startAction(
        name: '_EditPlaythoughViewModel.setBoardGameId');
    try {
      return super.setBoardGameId(boardGameId);
    } finally {
      _$_EditPlaythoughViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateStartDate(DateTime newStartDate) {
    final _$actionInfo = _$_EditPlaythoughViewModelActionController.startAction(
        name: '_EditPlaythoughViewModel.updateStartDate');
    try {
      return super.updateStartDate(newStartDate);
    } finally {
      _$_EditPlaythoughViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateDuration(int hoursPlayed, int minutesPlyed) {
    final _$actionInfo = _$_EditPlaythoughViewModelActionController.startAction(
        name: '_EditPlaythoughViewModel.updateDuration');
    try {
      return super.updateDuration(hoursPlayed, minutesPlyed);
    } finally {
      _$_EditPlaythoughViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updatePlayerScore(PlayerScore playerScore, double newScore) {
    final _$actionInfo = _$_EditPlaythoughViewModelActionController.startAction(
        name: '_EditPlaythoughViewModel.updatePlayerScore');
    try {
      return super.updatePlayerScore(playerScore, newScore);
    } finally {
      _$_EditPlaythoughViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reorderPlayerScores(int currentIndex, int movingToIndex) {
    final _$actionInfo = _$_EditPlaythoughViewModelActionController.startAction(
        name: '_EditPlaythoughViewModel.reorderPlayerScores');
    try {
      return super.reorderPlayerScores(currentIndex, movingToIndex);
    } finally {
      _$_EditPlaythoughViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleSharedPlaceTiebreaker(PlayerScore playerScore, bool sharePlace) {
    final _$actionInfo = _$_EditPlaythoughViewModelActionController.startAction(
        name: '_EditPlaythoughViewModel.toggleSharedPlaceTiebreaker');
    try {
      return super.toggleSharedPlaceTiebreaker(playerScore, sharePlace);
    } finally {
      _$_EditPlaythoughViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCooperativeGameResult(
      CooperativeGameResult cooperativeGameResult) {
    final _$actionInfo = _$_EditPlaythoughViewModelActionController.startAction(
        name: '_EditPlaythoughViewModel.updateCooperativeGameResult');
    try {
      return super.updateCooperativeGameResult(cooperativeGameResult);
    } finally {
      _$_EditPlaythoughViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addPlaythroughNote(PlaythroughNote note) {
    final _$actionInfo = _$_EditPlaythoughViewModelActionController.startAction(
        name: '_EditPlaythoughViewModel.addPlaythroughNote');
    try {
      return super.addPlaythroughNote(note);
    } finally {
      _$_EditPlaythoughViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editPlaythroughNote(PlaythroughNote note) {
    final _$actionInfo = _$_EditPlaythoughViewModelActionController.startAction(
        name: '_EditPlaythoughViewModel.editPlaythroughNote');
    try {
      return super.editPlaythroughNote(note);
    } finally {
      _$_EditPlaythoughViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deletePlaythroughNote(PlaythroughNote note) {
    final _$actionInfo = _$_EditPlaythoughViewModelActionController.startAction(
        name: '_EditPlaythoughViewModel.deletePlaythroughNote');
    try {
      return super.deletePlaythroughNote(note);
    } finally {
      _$_EditPlaythoughViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
playthroughScoresVisualState: ${playthroughScoresVisualState},
editPlaythroughPageVisualState: ${editPlaythroughPageVisualState},
playerScores: ${playerScores},
scoreTiebreakersSet: ${scoreTiebreakersSet},
playthroughDetails: ${playthroughDetails},
playthrough: ${playthrough},
players: ${players},
playthroughStartTime: ${playthroughStartTime},
playthoughEnded: ${playthoughEnded},
playthoughDuration: ${playthoughDuration},
hasNotes: ${hasNotes},
notes: ${notes},
cooperativeGameResult: ${cooperativeGameResult}
    ''';
  }
}
