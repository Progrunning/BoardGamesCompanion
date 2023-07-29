import 'package:board_games_companion/common/enums/playthrough_status.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/score.dart';
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
        'GIVEN creating a playthrough '
        'WHEN board game id is empty '
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
        'GIVEN creating a playthrough '
        'WHEN duration is not provided '
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
        'GIVEN creating a playthrough '
        'WHEN duration is provided '
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
  });
}
