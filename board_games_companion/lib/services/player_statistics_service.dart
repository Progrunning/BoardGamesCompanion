import 'package:injectable/injectable.dart';

import '../common/enums/game_classification.dart';
import '../common/enums/game_family.dart';
import '../common/enums/playthrough_status.dart';
import '../models/hive/board_game_details.dart';
import '../models/hive/no_score_game_result.dart';
import '../models/hive/player.dart';
import '../models/hive/playthrough.dart';
import '../models/hive/score.dart';
import '../models/player_overall_statistics.dart';
import '../stores/board_games_store.dart';
import '../stores/players_store.dart';
import '../stores/playthroughs_store.dart';
import '../stores/scores_store.dart';

/// Minimum number of shared competitive plays an opponent needs before they can be
/// considered as a candidate for the subject player's rival/nemesis.
const int _minimumSharedCompetitivePlaysForHeadToHead = 3;

/// Maximum number of buddies returned in [PlayerOverallStatistics.buddies].
const int _maxBuddies = 5;

@injectable
class PlayerStatisticsService {
  PlayerStatisticsService(
    this._playersStore,
    this._playthroughsStore,
    this._scoresStore,
    this._boardGamesStore,
  );

  final PlayersStore _playersStore;
  final PlaythroughsStore _playthroughsStore;
  final ScoresStore _scoresStore;
  final BoardGamesStore _boardGamesStore;

  PlayerOverallStatistics retrievePlayerStatistics(String playerId) {
    final player = _resolvePlayerById(playerId);

    final validPlaythroughs = _playthroughsStore.playthroughs
        .where((playthrough) =>
            playthrough.status == PlaythroughStatus.Finished &&
            playthrough.isDeleted != true &&
            playthrough.playerIds.contains(playerId))
        .toList();

    // Group the scores by playthrough once so the per-playthrough loop below does not
    // re-scan the whole scores collection for every play.
    final scoresByPlaythroughId = <String, List<Score>>{};
    for (final score in _scoresStore.scores) {
      final scorePlaythroughId = score.playthroughId;
      if (scorePlaythroughId == null) {
        continue;
      }
      (scoresByPlaythroughId[scorePlaythroughId] ??= <Score>[]).add(score);
    }

    // Reading the computed map once avoids rebuilding it on every playthrough.
    final boardGamesById = _boardGamesStore.allBoardGamesMap;

    final gamesByPlays = _retrieveGamesByPlays(validPlaythroughs, boardGamesById);
    final buddies = _retrieveBuddies(playerId, validPlaythroughs);

    var totalWins = 0;
    var competitiveEligible = 0;
    var competitiveWins = 0;
    var coopEligible = 0;
    var coopWins = 0;

    // opponentId -> accumulated head-to-head data
    final headToHeadByOpponentId = <String, _HeadToHeadAccumulator>{};

    for (final playthrough in validPlaythroughs) {
      final boardGame = boardGamesById[playthrough.boardGameId];
      final gameClassification = boardGame?.settings?.gameClassification ?? GameClassification.Score;
      final gameFamily = boardGame?.settings?.gameFamily ?? GameFamily.HighestScore;
      final playScores = scoresByPlaythroughId[playthrough.id] ?? const <Score>[];
      final subjectScore = playScores.firstWhereOrNullByPlayer(playerId);
      final isSolo = playthrough.playerIds.length == 1;

      final isWin = _isWin(
        gameClassification: gameClassification,
        gameFamily: gameFamily,
        playScores: playScores,
        subjectScore: subjectScore,
      );
      if (isWin) {
        totalWins++;
      }

      if (gameClassification == GameClassification.NoScore) {
        final cooperativeResult = subjectScore?.noScoreGameResult?.cooperativeGameResult ??
            playScores
                .firstWhereOrNullResult()
                ?.noScoreGameResult
                ?.cooperativeGameResult;
        if (cooperativeResult != null) {
          coopEligible++;
          if (cooperativeResult == CooperativeGameResult.win) {
            coopWins++;
          }
        }
      } else {
        if (!isSolo && (subjectScore?.hasNumericalScore ?? false)) {
          competitiveEligible++;
          // [isWin] already reflects membership in winners(gameFamily) for this play.
          if (isWin) {
            competitiveWins++;
          }
        }

        if (!isSolo) {
          _accumulateHeadToHead(
            headToHeadByOpponentId,
            playerId: playerId,
            playthrough: playthrough,
            playScores: playScores,
            subjectScore: subjectScore,
            gameFamily: gameFamily,
          );
        }
      }
    }

    final competitiveWinRate = competitiveEligible == 0 ? null : competitiveWins / competitiveEligible;
    final coopWinRate = coopEligible == 0 ? null : coopWins / coopEligible;

    final rival = _resolveRival(headToHeadByOpponentId);
    final nemesis = _resolveNemesis(headToHeadByOpponentId);

    return PlayerOverallStatistics(
      player: player,
      totalPlays: validPlaythroughs.length,
      totalWins: totalWins,
      competitiveWinRate: competitiveWinRate,
      coopWinRate: coopWinRate,
      gamesByPlays: gamesByPlays,
      rival: rival,
      nemesis: nemesis,
      buddies: buddies,
    );
  }

