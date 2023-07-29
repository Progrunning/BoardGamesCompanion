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

  const emptyScore = Score(
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
    registerFallbackValue(emptyScore);
  });

  tearDown(() {
    reset(mockHiveInterface);
    reset(mockScoreHiveBox);
  });

  group('GIVEN a score service ', () {
    void verifyScore(Score score, bool expectedResult) {
      test(
          'WHEN saving a score model $score '
          'THEN saving should result with $expectedResult ', () async {
        final createResult = await scoreService.addOrUpdateScore(score);
        expect(createResult, expectedResult);
      });
    }

    verifyScore(emptyScore, false);
    verifyScore(emptyScore.copyWith(id: '123'), false);
    verifyScore(emptyScore.copyWith(id: '123', boardGameId: '321'), false);
    verifyScore(emptyScore.copyWith(id: '123', boardGameId: '321', playerId: '834'), false);
    verifyScore(
      emptyScore.copyWith(id: '123', boardGameId: '321', playerId: '834', playthroughId: '123'),
      true,
    );
  });
}
