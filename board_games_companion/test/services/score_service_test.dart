import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/services/score_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/hive_interface_mock.dart';
import '../mocks/score_hive_box_mock.dart';

void main() {
  late MockHiveInterface mockHiveInterface;
  late MockScoreHiveBox mockScoreHiveBox;

  late ScoreService scoreService;

  const sampleScore = Score(
    boardGameId: '',
    id: '',
    playerId: '',
  );

  setUp(() {
    mockScoreHiveBox = MockScoreHiveBox();
    when(() => mockScoreHiveBox.put(any<dynamic>(), any())).thenAnswer((_) => Future.value());
    mockHiveInterface = MockHiveInterface();
    when(() => mockHiveInterface.isBoxOpen(any())).thenAnswer((_) => false);
    when(() => mockHiveInterface.openBox<Score>(any())).thenAnswer((_) async => mockScoreHiveBox);

    scoreService = ScoreService(mockHiveInterface);
  });

  setUpAll(() {
    // MK Required fallback of a dummy score when mocktail needs to return a model of such type
    registerFallbackValue(sampleScore);
  });

  tearDown(() {
    reset(mockHiveInterface);
    reset(mockScoreHiveBox);
  });

  group('Saving score ', () {
    void verifyScore(Score score, bool expectedResult) {
      test(
          'GIVEN a score $score '
          'WHEN saving it '
          'THEN saving should ${expectedResult ? "succeed" : "fail"} ', () async {
        final createResult = await scoreService.addOrUpdateScore(score);
        expect(createResult, expectedResult);
      });
    }

    verifyScore(sampleScore, false);
    verifyScore(sampleScore.copyWith(id: '123'), false);
    verifyScore(sampleScore.copyWith(id: '123', boardGameId: '321'), false);
    verifyScore(sampleScore.copyWith(id: '123', boardGameId: '321', playerId: '834'), false);
    verifyScore(
      sampleScore.copyWith(id: '123', boardGameId: '321', playerId: '834', playthroughId: '123'),
      true,
    );

    test(
        'GIVEN a score '
        'WHEN saving it '
        'THEN the score should be put in the hive box ', () async {
      final validScore = sampleScore.copyWith(
        id: '123',
        boardGameId: '321',
        playerId: '834',
        playthroughId: '123',
      );

      await scoreService.addOrUpdateScore(validScore);

      verify(() => mockScoreHiveBox.put(validScore.id, validScore)).called(1);
    });
  });
}
