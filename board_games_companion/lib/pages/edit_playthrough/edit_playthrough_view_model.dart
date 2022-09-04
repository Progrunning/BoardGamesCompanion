// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/models/playthrough_details.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../common/enums/playthrough_status.dart';

part 'edit_playthrough_view_model.g.dart';

@injectable
class EditPlaythoughViewModel = _EditPlaythoughViewModel with _$EditPlaythoughViewModel;

abstract class _EditPlaythoughViewModel with Store {
  _EditPlaythoughViewModel(this._playthroughsStore);

  late final String _playthroughId;
  final PlaythroughsStore _playthroughsStore;

  late PlaythroughDetails _updatedPlaythroughDetails;
  PlaythroughDetails get updatedPlaythroughDetails => _updatedPlaythroughDetails;

  @computed
  PlaythroughDetails get playthroughDetails =>
      _playthroughsStore.playthroughs.firstWhere((pd) => pd.id == _playthroughId);

  @computed
  Playthrough get playthrough => updatedPlaythroughDetails.playthrough;

  @computed
  ObservableList<PlayerScore> get playerScores =>
      updatedPlaythroughDetails.playerScores.asObservable();

  @computed
  DateTime get playthroughStartTime => updatedPlaythroughDetails.startDate;

  @computed
  bool get playthoughEnded => updatedPlaythroughDetails.playthoughEnded;

  @computed
  Duration get playthoughDuration => (updatedPlaythroughDetails.endDate ?? DateTime.now())
      .difference(updatedPlaythroughDetails.startDate);

  // ! MK Make sure that all properties of PlaythrougDetails are Freezed so comparison works https://stackoverflow.com/questions/60383178/combine-freezed-hive
  bool get isDirty => updatedPlaythroughDetails == playthroughDetails;

  @action
  void setPlaythroughId(String playthroughId) {
    _playthroughId = playthroughId;
    _updatedPlaythroughDetails = playthroughDetails.copyWith();
  }

  @action
  Future<void> stopPlaythrough() async {
    await _playthroughsStore.updatePlaythrough(updatedPlaythroughDetails.copyWith(
        playthrough: playthrough.copyWith(
      status: PlaythroughStatus.Finished,
      endDate: DateTime.now().toUtc(),
    )));
  }

  @action
  Future<void> saveChanges() async {
    if (isDirty) {
      await _playthroughsStore.updatePlaythrough(updatedPlaythroughDetails);
    }
  }

  @action
  void updateStartDate(DateTime newStartDate) {
    final updatedPlaythrough = playthrough.copyWith(
      startDate: newStartDate,
      status: PlaythroughStatus.Finished,
      endDate: newStartDate.add(playthoughDuration),
    );
    _updatedPlaythroughDetails =
        _updatedPlaythroughDetails.copyWith(playthrough: updatedPlaythrough);
  }

  @action
  void updateDuration(int hoursPlayed, int minutesPlyed) {
    final updatedPlaythrough = playthrough.copyWith(
        endDate:
            playthroughDetails.startDate.add(Duration(hours: hoursPlayed, minutes: minutesPlyed)));

    _updatedPlaythroughDetails =
        _updatedPlaythroughDetails.copyWith(playthrough: updatedPlaythrough);
  }

  // ! MK Update the scores on save
  @action
  void updatePlayerScore(PlayerScore playerScore, int newScore) {
    if (playerScore.score.valueInt == newScore) {
      return;
    }

    final updatedPlayerScore =
        playerScore.copyWith(score: playerScore.score.copyWith(value: newScore.toString()));
  }
  //   final currentPlayerScore = _updatedPlaythroughDetails.playerScores
  //       .firstWhere((element) => element.player?.id == playerScore.player?.id);
  //   if (currentPlayerScore == null) {
  //     return;
  //   }

  //   _updatedPlaythroughDetails =
  //       _updatedPlaythroughDetails.copyWith(playerScores: updatedPlaythrough);
  // }

  @action
  Future<void> deletePlaythrough() async {
    await _playthroughsStore.deletePlaythrough(playthroughDetails.id);
  }
}
