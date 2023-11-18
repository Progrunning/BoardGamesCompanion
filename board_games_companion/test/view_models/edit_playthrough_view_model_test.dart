import 'package:board_games_companion/common/enums/game_classification.dart';
import 'package:board_games_companion/common/enums/game_family.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/models/playthroughs/playthrough_details.dart';
import 'package:board_games_companion/pages/edit_playthrough/edit_playthrough_view_model.dart';
import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' show ObservableList;
import 'package:mocktail/mocktail.dart';

import '../mocks/game_playthroughs_details_store_mock.dart';

void main() {
  final mockGamePlaythroughsDetailsStore = MockGamePlaythroughsDetailsStore();

  const String mockPlaythroughId = '1';
  const String mockEmptyPlayerScoreId = '1';
  const PlayerScore emptyPlayerScore = PlayerScore(
    player: Player(id: mockEmptyPlayerScoreId),
    score: Score(
      boardGameId: '',
      id: '',
      playerId: '',
    ),
  );
  final mockPlaythroughDetails = PlaythroughDetails(
    playerScores: [emptyPlayerScore],
    playthrough: Playthrough(
      id: mockPlaythroughId,
      boardGameId: '',
      playerIds: [],
      scoreIds: [],
      startDate: clock.now(),
    ),
  );

  late EditPlaythoughViewModel editPlaythrouhgViewModel;

  setUp(() {
    when(() => mockGamePlaythroughsDetailsStore.playthroughsDetails).thenReturn(
      ObservableList.of([mockPlaythroughDetails]),
    );
    when(() => mockGamePlaythroughsDetailsStore.gameClassification)
        .thenReturn(GameClassification.Score);
    when(() => mockGamePlaythroughsDetailsStore.gameGameFamily).thenReturn(GameFamily.HighestScore);

    editPlaythrouhgViewModel = EditPlaythoughViewModel(
      mockGamePlaythroughsDetailsStore,
    );
    editPlaythrouhgViewModel.setPlaythroughId(mockPlaythroughId);
  });

  tearDown(() {
    reset(mockGamePlaythroughsDetailsStore);
  });

  test(
      'GIVEN edit playthrough view model '
      'WHEN setting a playthrough with an id '
      'THEN then the playthrough details should reflect that ', () {
    expect(editPlaythrouhgViewModel.playthroughDetails, mockPlaythroughDetails);
  });

  test(
      'GIVEN edit playthrough view model '
      'WHEN updating an empty player score  '
      'THEN the player score in the view model should reflect the change ', () {
    final playerScoreToUpdate = mockPlaythroughDetails.playerScores
        .firstWhereOrNull((element) => element.id == mockEmptyPlayerScoreId);
    const newScore = 10.0;

    editPlaythrouhgViewModel.updatePlayerScore(playerScoreToUpdate!.id!, newScore);

    final updatedPlayerScore = editPlaythrouhgViewModel.playerScores
        .firstWhereOrNull((element) => element.id == playerScoreToUpdate.id);

    expect(updatedPlayerScore!.score.scoreGameResult!.points, newScore);
  });
}
