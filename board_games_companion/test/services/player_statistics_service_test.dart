import 'package:board_games_companion/common/enums/game_classification.dart';
import 'package:board_games_companion/common/enums/game_family.dart';
import 'package:board_games_companion/common/enums/playthrough_status.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/models/hive/board_game_settings.dart';
import 'package:board_games_companion/models/hive/no_score_game_result.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:board_games_companion/services/player_statistics_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mocktail/mocktail.dart';

import '../mocks/board_games_store_mock.dart';
import '../mocks/players_store_mock.dart';
import '../mocks/playthroughs_store_mock.dart';
import '../mocks/scores_store_mock.dart';

void main() {
  late MockPlayersStore mockPlayersStore;
  late MockPlaythroughsStore mockPlaythroughsStore;
  late MockScoresStore mockScoresStore;
  late MockBoardGamesStore mockBoardGamesStore;

  late PlayerStatisticsService playerStatisticsService;

  const subjectPlayerId = 'subject';
  const subjectPlayer = Player(id: subjectPlayerId, name: 'Subject');

  const competitiveBoardGameId = 'competitive-board-game';
  const coopBoardGameId = 'coop-board-game';

  const competitiveBoardGame = BoardGameDetails(
    id: competitiveBoardGameId,
    name: 'Ticket to Ride',
    settings: BoardGameSettings(
      gameFamily: GameFamily.HighestScore,
      gameClassification: GameClassification.Score,
    ),
  );

  const coopBoardGame = BoardGameDetails(
    id: coopBoardGameId,
    name: 'Pandemic',
    settings: BoardGameSettings(
      gameFamily: GameFamily.Cooperative,
      gameClassification: GameClassification.NoScore,
    ),
  );

  void setUpStores({
    required List<Player> players,
    required List<Playthrough> playthroughs,
    required List<Score> scores,
    required Map<String, BoardGameDetails> boardGames,
  }) {
    when(() => mockPlayersStore.players).thenReturn(ObservableList.of(players));
    when(() => mockPlaythroughsStore.playthroughs).thenReturn(ObservableList.of(playthroughs));
    when(() => mockScoresStore.scores).thenReturn(ObservableList.of(scores));
    when(() => mockBoardGamesStore.allBoardGamesMap).thenReturn(ObservableMap.of(boardGames));
  }

  Playthrough playthrough(
    String id, {
    required String boardGameId,
    required List<String> playerIds,
    PlaythroughStatus status = PlaythroughStatus.Finished,
    bool? isDeleted = false,
  }) =>
      Playthrough(
        id: id,
        boardGameId: boardGameId,
        playerIds: playerIds,
        scoreIds: const [],
        startDate: DateTime(2024),
        status: status,
        isDeleted: isDeleted,
      );

  Score competitiveScore(
    String id, {
    required String playthroughId,
    required String playerId,
    int? place,
    double? points,
  }) =>
      Score(
        id: id,
        playthroughId: playthroughId,
        playerId: playerId,
        boardGameId: competitiveBoardGameId,
        scoreGameResult: (place != null || points != null)
            ? ScoreGameResult(place: place, points: points)
            : null,
      );

  Score coopScore(
    String id, {
    required String playthroughId,
    required String playerId,
    required CooperativeGameResult result,
  }) =>
      Score(
        id: id,
        playthroughId: playthroughId,
        playerId: playerId,
        boardGameId: coopBoardGameId,
        noScoreGameResult: NoScoreGameResult(cooperativeGameResult: result),
      );

  setUp(() {
    mockPlayersStore = MockPlayersStore();
    mockPlaythroughsStore = MockPlaythroughsStore();
    mockScoresStore = MockScoresStore();
    mockBoardGamesStore = MockBoardGamesStore();

    playerStatisticsService = PlayerStatisticsService(
      mockPlayersStore,
      mockPlaythroughsStore,
      mockScoresStore,
      mockBoardGamesStore,
    );
  });

  group('GIVEN a competitive play with tied first place scores ', () {
    test(
        'WHEN retrieving player statistics for one of the tied winners '
        'THEN totalWins counts the tied win ', () {
      const opponentId = 'opponent-1';
      final play = playthrough('p1',
          boardGameId: competitiveBoardGameId, playerIds: const [subjectPlayerId, opponentId]);

      setUpStores(
        players: const [subjectPlayer, Player(id: opponentId, name: 'Opponent')],
        playthroughs: [play],
        scores: [
          competitiveScore('s1', playthroughId: 'p1', playerId: subjectPlayerId, place: 1, points: 10),
          competitiveScore('s2', playthroughId: 'p1', playerId: opponentId, place: 1, points: 10),
        ],
        boardGames: const {competitiveBoardGameId: competitiveBoardGame},
      );

      final result = playerStatisticsService.retrievePlayerStatistics(subjectPlayerId);

      expect(result.totalWins, 1);
      expect(result.totalPlays, 1);
    });
  });

  group('GIVEN a competitive play with a missing result for the subject ', () {
    test(
        'WHEN retrieving player statistics '
        'THEN the play is excluded from win rate and head-to-head but still counted elsewhere ', () {
      const opponentId = 'opponent-1';
      final plays = [
        for (var i = 0; i < 3; i++)
          playthrough('shared-$i',
              boardGameId: competitiveBoardGameId, playerIds: const [subjectPlayerId, opponentId]),
        playthrough('missing',
            boardGameId: competitiveBoardGameId, playerIds: const [subjectPlayerId, opponentId]),
      ];

      final scores = <Score>[
        for (var i = 0; i < 3; i++) ...[
          competitiveScore('sub-$i',
              playthroughId: 'shared-$i', playerId: subjectPlayerId, place: 1, points: 100),
          competitiveScore('opp-$i',
              playthroughId: 'shared-$i', playerId: opponentId, place: 2, points: 50),
        ],
        // subject has no score recorded in this play
        competitiveScore('opp-missing',
            playthroughId: 'missing', playerId: opponentId, place: 1, points: 100),
      ];

      setUpStores(
        players: const [subjectPlayer, Player(id: opponentId, name: 'Opponent')],
        playthroughs: plays,
        scores: scores,
        boardGames: const {competitiveBoardGameId: competitiveBoardGame},
      );

      final result = playerStatisticsService.retrievePlayerStatistics(subjectPlayerId);

      expect(result.totalPlays, 4);
      expect(result.competitiveWinRate, 1.0); // 3 eligible plays, all wins
      expect(result.buddies, hasLength(1));
      expect(result.buddies.first.sharedPlaysCount, 4);
      expect(result.gamesByPlays.single.playCount, 4);
    });
  });

  group('GIVEN a co-op win and a co-op loss ', () {
    test(
        'WHEN retrieving player statistics '
        'THEN coopWinRate is correct, competitiveWinRate is null, and totalWins counts the win ', () {
      const otherId = 'other';
      final plays = [
        playthrough('coop-win', boardGameId: coopBoardGameId, playerIds: const [subjectPlayerId, otherId]),
        playthrough('coop-loss', boardGameId: coopBoardGameId, playerIds: const [subjectPlayerId, otherId]),
      ];
      final scores = [
        coopScore('s1', playthroughId: 'coop-win', playerId: subjectPlayerId, result: CooperativeGameResult.win),
        coopScore('s2', playthroughId: 'coop-win', playerId: otherId, result: CooperativeGameResult.win),
        coopScore('s3', playthroughId: 'coop-loss', playerId: subjectPlayerId, result: CooperativeGameResult.loss),
        coopScore('s4', playthroughId: 'coop-loss', playerId: otherId, result: CooperativeGameResult.loss),
      ];

      setUpStores(
        players: const [subjectPlayer, Player(id: otherId, name: 'Other')],
        playthroughs: plays,
        scores: scores,
        boardGames: const {coopBoardGameId: coopBoardGame},
      );

      final result = playerStatisticsService.retrievePlayerStatistics(subjectPlayerId);

      expect(result.coopWinRate, 0.5);
      expect(result.competitiveWinRate, isNull);
      expect(result.totalWins, 1);
      expect(result.totalPlays, 2);
    });
  });

  group('GIVEN a solo play ', () {
    test(
        'WHEN retrieving player statistics '
        'THEN it is counted in totalPlays but excluded from competitiveWinRate denominator ', () {
      final play =
          playthrough('solo', boardGameId: competitiveBoardGameId, playerIds: const [subjectPlayerId]);

      setUpStores(
        players: const [subjectPlayer],
        playthroughs: [play],
        scores: [
          competitiveScore('s1', playthroughId: 'solo', playerId: subjectPlayerId, place: 1, points: 42),
        ],
        boardGames: const {competitiveBoardGameId: competitiveBoardGame},
      );

      final result = playerStatisticsService.retrievePlayerStatistics(subjectPlayerId);

      expect(result.totalPlays, 1);
      expect(result.totalWins, 1);
      expect(result.competitiveWinRate, isNull);
    });
  });

  group('GIVEN a player whose plays are all co-op ', () {
    test(
        'WHEN retrieving player statistics '
        'THEN competitiveWinRate is null and coopWinRate is set ', () {
      const otherId = 'other';
      final play =
          playthrough('coop', boardGameId: coopBoardGameId, playerIds: const [subjectPlayerId, otherId]);

      setUpStores(
        players: const [subjectPlayer, Player(id: otherId)],
        playthroughs: [play],
        scores: [
          coopScore('s1', playthroughId: 'coop', playerId: subjectPlayerId, result: CooperativeGameResult.win),
        ],
        boardGames: const {coopBoardGameId: coopBoardGame},
      );

      final result = playerStatisticsService.retrievePlayerStatistics(subjectPlayerId);

      expect(result.competitiveWinRate, isNull);
      expect(result.coopWinRate, 1.0);
    });
  });

  group('GIVEN an opponent below the three-play head-to-head floor ', () {
    test(
        'WHEN retrieving player statistics '
        'THEN that opponent is not returned as rival or nemesis ', () {
      const opponentId = 'opponent';
      final plays = [
        for (var i = 0; i < 2; i++)
          playthrough('p-$i',
              boardGameId: competitiveBoardGameId, playerIds: const [subjectPlayerId, opponentId]),
      ];
      final scores = <Score>[
        for (var i = 0; i < 2; i++) ...[
          competitiveScore('sub-$i', playthroughId: 'p-$i', playerId: subjectPlayerId, place: 1),
          competitiveScore('opp-$i', playthroughId: 'p-$i', playerId: opponentId, place: 2),
        ],
      ];

      setUpStores(
        players: const [subjectPlayer, Player(id: opponentId, name: 'Opponent')],
        playthroughs: plays,
        scores: scores,
        boardGames: const {competitiveBoardGameId: competitiveBoardGame},
      );

      final result = playerStatisticsService.retrievePlayerStatistics(subjectPlayerId);

      expect(result.rival, isNull);
      expect(result.nemesis, isNull);
    });
  });

  group('GIVEN a deleted player appears as a rival ', () {
    test(
        'WHEN retrieving player statistics '
        'THEN the deleted opponent is still returned as rival ', () {
      const opponentId = 'deleted-opponent';
      final plays = [
        for (var i = 0; i < 3; i++)
          playthrough('p-$i',
              boardGameId: competitiveBoardGameId, playerIds: const [subjectPlayerId, opponentId]),
      ];
      final scores = <Score>[
        for (var i = 0; i < 3; i++) ...[
          competitiveScore('sub-$i', playthroughId: 'p-$i', playerId: subjectPlayerId, place: 1),
          competitiveScore('opp-$i', playthroughId: 'p-$i', playerId: opponentId, place: 2),
        ],
      ];

      setUpStores(
        players: const [
          subjectPlayer,
          Player(id: opponentId, name: 'Deleted Opponent', isDeleted: true),
        ],
        playthroughs: plays,
        scores: scores,
        boardGames: const {competitiveBoardGameId: competitiveBoardGame},
      );

      final result = playerStatisticsService.retrievePlayerStatistics(subjectPlayerId);

      expect(result.rival, isNotNull);
      expect(result.rival!.opponent.id, opponentId);
      expect(result.rival!.opponent.isDeleted, isTrue);
      expect(result.rival!.wins, 3);
      expect(result.rival!.losses, 0);
    });
  });

  group('GIVEN a deleted playthrough ', () {
    test(
        'WHEN retrieving player statistics '
        'THEN it is excluded from every statistic ', () {
      final deletedPlay = playthrough('deleted',
          boardGameId: competitiveBoardGameId,
          playerIds: const [subjectPlayerId, 'opponent'],
          isDeleted: true);

      setUpStores(
        players: const [subjectPlayer, Player(id: 'opponent')],
        playthroughs: [deletedPlay],
        scores: [
          competitiveScore('s1', playthroughId: 'deleted', playerId: subjectPlayerId, place: 1),
          competitiveScore('s2', playthroughId: 'deleted', playerId: 'opponent', place: 2),
        ],
        boardGames: const {competitiveBoardGameId: competitiveBoardGame},
      );

      final result = playerStatisticsService.retrievePlayerStatistics(subjectPlayerId);

      expect(result.totalPlays, 0);
      expect(result.hasNoPlays, isTrue);
      expect(result.totalWins, 0);
      expect(result.gamesByPlays, isEmpty);
      expect(result.buddies, isEmpty);
    });
  });

  group('GIVEN a play imported without a place, two tied top scorers ', () {
    test(
        'WHEN retrieving player statistics '
        'THEN both tied top scorers count as winners ', () {
      const opponentId = 'opponent';
      final play = playthrough('imported',
          boardGameId: competitiveBoardGameId, playerIds: const [subjectPlayerId, opponentId]);

      setUpStores(
        players: const [subjectPlayer, Player(id: opponentId)],
        playthroughs: [play],
        scores: [
          competitiveScore('s1', playthroughId: 'imported', playerId: subjectPlayerId, points: 50),
          competitiveScore('s2', playthroughId: 'imported', playerId: opponentId, points: 50),
        ],
        boardGames: const {competitiveBoardGameId: competitiveBoardGame},
      );

      final result = playerStatisticsService.retrievePlayerStatistics(subjectPlayerId);

      expect(result.totalWins, 1);
      expect(result.competitiveWinRate, 1.0);
    });
  });

  group('GIVEN a player with no plays at all ', () {
    test(
        'WHEN retrieving player statistics '
        'THEN totals are zero/empty/null ', () {
      setUpStores(
        players: const [subjectPlayer],
        playthroughs: const [],
        scores: const [],
        boardGames: const {},
      );

      final result = playerStatisticsService.retrievePlayerStatistics(subjectPlayerId);

      expect(result.totalPlays, 0);
      expect(result.hasNoPlays, isTrue);
      expect(result.totalWins, 0);
      expect(result.gamesByPlays, isEmpty);
      expect(result.buddies, isEmpty);
      expect(result.competitiveWinRate, isNull);
      expect(result.coopWinRate, isNull);
      expect(result.rival, isNull);
      expect(result.nemesis, isNull);
    });
  });

  group('GIVEN plays across multiple games and opponents ', () {
    test(
        'WHEN retrieving player statistics '
        'THEN gamesByPlays is ordered by playCount desc and buddies ordered/top-5 with shared counts ', () {
      const otherBoardGameId = 'other-board-game';
      const otherBoardGame = BoardGameDetails(
        id: otherBoardGameId,
        name: 'Catan',
        settings: BoardGameSettings(
          gameFamily: GameFamily.HighestScore,
          gameClassification: GameClassification.Score,
        ),
      );

      final buddyIds = List.generate(6, (i) => 'buddy-$i');
      final players = [subjectPlayer, ...buddyIds.map((id) => Player(id: id, name: id))];

      final playthroughs = <Playthrough>[];
      final scores = <Score>[];

      // 3 plays of competitiveBoardGame with buddy-0 (most shared plays: 3)
      for (var i = 0; i < 3; i++) {
        final id = 'ttr-$i';
        playthroughs.add(playthrough(id,
            boardGameId: competitiveBoardGameId, playerIds: [subjectPlayerId, buddyIds[0]]));
        scores.add(competitiveScore('ttr-sub-$i', playthroughId: id, playerId: subjectPlayerId, place: 1));
        scores.add(competitiveScore('ttr-opp-$i', playthroughId: id, playerId: buddyIds[0], place: 2));
      }

      // 1 play of otherBoardGame with buddies 1-5 (5 buddies, each sharedPlaysCount 1)
      playthroughs.add(playthrough('catan-1',
          boardGameId: otherBoardGameId,
          playerIds: [subjectPlayerId, ...buddyIds.sublist(1)]));
      for (var i = 1; i < 6; i++) {
        scores.add(competitiveScore('catan-$i', playthroughId: 'catan-1', playerId: buddyIds[i], place: i));
      }
      scores.add(competitiveScore('catan-sub', playthroughId: 'catan-1', playerId: subjectPlayerId, place: 6));

      setUpStores(
        players: players,
        playthroughs: playthroughs,
        scores: scores,
        boardGames: const {
          competitiveBoardGameId: competitiveBoardGame,
          otherBoardGameId: otherBoardGame,
        },
      );

      final result = playerStatisticsService.retrievePlayerStatistics(subjectPlayerId);

      expect(result.totalPlays, 4);
      expect(result.gamesByPlays.first.boardGameId, competitiveBoardGameId);
      expect(result.gamesByPlays.first.playCount, 3);
      expect(result.gamesByPlays.last.boardGameId, otherBoardGameId);
      expect(result.gamesByPlays.last.playCount, 1);

      expect(result.buddies, hasLength(5)); // top 5 of 6 total buddies
      expect(result.buddies.first.buddy.id, buddyIds[0]);
      expect(result.buddies.first.sharedPlaysCount, 3);
    });
  });

  group('GIVEN a subject with >=3 shared competitive plays against an opponent, asymmetric record ', () {
    test(
        'WHEN retrieving player statistics '
        'THEN wins/losses record is correct and the opponent is both a candidate rival and nemesis pool member ', () {
      const rivalId = 'rival'; // subject beats rival often
      const nemesisId = 'nemesis'; // subject loses to nemesis often

      final playthroughs = <Playthrough>[];
      final scores = <Score>[];

      // Subject beats rival 3 times, loses once (net +2)
      for (var i = 0; i < 4; i++) {
        final id = 'vs-rival-$i';
        playthroughs.add(
            playthrough(id, boardGameId: competitiveBoardGameId, playerIds: const [subjectPlayerId, rivalId]));
        final subjectWinsThisRound = i != 3;
        scores.add(competitiveScore('r-sub-$i',
            playthroughId: id, playerId: subjectPlayerId, place: subjectWinsThisRound ? 1 : 2));
        scores.add(competitiveScore('r-opp-$i',
            playthroughId: id, playerId: rivalId, place: subjectWinsThisRound ? 2 : 1));
      }

      // Subject loses to nemesis 4 times, wins never
      for (var i = 0; i < 4; i++) {
        final id = 'vs-nemesis-$i';
        playthroughs.add(playthrough(id,
            boardGameId: competitiveBoardGameId, playerIds: const [subjectPlayerId, nemesisId]));
        scores.add(competitiveScore('n-sub-$i', playthroughId: id, playerId: subjectPlayerId, place: 2));
        scores.add(competitiveScore('n-opp-$i', playthroughId: id, playerId: nemesisId, place: 1));
      }

      setUpStores(
        players: const [
          subjectPlayer,
          Player(id: rivalId, name: 'Rival'),
          Player(id: nemesisId, name: 'Nemesis'),
        ],
        playthroughs: playthroughs,
        scores: scores,
        boardGames: const {competitiveBoardGameId: competitiveBoardGame},
      );

      final result = playerStatisticsService.retrievePlayerStatistics(subjectPlayerId);

      expect(result.rival, isNotNull);
      expect(result.rival!.opponent.id, rivalId);
      expect(result.rival!.wins, 3);
      expect(result.rival!.losses, 1);

      expect(result.nemesis, isNotNull);
      expect(result.nemesis!.opponent.id, nemesisId);
      expect(result.nemesis!.wins, 0);
      expect(result.nemesis!.losses, 4);
    });
  });
}
