import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/enums/game_classification.dart';
import '../../common/enums/playthrough_status.dart';
import '../hive/playthrough.dart';
import '../hive/playthrough_note.dart';
import '../hive/score.dart';
import '../player_score.dart';
import 'score_tirebreaker.dart';

part 'playthrough_details.freezed.dart';

/// Model that contains the [Playthrough] and [PlayerScore] details
///
/// NOTE: This model was created becuase the [Playthrough] model only has player and score ids, rather than objects
@freezed
class PlaythroughDetails with _$PlaythroughDetails {
  const factory PlaythroughDetails({
    required Playthrough playthrough,
    required List<PlayerScore> playerScores,
    List<ScoreTiebreaker>? scoreTiebreakers,
  }) = _PlaythroughDetails;

  const PlaythroughDetails._();

  int get daysSinceStart => DateTime.now().toUtc().difference(playthrough.startDate).inDays;

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

  bool get hasTies => tiedPlayerScores.isNotEmpty;

  List<PlayerScore> get tiedPlayerScores =>
      playerScores.where((playerScore) => playerScore.id != null && playerScore.isTied).toList();

  GameClassification get playerScoreBasedGameClassification {
    if (playerScores.any((playerScore) => playerScore.score.noScoreGameResult != null)) {
      return GameClassification.NoScore;
    }

    return GameClassification.Score;
  }

  PlaythroughNote? get latestNote => notes?.sortedBy((note) => note.createdAt).last;

  List<Score> get scoresWithValue =>
      playerScores.map((playerScore) => playerScore.score).onlyScoresWithValue();

  bool get hasAnyScores => scoresWithValue.isNotEmpty;

  bool get finishedScoring => scoresWithValue.length == playerScores.length;
}