  Player _resolvePlayerById(String playerId) {
    for (final player in _playersStore.players) {
      if (player.id == playerId) {
        return player;
      }
    }

    return Player(id: playerId);
  }

  List<GamePlaysCount> _retrieveGamesByPlays(
    List<Playthrough> validPlaythroughs,
    Map<String, BoardGameDetails> boardGamesById,
  ) {
    final playCountByBoardGameId = <String, int>{};
    for (final playthrough in validPlaythroughs) {
      playCountByBoardGameId[playthrough.boardGameId] =
          (playCountByBoardGameId[playthrough.boardGameId] ?? 0) + 1;
    }

    final gamesByPlays = playCountByBoardGameId.entries.map((entry) {
      final BoardGameDetails? boardGame = boardGamesById[entry.key];
      return GamePlaysCount(
        boardGameId: entry.key,
        boardGameName: boardGame?.name ?? entry.key,
        boardGameImageUrl: boardGame?.imageUrl,
        playCount: entry.value,
      );
    }).toList();

    gamesByPlays.sort((a, b) {
      final byCount = b.playCount.compareTo(a.playCount);
      if (byCount != 0) {
        return byCount;
      }

      return a.boardGameName.compareTo(b.boardGameName);
    });

    return gamesByPlays;
  }

  List<BuddyRecord> _retrieveBuddies(String playerId, List<Playthrough> validPlaythroughs) {
    final sharedPlaysByBuddyId = <String, int>{};
    for (final playthrough in validPlaythroughs) {
      for (final otherPlayerId in playthrough.playerIds) {
        if (otherPlayerId == playerId) {
          continue;
        }

        sharedPlaysByBuddyId[otherPlayerId] = (sharedPlaysByBuddyId[otherPlayerId] ?? 0) + 1;
      }
    }

    final buddies = sharedPlaysByBuddyId.entries.map((entry) {
      final buddy = _resolvePlayerById(entry.key);
      return BuddyRecord(buddy: buddy, sharedPlaysCount: entry.value);
    }).toList();

    buddies.sort((a, b) {
      final byCount = b.sharedPlaysCount.compareTo(a.sharedPlaysCount);
      if (byCount != 0) {
        return byCount;
      }

      return (a.buddy.name ?? a.buddy.id).compareTo(b.buddy.name ?? b.buddy.id);
    });

    return buddies.take(_maxBuddies).toList();
  }

  bool _isWin({
    required GameClassification gameClassification,
    required GameFamily gameFamily,
    required List<Score> playScores,
    required Score? subjectScore,
  }) {
    if (gameClassification == GameClassification.NoScore) {
      final cooperativeResult = subjectScore?.noScoreGameResult?.cooperativeGameResult ??
          playScores.firstWhereOrNullResult()?.noScoreGameResult?.cooperativeGameResult;
      return cooperativeResult == CooperativeGameResult.win;
    }

    if (subjectScore == null) {
      return false;
    }

    return playScores.winners(gameFamily).contains(subjectScore);
  }

  void _accumulateHeadToHead(
    Map<String, _HeadToHeadAccumulator> headToHeadByOpponentId, {
    required String playerId,
    required Playthrough playthrough,
    required List<Score> playScores,
    required Score? subjectScore,
    required GameFamily gameFamily,
  }) {
    for (final opponentId in playthrough.playerIds) {
      if (opponentId == playerId) {
        continue;
      }

      final accumulator = headToHeadByOpponentId.putIfAbsent(
        opponentId,
        () => _HeadToHeadAccumulator(),
      );
      accumulator.sharedCompetitivePlays++;

      if (subjectScore == null) {
        continue;
      }

      final opponentScore = playScores.firstWhereOrNullByPlayer(opponentId);
      if (opponentScore == null) {
        continue;
      }

      final comparison = _compareFinish(subjectScore, opponentScore, gameFamily);
      if (comparison == null || comparison == 0) {
        continue;
      }

      if (comparison > 0) {
        accumulator.wins++;
      } else {
        accumulator.losses++;
      }
    }
  }

