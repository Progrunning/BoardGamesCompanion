import 'package:board_games_companion/common/enums/game_classification.dart';
import 'package:board_games_companion/common/enums/game_family.dart';
import 'package:board_games_companion/models/hive/no_score_game_result.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/models/playthroughs/playthrough_details.dart';
import 'package:board_games_companion/pages/edit_playthrough/edit_playthrough_page_visual_states.dart';
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
  const Score emptyScore = Score(
    boardGameId: '',
    id: '',
    playerId: '',
  );
  const PlayerScore emptyPlayerScore = PlayerScore(
    player: Player(id: mockEmptyPlayerScoreId),
    score: emptyScore,
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
  });

  tearDown(() {
    reset(mockGamePlaythroughsDetailsStore);
  });

  test(
      'GIVEN edit playthrough view model '
      'WHEN setting a playthrough with an id '
      'THEN then the playthrough details should reflect that ', () {
    editPlaythrouhgViewModel.setPlaythroughId(mockPlaythroughId);
    expect(editPlaythrouhgViewModel.playthroughDetails, mockPlaythroughDetails);
  });

  test(
      'GIVEN edit playthrough view model '
      'WHEN updating an empty player score  '
      'THEN the player score in the view model should reflect the change ', () {
    final playerScoreToUpdate = mockPlaythroughDetails.playerScores
        .firstWhereOrNull((element) => element.id == mockEmptyPlayerScoreId);
    const newScore = 10.0;

    editPlaythrouhgViewModel.setPlaythroughId(mockPlaythroughId);
    editPlaythrouhgViewModel.updatePlayerScore(playerScoreToUpdate!.id!, newScore);

    final updatedPlayerScore = editPlaythrouhgViewModel.playerScores
        .firstWhereOrNull((element) => element.id == playerScoreToUpdate.id);

    expect(updatedPlayerScore!.score.scoreGameResult!.points, newScore);
  });

  test(
      'GIVEN players are tied for a place '
      "WHEN updating player's score "
      "AND player's score are no longer tied "
      'THEN their tiebraker type should be null ', () {
    const firstPlayerId = '1';
    when(() => mockGamePlaythroughsDetailsStore.playthroughsDetails).thenReturn(
      ObservableList.of(
        [
          mockPlaythroughDetails.copyWith(
            playerScores: [
              emptyPlayerScore.copyWith(
                player: const Player(id: firstPlayerId),
                score: emptyScore.copyWith(
                  scoreGameResult: const ScoreGameResult(
                    points: 10,
                    tiebreakerType: ScoreTiebreakerType.place,
                  ),
                ),
              ),
              emptyPlayerScore.copyWith(
                player: const Player(id: '2'),
                score: emptyScore.copyWith(
                  scoreGameResult: const ScoreGameResult(
                    points: 10,
                    tiebreakerType: ScoreTiebreakerType.place,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );

    final playerScoreToUpdate = mockPlaythroughDetails.playerScores
        .firstWhereOrNull((playerScore) => playerScore.player!.id == firstPlayerId);
    const newScore = 20.0;

    editPlaythrouhgViewModel.setPlaythroughId(mockPlaythroughId);
    editPlaythrouhgViewModel.updatePlayerScore(playerScoreToUpdate!.id!, newScore);

    for (final playerScore in editPlaythrouhgViewModel.playerScores) {
      expect(playerScore.score.isTied, isFalse);
      expect(playerScore.score.scoreGameResult!.tiebreakerType, isNull);
    }
  });

  test(
      'GIVEN a non score game '
      'WHEN a player scored a cooperative game '
      'THEN cooperative game result should reflect that score ', () {
    const firstPlayerId = '1';
    const cooperativeResult = CooperativeGameResult.win;
    when(() => mockGamePlaythroughsDetailsStore.playthroughsDetails).thenReturn(
      ObservableList.of(
        [
          mockPlaythroughDetails.copyWith(
            playerScores: [
              emptyPlayerScore.copyWith(
                player: const Player(id: firstPlayerId),
                score: emptyScore.copyWith(
                  noScoreGameResult: const NoScoreGameResult(
                    cooperativeGameResult: cooperativeResult,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );

    editPlaythrouhgViewModel.setPlaythroughId(mockPlaythroughId);

    expect(editPlaythrouhgViewModel.cooperativeGameResult, cooperativeResult);
  });

  test(
      'GIVEN a non score game '
      'WHEN a non of the players scored '
      'THEN cooperative game result should be null ', () {
    const firstPlayerId = '1';
    when(() => mockGamePlaythroughsDetailsStore.playthroughsDetails).thenReturn(
      ObservableList.of(
        [
          mockPlaythroughDetails.copyWith(
            playerScores: [
              emptyPlayerScore.copyWith(
                player: const Player(id: firstPlayerId),
                score: emptyScore,
              ),
            ],
          )
        ],
      ),
    );

    editPlaythrouhgViewModel.setPlaythroughId(mockPlaythroughId);

    expect(editPlaythrouhgViewModel.cooperativeGameResult, null);
  });

  group('GIVEN edit playthrough page visual state', () {
    test(
        'WHEN players have no scores yet '
        'THEN visual state should be based on the game setting classification ', () {
      const gameFamily = GameFamily.Cooperative;
      when(() => mockGamePlaythroughsDetailsStore.gameClassification)
          .thenReturn(GameClassification.NoScore);
      when(() => mockGamePlaythroughsDetailsStore.gameGameFamily).thenReturn(gameFamily);
      when(() => mockGamePlaythroughsDetailsStore.playthroughsDetails).thenReturn(
        ObservableList.of(
          [
            mockPlaythroughDetails.copyWith(
              playerScores: [
                emptyPlayerScore.copyWith(
                  player: const Player(id: '1'),
                  score: emptyScore,
                ),
                emptyPlayerScore.copyWith(
                  player: const Player(id: '2'),
                  score: emptyScore,
                ),
              ],
            )
          ],
        ),
      );

      editPlaythrouhgViewModel.setPlaythroughId(mockPlaythroughId);

      expect(editPlaythrouhgViewModel.editPlaythroughPageVisualState,
          const EditPlaythroughPageVisualStates.editNoScoreGame(gameFamily: gameFamily));
    });

    // MK We need this behaviour in order to support / migrate results that were logged for a game
    //    which classification was changed after logging games
    test(
        'WHEN players have a score '
        'THEN visual state should be based on their score classificiation ', () {
      const gameFamily = GameFamily.Cooperative;
      when(() => mockGamePlaythroughsDetailsStore.gameClassification)
          .thenReturn(GameClassification.NoScore);
      when(() => mockGamePlaythroughsDetailsStore.gameGameFamily).thenReturn(gameFamily);
      when(() => mockGamePlaythroughsDetailsStore.playthroughsDetails).thenReturn(
        ObservableList.of(
          [
            mockPlaythroughDetails.copyWith(
              playerScores: [
                emptyPlayerScore.copyWith(
                  player: const Player(id: '1'),
                  score: emptyScore.copyWith(
                    scoreGameResult: const ScoreGameResult(points: 10),
                  ),
                ),
                emptyPlayerScore.copyWith(
                  player: const Player(id: '2'),
                  score: emptyScore,
                ),
              ],
            )
          ],
        ),
      );

      editPlaythrouhgViewModel.setPlaythroughId(mockPlaythroughId);

      expect(editPlaythrouhgViewModel.editPlaythroughPageVisualState,
          const EditPlaythroughPageVisualStates.editScoreGame(gameFamily: gameFamily));
    });
  });
}
