// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/models/hive/no_score_game_result.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/models/playthroughs/playthrough_details.dart';
import 'package:board_games_companion/pages/playthroughs/playthrough_migration.dart';
import 'package:board_games_companion/pages/playthroughs/playthrough_migration_progress.dart';
import 'package:board_games_companion/stores/game_playthroughs_details_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'playthrough_migration_view_model.g.dart';

@injectable
class PlaythroughMigrationViewModel = _PlaythroughMigrationViewModel
    with _$PlaythroughMigrationViewModel;

abstract class _PlaythroughMigrationViewModel with Store {
  _PlaythroughMigrationViewModel(this._gamePlaythroughsStore);

  final GamePlaythroughsDetailsStore _gamePlaythroughsStore;

  late PlaythroughDetails? _ogirinalPlaythroughDetails;

  bool get isDirty {
    return playthroughMighration.when(
      init: () => false,
      fromScoreToCooperative: (playthroughDetails, cooperativeGameResult) =>
          _ogirinalPlaythroughDetails != playthroughDetails || cooperativeGameResult != null,
    );
  }

  @observable
  PlaythroughMigration playthroughMighration = const PlaythroughMigration.init();

  @observable
  PlaythroughMigrationProgress playthroughMighrationProgress =
      const PlaythroughMigrationProgress.init();

  @action
  void setPlaythroughMigration(PlaythroughMigration playthroughMighration) {
    this.playthroughMighration = playthroughMighration;
    this.playthroughMighration.maybeWhen(
          fromScoreToCooperative: (playthroughDetails, cooperativeGameResult) {
            _ogirinalPlaythroughDetails = playthroughDetails;
          },
          orElse: () {},
        );
  }

  @action
  Future<void> migrate() async {
    playthroughMighrationProgress = const PlaythroughMigrationProgress.inProgress();

    /// MK Without this delay mobx doesn't seem to be firing evens correctly.
    ///    The assumptions is that they are happening to quickly after one another,
    ///    therefore this "random" delay was introduced
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await playthroughMighration.when(
      init: () async =>
          playthroughMighrationProgress = const PlaythroughMigrationProgress.failure(),
      fromScoreToCooperative: (playthroughDetails, cooperativeGameResult) async {
        await _migrateFromScoreToCooperative(playthroughDetails, cooperativeGameResult);
      },
    );
  }

  @action
  void updateCooperativeGameResult(CooperativeGameResult newCooperativeGameResult) {
    playthroughMighration.maybeWhen(
      fromScoreToCooperative: (playthroughDetails, cooperativeGameResult) {
        final playerScores = [...playthroughDetails.playerScores].map(
          (playerScore) => playerScore.copyWith(
            score: playerScore.score.copyWith(
              noScoreGameResult: NoScoreGameResult(
                cooperativeGameResult: newCooperativeGameResult,
              ),
            ),
          ),
        );
        playthroughMighration = PlaythroughMigration.fromScoreToCooperative(
          playthroughDetails: playthroughDetails.copyWith(
            playerScores: playerScores.toList(),
          ),
          cooperativeGameResult: newCooperativeGameResult,
        );
      },
      orElse: () {},
    );
  }

  @action
  void removePlayerScore(PlayerScore playerScoreToRemove) {
    playthroughMighration.maybeWhen(
      fromScoreToCooperative: (playthroughDetails, cooperativeGameResult) {
        final playerScoreIds = [...playthroughDetails.playthrough.scoreIds];
        final playerIds = [...playthroughDetails.playthrough.playerIds];
        final playerScores = [...playthroughDetails.playerScores];
        playerScores.remove(playerScoreToRemove);
        playerScoreIds.remove(playerScoreToRemove.score.id);
        playerIds.remove(playerScoreToRemove.player?.id);

        playthroughMighration = PlaythroughMigration.fromScoreToCooperative(
          playthroughDetails: playthroughDetails.copyWith(
            playthrough: playthroughDetails.playthrough.copyWith(
              playerIds: playerIds,
              scoreIds: playerScoreIds,
            ),
            playerScores: playerScores,
          ),
          cooperativeGameResult: cooperativeGameResult,
        );
      },
      orElse: () {},
    );
  }

  Future<void> _migrateFromScoreToCooperative(
    PlaythroughDetails playthroughDetails,
    CooperativeGameResult? cooperativeGameResult,
  ) async {
    try {
      if (cooperativeGameResult == null) {
        playthroughMighrationProgress = const PlaythroughMigrationProgress.invalid(
          validationErrorMessage:
              AppText.playthroughMigrationScoreToCooperativeInvalidFormErrorMessage,
        );
        return;
      }

      await _gamePlaythroughsStore.updatePlaythrough(playthroughDetails);
    } on Exception catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      playthroughMighrationProgress = const PlaythroughMigrationProgress.failure();
      return;
    }

    playthroughMighrationProgress = const PlaythroughMigrationProgress.success();
  }
}