  /// Compares two scores from the same play, returning:
  /// - a positive value when [subjectScore] finishes ABOVE [opponentScore]
  /// - a negative value when [subjectScore] finishes BELOW [opponentScore]
  /// - `0` when they tie
  /// - `null` when the two scores cannot be compared
  int? _compareFinish(Score subjectScore, Score opponentScore, GameFamily gameFamily) {
    final subjectPlace = subjectScore.scoreGameResult?.place;
    final opponentPlace = opponentScore.scoreGameResult?.place;
    if (subjectPlace != null && opponentPlace != null) {
      if (subjectPlace == opponentPlace) {
        return 0;
      }

      return subjectPlace < opponentPlace ? 1 : -1;
    }

    final subjectValue = subjectScore.score;
    final opponentValue = opponentScore.score;
    if (subjectValue == null || opponentValue == null) {
      return null;
    }

    if (subjectValue == opponentValue) {
      return 0;
    }

    switch (gameFamily) {
      case GameFamily.HighestScore:
        return subjectValue > opponentValue ? 1 : -1;
      case GameFamily.LowestScore:
        return subjectValue < opponentValue ? 1 : -1;
      case GameFamily.Cooperative:
        return null;
    }
  }

  HeadToHeadRecord? _resolveRival(Map<String, _HeadToHeadAccumulator> headToHeadByOpponentId) {
    final eligible = headToHeadByOpponentId.entries
        .where((entry) =>
            entry.value.sharedCompetitivePlays >= _minimumSharedCompetitivePlaysForHeadToHead &&
            entry.value.wins >= 1)
        .toList();
    if (eligible.isEmpty) {
      return null;
    }

    eligible.sort((a, b) {
      final byWins = b.value.wins.compareTo(a.value.wins);
      if (byWins != 0) {
        return byWins;
      }

      final byDiff =
          (b.value.wins - b.value.losses).compareTo(a.value.wins - a.value.losses);
      if (byDiff != 0) {
        return byDiff;
      }

      return _resolvePlayerById(a.key).name?.compareTo(_resolvePlayerById(b.key).name ?? '') ?? 0;
    });

    final best = eligible.first;
    return HeadToHeadRecord(
      opponent: _resolvePlayerById(best.key),
      wins: best.value.wins,
      losses: best.value.losses,
    );
  }

  HeadToHeadRecord? _resolveNemesis(Map<String, _HeadToHeadAccumulator> headToHeadByOpponentId) {
    final eligible = headToHeadByOpponentId.entries
        .where((entry) =>
            entry.value.sharedCompetitivePlays >= _minimumSharedCompetitivePlaysForHeadToHead &&
            entry.value.losses >= 1)
        .toList();
    if (eligible.isEmpty) {
      return null;
    }

    eligible.sort((a, b) {
      final byLosses = b.value.losses.compareTo(a.value.losses);
      if (byLosses != 0) {
        return byLosses;
      }

      final byDiff =
          (b.value.losses - b.value.wins).compareTo(a.value.losses - a.value.wins);
      if (byDiff != 0) {
        return byDiff;
      }

      return _resolvePlayerById(a.key).name?.compareTo(_resolvePlayerById(b.key).name ?? '') ?? 0;
    });

    final worst = eligible.first;
    return HeadToHeadRecord(
      opponent: _resolvePlayerById(worst.key),
      wins: worst.value.wins,
      losses: worst.value.losses,
    );
  }
}

class _HeadToHeadAccumulator {
  int wins = 0;
  int losses = 0;
  int sharedCompetitivePlays = 0;
}

extension _ScoresListExtensions on List<Score> {
  Score? firstWhereOrNullByPlayer(String playerId) {
    for (final score in this) {
      if (score.playerId == playerId) {
        return score;
      }
    }

    return null;
  }

  Score? firstWhereOrNullResult() {
    for (final score in this) {
      if (score.noScoreGameResult?.cooperativeGameResult != null) {
        return score;
      }
    }

    return null;
  }
}
