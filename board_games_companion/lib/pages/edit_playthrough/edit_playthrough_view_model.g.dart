// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_playthrough_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditPlaythoughViewModel on _EditPlaythoughViewModel, Store {
  Computed<PlaythroughDetails>? _$playthroughDetailsComputed;

  @override
  PlaythroughDetails get playthroughDetails => (_$playthroughDetailsComputed ??=
          Computed<PlaythroughDetails>(() => super.playthroughDetails,
              name: '_EditPlaythoughViewModel.playthroughDetails'))
      .value;
  Computed<Playthrough>? _$playthroughComputed;

  @override
  Playthrough get playthrough =>
      (_$playthroughComputed ??= Computed<Playthrough>(() => super.playthrough,
              name: '_EditPlaythoughViewModel.playthrough'))
          .value;
  Computed<List<PlayerScore>>? _$playerScoresComputed;

  @override
  List<PlayerScore> get playerScores => (_$playerScoresComputed ??=
          Computed<List<PlayerScore>>(() => super.playerScores,
              name: '_EditPlaythoughViewModel.playerScores'))
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
  String toString() {
    return '''
playthroughDetails: ${playthroughDetails},
playthrough: ${playthrough},
playerScores: ${playerScores},
playthroughStartTime: ${playthroughStartTime},
playthoughEnded: ${playthoughEnded},
playthoughDuration: ${playthoughDuration}
    ''';
  }
}
