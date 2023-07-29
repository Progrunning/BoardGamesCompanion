import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/services/score_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/hive_interface_mock.dart';
import '../mocks/score_hive_box_mock.dart';

void main() {
  late final MockHiveInterface mockHiveInterface;
  late final MockScoreHiveBox mockScoreHiveBox;

  late final ScoreService scoreService;

  setUp(() {
    mockHiveInterface = MockHiveInterface();
    mockScoreHiveBox = MockScoreHiveBox();
    scoreService = ScoreService(mockHiveInterface);
  });

  test(
      'GIVEN a score service '
      'WHEN creating a score without a playthrough id '
      'THEN score should not be created ', () async {
    const mockScore = Score(
      boardGameId: '',
      id: '',
      playerId: '',
    );

    final createResult = await scoreService.addOrUpdateScore(mockScore);
    expect(createResult, isFalse);
  });
}
