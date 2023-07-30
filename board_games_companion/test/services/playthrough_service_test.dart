import 'package:board_games_companion/common/enums/playthrough_status.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/services/playthroughs_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/hive_interface_mock.dart';
import '../mocks/playthrough_hive_box_mock.dart';
import '../mocks/score_service_mock.dart';

void main() {
  late MockHiveInterface mockHiveInterface;
  late MockPlaythroughHiveBox mockPlaythroughHiveBox;
  late MockScoreService mockScoreService;

  late PlaythroughService playthroughService;

  final samplePlaythrough = Playthrough(
    id: '123',
    boardGameId: '987',
    playerIds: [],
    scoreIds: [],
    startDate: DateTime.now(),
  );

  const sampleScore = Score(
    boardGameId: '',
    id: '',
    playerId: '',
  );

  setUp(() {
    mockScoreService = MockScoreService();
    when(() => mockScoreService.addOrUpdateScore(any())).thenAnswer((_) => Future.value(true));
    mockPlaythroughHiveBox = MockPlaythroughHiveBox();
    when(() => mockPlaythroughHiveBox.put(any<dynamic>(), any())).thenAnswer((_) => Future.value());
    mockHiveInterface = MockHiveInterface();
    when(() => mockHiveInterface.isBoxOpen(any())).thenAnswer((_) => false);
    when(() => mockHiveInterface.openBox<Playthrough>(any()))
        .thenAnswer((_) async => mockPlaythroughHiveBox);

    playthroughService = PlaythroughService(mockHiveInterface, mockScoreService);
  });

  setUpAll(() {
    // MK Required fallback of a dummy objects when mocktail needs to return a model of such type
    registerFallbackValue(samplePlaythrough);
    registerFallbackValue(sampleScore);
  });

  tearDown(() {
    reset(mockPlaythroughHiveBox);
    reset(mockHiveInterface);
    reset(mockScoreService);
  });

  group('Create playthrough ', () {
    test(
        'GIVEN playthrough service '
        'WHEN creating a playthrough '
        'AND board game id is empty '
        'THEN the playthrough does not get created ', () async {
      const boardGameId = '';
      final createdPlaythrough = await playthroughService.createPlaythrough(
        boardGameId,
        [],
        {},
        DateTime.now(),
        null,
      );

      expect(createdPlaythrough, isNull);
      verifyNever(() => mockPlaythroughHiveBox.put(any<dynamic>(), any()));
    });

    test(
        'GIVEN playthrough service '
        'WHEN creating a playthrough '
        'AND duration is not provided '
        'THEN the playthrough should be in Started status ', () async {
      const boardGameId = '123';
      const playerIds = ['434'];
      const Duration? duration = null;
      final createdPlaythrough = await playthroughService.createPlaythrough(
        boardGameId,
        playerIds,
        {},
        DateTime.now(),
        duration,
      );

      expect(createdPlaythrough!.status, PlaythroughStatus.Started);
    });

    test(
        'GIVEN playthrough service '
        'WHEN creating a playthrough '
        'AND duration is provided '
        'THEN the playthrough should be in Finished status ', () async {
      const boardGameId = '123';
      const playerIds = ['434'];
      const duration = Duration(seconds: 100);
      final createdPlaythrough = await playthroughService.createPlaythrough(
        boardGameId,
        playerIds,
        {},
        DateTime.now(),
        duration,
      );

      expect(createdPlaythrough!.status, PlaythroughStatus.Finished);
    });

    test(
        'GIVEN playthrough service '
        'WHEN creating a playthrough '
        'AND player scores are provided '
        'THEN the playthrough should be saved with the player scores ', () async {
      const boardGameId = '123';
      const playerIds = ['434', '564'];
      final playerScores = {
        playerIds[0]: PlayerScore(
          player: Player(id: playerIds[0]),
          score: Score(
            id: '12938',
            boardGameId: boardGameId,
            playerId: playerIds[0],
          ),
        ),
        playerIds[1]: PlayerScore(
          player: Player(id: playerIds[1]),
          score: Score(
            id: '98223',
            boardGameId: boardGameId,
            playerId: playerIds[1],
          ),
        ),
      };
      const duration = Duration(seconds: 100);
      final createdPlaythrough = await playthroughService.createPlaythrough(
        boardGameId,
        playerIds,
        playerScores,
        DateTime.now(),
        duration,
      );

      expect(createdPlaythrough!.playerIds, playerIds);
      expect(
        createdPlaythrough.scoreIds,
        playerScores.values.map((playerScore) => playerScore.score.id),
      );
    });
  });
}
