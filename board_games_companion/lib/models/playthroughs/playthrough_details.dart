import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/enums/game_classification.dart';
import '../../common/enums/playthrough_status.dart';
import '../../extensions/scores_extensions.dart';
import '../hive/playthrough.dart';
import '../hive/playthrough_note.dart';
import '../player_score.dart';

part 'playthrough_details.freezed.dart';

/// Model that contains the [Playthrough] and [PlayerScore] details
///
/// NOTE: This model was created becuase the [Playthrough] model only has player and score ids, rather than objects
@freezed
class PlaythroughDetails with _$PlaythroughDetails {
  const factory PlaythroughDetails({
    required Playthrough playthrough,
    required List<PlayerScore> playerScores,
  }) = _PlaythroughDetails;

  const PlaythroughDetails._();

  int? get daysSinceStart => DateTime.now().toUtc().difference(playthrough.startDate).inDays;

  Duration get duration {
    final nowUtc = DateTime.now().toUtc();
    final playthroughEndDate = playthrough.endDate ?? nowUtc;
    return playthroughEndDate.difference(playthrough.startDate);
  }

  bool get playthoughEnded => playthrough.status == PlaythroughStatus.Finished;

  PlaythroughStatus? get status => playthrough.status;

  String get id => playthrough.id;

  String get boardGameId => playthrough.boardGameId;

  int? get bggPlayId => playthrough.bggPlayId;

  DateTime get startDate => playthrough.startDate;

  DateTime? get endDate => playthrough.endDate;

  List<PlaythroughNote>? get notes => playthrough.notes;

  bool get hasNotes => notes?.isNotEmpty ?? false;

  GameClassification get playerScoreBasedGameClassification {
    if (playerScores.any((playerScore) => playerScore.score.noScoreGameResult != null)) {
      return GameClassification.NoScore;
    }

    return GameClassification.Score;
  }

  PlaythroughNote? get latestNote => notes?.sortedBy((note) => note.createdAt).last;

  bool get hasAnyScores => playerScores
      .map((playerScore) => playerScore.score)
      .toList()
      .onlyScoresWithValue()
      .isNotEmpty;
}
