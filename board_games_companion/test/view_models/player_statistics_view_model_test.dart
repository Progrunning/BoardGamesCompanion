import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/player_overall_statistics.dart';
import 'package:board_games_companion/pages/player_statistics/player_statistics_view_model.dart';
import 'package:board_games_companion/pages/player_statistics/player_statistics_visual_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mocktail/mocktail.dart';

import '../mocks/board_games_store_mock.dart';
import '../mocks/player_statistics_service_mock.dart';
import '../mocks/players_store_mock.dart';
import '../mocks/playthroughs_store_mock.dart';
import '../mocks/scores_store_mock.dart';

void main() {
  late MockPlayerStatisticsService mockPlayerStatisticsService;
  late MockPlayersStore mockPlayersStore;
  late MockPlaythroughsStore mockPlaythroughsStore;
  late MockScoresStore mockScoresStore;
  late MockBoardGamesStore mockBoardGamesStore;

  late PlayerStatisticsViewModel playerStatisticsViewModel;

  const testPlayer = Player(id: 'player1', name: 'Alice');

  setUp(() {
    mockPlayerStatisticsService = MockPlayerStatisticsService();
    mockPlayersStore = MockPlayersStore();
    mockPlaythroughsStore = MockPlaythroughsStore();
    mockScoresStore = MockScoresStore();
    mockBoardGamesStore = MockBoardGamesStore();

    when(() => mockPlayersStore.loadPlayers()).thenAnswer((_) => Future.value());
    when(() => mockPlaythroughsStore.loadPlaythroughs()).thenAnswer((_) => Future.value());
    when(() => mockScoresStore.loadScores()).thenAnswer((_) => Future.value());
    when(() => mockBoardGamesStore.loadBoardGames()).thenAnswer((_) => Future.value());
    when(() => mockPlayersStore.players).thenReturn(ObservableList.of([testPlayer]));

    playerStatisticsViewModel = PlayerStatisticsViewModel(
      mockPlayerStatisticsService,
      mockPlayersStore,
      mockPlaythroughsStore,
      mockScoresStore,
      mockBoardGamesStore,
    );
  });

  group('GIVEN a player with no recorded plays ', () {
    test(
        'WHEN player statistics are loaded '
        'THEN visual state is PlayerStatisticsEmpty ', () async {
      when(() => mockPlayerStatisticsService.retrievePlayerStatistics(any())).thenReturn(
        const PlayerOverallStatistics(
          player: testPlayer,
          totalPlays: 0,
          totalWins: 0,
        ),
      );

      playerStatisticsViewModel.setPlayer(testPlayer);
      playerStatisticsViewModel.loadPlayerStatistics();
      await playerStatisticsViewModel.futureLoadStatistics;

      expect(playerStatisticsViewModel.visualState, isA<PlayerStatisticsEmpty>());
    });
  });

  group('GIVEN a player with a rich set of recorded plays ', () {
    test(
        'WHEN player statistics are loaded '
        'THEN visual state is PlayerStatisticsLoaded carrying the statistics ', () async {
      const statistics = PlayerOverallStatistics(
        player: testPlayer,
        totalPlays: 10,
        totalWins: 6,
        competitiveWinRate: 0.6,
        coopWinRate: 0.5,
        gamesByPlays: [
          GamePlaysCount(boardGameId: 'g1', boardGameName: 'Catan', playCount: 5),
        ],
        rival: HeadToHeadRecord(
          opponent: Player(id: 'player2', name: 'Bob'),
          wins: 3,
          losses: 1,
        ),
        nemesis: HeadToHeadRecord(
          opponent: Player(id: 'player3', name: 'Carol'),
          wins: 1,
          losses: 4,
        ),
        buddies: [
          BuddyRecord(buddy: Player(id: 'player2', name: 'Bob'), sharedPlaysCount: 8),
        ],
      );
      when(() => mockPlayerStatisticsService.retrievePlayerStatistics(any()))
          .thenReturn(statistics);

      playerStatisticsViewModel.setPlayer(testPlayer);
      playerStatisticsViewModel.loadPlayerStatistics();
      await playerStatisticsViewModel.futureLoadStatistics;

      expect(playerStatisticsViewModel.visualState, isA<PlayerStatisticsLoaded>());
      expect(
        (playerStatisticsViewModel.visualState as PlayerStatisticsLoaded).statistics,
        statistics,
      );
    });
  });

  group('GIVEN a player with plays but no rival, nemesis, coop plays or buddies ', () {
    test(
        'WHEN player statistics are loaded '
        'THEN visual state is PlayerStatisticsLoaded preserving the nulls and empties ', () async {
      const statistics = PlayerOverallStatistics(
        player: testPlayer,
        totalPlays: 4,
        totalWins: 1,
        competitiveWinRate: 0.25,
      );
      when(() => mockPlayerStatisticsService.retrievePlayerStatistics(any()))
          .thenReturn(statistics);

      playerStatisticsViewModel.setPlayer(testPlayer);
      playerStatisticsViewModel.loadPlayerStatistics();
      await playerStatisticsViewModel.futureLoadStatistics;

      expect(playerStatisticsViewModel.visualState, isA<PlayerStatisticsLoaded>());
      final loaded = playerStatisticsViewModel.visualState as PlayerStatisticsLoaded;
      expect(loaded.statistics.rival, isNull);
      expect(loaded.statistics.nemesis, isNull);
      expect(loaded.statistics.coopWinRate, isNull);
      expect(loaded.statistics.buddies, isEmpty);
    });
  });

  group('GIVEN a player with more games played than the collapsed count ', () {
    test(
        'WHEN player statistics are loaded '
        'THEN games list can be expanded and displays all games ', () async {
      final gamesByPlays = List.generate(
        7,
        (index) => GamePlaysCount(boardGameId: 'g$index', boardGameName: 'Game $index', playCount: index),
      );
      when(() => mockPlayerStatisticsService.retrievePlayerStatistics(any())).thenReturn(
        PlayerOverallStatistics(
          player: testPlayer,
          totalPlays: 20,
          totalWins: 10,
          gamesByPlays: gamesByPlays,
        ),
      );

      playerStatisticsViewModel.setPlayer(testPlayer);
      playerStatisticsViewModel.loadPlayerStatistics();
      await playerStatisticsViewModel.futureLoadStatistics;

      expect(playerStatisticsViewModel.canExpandGames, isTrue);
      expect(playerStatisticsViewModel.displayedGames.length, 5);

      playerStatisticsViewModel.toggleGamesExpansion();

      expect(playerStatisticsViewModel.displayedGames.length, 7);
    });

    test(
        'WHEN there are fewer games played than the collapsed count '
        'THEN games list cannot be expanded and displays all games ', () async {
      final gamesByPlays = List.generate(
        3,
        (index) => GamePlaysCount(boardGameId: 'g$index', boardGameName: 'Game $index', playCount: index),
      );
      when(() => mockPlayerStatisticsService.retrievePlayerStatistics(any())).thenReturn(
        PlayerOverallStatistics(
          player: testPlayer,
          totalPlays: 5,
          totalWins: 2,
          gamesByPlays: gamesByPlays,
        ),
      );

      playerStatisticsViewModel.setPlayer(testPlayer);
      playerStatisticsViewModel.loadPlayerStatistics();
      await playerStatisticsViewModel.futureLoadStatistics;

      expect(playerStatisticsViewModel.canExpandGames, isFalse);
      expect(playerStatisticsViewModel.displayedGames.length, 3);
    });
  });

  group('GIVEN a deleted player ', () {
    test(
        'WHEN player statistics are loaded '
        'THEN isPlayerDeleted is true ', () async {
      const deletedPlayer = Player(id: 'player1', name: 'Alice', isDeleted: true);
      when(() => mockPlayersStore.players).thenReturn(ObservableList.of([deletedPlayer]));
      when(() => mockPlayerStatisticsService.retrievePlayerStatistics(any())).thenReturn(
        const PlayerOverallStatistics(
          player: deletedPlayer,
          totalPlays: 3,
          totalWins: 1,
        ),
      );

      playerStatisticsViewModel.setPlayer(testPlayer);
      playerStatisticsViewModel.loadPlayerStatistics();
      await playerStatisticsViewModel.futureLoadStatistics;

      expect(playerStatisticsViewModel.isPlayerDeleted, isTrue);
    });
  });
}
