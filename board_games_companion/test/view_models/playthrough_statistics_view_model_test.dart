import 'package:board_games_companion/common/enums/game_classification.dart';
import 'package:board_games_companion/common/enums/game_family.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:board_games_companion/pages/playthroughs/playthrough_statistics_view_model.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/stores/scores_store.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' show ObservableList;
import 'package:mocktail/mocktail.dart';

import '../mocks/game_playthroughs_details_store_mock.dart';

void main() {
  final mockPlayerService = MockPlayerService();
  final mockScoresStore = MockScoresStore();
  final mockGamePlaythroughsDetailsStore = MockGamePlaythroughsDetailsStore();

  const playerOne = Player(id: '1', name: 'One');
  const playerTwo = Player(id: '2', name: 'Two');
  const playerThree = Player(id: '3', name: 'Three');

  final playthrough = Playthrough(
    id: 'playthrough-1',
    boardGameId: 'board-game-1',
    playerIds: [playerOne.id, playerTwo.id, playerThree.id],
    scoreIds: const [],
    startDate: clock.now().subtract(const Duration(hours: 1)),
    endDate: clock.now(),
  );

  // MK Player one has the actual lowest score (and is recorded as place 1, the true winner),
  // while player three has the highest score/value. Under GameFamily.LowestScore, player one
  // should be reported as the winner of the "games won" statistics.
  final scores = [
    Score(
      id: 's1',
      playerId: playerOne.id,
      boardGameId: playthrough.boardGameId,
      playthroughId: playthrough.id,
      scoreGameResult: const ScoreGameResult(place: 1, points: 3),
    ),
    Score(
      id: 's2',
      playerId: playerTwo.id,
      boardGameId: playthrough.boardGameId,
      playthroughId: playthrough.id,
      scoreGameResult: const ScoreGameResult(place: 2, points: 7),
    ),
    Score(
      id: 's3',
      playerId: playerThree.id,
      boardGameId: playthrough.boardGameId,
      playthroughId: playthrough.id,
      scoreGameResult: const ScoreGameResult(place: 3, points: 10),
    ),
  ];

  late PlaythroughStatisticsViewModel playthroughStatisticsViewModel;

  setUp(() {
    when(() => mockPlayerService.retrievePlayers(includeDeleted: true)).thenAnswer(
      (_) async => [playerOne, playerTwo, playerThree],
    );
    when(() => mockScoresStore.scores).thenReturn(ObservableList.of(scores));
    when(() => mockGamePlaythroughsDetailsStore.playthroughs).thenReturn([playthrough]);
    when(() => mockGamePlaythroughsDetailsStore.finishedPlaythroughs).thenReturn([playthrough]);
    when(() => mockGamePlaythroughsDetailsStore.boardGameId).thenReturn(playthrough.boardGameId);
    when(() => mockGamePlaythroughsDetailsStore.boardGameName).thenReturn('Test Game');
    when(() => mockGamePlaythroughsDetailsStore.boardGameImageUrl).thenReturn(null);
    when(() => mockGamePlaythroughsDetailsStore.gameClassification)
        .thenReturn(GameClassification.Score);
    when(() => mockGamePlaythroughsDetailsStore.gameGameFamily)
        .thenReturn(GameFamily.LowestScore);
    when(() => mockGamePlaythroughsDetailsStore.averageScorePrecision).thenReturn(0);

    playthroughStatisticsViewModel = PlaythroughStatisticsViewModel(
      mockPlayerService,
      mockScoresStore,
      mockGamePlaythroughsDetailsStore,
    );
  });

  test(
      'GIVEN a board game with GameFamily.LowestScore '
      'AND a finished playthrough where the lowest score has place 1 '
      'WHEN loading board game statistics '
      'THEN the "games won" statistics should credit the actual (lowest-score) winner ',
      () async {
    playthroughStatisticsViewModel.loadBoardGamesStatistics();
    await playthroughStatisticsViewModel.futureLoadBoardGamesStatistics;

    final playerWinsPercentage = playthroughStatisticsViewModel.boardGameStatistics.maybeWhen(
      score: (boardGameStatistics) => boardGameStatistics.playerWinsPercentage,
      orElse: () => null,
    );

    expect(playerWinsPercentage, isNotNull);
    expect(playerWinsPercentage!.length, 1);
    expect(playerWinsPercentage.first.player, playerOne);
    expect(playerWinsPercentage.first.numberOfWins, 1);
  });
}

class MockPlayerService extends Mock implements PlayerService {}

class MockScoresStore extends Mock implements ScoresStore {}
