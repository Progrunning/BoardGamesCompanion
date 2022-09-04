import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/enums/playthrough_status.dart';
import 'hive/player.dart';
import 'hive/playthrough.dart';
import 'hive/score.dart';
import 'player_score.dart';

part 'playthrough_details.freezed.dart';

@freezed
class PlaythroughDetails with _$PlaythroughDetails {
  const factory PlaythroughDetails({
    required Playthrough playthrough,
    required List<Score> scores,
    required List<Player> players,
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
}
