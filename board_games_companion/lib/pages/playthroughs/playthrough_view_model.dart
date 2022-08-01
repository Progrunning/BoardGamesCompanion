// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/common/enums/game_winning_condition.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../common/enums/playthrough_status.dart';
import '../../extensions/scores_extensions.dart';
import '../../models/hive/player.dart';
import '../../models/hive/playthrough.dart';
import '../../models/hive/score.dart';
import '../../models/player_score.dart';
import '../../services/player_service.dart';
import '../../services/score_service.dart';
import '../../stores/playthroughs_store.dart';

part 'playthrough_view_model.g.dart';

@injectable
class PlaythroughViewModel = _PlaythroughViewModel with _$PlaythroughViewModel;

abstract class _PlaythroughViewModel with Store {
  _PlaythroughViewModel(
    this._playerService,
    this._scoreService,
    this._playthroughsStore,
  );

  final PlayerService _playerService;
  final ScoreService _scoreService;
  final PlaythroughsStore _playthroughsStore;

  // MK Can't use late with mobx becuase of this issue https://github.com/mobxjs/mobx.dart/issues/598
  @observable
  Playthrough? _playthrough;

  @computed
  Playthrough get playthrough => _playthrough!;

  int? _daysSinceStart;
  int? get daysSinceStart => _daysSinceStart;

  Duration get duration {
    final nowUtc = DateTime.now().toUtc();
    final playthroughEndDate = playthrough.endDate ?? nowUtc;
    return playthroughEndDate.difference(playthrough.startDate);
  }

  @computed
  bool get playthoughEnded => playthrough.status == PlaythroughStatus.Finished;

  @observable
  ObservableList<Score>? scores;

  @observable
  ObservableList<Player>? players;

  @observable
  ObservableList<PlayerScore>? playerScores;

  @observable
  ObservableFuture<void>? futureLoadPlaythrough;

  @action
  void loadPlaythrough(Playthrough playthrough) =>
      futureLoadPlaythrough = ObservableFuture<void>(_loadPlaythrough(playthrough));

  Future<void> _loadPlaythrough(Playthrough playthrough) async {
    if (playthrough.id.isEmpty) {
      return;
    }

    final nowUtc = DateTime.now().toUtc();
    _playthrough = playthrough;
    _daysSinceStart = nowUtc.difference(_playthrough!.startDate).inDays;

    try {
      scores = ObservableList.of((await _scoreService.retrieveScores([_playthrough!.id]))
        ..sortByScore(_playthroughsStore.boardGame.settings?.winningCondition ??
            GameWinningCondition.HighestScore)
        ..toList());
      players = ObservableList.of(await _playerService.retrievePlayers(
        playerIds: _playthrough!.playerIds,
        includeDeleted: true,
      ));

      playerScores = ObservableList.of(scores!.mapIndexed((int index, Score score) {
        final player = players!.firstWhereOrNull((Player p) => score.playerId == p.id);
        return PlayerScore.withPlace(player, score, index + 1);
      }).toList());
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Future<void> updatePlaythrough(Playthrough playthrough, List<PlayerScore> playerScores) async {
    await _playthroughsStore.updatePlaythrough(playthrough);
    for (final PlayerScore playerScore in playerScores) {
      await _scoreService.addOrUpdateScore(playerScore.score);
    }

    // MK Reload all playthrough data from Hive's db
    loadPlaythrough(playthrough);
  }

  Future<bool> stopPlaythrough() async {
    final oldStatus = playthrough.status;

    playthrough.status = PlaythroughStatus.Finished;
    playthrough.endDate = DateTime.now().toUtc();

    final updateSucceeded = await _playthroughsStore.updatePlaythrough(playthrough);
    if (!updateSucceeded) {
      playthrough.status = oldStatus;
      playthrough.endDate = null;
      return false;
    }

    return true;
  }
}
